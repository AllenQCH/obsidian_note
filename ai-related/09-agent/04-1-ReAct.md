---
title: "04-1-ReAct"
source: "ReAct: Synergizing Reasoning and Acting in Language Models；Allen 与笨笨整理"
author: "Allen / 笨笨"
published:
created: 2026-05-07
description: "解释 ReAct 与 Reasoning、Tool Calling 的层次关系：Reasoning 是思考能力，Tool Calling 是行动机制，ReAct 是推理、行动和观察交替运行的 Agent 执行策略。"
tags: ["obsidian-note", "tech-note", "agent", "react", "reasoning", "tool-calling", "agent-loop"]
type: "tech-note"
status: "processed"
---

# 04-1-ReAct

## 摘要

**ReAct ≠ Reasoning。**

ReAct 会使用 Reasoning，但它本身不是模型的推理能力。更准确地说：

- **Reasoning**：回答“怎么想、如何分析和决策”。
- **Tool Calling**：回答“如何调用工具与外部世界交互”。
- **ReAct**：回答“按照什么循环反复思考、行动、观察和调整”。

因此，ReAct 应归类为一种 **Agent Loop / Execution Strategy（执行策略）**，而不是与 LLM、Memory、Reasoning、Tool Calling 并列的基础能力。

> Reasoning 是能力，Tool Calling 是行动机制，Observation 是环境反馈，ReAct 是把三者组织成闭环的执行模式。

## 核心内容

### 一、ReAct 的原始含义

ReAct 来自论文 _ReAct: Synergizing Reasoning and Acting in Language Models_。

名称由两部分组成：

```text
Reason + Act
```

它表达的不是：

```text
ReAct = Reasoning
```

而是让模型把推理和行动交错起来：

```text
Reason / Thought
-> Action
-> Observation
-> Reason / Thought
-> Action
-> Observation
-> ...
-> Final Answer
```

经典表示方式：

```text
Thought
-> Action
-> Observation
-> Thought
-> Action
-> Observation
```

它像一个“边走、边看、边调整”的执行者，而不是先在内部一次性想完全部步骤。

### 二、Reasoning 与 ReAct 的关系

| 概念 | 本质 | 回答的问题 | 是否必须使用工具 |
| --- | --- | --- | --- |
| Reasoning | 模型或人的分析、推断、规划和决策能力 | 怎么想？ | 否 |
| Tool Calling | 选择并调用外部工具的机制 | 怎么做？ | 是 |
| Observation | 工具或环境返回的新事实 | 实际发生了什么？ | 通常来自外部交互 |
| ReAct | 组织 Reasoning、Action、Observation 的循环策略 | 按什么流程持续想和做？ | 典型 ReAct 通常包含行动或环境交互 |

Reasoning 可以独立存在。例如：

```text
问题
-> 内部分析
-> 直接回答
```

这个过程属于 Reasoning，但没有外部行动和 Observation，因此不是完整的 ReAct。

ReAct 则要求推理能够影响行动，并让行动结果反过来修正后续决策：

```text
Reasoning
-> 决定调用工具
-> Tool Calling
-> Observation
-> 根据新事实继续 Reasoning
```

### 三、一个天气推荐示例

```text
User:
北京今天适合去哪里？

Thought / Reason:
需要先确认北京当前天气。

Action:
get_weather(city="北京")

Observation:
今天有雨，气温 18～23℃。

Thought / Reason:
下雨时更适合推荐室内活动。

Final Answer:
今天可以优先考虑国家博物馆、首都博物馆等室内场所。
```

这里：

- 判断需要天气信息，是 Reasoning。
- `get_weather(...)` 是 Tool Calling / Action。
- 天气结果是 Observation。
- 根据天气调整推荐，是下一轮 Reasoning。
- 整个闭环才是 ReAct。

### 四、为什么有些教程把 ReAct 讲成 Reasoning

主要有三个原因。

#### 原因 1：ReAct 的第一步就是 Reason

名称中的 `Reason` 很容易被直接等同于 `Reasoning`。实际上，Reasoning 是 ReAct 循环中使用的一种能力，不是整个循环本身。

#### 原因 2：不同框架使用不同术语

常见表达包括：

```text
Thought -> Action -> Observation
```

```text
Reasoning -> Tool Calling -> Tool Result
```

```text
Thinking -> Tool -> Result
```

这些表达都可能描述类似的 Agent 交互循环，但术语相似不代表概念层次完全相同。

只有当工具结果重新进入模型上下文，并影响下一轮判断时，才形成典型的 ReAct 闭环。

#### 原因 3：现代 Agent 经常隐藏中间推理

开发者可能只看到：

```text
agent.run(question)
```

内部执行过程可能是：

```text
LLM 决策（内部）
-> Tool
-> Observation
-> LLM 决策（内部）
-> Finish
```

框架可能不会公开模型的完整内部思考过程，只展示：

- 工具调用。
- 工具结果。
- 最终回答。

所以界面上看起来像：

```text
User -> Tool -> Result
```

但运行时仍可能存在“模型决策—工具执行—结果回传—继续决策”的循环。

需要注意：**隐藏 Reasoning 不等于没有 Reasoning；但一次简单工具调用也不必然构成 ReAct。**

