# 0、Codex CLI 本质架构
```text
输入  
↓  
构建 context（history + 索引）  
↓  
LLM（决策）  
↓  
Agent Loop（ReAct）  
↓  
Tool 执行  
↓  
写入 rollout（sessions）  
↓  
直到完成
```
## 你可以这样理解它
```text
LLM：大脑（决策）  
Codex：执行引擎（loop + tools）  
sessions：黑盒飞行记录仪  
history：短期记忆  
agents：流程模板  
hooks：拦截器
```
**Codex CLI = 面向“开发者”的执行工具（轻量、可编程）**
```text
~/.codex/  
= config（规则）  
+ history（上下文）  
+ sessions（Agent执行全过程）  
+ skills（能力扩展）
```
# 1、初始文件夹内容

## mac 上安装 Codex CLI 后的文件与目录：
### ① 可执行入口（你在终端敲的 `codex`）
#### ▶ npm（全局安装）
/usr/local/bin/codex  
或  
~/.npm-global/bin/codex
👉 这个文件通常是一个很小的“入口脚本”，负责把命令转发到真正的程序。
你可以验证：
which codex
/Users/heytea/.nvm/versions/node/v18.20.8/bin/codex
### ② CLI 本体（程序安装位置）
### ▶ npm
```text
/usr/local/lib/node_modules/@openai/codex/  
├── bin/  
├── dist/            # 核心逻辑（Agent loop、工具调度）  
├── package.json  
└── node_modules/
```
👉 这一层是“程序本身”，一般不需要你去改。
### ③ 用户运行目录（最关键）：`~/.codex/`
mac 上首次运行 `codex` 后自动生成：
```text
~/.codex/  
├── config.toml  ----全局配置中心
├── auth.json  -------认证中心  
├── history.jsonl-----和 Codex 每次对话的日志 
├── logs/      -------Codex 工具自身的运行记录
├── cache/     -------本地缓存层，KV存储
├── sessions/   -----会话记录（history的子集）
├── skills/     
├── agents/     -----各类agent.md
├── hooks.json（可选）  
├── tmp/ 或 bash/（你看到的那些bash文件）
```
# 2、总目录：~/.codex/每个文件/目录的作用

### 1️⃣ `config.toml`
全局配置中心
```text
model_provider = "cxapi"
model = "gpt-5.5"
model_reasoning_effort = "medium"
disable_response_storage = true
approvals_reviewer = "user"
model_catalog_json = './model-catalog.gpt-5.5.json'
service_tier = "fast"

[model_providers.cxapi]
name = "cxapi"
base_url = "http://121.********:****"
wire_api = "responses"
requires_openai_auth = true

[projects."/Users/heytea/tools/gaiaworkforce-assistant"]
trust_level = "trusted"

[projects."/Users/heytea"]
trust_level = "trusted"

[notice]
hide_full_access_warning = true
fast_default_opt_out = true

[notice.model_migrations]
gpt-5-codex = "gpt-5.3-codex"
base_url = "https://api.********"
```
作用：
- 模型选择
- MCP工具配置
- 权限/沙箱控制
### 2️⃣ `auth.json`
认证信息
```text
{
  "OPENAI_API_KEY": "sk-a989b8390ec9ac679c313acf9c2b658e47503dc029d3c21f3ac914cef78119c2"
}
//official example
{  
  "access_token": "...",  
  "refresh_token": "..."  
}
```
### 3️⃣ `history.jsonl`

```text
文件/目录       ｜  作用
history.jsonl  ｜全量日志（类似流水账）
sessions/      ｜按会话拆分的结构化数据
```
- history.jsonl 会一直增长
- 本质就是日志文件
- - codex 不会全量加载 history
- 只会：
    - 按 session 读取
    - 或读取最近片段
对话历史（逐行 JSON）
```text
{"session_id":"019bdf57-52ae-7201-b5dc-a457eb58971f","ts":1768979221,"text":"我现在有一个需要帮忙实现，我有一个 excel，我需要截取其中的列，并将其转换为一个 insert 脚本，你看能不能帮忙实现这个功能，然后你有什么问题可以跟我说，例如文件和 insert 脚本我也可以给你"}
{"session_id":"019bdf57-52ae-7201-b5dc-a457eb58971f","ts":1768980296,"text":"/Users/heytea/Downloads/物料分类信息文档.xlsx 这个是 Excel 文档，最后得到脚本"}
{"session_id":"019bdf74-8a0c-72d0-846d-219c8ca98388","ts":1768980546,"text":"我现在想要跟你聊一下需求，然后你可以把我的需求了解，放到一个 md 文档中"}
```
👉 用于：
- 上下文补全
- 简单记忆
> 把你刚才聊过的内容，带进下一次提问里，让模型“记得上下文”。


