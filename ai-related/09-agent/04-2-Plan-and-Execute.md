---
title: "04-2-Plan-and-Execute"
source: "ai-related/03-agent/04-2-Plan-and-Execute.md"
author: "Allen"
published: 
created: 2026-05-07
description: "这是另一种 agent 模式。核心是："
tags: ["obsidian-note", "tech-note", "agent", "harness"]
type: "tech-note"
status: "processed"
---
这是另一种 agent 模式。核心是：

**先整体规划，再按步骤执行**

典型过程：

1. Planner 先生成计划
2. Executor 按计划逐步执行
3. 必要时重规划

LangChain 官方专门写过这类 agents，明确把它作为一种不同于传统 ReAct 的设计路线，并且现在是用 LangGraph 来承载这些 planning agents。

所以它和框架的关系也是：

- **Plan-and-Execute 是模式**
- **LangGraph / LangChain 是实现它的框架**
- **Harness 可以作为企业运行平台承载这种模式的 agent**

像一个先列清单再干活的执行者：

- 先做全局规划
- 再一步步落实
- 更适合复杂长任务
- 但如果初始计划错了，后面可能一路偏

# 04-2-Plan-and-Execute

## 摘要

- 待整理。

## 核心内容

- 待补充。

## 可执行动作

- [ ] 待确认。

## 相关链接

- [[04-0-运行模式]]
- [[1、agent.md与agent的区别；]]
