来由：不是 LLM 突然支持了 agent.md，而是 Agent 框架开始“约定式加载 agent.md”
# 1、agent.md与agent的区别；
```text
Agent ≠ agent.md
Agent = 运行中的“执行体”（一个会做事的系统）  
agent.md = 定义这个执行体行为的“说明书”（配置/Prompt）
agent.md 是 Agent 的“人格 + 工作流程设定”
```
## 1️⃣ Agent（真正的东西）
👉 是“活的”
Agent = 一个正在运行的任务执行体
它包含：
- LLM（决策）
- loop（循环执行）
- tools（工具）
- context（上下文）
- memory（history + session）
👉 举例：
当你执行：
codex "修复订单问题"
👉 实际上：
启动了一个 Agent
## 2️⃣ agent.md（你看到的文件）
👉 是“死的”
agent.md = 定义 Agent 行为的 Prompt 模板
一个典型 agent.md：
```text
invoice-repair-agent 
目标：  
修复发票异常  
流程：  
1. 查询数据  
2. 分析原因  
3. 生成SQL  
4. 执行  
5. 验证  
约束：  
- 必须按顺序执行  
- 每步必须验证
```
👉 它的作用：
```text
告诉 Agent：  
“你应该怎么做这件事”
```

# 2、agent产品的变化
### 以前（早期 Codex）
```text
- 只有：
    - prompt（你输入）
    - context（上下文）
- 没有“角色文件”的概念
- 你要写“你是一个xxx工程师…”这种都写在 prompt 里
```
### 现在（Claude Code / 新版 Codex / Cursor）
多了一层：
```text
用户输入  
   ↓  
Agent（编排层）  
   ↓（加载 agent.md / skill / tool）  
拼接 context  
   ↓  
LLM 推理
```
# 3、agent.md 本质是什么？
👉 **一个“结构化 prompt 模板”，但不是直接给 LLM，而是先被 Agent 读取**
典型内容：
```text
# Role
你是一个后端工程师
# Goals
解决生产问题
# Constraints
不能直接执行破坏性 SQL
# Workflow
1. 先分析日志
2. 再定位问题
3. 再生成方案
```
### 为什么现在“突然支持”了？
因为这些工具做了三件事：
1. **定义规范（约定）**
    - agent.md / skills/xxx.md
2. **实现加载逻辑（Agent层）**
    - 自动读取文件
3. **动态拼接 context 给 LLM**
👉 所以结论：
> **agent.md 的支持，是 Agent 工程能力，不是 LLM 本身能力**

|能力|属于谁|
|---|---|
|理解 agent.md 内容|LLM|
|读取 agent.md 文件|Agent|
|决定何时用 agent.md|Agent|
|按 agent.md 执行流程|LLM + Agent 协同|
> agent.md = Agent 写给 LLM 的“操作说明书”

# 4、Codex 启动后，agent.md 是怎么进入系统的？
## 1）启动阶段（初始化扫描）
Codex（或类似工具）启动时会做一件固定的事：
```text
扫描工作目录  
  ↓  
查找 agents/ 目录  
  ↓  
加载所有 agent.md  
  ↓  
构建 Agent Registry（注册表）
```
## 2）agent.md 被解析成什么？
不是原样文本直接用，而是被结构化：
```text
agent.md  
  ↓  
解析（parser）  
  ↓  
结构化对象（AgentSpec）
```
典型结构：
```text
AgentSpec:  
  name  
  description  
  goals  
  constraints  
  workflow  
  tools（可选）  
  examples（可选）
```
## 3）注册进一个“候选池”
```text
Agent Registry:  
  - agent_A  
  - agent_B  
  - agent_C
```
👉 到这里为止：
> agent.md **只是被加载，还没有参与执行**

# 5、什么时候用到agent.md，怎么选择agent.md
## 1）什么时候会“用到 agent.md”？
触发点只有一个：
👉 **用户输入**
```text
用户输入  
  ↓  
Agent Router（路由器）  
  ↓  
选择一个 agent.md（或不选）
```
## 2）多个 agent.md 时：是谁在选择？
👉 **是 Agent 系统在选，但“判断能力”来自 LLM**
**Agent提供候选，LLM做判断，Agent执行选择**
### Step 1：构造“候选 agent 列表描述”
系统会把所有 agent 做成一个摘要（不是全文）：
```text
可用 agents：  
1. agent_A：  
   描述：处理数据库问题  
2. agent_B：  
   描述：处理前端问题  
3. agent_C：  
   描述：处理运维问题
```
### Step 2：连同用户输入，一起发给 LLM
```text
Prompt：  
用户问题：  
xxx  
可选 agents：  
A：xxx  
B：xxx  
C：xxx  
问题：  
应该选择哪个 agent？
```
### Step 3：LLM 返回选择结果
```text
LLM 输出：  
选择 agent_A
```
### Step 4：Agent 系统执行选择
```text
selected_agent = agent_A
```
## 3）如何选择/判断依据是什么
👉 本质是：**语义匹配（不是规则匹配）**
只基于三类信息：
### 1）用户输入语义
例如：
“帮我修复数据库数据问题”
### 2）agent.md 的 description / goals
例如：
agent_A:  
  处理数据库问题
