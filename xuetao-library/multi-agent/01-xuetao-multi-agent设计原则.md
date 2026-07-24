---
title: "xuetao multi-agent设计原则"
aliases: ["xuetao multi-agent设计原则"]
source: "/Users/heytea/Documents/xuetao的agetns/.codex"
author: "Codex"
published:
created: 2026-06-05
description: "归档 Xuetao 原型中的注册、路由、工具、门禁和证据设计原则。"
tags: ["codex", "agent", "workflow", "xuetao", "research"]
type: "workflow"
status: "archived"
---

# xuetao multi-agent设计原则

## 摘要

Xuetao 原型的价值不在 Agent 数量，而在于把“谁决定下一步、谁取得证据、谁执行、谁检查”拆开，并通过注册表、结构化合同和风险边界连接起来。本地体系只吸收这些原则，不复制原型的角色数量和名称。

## 原型的四个稳定机制

| 机制 | 解决的问题 |
| --- | --- |
| 注册表 | 角色从哪里加载、可被谁调用 |
| Workflow/Router | 当前任务处在哪个流程和阶段 |
| 结构化合同 | 上下游如何稳定交换事实、决定和缺口 |
| Gate/Review | 证据不足、风险过高或产物不完整时如何停止 |

## 原型的一般执行方式

```text
入口角色识别任务
-> 规划或调查角色确定证据需求
-> selector/operator 选择并调用能力
-> 实现或分析角色产出结果
-> reviewer/gate 检查
-> 记录证据与收口状态
```

来源工程中的 `workflow_router`、`dbauto_operator`、`trace_log_operator` 等名称是原始标识，不是本地目标 ID。

## 最值得保留的原则

1. Router 只做分类，不亲自查询或修改外部系统。
2. 工具执行返回事实和证据，不决定业务流程是否完成。
3. 调查先提出可证伪假设，再按成本和区分度收集证据。
4. Reviewer/Gate 与实现者分离，避免自己证明自己正确。
5. 外部写入、发布和生产动作在执行前保留明确授权。
6. 结论、证据、缺口和下一步使用结构化输出，不散落在长对话中。

## 本地实现采用的变化

- Workflow 是 Orchestrator 使用的状态机定义，不单独注册 Agent。
- 入口 Router 和长任务 Orchestrator 是两个职责不同的 Control Agent。
- 只注册一个 `gate_stage_evaluator`，不同门禁作为规则集。
- 具体工具能力通过公共 Skill、Script 或 MCP 调用，旧 `tool_*` 不再激活。
- 不引入独立 subflow，等真实重复场景出现后再增加。

## 相关链接

- [[xuetao multi-agent总览]]
- [[xuetao agent分层]]
- [[本地五层模型与xuetao历史对比]]
