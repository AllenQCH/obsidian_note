---
title: "00-Agent Runtime总览"
source: "conversation: Feishu 2026-07-12"
author: "Allen / 笨笨"
published:
created: 2026-07-12
description: "Agent Runtime 是位于用户和 LLM 之间、负责执行环境、工具调度、状态、记忆、上下文和循环控制的运行层。"
tags: ["ai-agent", "runtime", "agent-runtime", "architecture", "llm-infra"]
type: "note"
status: "processed"
---

# 00-Agent Runtime总览

## 摘要

Agent Runtime 可以理解为 **Agent 的运行环境（Execution Environment）**。

一句话记忆：

> LLM 负责思考（Reasoning），Runtime 负责执行（Execution）。

很多 Agent 入门图只写成：

```text
User
↓
LLM
↓
Tool
```

但真实工程架构更接近：

```text
User
│
▼
Agent Runtime
│
├── Planner
├── Memory
├── Tools
├── Hooks
├── State
├── Context
└── Loop
│
▼
LLM
│
▼
Model API
```

Runtime 位于 **用户和 LLM 之间**。它不是模型本身，而是让 Agent 能持续、可控、可观测地运行起来的那层执行系统。

## 核心内容

### 1. Runtime 是什么

Runtime 本质上是：

```text
管理运行过程的执行环境
```

它负责：

- 管理整个生命周期
- 控制执行流程
- 保存状态
- 调度工具
- 处理异常
- 管理 Memory
- 控制 Hook
- 控制循环（Loop）
- 控制权限与日志
- 在必要时调度多 Agent / Worker

可以类比传统编程语言：

| 编程体系 | Runtime |
| --- | --- |
| Java | JVM |
| Python | CPython |
| Node.js | Node Runtime |
| AI Agent | Agent Runtime |

对应关系：

```text
Java 代码
↓
JVM
↓
CPU
```

```text
Prompt / User Request
↓
Agent Runtime
↓
LLM + Tools
```

### 2. 为什么说真正执行 Tool 的不是 LLM

假设用户说：

```text
帮我分析 GitHub 项目，并生成总结。
```

真实发生的不是 LLM 自己去访问 GitHub，而是：

```text
用户
↓
Runtime 接收任务
↓
调用 LLM
↓
LLM 判断：需要 GitHub Tool
↓
Runtime 执行 GitHub Tool
↓
Runtime 拿到工具结果
↓
再次调用 LLM
↓
LLM 基于结果继续分析
↓
Runtime 输出最终结果
```

关键点：

> LLM 只是“提出工具调用意图”，真正执行 Tool 的是 Runtime。

这也是为什么 Agent 工程里需要 Tool Manager、Permission、Hook、Logger、State Manager：如果没有 Runtime，LLM 只能输出文本，不能可靠地执行动作。

### 3. Runtime 的典型模块

一个完整 Agent Runtime 通常可以拆成：

```text
Agent Runtime
├── Loop
├── Planner
├── Tool Manager
├── Memory Manager
├── Context Manager
├── Hook Manager
├── Event Bus
├── State Manager
├── Logger / Tracing
├── Permission
└── Scheduler
```

#### Loop：维护思考-行动-观察循环

Agent 的核心循环：

```text
Think
↓
Tool
↓
Observe
↓
Think
↓
Tool
↓
Observe
↓
Finish
```

这个循环不是模型自己维护的，而是 Runtime 维护的。

#### State Manager：保存任务状态

Runtime 要知道：

```text
当前任务：分析仓库
当前步骤：2 / 5
当前 token：13000
当前 memory：...
当前工具结果：...
```

这些状态决定下一轮 Context 如何组装，以及任务是否应该继续、重试、停止或升级给用户确认。

#### Context Manager：决定送给模型什么

Runtime 会把多种信息拼成下一次模型输入：

```text
聊天记录
+ System / Agent Prompt
+ Memory
+ Tool Result
+ 当前任务状态
+ 可用工具定义
↓
新的 Context
```

Context Manager 的难点在于：

- 哪些历史要保留
- 哪些内容要摘要
- 哪些 Memory 要注入
- 工具结果如何压缩
- token budget 如何控制

#### Tool Manager：执行真实工具

工具可能包括：

```text
Git
Filesystem
Browser
Python
MCP
HTTP
Database
Calendar / IM / Email
```

LLM 只会表达：

```text
请调用 Browser / GitHub / Filesystem
```

真正执行的是 Tool Manager。它还要负责 schema 校验、权限、错误处理、重试、结果回填。

#### Hook Manager：在关键节点插入规则

Hook 是 Runtime 提供的扩展点，例如：

```text
Before Tool
↓
检查权限
↓
允许 / 拒绝 / 要求确认
```

或者：

```text
After Edit
↓
自动格式化
↓
自动运行测试
```

所以 Hook 本质上不是 LLM 能力，而是 Runtime 在执行流程中开放的控制点。

#### Memory Manager：管理短期与长期记忆

Agent 常见记忆包括：

```text
Conversation Memory
Long-term Memory
Summary Memory
Scratchpad
Retrieved Notes
```

Memory Manager 要决定：

