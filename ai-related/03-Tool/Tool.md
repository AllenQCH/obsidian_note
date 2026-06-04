---
title: "Tool 学习"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/tool 学习"
author: "Allen"
published:
created: 2026-05-11
description: "Tool 的定义、结构、工作原理和工程边界。"
tags: ["obsidian-note", "tech-note", "tool", "tool-calling", "agent"]
type: "tech-note"
status: "processed"
---

# Tool 学习

## 摘要

- Tool 是让 LLM 调用外部世界能力的标准化接口，本质是函数或 API 的抽象。
- Tool 不是智能和决策本身，它需要明确名称、结构化参数、结构化返回和确定行为。
- Agent 通过 Tool 把“想”变成“做”。

## 核心内容

### Tool 是什么

Tool = 让 LLM 能调用外部世界能力的标准化接口。

它不是逻辑、不是决策、也不是智能本身，而是一个可被模型调用的函数或 API。

### Tool 的四个特征

| 特征 | 说明 |
|---|---|
| 名字明确 | 表示这个工具做什么 |
| 参数结构化 | 告诉模型怎么调用 |
| 返回结构化 | 结果可被模型继续理解 |
| 行为确定 | 工具本身不自由发挥 |

### 示例

```text
get_weather(city)
query_db(sql)
send_email(to, content)
```

### 工作原理

1. 系统把可用 Tool 声明给 LLM。
2. LLM 判断是否需要调用 Tool。
3. LLM 输出工具名和参数。
4. 程序或框架执行工具。
5. 工具结果返回给 LLM。
6. LLM 基于结果继续推理或生成答案。

### 工程边界

- Tool 要做确定动作。
- LLM 负责判断和生成参数。
- 权限、审计、超时、错误处理必须在工具层实现。

## 可执行动作

- [ ] 为常用后端操作设计安全 Tool schema。
- [ ] 补 Tool 调用失败时的错误处理模式。

## 相关链接

- [[01-01-LLM-总览]]
- [[02-01-RAG-总览]]
- [[Function Tool Calling]]
- [[mcp]]
- [[00-agent introduction]]
