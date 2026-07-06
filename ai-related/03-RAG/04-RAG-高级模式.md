---
title: "02-07-RAG-高级模式"
source: "整理自 ai-related/02-LLM/RAG 原始长文归档.md"
author: "Allen"
published:
created: 2026-05-14
description: "GraphRAG、Agentic RAG、Self-RAG 等高级 RAG 模式的定位。"
tags: ["obsidian-note", "tech-note", "rag", "graph-rag", "agentic-rag"]
type: "tech-note"
status: "processed"
aliases: ["高级 RAG 模式"]
---

# 02-07-RAG-高级模式

## 摘要

- 高级 RAG 是在基础“检索 -> 生成”链路上增加规划、图谱、多轮检索、自我评估等能力。
- 这些模式适合复杂、多跳、跨文档的问题；不适合在基础检索还没做好时过早引入。
- 先把解析、切块、metadata、召回、重排和评估做好，再考虑高级模式。

## 核心内容

### GraphRAG

GraphRAG 会把知识整理成实体、关系和社区结构，再结合图谱检索回答问题。

适合：

- 多实体、多关系问题。
- 需要跨文档聚合的知识。
- 组织、人、系统、业务对象之间关系复杂的场景。

风险：

- 图谱构建成本高。
- 实体和关系抽取错误会传播。
- 不一定适合简单 FAQ 或单文档问答。

### Agentic RAG

Agentic RAG 让 Agent 决定如何检索：

- 是否需要检索。
- 检索哪个知识库。
- 如何改写 query。
- 是否多轮检索。
- 是否调用工具验证。

适合：

- 问题需要拆解。
- 需要跨多个知识源查证。
- 需要边查边判断下一步。

风险：

- 成本和延迟上升。
- 检索循环需要上限。
- 工具调用和权限边界要明确。

### Self-RAG

Self-RAG 强调模型对检索和生成结果做自我评估：

- 判断是否需要检索。
- 判断检索结果是否足够。
- 判断生成答案是否被证据支持。
- 证据不足时拒答或继续检索。

风险：

- 自我评估仍可能误判。
- 需要配合外部评估集验证。

### 选择原则

| 场景 | 优先模式 |
|---|---|
| 单文档或 FAQ | 基础 RAG |
| 同义表达多、关键词不稳定 | 混合检索 + Rerank |
| 跨多个实体和关系 | GraphRAG |
| 需要多步查证 | Agentic RAG |
| 需要低幻觉和拒答策略 | Self-RAG 思路 + 评估集 |

