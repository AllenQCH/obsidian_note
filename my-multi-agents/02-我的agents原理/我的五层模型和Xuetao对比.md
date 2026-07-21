---
title: "我的五层模型和Xuetao对比"
source: "Xuetao agent原型资料; conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "比较 Xuetao 原型与本地五类 Agent 目标模型的职责，而不是复制命名。"
tags: ["codex", "agent", "workflow", "comparison"]
type: "workflow"
status: "processed"
---

# 我的五层模型和Xuetao对比

## 摘要

Xuetao 原型提供了“分离路由、阶段、工具与校验”的参考；本地模型进一步把完整任务类型显式建模为 Workflow Agent，并统一所有本地 Agent 的层级前缀与 `_agent` 后缀。两套体系应按职责比较，不能按文件名一一照搬。

## 对比

| 关注点 | Xuetao 原型 | 本地目标模型 |
| --- | --- | --- |
| 入口选择 | Router / selector 类角色 | `control_request_router_agent` 只选择 Workflow |
| 流程定义 | 分散在 planner、任务说明或 harness | 独立 `workflow_*_agent` 固化阶段图 |
| 流程推进 | 多个协调角色共同完成 | `control_stage_orchestrator_agent` 持有唯一状态 |
| 专业阶段 | planner、implementer、reviewer 等 | `stage_*_agent` 按职责命名 |
| 工具调用 | 各类 operator | `tool_<capability>_agent` 治理能力调用 |
| 放行判断 | reviewer、policy 或校验逻辑 | `gate_stage_evaluator_agent` 统一执行规则 |
| 命名 | 来源工程自己的命名 | 全部本地 Agent 以层前缀开头、以 `_agent` 结尾 |

## 保留的原则

- 每个角色只对一种决定或产物负责。
- 工具结果必须是结构化、可复现的证据。
- 先有交付物，再做门禁；Gate 不凭聊天印象放行。
- 外部写入、生产动作和发布保留明确授权边界。

## 本地没有照搬的部分

- 不把外部原型的 operator 命名直接当本地目标 ID。
- 不为尚未出现的独立使用场景提前建立 subflow。
- 不让多个协调 Agent 同时持有同一 Workflow 的推进状态。
