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