```text
|模块|本质|是否参与推理|生命周期|
|---|---|---|---|
|history|原始对话日志（流水）|❌ 不直接参与|长期累计|
|memory|提炼后的长期记忆|✅ 会注入上下文|跨 session|
|spec|当前任务的结构化说明|✅ 强约束当前行为|单任务|

history（原始日志）  
↓ 提炼  
memory（长期记忆）  
↓ 注入  
context = memory + spec + 当前输入  
↓  
LLM 推理
```
#### 怎么工作的（简化）
- 每一轮对话会追加一行到 `history.jsonl`
- 下一次你再问时，Codex 会**选取最近几轮**拼进这次的请求里
### 4️⃣ `logs/`
日志
最新版本已经弱化 logs：
日志主要转移到了 sessions
它记录的是**系统层面的行为**，而不是对话内容，例如：

```text
### 1️⃣ 模型调用过程
调用模型: gpt-5  
请求token: 3200  
响应token: 800  
耗时: 2.3s
### 2️⃣ 工具调用 / Agent 行为

执行工具: bash  
命令: ls -al  
状态: success
或：
调用 skill: generate-sql  
步骤: step-2

### 3️⃣ 错误 / 异常
Error: failed to connect API  
Timeout after 30s

### 4️⃣ 配置 / 环境信息

加载 config.toml  
启用 memory  
当前 sessionId: xxx
```
#### 1、排查问题（最重要）
当你遇到：
- Codex 卡住
- 调用失败
- 结果异常
👉 第一件事就是看 logs
#### 2、理解 Agent 行为
你可以看到：
- 为什么调用了某个 tool
- 执行顺序是什么
- 是否走了错误分支
👉 对你理解 agent 非常关键
#### 3、性能分析
可以看到：
- token 消耗
- 响应时间
- 是否有重复调用
```text
你输入问题  
↓  
spec（任务约束）  
memory（长期记忆）  
↓  
LLM 推理  
↓  
history（记录对话）  
logs（记录过程）
```
### 5️⃣ `cache/`
缓存
👉 存：
- 模型结果缓存
- 工具执行缓存
#### 1、模型响应结果（最关键）
例如你问了同一个问题：
生成某个 SQL / 解释某段代码
👉 如果：
- prompt 一样
- context 一样
则可能直接命中 cache，不再请求模型
#### 2、embedding / 向量结果
如果有：
- RAG
- 文件检索
👉 embedding 计算会被缓存，避免重复算
#### 3、工具调用结果
例如：
读取文件  
扫描目录  
解析代码结构
👉 这些结果也可能缓存
#### 4、中间推理结果（部分框架支持）
在 agent 流程中：
step1 → step2 → step3
👉 某些 step 的输出会被缓存，避免重复执行
#### 5、cache 的作用：
```text
## 提升速度（最直接）
- 不用重复调用 LLM
- 不用重复算 embedding
- 不用重复跑工具
👉 你会感觉“秒出结果”

## 降低成本
- 减少 token 消耗
- 减少 API 调用次数

## 提升稳定性
- 避免模型多次生成不一致结果
- 保证重复任务输出一致
```
> **history / logs 是“记录”，cache 是“复用”。**
### 6️⃣ `sessions/`
**rollout 按日期存，是为了“日志化 + 易管理”**  
**session 实际是“逻辑概念”，不是必须对应一个独立文件**
session = 多条 rollout 记录的集合（通过 sessionId 关联）
一个 rollout 对应一个 session->>> **rollout ∈ 某一个 session（归属关系）**
一个 session 包含多个 rollout->>>
- 一个 session 非常大（长对话）
- 不好读取 / 性能差
- 按天拆分后：
- 单文件更小
- 读写更快
sessions = Agent 执行日志（完整链路）
运行中的 Agent 状态
sessions/  
  └── session-xxx/  
        ├── state.json  
        ├── steps.json
