---
title: "用户说法对应哪个agent"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "将常见用户请求映射到 Workflow Agent 或单一职责 Stage Agent。"
tags: ["codex", "agent", "routing", "workflow"]
type: "reference"
status: "processed"
---

# 用户说法对应哪个agent

## 摘要

默认由 `control_request_router_agent` 选择一个 Workflow。只有用户明确要求一个窄职责时，才缩短为单 Stage 流程；直接指定 Stage 也不能绕过必需输入和安全边界。

## Workflow 路由

| 用户说法 | 目标 Workflow Agent | 关键判断 |
| --- | --- | --- |
| “做这个需求”“新增一个功能” | `workflow_iterative_feature_development_agent` | 包括项目初始功能，不另建绿地 Workflow |
| “基于原来的功能继续改”“重做这一版迭代” | `workflow_rewrite_iterative_feature_development_agent` | 必须梳理历史文档和现有实现 |
| “查一下为什么报错”“先定位根因” | `workflow_bug_investigation_agent` | 先证据后修复，不能直接跳编码 |
| “整理本地配置”“更新 Obsidian”“做个人自动化” | `workflow_solve_personal_problem_agent` | 不隐含开发、分支或交付流程 |

## 窄职责路由

| 用户说法 | 主要 Agent | 默认停止点 |
| --- | --- | --- |
| “只梳理需求” | `stage_product_owner_agent` | 需求产物完成 |
| “只给后端设计” | `stage_backend_designer_agent` | 设计产物完成 |
| “只写后端并补单测” | `stage_backend_developer_agent` | 实现与单测完成 |
| “只开发前端” | `stage_frontend_developer_agent` | 前端实现与验证完成 |
| “只整理测试用例” | `stage_test_case_designer_agent` | 测试用例和回归范围完成 |
| “只做 CR” | `stage_code_reviewer_agent` | 审查报告完成，不自动修复 |
| “只做本地联调/测试” | `stage_test_runner_agent` | 测试证据完成，不自动发布 |
| “只准备或执行版本交付” | `stage_version_delivery_agent` | 按授权执行到交付/观察/归档 |

## 模糊请求

当一句话同时可能属于多个 Workflow 时，Router 只补问会改变流程选择的关键问题。其余小缺口由所选 Workflow 的产品或调查阶段继续澄清。
