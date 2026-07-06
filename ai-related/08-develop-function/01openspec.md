---
title: "1、什么是openspec"
source: "ai-related/08-develop-function/07-01openspec.md"
author: "Allen"
published: 
created: 2026-05-07
description: "**OpenSpec** 是一套用于“规范驱动开发”的工具与方法论，目标是把**需求 → 设计 → 实现 → Agent执行**串成一条可自动化的链路。"
tags: ["obsidian-note", "tech-note", "agent", "skill", "tooling", "prompt", "llm", "openspec"]
type: "tech-note"
status: "processed"
---
# 1、什么是openspec
**OpenSpec** 是一套用于**规范驱动开发**的工具与方法论，目标是把**需求 → 设计 → 实现 → Agent执行**串成一条可自动化的链路。
核心思想：
- 用**结构化 spec（规范文件）**替代零散文档
- 让 **LLM / Agent 按 spec 执行，而不是自由发挥**
- 支持多人协作 + 可追溯 + 可复用

# 2、OpenSpec 的核心结构
初始化项目后通常会生成：
```text
.openspec/  
  ├── config.yaml        # 全局配置  
  ├── project.md         # 项目级说明  
  ├── AGENTS.md          # Agent能力声明  
  ├── specs/             # 所有规范文件  
  │    ├── xxx.md  
  │    ├── yyy.md
```
### 1️⃣ `config.yaml`
控制行为策略，例如：
- 默认 Agent
- 使用哪些模型
- 执行策略（严格/宽松）
### 2️⃣ `project.md`
描述：
- 项目背景
- 技术栈
- 约束（比如你常见的 Java + 微服务）
### 3️⃣ `AGENTS.md`
定义：
- 有哪些 Agent
- 每个 Agent 的职责
- 能使用哪些 tools / skills
示例：
## main-agent  
负责整体流程编排    
## sql-agent  
负责生成 SQL 和数据库操作
### 4️⃣ `specs/*.md`
这是 **核心**
一个 spec 通常包含：
# 功能名称  

## 背景  
为什么做    
## 输入  
输入数据结构  
## 输出  
输出结果  
## 约束  
必须遵守的规则  
## 执行步骤  
1. 查询数据库  
2. 处理数据  
3. 生成SQL  
## 验证  
如何判断正确
👉 本质：**把 prompt 固化成结构化 DSL**

## 、OpenSpec 的使用流程（重点）

### Step 1：初始化

openspec init

生成 `.openspec` 目录

---

### Step 2：创建 spec

/opsx:new

或手动写：

.openspec/specs/fix_invoice_issue.md

---

### Step 3：执行 spec

/opsx:apply fix_invoice_issue

执行过程：

用户命令  
   ↓  
读取 spec  
   ↓  
加载 AGENTS.md  
   ↓  
选择 agent  
   ↓  
执行 spec 步骤  
   ↓  
调用 skill / tool  
   ↓  
输出结果

## 四、Agent + OpenSpec 的执行机制（核心理解）

你之前问的关键点，这里给你讲清楚：

### 1️⃣ spec ≠ prompt

- prompt：一次性文本
- spec：**结构化执行计划**

👉 spec 更像：

Plan + Constraint + Contract

---

### 2️⃣ Agent 如何执行 spec

流程本质是：

spec → 转换为上下文 → LLM推理 → 决策下一步

关键点：

- Agent **不会逐行死执行**
- 而是：
    - 读取 spec
    - 结合上下文
    - 动态决策

👉 这就是你之前困惑的：

> “为什么会跳步骤？”

因为：  
👉 **执行者是 LLM，不是状态机**

---

### 3️⃣ 如果你想“强约束执行”

需要：

- 明确步骤依赖
- 写“必须执行”
- 或结合 **skill state**

例如：

## 执行步骤（必须按顺序执行）

# 五、HeyTea 需求改造协作流程

当用户提到 `openspec`、需求改造、多服务改动、先确认方案、先看 diff、确认分支、需求号/需求名、提交前人工复核，或希望按规范沉淀需求文档时，Codex 应使用 `openspec-demand-workflow`。

## 1、核心顺序

按下面顺序推进，不要跳步：

1. 需求确认
2. 方案确认
3. 代码 diff 确认
4. 执行确认
5. 编码与验证
6. 更新 OpenSpec
7. commit / push 特性分支