👉 用于：
- 长任务
- 恢复执行
我现在的sessions内部是按照年月日归档为各种【/sessions/2026/04/24/rollout-2026-04-24T14-50-32-019dbe41-20da-73e2-ae97-a5e365a58037.jsonl】
一个 rollout 文件 = 一次完整 Agent 执行

**session = 一次连续对话的上下文容器**  
**rollout = 这次对话里，模型每一步“怎么想 + 怎么做”的展开轨迹**
> **session rollout 就是模型在一次任务中“从输入到最终输出”的完整推理与执行轨迹，相当于 agent 的调用链。**
一个完整的 rollout，通常包含这些阶段👇
```text
用户输入  
  ↓  
构造 context（memory + spec + 输入）  
  ↓  
LLM 推理（可能多步）  
  ↓  
决定是否调用工具（tool / skill）  
  ↓  
执行工具  
  ↓  
观察结果（observation）  
  ↓  
再次推理（循环）  
  ↓  
最终输出

### 一个 rollout 可能长这样：
Thought: 我要先查数据库  
Action: 执行 SQL 查询  
Observation: 返回数据  
  
Thought: 数据不完整，需要补充  
Action: 再查另一张表  
Observation: 返回结果  
  
Thought: 已足够  
Final Answer: 输出 SQL
👉 这一整条链路，就是 **rollout**
```

```text
概念   ｜   含义
session｜整个对话生命周期
rollout｜session 中一次“执行过程”

👉 一个 session 里可以有多个 rollout：
session  
├── rollout #1（第一次提问）  
├── rollout #2（继续追问）  
└── rollout #3（新任务）
```


### 7️⃣ `skills/`
能力模块
skills/  
  └── xxx/  
      └── SKILL.md
👉 定义：
- 能做什么
- 怎么用工具
我的项目中有skills_backup是skills 的备份目录；Codex 在升级 / 修改 skills 时自动做的备份；不参与运行，确定不用的话可以删除

### 8️⃣ `agents/`
子 Agent
agents/  
  └── xxx-agent.md
👉 定义复杂流程
### 9️⃣ `tmp/ / bash/`
tmp/  
bash/
作用：
LLM生成命令 → 写成bash → 执行 → 记录
👉 本质是：
> 执行过程产物（不是备份）
# 3、项目目录：.codex/
在你的代码仓库中：
```text
project/  
├── .codex/  
│   ├── config.toml  
│   ├── skills/  
│   ├── agents/  
│   ├── tools/  
│   └── AGENTS.md
作用：
- 覆盖全局配置
- 团队共享
- 项目级 Agent 定义
```
## 关于我的项目没有.codex/
### `.codex/` **不是必须的**
你一直能用 Codex，是因为：默认只用 ~/.codex（全局配置）
### 什么时候才会有 `.codex/`
只有当你主动：
- 想给项目定制配置
- 想加项目专属 skill / agent
- 或手动创建
才会出现：mkdir .codex
### 所以你现在的状态是
你 = 用“全局模式”在用 Codex
👉 没有问题，但：
不可复用 / 不可团队共享


