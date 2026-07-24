---
title: "当前agent注册表"
source: "my-multi-agents/02-当前agent架构/当前agent注册表.md"
author: "Codex"
published:
created: 2026-07-22
description: "当前 config.toml 中十三个活跃 Agent 的职责清单。"
tags: ["codex", "agent", "registry"]
type: "note"
status: "evergreen"
---

# 当前agent注册表

## 摘要

当前本机运行时共 13 个 Agent：2 Control、9 Stage、1 Tool、1 Gate。以下清单只按 `~/.codex/config.toml` 的活跃注册统计。

## 核心内容

| 层 | Agent ID | 职责 |
| --- | --- | --- |
| Control | `control_request_router` | 选择 Workflow、入口、项目和 OpenSpec 对象 |
| Control | `control_stage_orchestrator` | 管理阶段状态、Gate、重试和回退 |
| Stage | `stage_product_owner` | 梳理需求范围、服务、验收标准和非目标 |
| Stage | `stage_backend_designer` | 后端接口、数据、兼容、回滚和改动设计 |
| Stage | `stage_test_case_designer` | 从产品和后端设计生成测试及回归用例 |
| Stage | `stage_backend_developer` | 按确认设计编码并补单元测试 |
| Stage | `stage_code_reviewer` | 按用户、项目或本机 fallback CR 规范独立审查；默认资料位于 `~/.codex/agents/references/code-review/` |
| Stage | `stage_test_runner` | 执行本地测试并给出证据化 verdict |
| Stage | `stage_version_delivery` | 统一处理 SQL、依赖、材料和 BK 流水线 |
| Stage | `stage_bug_investigator` | 从描述、异常或 traceId 定位源码链路；不改代码 |
| Stage | `stage_test_environment_runner` | 验证测试环境版本、数据、Pod curl 和业务结果 |
| Tool | `tool_alidocs_test_delivery_agent` | 创建、计时并回读验证 AliDocs 六 Sheet 提测文档 |
| Gate | `gate_stage_evaluator` | 依据一条 Gate 规则判定 `go / warn / block` |

只有 `~/.codex/config.toml` 中注册且 TOML 存在的条目才是活跃 Agent。Workflow ID 和 `gate_*` 规则不计入 Agent 数量。

## 相关链接

- [[my-multi-agents总览]]
- [[九个Stage职责]]
- [[当前运行架构和统一流程]]
