---
title: "目标agent注册表"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "当前确认的目标 Agent ID、所属层和职责速查表。"
tags: ["codex", "agent", "registry", "architecture"]
type: "reference"
status: "processed"
---

# 目标agent注册表

## 摘要

本表是设计注册表，不是运行时注册表。`状态` 统一标记为“目标”，直到对应 TOML、全局配置和验证全部完成。

## Control 与 Workflow

| Agent ID | 职责 | 状态 |
| --- | --- | --- |
| `control_request_router_agent` | 分类请求并选择一个 Workflow | 目标 |
| `control_stage_orchestrator_agent` | 执行阶段状态机、重试、恢复和收口 | 目标 |
| `workflow_iterative_feature_development_agent` | 定义常规迭代开发流程 | 目标 |
| `workflow_rewrite_iterative_feature_development_agent` | 定义已有迭代继续改造流程 | 目标 |
| `workflow_bug_investigation_agent` | 定义证据优先的 Bug 排查流程 | 目标 |
| `workflow_solve_personal_problem_agent` | 定义个人非业务任务的动态流程 | 目标 |

## Stage

| Agent ID | 职责 | 状态 |
| --- | --- | --- |
| `stage_product_owner_agent` | 需求澄清与产品闭环 | 目标 |
| `stage_backend_designer_agent` | 后端改动设计 | 目标 |
| `stage_backend_developer_agent` | 后端编码与单元测试 | 目标 |
| `stage_frontend_developer_agent` | 前端实现与前端验证 | 目标 |
| `stage_test_case_designer_agent` | 独立测试用例与回归设计 | 目标 |
| `stage_code_reviewer_agent` | 独立代码审查 | 目标 |
| `stage_test_runner_agent` | 本地集成调试与正式测试执行 | 目标 |
| `stage_version_delivery_agent` | 版本交付、观察与归档 | 目标 |
| `stage_investigation_planner_agent` | Bug 排查的证据计划与假设收敛 | 保留候选 |

## Gate 与已确认新增 Tool

| Agent ID | 职责 | 状态 |
| --- | --- | --- |
| `gate_stage_evaluator_agent` | 按规则检查阶段证据并输出放行结果 | 目标 |
| `tool_dependency_package_publisher_agent` | 解析并执行依赖包远程发布 | 目标 |
| `tool_test_delivery_document_agent` | 生成或更新提测材料 | 目标 |

其他 Tool Agent 必须在运行时盘点后逐个迁移，不能用本表推断其当前 ID 或启用状态。

## 运行态判定

一个 Agent 只有同时满足以下条件才能标记为 active：

1. 存在 `~/.codex/agents/<layer>/<name>.toml`。
2. 存在 `~/.codex/config.toml` 的 `[agents.<name>]` 注册项。
3. 注册表引用和校验脚本通过。
4. 至少有一个可复现的路由或调用验证。