每一步操作前，先说明当前步骤、为什么做、会影响什么。需要人工复核时，展示 `git diff`、关键命令输出或文件内容，不只给摘要。

## 2、需求与分支确认

执行前必须向 human 确认：

1. 需求号
2. 需求名
3. 从哪个分支拉取
4. 目标特性分支名

分支规则：

- 分支名单独由 human 确认，不要默认把 OpenSpec change 名直接当成 git 分支名。
- 默认从主干分支拉取特性分支。
- 如果项目主干是 `master`，必须先同步远程 `master`，再基于最新主干创建新分支。
- 分支名参考项目历史分支风格，并尽量包含需求编码和需求名称。
- 需求编码缺失时，至少包含区域或模块、变更类型和业务对象。
- 创建或切换分支前，把来源分支、目标分支名、是否已同步远程主干发给 human 确认。

## 3、主干与 MR/PR 底线

- 允许在 human 明确确认后 commit / push 特性分支。
- 禁止自行创建 MR/PR。
- 禁止自行合并到 `master` 或其他主干分支。
- 禁止推动任何进入主干的流程。
- 合并、提 MR/PR、指定评审人、进入主干等动作必须由 human 或团队按内部流程处理。

## 4、OpenSpec change 命名

OpenSpec change 名必须使用：

```text
YYYY-MM-DD-需求号 需求内容
```

要求：

- 中文需求内容。
- 日期使用实际创建日。
- 需求号和需求内容都必须来自 human 明确确认。

## 5、完整 OpenSpec change 目录写法

每个实际改动过的服务仓库中至少包含：

- `.openspec.yaml`
- `proposal.md`
- `design.md`
- `tasks.md`
- `specs/<service-scope>/spec.md`

内容边界：

- 只在实际改动过的服务仓库中创建或更新 OpenSpec。
- 每个服务都写本服务自己的 OpenSpec。
- 不要把一份总 OpenSpec 复制到无关仓库。
- 如果一次需求改动多个服务，每个服务中的 `涉及服务` 清单必须保持一致。
- 当前服务的决策、改动文件、回归点只写当前服务内部内容。

## 6、轻量级 `openspec/*.md` 写法

如果项目使用轻量级 Markdown 规格文档，而不是完整 OpenSpec change 目录，则文件开头必须先写变更规格区，再写接口字段表或示例。

推荐结构：

```markdown
## Context

说明当前问题、入口、目标和明确的非目标。

## 分支名称

- 目标分支：`feature/example`
- 来源分支：从 `master` 拉取

## 涉及服务

- `service-a`
- `service-b`

## Decisions

1. 只写当前服务内部的实现决策或契约决策。

## Changed Files

- `src/main/java/...`

## Regression Focus

- 当前服务需要保护的行为。
```

规则：

- `涉及服务` 只写本次有代码改动的服务。
- 如果同一需求改动多个服务，每个服务文档中的 `涉及服务` 清单必须保持一致。
- `Decisions`、`Changed Files`、`Regression Focus` 只写当前服务内部内容，不替其他服务写决策或文件。
- `分支名称` 必须写目标分支和来源分支，方便复盘。
- 当同一个文件也承担接口文档职责时，把详细请求/响应字段表放在上述变更规格区之后。

## 7、验证规则

- 按项目实际技术栈和项目规则选择验证命令。
- Java 项目优先使用项目声明的 JDK 版本。
- 如果项目或 human 明确 Java 8，就用显式 `JAVA_HOME` 执行 Maven/Gradle 验证，不要默认使用当前 shell JDK。
- 验证失败时先定位根因，只做一次有依据的修复；仍失败则停止并说明阻塞点。

## 8、无效代码清理边界

- 修改代码时，可以删除本次改造引用链内暴露出的无效代码，例如无用 import、明显不可达分支或已失效的局部辅助逻辑。
- 清理范围必须限制在当前服务、本次触碰的调用链或引用链内。
- 不做跨模块、跨服务、无关文件的泛化清理。

## 摘要

- 待整理。

## 核心内容

- 待补充。

## 可执行动作

- [ ] 待确认。

## 相关链接

- [[Workspace Onboarding Rule]]
- [[dinghuotong 收货物流信息优化项目记忆]]