# 4、**codex的启动流程**
总体启动链路（核心结论版）
```text
1. 进程启动（CLI/App）  
2. 读取本地配置（config / env / profile）  
3. 身份认证（ChatGPT / API Key）  
4. 初始化项目上下文（workspace / repo）  
5. 加载记忆体系（memory / history / session）  
6. 加载 Agent 相关（AGENTS.md / skills / MCP）  
7. 构建 Context（prompt + memory + tools）  
8. 等待用户输入 / resume session
```
## 1、三层结构（优先级从低到高）
```
① 全局层（Global / Home）② 项目层（Project / Workspace）③ 会话层（Session / Runtime）
全局定义“通用能力”  
项目定义“具体做法”  
session负责“当前状态”
```
👉 覆盖规则：
```
Session > Project > Global
```
##### 所有东西放到这个模型里
你关心的这些：
- config
- AGENTS.md
- skills
- memory
- history
- session
**全部可以映射到三层：**
### ✅ Global（放通用能力）
```
~/.codex/  AGENTS.md（第一性原理 / 思考框架）  skills/    thinking.md    analysis.md
```
### ✅ Project（放业务）
```
project/  AGENTS.md（业务流程）  skills/    sql-generator.md    debug-flow.md  memories/    db-structure.md
```
### ✅ Session（不管）
👉 用完就总结成 memory
## ① 全局层（Global）
位置（典型）：
```
~/.codex/
```
包含：
- config（默认配置）
- global AGENTS.md
- global skills
- global memory（长期习惯）
- MCP 全局配置
👉 特点：
- 跨项目复用
- 通用能力（类似“第一性原理 agent”）
## ② 项目层（Project）
位置：
```
project-root/
```
包含：
- 项目 AGENTS.md
- 项目 skills
- 项目 memory
- 项目配置（如 model override）
👉 特点：
- 针对当前项目定制
- 比 global 更具体
## ③ 会话层（Session）
位置：
```
.codex/sessions/.codex/history/
```
包含：
- 当前对话
- rollout
- 临时上下文
👉 特点：
- 最实时
- 不可复用（除非摘要成 memory）
## 2、完整加载顺序（你要的“总+项目+所有”）
下面是**真实可用的加载链路（按执行顺序）**：
### 🔵 第1步：加载全局 config
```
~/.codex/config.toml
```
👉 定义默认行为
### 🔵 第2步：加载项目 config（覆盖全局）
```
project/.codex/config.toml
```
👉 覆盖：
- model
- sandbox
- tools
### 🔵 第3步：加载全局 Memory
```
~/.codex/memories/
```
👉 比如：
- 你的编码习惯
- 通用 workflow
### 🔵 第4步：加载项目 Memory（覆盖 / 叠加）
```
project/.codex/memories/
```
👉 更具体：
- 项目业务知识
- 表结构理解
### 🔵 第5步：加载 Session / History（最高优先级）
```
.codex/sessions/.codex/history/
```
👉 当前上下文
### 🔵 第6步：加载 AGENTS.md（关键）
加载顺序：
```
global AGENTS.md        ↓project AGENTS.md（覆盖/追加）
```
👉 合并规则：
- project 优先
- global 作为 fallback
### 🔵 第7步：加载 Skills
```
global skills        ↓project skills（优先）
```
👉 同名 skill：
👉 project 覆盖 global
### 🔵 第8步：加载 MCP（工具）
```
global MCP        ↓project MCP（覆盖/新增）
```
### 🔵 第9步：构建最终 Context（最核心）
```
Context =  用户输入+ session+ project memory+ global memory+ project agent+ global agent+ project skills+ global skills+ tools schema
```
👉 注意顺序：
👉 越靠上优先级越高
## 3、一个“优先级叠加图”（非常重要）
```
┌──────────────────────┐
│ 用户输入（最高）       │
├──────────────────────┤
│ Session（当前对话）    │
├──────────────────────┤
│ Project Memory        │
├──────────────────────┤
│ Global Memory         │
├──────────────────────┤
│ Project AGENT         │
├──────────────────────┤
│ Global AGENT          │
├──────────────────────┤
│ Project Skills        │
├──────────────────────┤
│ Global Skills         │
├──────────────────────┤
│ Tools（MCP）          │
└──────────────────────┘
```
## 4、几个你会踩的坑（很关键）
### ❗1. AGENTS.md 不是“替换”，而是“叠加”
👉 很多人误解：
```
project agent 会完全替换 global agent
```
❌ 实际：
👉 是 merge + override
### ❗2. memory 是“叠加”，不是覆盖
👉 project memory 不会删除 global memory
👉 只是：
```
更相关 → 更容易被用
```
### ❗3. skill 冲突时才覆盖
👉 只有“同名 skill”才会：
```
project > global
```
否则：
👉 全部都会存在（一起被 LLM 选择）
### ❗4. session 永远最高优先级
👉 所有设计的最终目标：
```
不要让 session 爆炸
```
（你之前问“session 变差”就是这里）


# 5、一次任务的真实执行流程
> 假设你输入：codex "帮我修复订单表异常数据"
## Step 1：构建 context
context =  
  system instructions  
+ 你的输入  
+ 最近 history（裁剪）  
+ tools 索引  
+ skills / agents 索引
## Step 2：第一次推理（决策）
模型输出：
- 直接给答案  
或  
- 决定调用工具  
或  
- 先给一个简要计划
## Step 3：进入 Agent Loop
### 3.1 思考
需要查数据库
### 3.2 调工具
db.query("select ...")
### 3.3 执行
Codex 执行工具 → 得到结果
### 3.4 记录
写入 rollout（tool_call + tool_result）
### 3.5 再思考
发现字段缺失 → 需要修复
👉 循环继续
## Step 4：结束条件
- 模型输出 final answer  
或  
- 达到步数/时间限制
## Step 5：输出结果
terminal 展示
## Step 6：落盘
~/.codex/  
├── history.jsonl（追加）  
├── sessions/rollout-xxx.zip（完整记录）

