---
title: "04-harness engineering 文章时间线"
source: "6 篇公开文章整理：Anthropic / Mitchell Hashimoto / OpenAI / Martin Fowler / LangChain"
author: "Allen"
published:
created: 2026-05-11
description: "围绕 harness / harness engineering / agent harness 的代表性文章时间线与阅读索引。"
tags: ["obsidian-note", "tech-note", "harness", "harness-engineering", "agent", "reading-list", "timeline"]
type: "tech-note"
status: "processed"
---
饿，
# 04-harness engineering 文章时间线

## 摘要

这篇笔记把 6 篇与 **harness / harness engineering / agent harness** 相关的公开文章按发布时间整理成时间线，方便后续持续沉淀、对比观点和补充新材料。

## 时间线（按发布时间从早到晚）

1. **Anthropic — Effective harnesses for long-running agents**  
   - 日期：2025-11-26  
   - 链接：https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents

2. **Mitchell Hashimoto — My AI Adoption Journey**  
   - 日期：2026-02-05  
   - 链接：https://mitchellh.com/writing/my-ai-adoption-journey

3. **OpenAI — Harness engineering: leveraging Codex in an agent-first world**  
   - 日期：2026-02-11  
   - 链接：https://openai.com/index/harness-engineering/

4. **Martin Fowler — Harness Engineering - first thoughts**  
   - 日期：2026-02-17  
   - 链接：https://martinfowler.com/articles/exploring-gen-ai/harness-engineering-memo.html

5. **LangChain — The Anatomy of an Agent Harness**  
   - 日期：2026-03-10  
   - 链接：https://langchain.com/blog/the-anatomy-of-an-agent-harness

6. **Anthropic — Harness design for long-running application development**  
   - 日期：2026-03-24  
   - 链接：https://www.anthropic.com/engineering/harness-design-long-running-apps

## 一句话理解每篇文章

### 1. Anthropic — Effective harnesses for long-running agents
- 更偏 **长时间运行 agent 的工作支架设计**。
- 重点通常会落在：上下文切换、持久化状态、恢复机制、长任务执行质量。

### 2. Mitchell Hashimoto — My AI Adoption Journey
- 更像是 **个人/工程实践视角**，讲自己如何逐步把 AI 真正用进日常开发。
- `Step 5: Engineer the Harness` 很关键，说明光有模型不够，关键是把工作流和边界搭好。

### 3. OpenAI — Harness engineering: leveraging Codex in an agent-first world
- 更偏 **内部工程团队如何围绕 Codex 搭建 agent-first 开发工作方式**。
- 重点是：不是单纯“问答式用模型”，而是把模型放进一个可执行、可迭代、可交付的工程 harness 里。

### 4. Martin Fowler — Harness Engineering - first thoughts
- 更偏 **概念辨析和方法论整理**。
- 适合用来理解：为什么软件工程领域开始单独讨论 harness engineering，它和 prompt / context / tooling 的关系是什么。

### 5. LangChain — The Anatomy of an Agent Harness
- 更偏 **把 agent harness 拆成结构组件来讲**。
- 适合理解 agent harness 的组成部分，比如任务编排、持久化、上下文管理、工具调用、行为约束。

### 6. Anthropic — Harness design for long-running application development
- 更偏 **面向实际应用开发的 harness 设计**。
- 重点是如何把长时间运行、前后端协作、自主软件工程这些复杂任务放进稳定的执行框架里。

## 这 6 篇文章可以怎么分层理解

### 第一层：为什么需要 harness
- [[03-harness engineering]]
- Martin Fowler
- Mitchell Hashimoto

这层回答的是：
- 为什么不能只靠聊天框
- 为什么 agent 不是“模型 + prompt”就够
- 为什么真正落地需要执行环境、状态管理和工作流边界

### 第二层：harness 到底由什么组成
- LangChain
- Anthropic（2025-11-26）

这层回答的是：
- harness 的核心组件是什么
- 长任务 agent 为什么必须有 durable storage / context management / recovery
- 什么叫对 agent 友好的执行支架

### 第三层：harness engineering 如何用于真实开发
- OpenAI
- Anthropic（2026-03-24）

这层回答的是：
- 如何把 harness 真正接进 coding / app development 流程
- 如何支持 long-running autonomous work
- 如何让 agent-first workflow 具备交付能力

## 建议阅读顺序

如果目的是 **先建立整体理解**，建议按下面顺序读：

1. Mitchell Hashimoto  
2. Martin Fowler  
3. LangChain  
4. Anthropic（2025-11-26）  
5. OpenAI  
6. Anthropic（2026-03-24）

### 原因
- Mitchell：先从个人开发工作流视角建立直觉
- Fowler：再补方法论和概念框架
- LangChain：把 agent harness 拆开看结构
- Anthropic（2025-11-26）：看长时运行 agent 的底层难点
- OpenAI：看 agent-first coding 的工程落地
- Anthropic（2026-03-24）：看更完整的 long-running app dev harness 设计

## 当前可沉淀出的共同主题

- **Harness ≠ Prompt**：重点不在单条提示词，而在任务运行环境。
- **Harness ≠ 单个 Agent SDK**：它更像一层工作支架 / 控制平面 / 执行框架。
- **长任务是分水岭**：任务一旦跨多轮、多文件、多上下文窗口，harness 设计就变成核心。
- **真正价值在工程闭环**：状态、工具、日志、恢复、边界、评估，缺一不可。
- **Agent-first 开发需要新的工程方法**：模型不是附加插件，而是执行流中的主体之一。

## 后续整理建议

下一步可以把这组文章继续拆成 3 类笔记：

1. **概念笔记**  
   - 什么是 harness  
   - 什么是 harness engineering  
   - 什么是 agent harness

2. **结构笔记**  
   - durable storage  
   - context management  
   - recovery / retry  
   - tool sandbox / execution boundary

3. **实践笔记**  
   - coding agent workflow  
   - long-running app development  
   - agent-first engineering team

## 相关链接

- [[03-harness engineering]]
- [[ai-related/09-agent/03-harness]]
- [[01-prompt engineering]]
- [[02-context engineering]]
