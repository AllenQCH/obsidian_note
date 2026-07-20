---
title: "01-04-LLM-Context"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/上下文context"
author: "Allen"
published:
created: 2026-05-11
description: "LLM 上下文的定义、组成和设计原则。"
tags: ["obsidian-note", "tech-note", "context", "llm", "context-engineering"]
type: "tech-note"
status: "processed"
aliases: ["context", "Context 学习"]
---

# 01-04-LLM-Context

## 摘要

- Context 是模型处理当前请求时能看到的全部文本信息。
- 它包括系统指令、历史对话、当前输入和参考材料。
- 上下文既是工作台，也是短期记忆，但受窗口长度限制。

## 核心内容

### Context 是什么

LLM 的上下文是模型在处理当前请求时能看到和考虑的全部文本信息。

通常包括：

- 系统指令：角色、行为规范、安全边界。
- 历史对话：当前会话里之前的问答。
- 当前输入：用户最新问题或指令。
- 参考材料：文档、数据、代码、工具返回结果。

### 如何理解 Context

| 比喻 | 含义 |
|---|---|
| 工作台 | 当前任务需要的材料都放在上面 |
| 短期记忆 | 模型只能基于窗口里的内容回答 |
| 滑动窗口 | 容量有限，新内容进来，旧内容可能被推出去 |

### 设计原则

- 重要信息放前面或靠近任务处。
- 避免把无关历史塞满窗口。
- 长任务需要摘要、分段和检索机制。
- 工具结果要精简，避免让噪声污染推理。

## 可执行动作

- [ ] 和 `Prompt 学习`、`memory 学习` 建立交叉链接。
- [ ] 补一篇 Context Engineering 实战笔记。

## 相关链接

- [[01-01-LLM-总览]]
- [[01-03-LLM-Prompt]]
- [[01-06-LLM-Memory]]
- [[02-context engineering]]

## 开源 Agent 中的 Context 拼接案例

案例项目：[timlrx/simple-ai-agents](https://github.com/timlrx/simple-ai-agents)

这个项目比较适合看基础 agent 的 context 组装逻辑，因为它没有复杂的 prompt builder，而是直接在一次请求前把 `messages` 列表拼好，再传给 LiteLLM。

### 拼接逻辑在哪里

核心位置在：

- `simple_ai_agents/chat_session.py`
- 类：`ChatLLMSession`
- 方法：`prepare_request()`

普通聊天时，它会根据是否已有历史消息来组装 `history`：

```python
if response_model:
    history = [
        {"role": "user", "content": prompt},
    ]
elif self.messages:
    history = [{"role": "system", "content": system or self.system}]
    for msg in self.messages:
        history.append({"role": msg.role, "content": msg.content})
    history.append({"role": "user", "content": prompt})
else:
    history = [
        {"role": "system", "content": system or self.system},
        {"role": "user", "content": prompt},
    ]
```

所以它的基本顺序是：

```text
system
历史 user / assistant messages
当前 user prompt
```

然后在 `gen()` 里把这个 `history` 传给模型：

```python
completion(
    model=model,
    messages=history,
    tools=tool_schemas,
    ...
)
```

这里的 `messages=history` 就是一次模型调用真正接收到的 context 主体。

### 多轮情况下如何拼接

假设第一轮：

```text
User: Generate 2 random numbers between 0 to 100
Assistant: 17 and 83
```

这两条会被保存到 `self.messages`。

第二轮用户问：

```text
User: Which of the two numbers is bigger?
```

实际传给模型的 `history` 大致是：

```text
system: You are a helpful assistant.
user: Generate 2 random numbers between 0 to 100
assistant: 17 and 83
user: Which of the two numbers is bigger?
```

所以模型能理解 “the two numbers” 指的是上一轮生成的 `17` 和 `83`。

历史消息的保存逻辑在：

- `simple_ai_agents/models.py`
- 类：`ChatSession`
- 方法：`add_messages()`

核心逻辑是：

```python
self.messages.extend(messages)
```

在 `gen()` 完成后，它保存的是当前用户消息和最终助手消息：

```python
self.add_messages([user_message, assistant_message], save_messages)
```

### 带工具调用时如何拼接

如果模型第一次回答时触发 tool call，`gen()` 会做第二次模型调用：

```python
tool_history = self._handle_tool_response(response_message, tool_calls, tools)
history.extend(tool_history)

response = completion(
    model=model,
    messages=history,
    ...
)
```

工具返回内容由 `_handle_tool_response()` 组装，结构大致是：

```python
tool_history = [format_tool_call(response_message)]

for tool_call in tool_calls:
    function_message = {
        "tool_call_id": tool_call["id"],
        "role": "tool",
        "name": function_name,
        "content": function_response,
    }
    tool_history.append(function_message)
```

这时第二次模型调用的 context 顺序会变成：

```text
system
历史 user / assistant messages
当前 user prompt
assistant 的 tool_call 请求
tool 的执行结果
```

模型再基于这个扩展后的 context 生成最终回答。

一个关键细节：这个项目默认只把 `user_message` 和最终的 `assistant_message` 存入 `self.messages`。工具调用过程中的 `tool_history` 只是临时拼到本次请求里，不会默认保存进下一轮历史。

### 从这个案例可以抽象出的规律

1. Context 不是单个 prompt，而是一个按角色组织的消息列表。
2. 当前用户 prompt 通常追加在最后，因为它是这次要回答的问题。
3. 历史对话按时间顺序放在当前 prompt 前面。
4. 工具调用会把 `assistant tool_call` 和 `tool result` 继续追加到同一次请求的上下文中。
5. 是否保存工具中间过程，是 agent 框架自己的设计选择；这个简单项目选择只保存最终对话结果。
