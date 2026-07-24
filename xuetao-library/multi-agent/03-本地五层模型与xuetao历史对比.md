---
title: "本地五层模型与xuetao历史对比"
aliases: ["本地五层模型与xuetao历史对比"]
source: "Git history: my-multi-agents/02-我的agents原理/我的五层模型和Xuetao对比.md"
author: "Codex"
published:
created: 2026-07-20
description: "归档早期本地五层目标模型与 Xuetao 原型的职责对比；本地目标结构现已失效。"
tags: ["codex", "agent", "xuetao", "comparison", "archive"]
type: "note"
status: "archived"
---

# 本地五层模型与xuetao历史对比

## 摘要

这篇从 Git 中恢复，记录 2026-07-20 时的设计比较。表中的“本地目标模型”已经被当前四层运行架构替代，只用于理解演进过程。

## 历史对比

| 关注点 | Xuetao 原型 | 当时的本地目标 |
| --- | --- | --- |
| 入口选择 | Router / selector 类角色 | 独立请求 Router |
| 流程定义 | planner、任务说明或 harness | 曾计划把 Workflow 注册成 Agent |
| 流程推进 | 多个协调角色共同完成 | 单一 Orchestrator 持有状态 |
| 专业阶段 | planner、implementer、reviewer | Stage 按职责拆分 |
| 工具调用 | 各类 operator | Tool Agent 治理能力调用 |
| 放行判断 | reviewer、policy 或校验逻辑 | 单一 Gate Evaluator 执行规则 |

## 已失效部分

- Workflow 现在是状态机定义，不注册 Agent。
- 当前运行时采用 Control、Stage、Tool、Gate 四层，不再称“五层 Agent”。
- Agent ID 不再统一追加 `_agent`；以当前注册表中的真实 ID 为准。

## 仍有价值的原则

- 每个角色只对一种决定或产物负责。
- 工具结果必须是结构化、可复现的证据。
- Gate 不凭聊天印象放行。
- 外部写入、生产动作和发布保留明确授权边界。

## 相关链接

- [[xuetao multi-agent总览]]
- [[xuetao multi-agent设计原则]]
- [[当前运行架构和统一流程]]