- 什么事实值得长期保存
- 当前任务需要召回哪些历史
- 旧对话如何摘要
- Memory 与当前 Context 如何合并

#### Scheduler：调度多 Agent / 多任务

尤其在 Multi-Agent 场景里，Runtime 还要负责调度：

```text
Planner
↓
Worker A
Worker B
Worker C
↓
Merge
```

Runtime 决定：

- 哪些任务可并行
- 哪些任务必须串行
- Worker 之间如何传递上下文
- 如何合并结果
- 如何处理失败与重试

### 4. 四层架构：Application、Runtime、Model、Infrastructure

理解 Agent Runtime 时，最重要的是不要把应用、运行层、模型层、基础设施混在一起。

```text
User
│
▼
Application（应用层）
│
▼
Agent Runtime（运行层）
│
▼
Model Provider（模型层）
│
▼
Infrastructure（基础设施）
```

| 层级 | 例子 | 主要职责 |
| --- | --- | --- |
| Application | Claude Code、Codex CLI、Cursor、Hermes、OpenHands | 面向用户的产品入口与交互体验 |
| Agent Runtime | Loop、State、Context、Planner、Memory、Tool、Hook、Scheduler | 让 Agent 稳定执行任务 |
| Model Provider | OpenAI、Anthropic、Google Gemini、DeepSeek | 提供模型推理能力 |
| Infrastructure | GPU、CUDA、Kubernetes、Redis、Postgres | 计算、存储、网络和底层服务 |

应用不等于 Runtime，模型也不等于 Runtime。

Runtime 是中间那层：它把用户意图、应用交互、模型推理、工具执行和外部系统连接起来。

### 5. Runtime 像 Agent 世界的操作系统

一个很好用的比喻：

```text
CPU
↑
Operating System
↑
Application
```

对应到 Agent：

```text
LLM
↑
Agent Runtime
↑
Your Agent / Agent Application
```

操作系统负责：

- 调度
- 内存
- 文件
- 权限
- IO
- 进程生命周期

Agent Runtime 负责：

- Tool
- Memory
- Loop
- Hook
- State
- Context
- Scheduler
- Permission

两者职责高度相似：都不是“思考者”本身，而是让复杂系统可运行、可调度、可恢复的执行环境。

### 6. 对应到常见 Agent 框架

| 框架 / 产品 | Runtime 体现在哪里 |
| --- | --- |
| OpenAI Agent SDK | Runner、Session、Tool Executor、Memory 等共同构成 Runtime |
| Hermes | Agent Engine / Workflow Engine / Tool Registry / Memory / Session / Cron / Gateway 等构成 Runtime |
| LangGraph | Graph Runtime，负责节点调度、状态流转和图执行 |
| Claude Code | CLI Runtime，管理工具、上下文、Hook、循环和权限 |
| Codex CLI | CLI Runtime，管理事件、Hook、工具执行、审批、上下文和补丁流程 |

它们 API 不同、目录不同，但底层都在回答同一个问题：

> 如何为 LLM 提供一个可靠的运行环境？

### 7. 阅读 Agent 框架源码时的统一检查表

以后看任何 Agent 框架，不要先陷进目录名，而是先问它的 Runtime 如何实现这些能力：

```text
Application
│
▼
Agent Runtime
├── Loop
├── State
├── Context
├── Planner
├── Memory
├── Tool Manager
├── Hook Manager
├── Event Bus
├── Scheduler
└── Logger / Tracing
│
▼
Model Provider
│
▼
Infrastructure
```

可以按下面问题读源码：

| 问题 | 观察点 |
| --- | --- |
| Loop 在哪里？ | 谁负责反复调用模型、工具、观察结果、判断结束？ |
| State 在哪里？ | 任务状态、步骤、工具结果、错误状态存在哪里？ |
| Context 怎么组装？ | system prompt、memory、history、tool result 如何进入模型输入？ |
| Tool 怎么注册和执行？ | schema、权限、执行器、异常、重试在哪里处理？ |
| Memory 怎么保存和召回？ | 短期、长期、摘要、检索分别在哪里？ |
| Hook 怎么挂？ | before / after tool、before / after edit、审批点在哪里？ |
| Event 怎么流转？ | streaming、日志、trace、observer 如何实现？ |
| Scheduler 怎么调度？ | 单 Agent、多 Agent、并行、串行、merge 如何实现？ |

## 可执行动作

- [ ] 后续读 OpenAI Agent SDK、Hermes、LangGraph、Claude Code、Codex CLI 源码时，都先按 Runtime 模块拆解，而不是按项目目录硬看。
- [ ] 把 `Loop / State / Context / Tool / Memory / Hook / Scheduler` 当成 Agent 框架源码阅读的固定检查表。
- [ ] 继续补一篇对比笔记：`Agent Runtime、LLM Runtime、Workflow Runtime 的区别`。
- [ ] 继续补一篇工程化笔记：`Runtime 为什么决定 Agent 是否可靠`。

## 相关链接

- [[LLM Runtime]]
- [[AI-runtime]]
- [[01-04-LLM-Context]]
- [[01-06-LLM-Memory]]
- [[Tool]]
- [[04-loop engineering]]
- [[03-harness engineering]]
- [[orchestration concept]]
- [[Hermes agent总览]]
