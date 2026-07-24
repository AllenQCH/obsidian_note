---
title: "开发流程Gate规则"
source: "my-multi-agents/02-当前agent架构/开发流程Gate规则.md"
author: "Codex"
published:
created: 2026-07-22
description: "单一 Gate Agent 使用的规则、证据和回退目标。"
tags: ["codex", "agent", "gate", "evidence"]
type: "note"
status: "evergreen"
---

# 开发流程Gate规则

## 摘要

`gate_stage_evaluator` 只读取产物和证据，输出 `go`、`warn` 或 `block`。它不写代码、不补文档、不调用工具、不推进状态。

## 核心内容

| Gate 规则 | Go 条件 | Block 回退 |
| --- | --- | --- |
| `gate_requirement_ready` | 范围、服务、验收标准和非目标齐全 | `stage_product_owner` |
| `gate_design_confirmed` | 用户已明确确认具体设计 | `stage_backend_designer` |
| `gate_code_review_passed` | 按指定 CR 规范检查且无阻塞项 | `stage_backend_designer` |
| `gate_test_passed` | 测试真实执行且 verdict 为 pass | Developer 或 Designer |
| `gate_delivery_completed` | Commit、依赖、SQL、材料和授权动作证据齐全 | `stage_version_delivery` |
| `gate_test_environment_passed` | 部署版本、curl 和业务结果均验证 | `stage_test_environment_runner` |
| `gate_archive_ready` | 完整 Commit、环境验证和快照输入齐全 | 对应证据所有者 |

`warn` 只适用于不影响验收且已有明确接受人的剩余风险。缺少强制证据、测试失败、生产风险未知或未获授权必须 `block`。

中央 OpenSpec Gate 只接受 capability、operation、args、退出码和产物路径相匹配的执行证据。

## 相关链接

- [[当前运行架构和统一流程]]
- [[Multi-Agent与OpenSpec边界]]
- [[测试执行和版本交付]]
