---
title: "01-03-LLM-Prompt"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/Prompt 学习"
author: "Allen"
published:
created: 2026-05-11
description: "Prompt 的概念、结构、常见误区以及它与 RAG、Tool、Agent 的关系。"
tags: ["obsidian-note", "tech-note", "prompt", "llm", "context-engineering"]
type: "tech-note"
status: "processed"
aliases: ["prompt", "Prompt 学习"]
---

# 01-03-LLM-Prompt

## 摘要

- Prompt 不是一句提问，而是给 LLM 的完整任务环境：指令、上下文、约束和输出格式。
- 好的 Prompt 会让模型输出更稳定；坏的 Prompt 会让模型靠猜。
- Prompt 与 RAG、Tool、Agent 的关系是：这些机制都会改变或扩展模型当前看到的上下文。

## 核心内容

### Prompt 是什么

Prompt = 给 LLM 的输入指令 + 上下文 + 约束。

它不是一句简单问题，而是一份任务说明书。更准确地说，Prompt 是为了让 AI 正确完成任务而构造的输入环境。

### 常见误区

| 误区 | 更准确的理解 |
|---|---|
| Prompt 就是我问的一句话 | Prompt 是模型当前能看到的全部上下文 |
| Prompt 是提问技巧 | Prompt 更接近上下文工程 |
| LLM 会自己理解任务 | LLM 只会根据上下文预测下一段合理文本 |

### 为什么 Prompt 能影响输出

- 出现“你是专家”会让输出更偏专业语气。
- 出现“一步一步思考”会让推理更稳定。
- 出现“JSON 输出”会让格式更可控。

本质不是魔法，而是让概率分布向目标输出收敛。

### 标准结构

```text
System / Role：角色和能力边界
Task / Goal：任务目标
Context：背景、数据、约束材料
Constraints：限制条件
Output Format：输出格式
```

### 示例

```text
你是一个资深 Java 后端工程师，熟悉 MySQL 和高并发系统。

请分析下面 SQL 是否存在性能问题，并给出优化建议。

表结构：order(id, shop_no, status, created_time)
索引：idx_shop_no, idx_created_time
SQL：SELECT * FROM order WHERE shop_no IN (...)

限制：不要泛泛而谈，只从 SQL 和索引角度分析。
输出：问题点、原因、优化方案。
```

### Prompt 与 RAG / Tool / Agent

- RAG：把检索到的相关资料拼进 Prompt。
- Tool：把工具描述、参数 schema 和调用结果放进上下文。
- Agent：在每轮任务中不断构造新的 Prompt，用于分析、行动和总结。

## 可执行动作

- [ ] 把常用 Prompt 模板沉淀成 Obsidian 模板。
- [ ] 补一个 Java 后端代码审查 Prompt。

## 相关链接

- [[01-01-LLM-总览]]
- [[01-04-LLM-Context]]
- [[02-01-RAG-总览]]
- [[Tool]]
- [[01-prompt engineering]]
