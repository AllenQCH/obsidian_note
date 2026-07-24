---
title: "Workflow路由和使用方式"
source: "my-multi-agents/02-当前agent架构/Workflow路由和使用方式.md"
author: "Codex"
published:
created: 2026-07-22
description: "常见用户请求如何进入 Workflow 或部分入口。"
tags: ["codex", "agent", "routing", "workflow"]
type: "workflow"
status: "evergreen"
---

# Workflow路由和使用方式

## 摘要

Router 按任务形态选择五个 Workflow 或部分入口；缩短入口不等于绕过必需输入、Gate 或授权。

## 核心内容

| 用户意图 | 路由 |
| --- | --- |
| “做这个后端需求” | `workflow_iterative_feature_development` |
| “补之前遗漏的需求”或提供 `bug-list.md` | `workflow_rewrite_iterative_feature_development` |
| “根据问题/异常/traceId 分析原因” | `workflow_bug_investigation` |
| “去测试环境验证刚交付的功能” | `workflow_test_environment_validation` |
| “处理本机配置、浏览器、文档或个人自动化” | `workflow_solve_personal_problem` |
| “只执行本地测试” | 迭代 Workflow，`entry_mode=testing_only`，从 `stage_test_runner` 开始 |
| “只执行交付” | 迭代 Workflow，`entry_mode=delivery_only`，从 `stage_version_delivery` 开始 |

直接指定 Stage 只缩短入口，不绕过必需输入、Gate 和外部写入授权。纯前端工作当前没有注册 Stage，必须单独明确边界，不能伪装成后端 Workflow。

## 相关链接

- [[最新multi-agent流程总览]]
- [[当前运行架构和统一流程]]
- [[开发流程Gate规则]]