### 五、为什么现代 Agent 更常单独强调 Reasoning

现代推理模型本身已经具备较强的：

- 问题分解。
- 规划。
- 分析与判断。
- 反思与纠错。
- 工具选择决策。

因此，描述 Agent 能力时常使用：

```text
LLM
Reasoning
Memory
Tool Calling
```

而不是：

```text
LLM
ReAct
Memory
Tool Calling
```

原因是两组概念不在同一个层次：

| 层次 | 典型内容 |
| --- | --- |
| 模型/生成核心 | LLM |
| 认知能力 | Reasoning、Planning、Reflection |
| 状态与上下文 | Memory、Context、State |
| 外部交互能力 | Tool Calling、Retrieval、Computer Use |
| 执行策略 | ReAct、Plan-and-Execute、ReWOO |
| 编排与运行载体 | LangGraph、LangChain、自研 Agent Runtime、Harness |

ReAct 仍然重要，只是更适合放在“执行策略”这一层，而不是当成模型本身的核心能力。

### 六、推荐的分层理解

```text
Agent
|
|-- LLM：理解与生成核心
|-- Reasoning：分析、规划、判断与决策能力
|-- Memory / State：保存上下文和任务状态
|-- Tool Calling：与外部世界交互
|
`-- Execution Strategy
    |
    |-- ReAct
    |   `-- Reason -> Action -> Observation -> Reason ...
    |
    |-- Plan-and-Execute
    `-- 其他 Agent Loop
```

另一种更强调运行闭环的表示：

```text
             ReAct Loop
+-----------------------------------+
| Reasoning                         |
|    |                              |
|    v                              |
| Action / Tool Calling             |
|    |                              |
|    v                              |
| Observation                       |
|    |                              |
|    +------> 下一轮 Reasoning       |
+-----------------------------------+
```

### 七、ReAct 与其他概念不要混淆

#### ReAct 与 Chain-of-Thought

- Chain-of-Thought 关注推理过程。
- ReAct 关注推理与外部行动如何交替。
- 只有 Thought、没有 Action 和 Observation，通常不属于完整 ReAct。

#### ReAct 与 Tool Calling

- Tool Calling 是一次或多次工具调用机制。
- ReAct 是决定何时调用、如何读取结果、是否继续行动的循环策略。
- 一次固定流程中的函数调用不一定是 ReAct。

#### ReAct 与 Plan-and-Execute

| ReAct | Plan-and-Execute |
| --- | --- |
| 边执行边思考 | 先形成整体计划再执行 |
| 每一步都可根据 Observation 调整 | 主要按计划推进，必要时重规划 |
| 适合探索性、信息不完整的任务 | 适合步骤较多、目标较清晰的长任务 |
| 容易产生过多调用或局部绕行 | 初始计划错误时可能整体偏离 |

实际系统可以混合两者：先做高层计划，再让每个步骤内部使用 ReAct。

#### ReAct 与 LangChain / LangGraph

- ReAct 是模式。
- LangChain、LangGraph 是实现或承载这种模式的框架。
- Harness、Agent Runtime 可以在更上层提供权限、状态、观测、测试和质量门禁。

因此：

> ReAct 不是 LangChain 专属，也不是 LangGraph 专属；框架是载体，ReAct 是运行策略。

### 八、ReAct 的适用场景与局限

#### 适用场景

- 需要搜索、浏览器、数据库或代码工具的开放任务。
- 任务开始时信息不完整，需要逐步探索。
- 每一步的结果都会影响下一步选择。
- 错误后需要根据真实 Observation 调整策略。

#### 主要局限

- 可能反复调用工具，成本和延迟较高。
- 容易局部搜索过深或绕圈。
- 长任务如果缺少计划、状态和停止条件，容易漂移。
- 错误 Observation 会污染后续判断。
- 必须配合最大步数、超时、权限、参数校验和终止条件。

#### 常见工程补强

```text
ReAct
+ Task State
+ Step Limit
+ Tool Permission
+ Structured Observation
+ Retry / Timeout
+ Evaluation / Gate
```

## 可执行动作

设计 Agent 时，可以按以下问题判断是否需要 ReAct：

1. 任务是否需要真实的外部信息或系统操作？
2. 工具结果是否会改变下一步决策？
3. 执行路径是否无法在开始时完全确定？
4. 是否允许模型在多轮工具调用之间动态调整？
5. 是否设置了最大步数、工具权限、失败处理和终止条件？

最小伪代码：

```python
state = initial_request

for step in range(max_steps):
    decision = model.decide(state)

    if decision.is_final:
        return decision.answer

    observation = tools.execute(
        decision.tool,
        decision.arguments,
    )

    state = state.with_observation(observation)

raise MaxStepsExceeded()
```

判断标准：

> 如果系统只是调用一次预先确定的工具，它更像 Tool Calling；如果系统根据每次 Observation 决定下一步做什么，它才更接近 ReAct。

## 相关链接

- [[04-0-运行模式]]
- [[04-2-Plan-and-Execute]]
- [[Function Tool Calling 学习]]
- [[01-langgraph]]
- [[02-langchain]]
- [[03-harness]]
- [[04-loop engineering]]
- [[00-Agent Runtime总览]]
