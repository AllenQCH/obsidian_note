---
title: "my-multi-agents总览"
source: "my-multi-agents/00-先看这里/my-multi-agents总览.md"
author: "Codex"
published:
created: 2026-07-22
description: "个人 Codex Multi-Agent 当前运行架构的唯一入口。"
tags: ["codex", "agent", "workflow", "index"]
type: "workflow"
status: "evergreen"
---

# my-multi-agents总览

## 摘要

当前 Multi-Agent 已覆盖旧运行框架。运行时注册 2 个 Control、9 个 Stage、1 个 Tool 和 1 个 Gate，共 13 个 Agent；5 个 `workflow_*` 是 `control_stage_orchestrator` 使用的状态机定义，不单独注册 Agent。AliDocs 提测文档通过 `tool_alidocs_test_delivery_agent` 提供独立治理入口；日志、SQL、GitHub、流水线等其余旧 `tool_*` 角色仍退出注册，由 Stage 或 Root Agent 直接调用公共 Skill/Script。

OpenSpec 与 Multi-Agent 分开：项目内 `openspec/` 是开发期事实；中央 `/Users/heytea/Documents/myHeytea/code/my-openspec` 管理项目规范、需求绑定、调查和不可变归档。

GitHub 便携仓库 `AllenQCH/multi-agent` 只发布 12 个核心 Agent，不包含公司专用 Tool Agent；不要用便携版数量覆盖本机运行时事实。

## 阅读顺序

1. [[最新multi-agent流程总览]]
2. [[当前运行架构和统一流程]]
3. [[当前agent注册表]]
4. [[九个Stage职责]]
5. [[Workflow路由和使用方式]]
6. [[开发流程Gate规则]]
7. [[测试执行和版本交付]]
8. [[Multi-Agent与OpenSpec边界]]

## 事实源

- 激活事实：`~/.codex/config.toml`
- Agent 合同：`~/.codex/agents/{control,stage,tool,gate}/*.toml`
- Workflow：`~/.codex/agents/docs/agent-workflows.md`
- 公共能力：`~/.codex/agents/docs/tool-agent-matrix.md`
- 中央 OpenSpec：`/Users/heytea/Documents/myHeytea/code/my-openspec`
- Xuetao 历史资料：[[xuetao-library总览]]

## 相关链接

- [[my-openspec总览]]
- [[Multi-Agent与OpenSpec边界]]
- [[xuetao-library总览]]
