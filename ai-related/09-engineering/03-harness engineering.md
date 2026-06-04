---
title: "03-harness engineering"
source: "ai-related/09-engineering/03-harness engineering.md"
author: "Allen"
published:
created: 2026-05-07
description: "harness engineering 的概念入口笔记，连接时间线、方法论与工程实践。"
tags: ["obsidian-note", "tech-note", "harness", "harness-engineering", "agent"]
type: "tech-note"
status: "processed"
---

# 03-harness engineering

## 摘要

harness engineering 关注的不是“怎么把 prompt 写漂亮”，而是 **怎么为 agent / coding model 搭建一个可长期运行、可恢复、可观测、可交付的执行支架**。

## 核心内容

### 什么是 harness engineering
- 可以把它理解为：围绕模型与 agent 的 **工程运行框架设计**。
- 重点不是模型本体，而是：
  - 上下文如何组织
  - 工具如何调用
  - 状态如何持久化
  - 失败如何恢复
  - 任务如何分解与持续推进

### 为什么它会变重要
- 聊天式 AI 适合一次性问答。
- 但一旦进入真实开发、长任务执行、多轮编辑、多文件修改，问题就不再是“回答得像不像”，而是“能不能稳定把事做完”。
- 这时候，harness 本身就变成关键工程对象。

### 可以把它和这些概念区分开
- [[01-prompt engineering]]：更关注提示输入设计
- [[02-context engineering]]：更关注上下文组织与注入
- [[ai-related/08-agent/03-harness]]：更偏 agent / 平台 / 执行框架视角
- harness engineering：站在更完整的工程方法层，关注整条执行链路

## 当前文章索引

- [[04-harness engineering 文章时间线]]

这篇时间线笔记已经收录了 6 篇代表性文章：
- Anthropic（2025-11-26）
- Mitchell Hashimoto（2026-02-05）
- OpenAI（2026-02-11）
- Martin Fowler（2026-02-17）
- LangChain（2026-03-10）
- Anthropic（2026-03-24）

## 可执行动作

- [ ] 继续把 6 篇文章分别补成逐篇摘要笔记
- [ ] 单独整理 durable storage / context management / recovery 三个子主题
- [ ] 补一张“prompt engineering / context engineering / harness engineering” 对比图

## 相关链接

- [[04-harness engineering 文章时间线]]
- [[ai-related/08-agent/03-harness]]
- [[01-prompt engineering]]
- [[02-context engineering]]
