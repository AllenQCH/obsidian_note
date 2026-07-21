---
title: "01-02-LLM-Token"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/token 学习"
author: "Allen"
published:
created: 2026-05-11
description: "Token 的定义、影响范围和成本意识。"
tags: ["obsidian-note", "tech-note", "llm", "token", "cost"]
type: "tech-note"
status: "processed"
aliases: ["01-token", "Token 学习"]
---

# 01-02-LLM-Token

## 摘要

- Token 是 LLM 处理文本的基本单位，输入输出都会按 token 计量。
- Token 影响上下文窗口、响应速度和调用成本。
- 模型价格具有强时效性，使用前必须重新核验。

## 核心内容

### 为什么需要 Token

如果模型直接按字符处理，效率会很低。Tokenizer 会把文本切成 token，让模型用预定义词表中的 token id 进行计算。

### Token 是什么

Token 是 LLM 理解和生成文本的基本单位。

经验估算：

- 英文：约 `1 token ≈ 4 个字符` 或 `0.75 个单词`。
- 中文：约 `1 token ≈ 1-2 个汉字`，具体取决于 tokenizer。

### Token 影响什么

| 影响项 | 说明 |
|---|---|
| 上下文窗口 | 输入历史、文档、工具结果都占 token |
| 成本 | 大多数 API 按输入/输出 token 计费 |
| 速度 | token 越多，推理和传输越慢 |
| 记忆策略 | 超出窗口后需要摘要、检索或截断 |

### 成本意识

不要把历史对话、检索结果、工具返回和日志无节制塞进上下文。长任务需要做摘要、裁剪、分块检索和缓存。

## 可执行动作

- [ ] 整理一份当前真实可用模型的 token 价格表。
- [ ] 为常用 Prompt 建立 token 预算。

## 相关链接

- [[01-01-LLM-总览]]
- [[01-04-00-LLM-Context]]
- [[01-03-LLM-Prompt]]
