---
title: "01-05-LLM-Temperature"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/temperature 学习"
author: "Allen"
published:
created: 2026-05-11
description: "Temperature 参数的含义、取值和使用建议。"
tags: ["obsidian-note", "tech-note", "llm", "temperature", "sampling"]
type: "tech-note"
status: "processed"
aliases: ["temperature", "Temperature 学习"]
---

# 01-05-LLM-Temperature

## 摘要

- Temperature 控制模型输出的随机性：低温更稳定，高温更多样。
- 开发、事实问答、数据抽取等严肃任务适合低温；创作、头脑风暴可适当升温。
- Temperature 与 `top_p` 都会影响采样，通常不要同时大幅调整。

## 核心内容

### Temperature 是什么

Temperature 是大语言模型生成文本时的采样参数，用来控制输出的随机性或创造性。

- 低 temperature：更确定、更保守、更稳定。
- 高 temperature：更多样、更有创意，但也更可能不稳定或跑偏。

### 典型取值

| Temperature | 行为特点 | 适合场景 |
|---|---|---|
| 0.1 - 0.3 | 确定性高、可重复、偏标准答案 | 代码生成、技术问答、事实摘要、数据提取 |
| 0.5 - 0.7 | 创造性和可靠性平衡 | 通用对话、内容创作、邮件草稿、头脑风暴 |
| 0.8 - 1.0+ | 高度多样、不可预测 | 小说、诗歌、广告标语、探索性创意 |

### 使用建议

- 严肃开发、分析、抽取：从低温开始。
- 内容创作、构思：使用中高温。
- 线上稳定任务：固定参数并做回归样例。

## 可执行动作

- [ ] 补一组同一 prompt 在不同 temperature 下的输出对比。
- [ ] 建立自己常用场景的默认参数表。

## 相关链接

- [[01-01-LLM-总览]]
- [[01-03-LLM-Prompt]]
