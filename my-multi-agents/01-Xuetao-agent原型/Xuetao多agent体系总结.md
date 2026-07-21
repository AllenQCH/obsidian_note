---
title: "Xuetao多agent体系总结"
source: "/Users/heytea/Documents/xuetao的agetns/.codex"
author: "Codex"
published:
created: 2026-06-05
description: "总结 Xuetao 原型的注册、路由、工具、门禁和证据设计原则。"
tags: ["codex", "agent", "workflow", "xuetao", "research"]
type: "workflow"
status: "processed"
---

# Xuetao多agent体系总结

## 摘要

Xuetao 原型的价值不在 Agent 数量，而在于把“谁决定下一步、谁取得证据、谁执行、谁检查”拆开，并通过注册表、结构化合同和风险边界连接起来。本地体系吸收这些原则，但使用自己的五类 Agent 和统一命名。

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

## 迁移到本地时的变化

- 本地显式增加 Workflow Agent，完整承载一类任务的阶段图。
- 本地把入口 Router 和长任务 Orchestrator 分成两个 Control Agent。
- 本地只保留一个 `gate_stage_evaluator_agent`，不同门禁作为规则集。
- 本地所有 Agent 用层前缀和 `_agent` 后缀。
- 本地暂不引入独立 subflow，等真实单独场景出现后再增加。

具体目标设计见 [[最新multi-agent流程总览]]、[[所有agent五层结构和统一流程]] 和 [[我的五层模型和Xuetao对比]]。
