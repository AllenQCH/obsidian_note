---
title: "Function Tool Calling 学习"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/Function/Tool Calling 学习"
author: "Allen"
published:
created: 2026-05-11
description: "Function calling 与 tool calling 的区别和工程边界。"
tags: ["obsidian-note", "tech-note", "function-calling", "tool-calling", "tool", "agent"]
type: "tech-note"
status: "processed"
---

# Function Tool Calling 学习

## 摘要

- Function calling 是模型按结构输出函数名和参数；它本身不会执行函数。
- Tool calling 更接近完整工具使用流程：选择工具、生成参数、执行、把结果再交给模型。
- 二者区别在于执行责任和闭环程度。

## 核心内容

### 核心区别

| 能力 | Function Calling | Tool Calling |
|---|---|---|
| 模型做什么 | 生成调用意图和结构化参数 | 决定用哪个工具并参与调用流程 |
| 是否执行 | 不执行，执行逻辑在你的代码里 | 框架或 Agent 可能自动执行 |
| 输出形式 | 函数名 + arguments | 工具选择 + 参数 + 结果回传 |
| 所属层次 | 结构化输出能力 | 工具使用闭环的一部分 |

### Function Calling 示例

```json
{
  "name": "get_weather",
  "arguments": {"city": "Tokyo"}
}
```

这只是模型告诉你“应该调用什么”，真正执行仍在你的程序中。

### Tool Calling 流程

```text
LLM -> 选择工具 -> 生成参数 -> 执行工具 -> 工具结果 -> LLM 继续推理
```

### 工程理解

- Function calling 解决“结构化表达调用意图”。
- Tool calling 解决“把调用接进任务闭环”。
- Agent 在更上层决定什么时候继续调用、什么时候结束。

## 可执行动作

- [ ] 补一份 OpenAI/Claude 工具调用 API 对比。
- [ ] 整理工具调用的安全边界：权限、参数校验、审计、回滚。

## 相关链接

- [[Tool]]
- [[mcp]]
- [[00-agent introduction]]