# 6、agent.md和skill.md的本质区别
角色完全不同：
SKILL.md = “会做什么（能力）”  
AGENT.md = “怎么做（流程）”
SKILL = 工具说明（tool usage pattern）
AGENT = 工作流（workflow / orchestration
## 核心区别（最重要）

|维度|SKILL.md|AGENT.md|
|---|---|---|
|本质|能力说明|流程编排|
|粒度|单点能力|多步骤任务|
|是否有顺序|❌ 没有|✅ 有明确步骤|
|是否强约束执行|❌ 弱（建议）|✅ 强（流程）|
|典型用途|写SQL / 查日志 / 调API|故障修复 / 数据处理 / 自动化流程|
## SKILL（单能力）
## sql-fixer skill  
当用户需要修复SQL问题时：  
1. 先 SELECT 查询数据  
2. 分析异常原因  
3. 生成 UPDATE SQL  
4. 执行前必须确认  
工具：  
- db.query  
- db.execute
👉 特点：
没有“必须按顺序执行”  
只是告诉模型：怎么做这类事
## AGENT（流程）
### invoice-repair-agent  
目标：修复发票系统异常  
流程：  
1. 查询异常单据  
2. 分类问题类型  
3. 针对每类生成修复方案  
4. 执行修复SQL  
5. 验证结果  
约束：  
- 必须逐步执行  
- 每步都要验证
👉 特点：
明确流程 + 强约束
### 执行时的差异（关键理解）
#### 使用 SKILL
模型自己决定：  
什么时候用？  
用几次？  
用哪个？
👉 比较“自由”
#### 使用 AGENT
模型被限制在：  
这个流程里执行
👉 比较“可控”


# 7、codex cli的session使用案例：
**背景：因为我以前没有根据项目目录打开codex的习惯，所以导致重新打开的时候都会重新聊天，重新处理需求，这其实是不对的**
## 7.1、用已有session绑定目录
1、在任意目录执行：codex resume；找出合适的session-id，并记录下来；
如果列表很多，可以用更直接的方法：ls ~/.codex/sessions/（文件名里通常包含时间或 id）
1.2、进入你的项目目录：cd project-A；并执行：codex resume <你的session-id>
1.3、以后的启动方式：在 project A 里**只用这个命令启动**；codex resume --last；这样就可以自动续上你刚才绑定的那个 session
1.4、额外：可以搞一个快捷指令：alias cx="codex resume --last"；
以后就直接：
cd project-A  
cx
1.5、固定session启动：
project-A/run-codex.sh  
codex resume <你的session-id>
以后直接进入项目：./run-codex.sh
## 7.2、进入一个项目绑定唯一session
1、首次进入：codex
2、后面进入：codex resume/codex resume seesionId（要记住才行，不记就用前面那个）
## 7.3、多个项目绑定多个session操作；
进入：
project-A → session-A  
project-B → session-B
使用的时候：（项目 = 上下文容器（人为绑定））
cd project-A  
codex resume session-A  
cd project-B  
codex resume session-B
## 7.4、同一个项目多个任务同时进行；
### 1、场景 1：同一个项目中，功能A / B 互不冲突（必须隔离）
开始的时候：
```text
窗口1（功能A）  
cd project-A  
codex resume <session-A>  
  
窗口2（功能B）  
cd project-A  
codex resume <session-B>
```
迭代时怎么做
```text
功能A继续开发：
    codex resume <session-A>
功能B继续开发：   
    codex resume <session-B>
```
### 2、场景2:同一个项目中，功能C/D互相影响（需要共享）
窗口3：session-CD（主）  
窗口4：临时 codex（实验）
👉 用 **resume 固定一个 session**
窗口3:
```text
cd project-A  
codex resume <session-CD>
```
窗口4：临时实验窗口
```text
👉 直接开：问一些问题即可，不会污染原上下文
codex
也可以用/fork；
这样在原来的上下文做一个尝试
```