### 3）（有些系统支持）关键词 / tags
例如：
tags: [db, sql, data]

# 6、选中 agent.md 后，怎么“用”？

## 1）：把 agent.md 注入 context
不是简单拼接，而是“结构化注入”：
```text
System Prompt +=  
你现在是：  
[agent_A]  
你的目标：  
...  
你的约束：  
...    
你的流程：  
1.  
2.  
3.
```
## 2）：形成最终输入给 LLM
```text
[System]  
agent.md 内容  
[User]  
用户问题
```
## 3）：LLM 开始推理执行
👉 LLM 并不是“执行文件”，而是：**根据 agent.md 的描述进行推理**
# 7、执行过程中 agent.md 起什么作用？
持续作用在整个推理周期中：
## 1）约束行为
Constraints:  
不能执行危险 SQL
→ LLM 在生成时会规避
## 2）引导流程
Workflow:  
1. 查日志  
2. 查数据  
3. 修复
→ LLM 会“倾向”按这个顺序思考
## 3）控制输出风格
必须输出 SQL + 解释
👉 注意：
> **agent.md 只影响“思考”，不控制“执行”**

# 8、执行是如何推进的？
```text
循环过程：
LLM 输出  
  ↓  
Agent 解析（是否需要 tool）  
  ↓  
执行 tool（如果有）  
  ↓  
结果返回  
  ↓  
再次调用 LLM（带新上下文）
```
agent.md 在这里的作用：👉 每一轮推理都在 context 中持续生效

# 9、为什么可能选错 agent？
👉 **选择完全依赖 LLM 的语义理解**
可能出现：
- 描述不清 → 选错
- 多个 agent 重叠 → 随机性
- prompt 不稳定 → 波动
## 常见优化手段
只围绕 agent.md：
### 1）写清 description（最重要）
❌ 处理问题  
✅ 专门处理 MySQL 数据修复问题
### 2）增加边界
只处理数据库问题，不处理前端
### 3）加入 examples（强提示）
示例：  
用户：修复订单数据  
→ 使用本 agent

# 10、完整流程总结（从启动到执行）
```text
① 启动  
扫描 agents/  
加载 agent.md  
注册 Agent Registry  
② 用户输入  
↓  
构建候选 agent 列表  
③ LLM 选择 agent  
↓  
返回 agent_X  
④ Agent 系统加载 agent_X  
↓  
注入 context  
⑤ LLM 执行  
↓  
生成结果（可能多轮）  
⑥ 返回给用户
```

# 11、agent（包含main+sub）+skill配合使用
本质是：
```text
main-agent（流程控制）
    ↓
选择 sub-agent
    ↓
sub-agent 执行（携带对应 skill）
```
结论分三点：
1. **可以显著减少 context 体积（成立）**
2. **可以降低幻觉概率（成立，但不是绝对）**
3. **核心价值是“职责拆分 + 按需加载”，而不是单纯结构好看**

核心是三层解耦：
```text
[调度层] main-agent  
[领域层] sub-agent  
[能力层] skill
```
## 1）agent.md 负责什么？
👉 **“做什么 + 大流程怎么走”**
```text
main-agent.md  
Goals:  
完成问题修复  
Workflow:  
1. 分析问题类型  
2. 选择子 agent  
3. 汇总结果
```
## 2）skill 负责什么？
👉 **“某一类问题具体怎么做（可执行能力）”**
```text
skill: fix_sql_issue   
步骤：  
1. 查表  
2. 生成 SQL  
3. 校验
```
## 3）sub-agent 负责什么？

👉 **“一个领域的执行专家（= agent + skill组合）”**
```text
db-sub-agent.md  
Goals:  
处理数据库问题  
Skills:  
- fix_sql_issue  
- query_data
```

## 完整执行流程（重点）
### Step 1：用户输入进入 main-agent
用户：修复订单数据异常
### Step 2：main-agent 做“任务拆解 + 路由”
main-agent 推理：   
这是数据库问题  
→ 选择 db-sub-agent
### Step 3：只加载“被选中的 sub-agent”
👉 关键点：
❌ 不加载所有 agent + 所有 skill  
✅ 只加载 db-sub-agent
### Step 4：sub-agent 决定使用哪些 skill
db-sub-agent 推理：  
需要：  
- query_data  
- fix_sql_issue
### Step 5：执行 skill（多轮循环）
LLM → 调用 skill  
Agent → 执行  
→ 返回结果  
→ 再推理
### Step 6：结果返回 main-agent 汇总
main-agent：  
整合结果 → 输出

**优势：**
降低幻觉：因为context更少更干净
减少token：减少context开销

