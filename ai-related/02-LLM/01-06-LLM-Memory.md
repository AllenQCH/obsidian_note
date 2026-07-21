---
title: "01-06-LLM-Memory"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/memory 学习"
author: "Allen"
published:
created: 2026-05-11
description: "LLM 与 Agent 语境下 Memory 的类型、边界和工程设计。"
tags: ["obsidian-note", "tech-note", "llm", "memory", "agent", "context"]
type: "tech-note"
status: "processed"
aliases: ["memory", "Memory 学习"]
---

# 01-06-LLM-Memory

## 摘要

- Memory 有三种语境：模型推理时的 KV cache、上下文窗口里的历史文本、Agent 外部长期记忆。
- 真正可控、可持久化的是 Agent 长期 memory，通常存储在外部数据库、向量库或图数据库里。
- 没有 memory 的 Agent 无法跨步骤保留状态，也无法积累经验。

## 核心内容

### 三种 Memory

| 记忆类型 | 对象 | 技术本质 | 持久性 | 可控性 |
|---|---|---|---|---|
| Session 内 memory / KV cache | LLM | 模型推理的临时工作区 | 单次生成结束即消失 | 用户不可控 |
| 上下文窗口记忆 | LLM / 产品 | 将历史对话文本回传给模型 | 单次会话内有效 | 由产品策略控制 |
| Agent 长期 memory | Agent 系统 | 外部数据库、向量库、图数据库 | 可跨会话持久化 | 可设计、可查看、可编辑 |

### 为什么需要 Memory

没有 memory 的 Agent 会出现：

- 每一步都像第一次见你。
- 刚查完 DB，下一步就忘。
- 无法做多步推理。
- 无法总结经验。
- 无法跨任务保留偏好和背景。

### 工程设计要点

- 短期 memory 用于当前任务状态。
- 长期 memory 用于用户偏好、项目背景、历史结论和可复用经验。
- 不是所有内容都该记忆，必须有筛选、摘要、过期和删除机制。
- 记忆内容需要可追溯，否则会放大错误假设。

## 可执行动作

- [ ] 设计自己的 Agent memory 分层：session、project、user。
- [ ] 明确哪些内容不能写入长期 memory。

## 相关链接

- [[01-01-LLM-总览]]
- [[01-04-LLM-Context]]
- [[01-07-AI-Memory-GitHub资料整理]]
- [[00-agent introduction]]