## 7.5、session的半自动化能力
**不能重新命名，可以自己做映射**
### 方案 A：脚本绑定（最实用）
```text
run-CD.sh  
codex resume 7f9f9a2e-xxx

run-A.sh  
codex resume 123abc-xxx
```
👉 你看到的就是“命名 session”

### 方案 B：alias
```text
alias ccd="codex resume 7f9f9a2e-xxx"  
alias ca="codex resume 123abc-xxx"
```
### 方案 C：文档记录
```text
session映射：  
  
C：7f9f9a2e  
D：8a1b2c3d  
CD：9x8y7z6
```

### 7.6、长期使用一个sessionId变差怎么解决
长期复用同一个 `sessionId`，**确实很容易“变差”**（上下文越来越长、噪音累积、模型注意力被稀释）。核心思路不是放弃 session，而是**控制进入 context 的内容**。
> **不要让“全部历史”进入 context，只让“必要信息”进入。**
> - **截断（只保留最近对话）**
>- **摘要（把旧内容压缩成 memory）**
>- **重启（在关键节点切新 rollout / session）**

1、截断：
2、摘要
3、重启：就是用一个新的session，不用旧的了；总结为memory，再新打开session即可

综上：还是定期整理memory，然后打开新的session做需求比较好；

# 8、各个命令讲解
## 8.1、/resume
resume作用就是重新打开上一次的聊天记录
方式1：选择历史
codex resume
方式2：直接回到最近一次
codex resume --last
方式3：指定 session
codex resume 【session-id】
### 底层原理：
Codex 会把每次会话存到本地：~/.codex/sessions/；里面是：jsonl 日志（完整对话记录）
👉 `resume` 做的事情就是：读取日志 → 重新塞进模型 context → 继续推理

```text
codex：new chat
resume：继续原会话
fork：从原会话“分叉”一个新会话
codex resume：会列出当前工作目录相关的历史会话
codex resume --last：`--last` 会跳过选择，直接进入最近一次 session
resume 是“按目录找”，--last 是“全局找”
```
 **`codex resume --last` 默认是“全局最近 session”，不是按目录隔离的**
所以： **不同目录执行 → 很可能得到同一个 session **
❗以下有两个重要的场景：
#### 情况 1：你用 `resume --last`
```text
cd /project-A  
codex resume --last

cd /project-B  
codex resume --last

👉 结果：
两个地方打开的是同一个 session（最近的那个）
```
### 情况 2：你用 `resume`
```text
cd /project-A  
codex resume
👉 只会看到：
project-A 的 session

cd /project-B  
codex resume
👉 只会看到：
project-B 的 session
```
比较好的解决方案：
#### 👉 每个项目绑定一个 session

```text
#### project-A  
alias ca="codex resume <A-session>"  
#### project-B  
alias cb="codex resume <B-session>"

 👉 使用方式
cd project-A  
ca  
  
cd project-B  
cb
```
## 8.2、memory
Codex 的 memory 有三种生成方式：
### A、手动创建（最稳定、最推荐）
直接用命令：
/memories add
或者在对话里说：
请把这段总结记录为 memory
👉 Codex 会：
- 提取你当前对话中的关键信息；生成一条结构化 memory；存到 `memories/` 目录
### B、半自动生成（需要触发）
在某些情况下 Codex 会提示你：
Do you want to save this as memory?
👉 常见触发条件：你做了“总结”；出现稳定规则（例如接口规范、数据库约束）；明确的“以后都要这样做”
👉 但注意：不会默认自动保存（避免污染 memory）
### C、你显式引导生成（推荐方式）
这是最实用的：
帮我把当前功能C的结论整理成 memory/提取这个项目的关键约束，写入 memory
👉 这样生成的质量最高
### 存的是什么
memory = 可复用的结构化上下文片段
```text
{
  "title": "订单表约束",
  "content": "订单表必须保证 xxx",
  "tags": ["db", "constraint"]
}
```
### memory 在什么时候会被使用
根据当前问题 → 检索相关 memory → 注入 context--->可以类比为：轻量版 RAG（检索增强）

### memory 应该写到什么粒度（过粗 vs 过细）
> **memory 的最佳粒度 = “可直接用于决策/生成”的规则级信息（而不是故事，也不是原始细节）**
memory/  
├── project.md （长期规则）  
├── domain.md （领域知识）  
└── task.md （当前任务）