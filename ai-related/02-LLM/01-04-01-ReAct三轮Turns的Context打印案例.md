---
title: "01-04-01-ReAct三轮Turns的Context打印案例"
created: 2026-07-21
tags: ["obsidian-note", "tech-note", "context", "llm", "react", "agent"]
type: "case-note"
status: "processed"
aliases: ["ReAct 三轮 Turns 的 Context 打印案例", "minimal ReAct agent context trace"]
---

# 01-04-01-ReAct三轮Turns的Context打印案例

## 摘要

- 这个案例展示了一个 minimal ReAct agent 在 3 次用户输入中的 prompt / context 打印结果。
- 每一次用户输入都会重新渲染一份完整 prompt，把长期记忆、历史对话、技能说明、工具目录、当前用户输入和中间步骤放进模型可见上下文。
- 计算类问题会先调用 `calculator`，得到 `Observation` 后再进入下一次模型调用，最后用 `final` 输出答案。
- agent 的长期记忆和历史对话会跨用户轮次保留；ReAct 中间步骤主要服务于当前问题的推理闭环。

## 背景

用户正在做一个 minimal ReAct agent demo。这个 agent 会把每次模型调用前的 prompt 和 context 都打印出来，用来观察模型到底看到了什么。

长期记忆中有两条偏好：

```text
User prefers transparent agent demos that print prompt and context.
Keep implementations small before introducing frameworks.
```

加载的调试技能是：

```text
Skill: react_debugging

When debugging this ReAct agent:

1. Inspect the rendered prompt before judging model behavior.
2. Check whether the action name exactly matches an available tool.
3. Check whether Action Input is valid JSON.
4. Check whether the observation contains enough information for final.
```

可用动作是：

```text
calculator
clock
search_notes
final
```

MCP 工具目录中展示了：

```text
filesystem.read_file
browser.search
```

## 三次用户输入

### 第 1 次：hi

当前用户输入：

```text
hi
```

模型输出：

```text
Thought: I have enough information from the current context to answer.
Action: final
Action Input: {"answer": "I received your message: hi"}
```

最终回答：

```text
I received your message: hi
```

这一轮没有使用工具，因为普通问候不需要外部观察结果。

### 第 2 次：1+1 = ？

当前用户输入：

```text
1+1 = ？
```

第 1 步模型输出：

```text
Thought: The user is asking for a calculation, so I should use the calculator.
Action: calculator
Action Input: {"expression": "1+1"}
```

工具返回：

```text
Observation: 2
```

第 2 步模型输出：

```text
Thought: I have enough information from the current context to answer.
Action: final
Action Input: {"answer": "2"}
```

最终回答：

```text
2
```

这一轮说明：当问题需要工具时，第一次模型调用只决定动作；工具结果会作为 `Observation` 拼回下一次 prompt / context，模型再基于这个观察结果输出最终答案。

### 第 3 次：2+2=

当前用户输入：

```text
2+2=
```

此时历史对话已经包含：

```text
- user: I want a minimal ReAct agent.
- assistant: We built a small Python ReAct loop that prints prompt and context.
- user: hi
- assistant: I received your message: hi
- user: 1+1 = ？
- assistant: 2
```

第 1 步模型输出：

```text
Thought: The user is asking for a calculation, so I should use the calculator.
Action: calculator
Action Input: {"expression": "2+2"}
```

工具返回：

```text
Observation: 4
```

第 2 步模型输出：

```text
Thought: I have enough information from the current context to answer.
Action: final
Action Input: {"answer": "4"}
```

最终回答：

```text
4
```

这一轮说明：新问题开始时，agent 会把前面已经完成的用户 / assistant 对话放进历史上下文，但不会把上一轮内部的 calculator 调用细节当作普通历史对话展示给模型。

## Context 拼接结构

从打印结果看，每次模型调用前的上下文大致是：

```text
固定规则
- ReAct loop 规则
- 可用 action 列表
- final 的输出格式要求

当前上下文
- Long-term memory
- Conversation history
- Loaded skills
- MCP tool catalog
- Current user

当前问题的 ReAct 中间过程
- Step 1 Thought / Action / Action Input
- Observation
- Next step
```

普通问题一轮结束：

```text
user input
-> model chooses final
-> answer
```

工具问题两步结束：

```text
user input
-> model chooses calculator
-> tool observation
-> model chooses final
-> answer
```

## 对 Context 的理解

这个案例可以用来说明 Context 不是单独一句 prompt，而是一次模型调用时可见的完整工作现场。

它至少包含 5 类内容：

1. 固定系统规则：告诉模型必须使用 ReAct 格式，动作只能从白名单中选。
2. 长期记忆：保存跨会话或跨任务的用户偏好。
3. 对话历史：保存已经完成的用户输入和 assistant 最终回答。
4. 技能说明：给模型提供当前任务的调试检查清单。
5. 临时步骤：保存当前 ReAct 循环中的 Thought、Action、Action Input 和 Observation。

## 关键观察

- `Action` 名称必须精确匹配可用动作，例如 `calculator`，不能写成 `calculate`。
- `Action Input` 必须是合法 JSON，例如 `{"expression": "2+2"}`。
- `Observation` 是模型调用工具后的结果，会被放回下一轮 prompt。
- 当 `Observation` 已经足够回答问题时，下一步应该选择 `final`。
- `final` 的 `Action Input` 也必须符合约定：`{"answer": "..."}`。

## 和 LLM Context 的关系

这个 demo 把抽象的 Context 概念具体化了：

- Prompt 模板决定每次上下文的骨架。
- Memory 决定哪些长期信息会被带入。
- Conversation history 决定模型能看到哪些已完成对话。
- Tool observation 决定模型能不能基于外部执行结果继续推理。
- ReAct trace 决定当前任务的中间状态如何被显式保存。

所以，对 agent 来说，Context Engineering 不是只写一句好 prompt，而是设计每次模型调用前到底要拼哪些信息、按什么顺序拼、哪些信息保留到下一轮、哪些信息只在当前任务中临时存在。

## 相关链接

- [[01-04-00-LLM-Context]]
- [[01-03-LLM-Prompt]]
- [[01-06-00-LLM-Memory]]
- [[04-1-ReAct]]
