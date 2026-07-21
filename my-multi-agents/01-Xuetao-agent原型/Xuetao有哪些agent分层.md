---
title: "Xuetao有哪些agent分层"
source: "/Users/heytea/Documents/xuetao的agetns/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-05
description: "按来源工程原始职责整理 Xuetao 的 Agent 分层，不映射为本地目标 ID。"
tags: ["codex", "agent", "xuetao", "research"]
type: "reference"
status: "processed"
---

# Xuetao有哪些agent分层

## 摘要

这篇只记录 Xuetao 原型的来源事实。下面的标识符沿用对方工程原名，因此不适用本地 `<layer>_<responsibility>_agent` 命名规范，也不代表本地运行时存在同名 Agent。

## 来源分层

| 来源职责 | 原型中的典型标识 | 作用 |
| --- | --- | --- |
| 入口路由 | `workflow_router` | 识别任务阶段、缺失输入和下游角色 |
| 调查规划 | `investigation_planner` | 设计证据收集顺序并收敛假设 |
| 仓库选择 | `catalog_repo_selector` | 从 catalog 选择相关仓库 |
| 工具二级路由 | `tool_operator` | 选择具体 CLI operator 并聚合输出 |
| 知识来源 | `knowledge_base_operator` | 搜索和索引外部知识来源 |
| 具体工具 | `bk_operator`、`dbauto_operator`、`trace_log_operator` 等 | 调用单一外部系统能力 |
| 实现与审查 | implementer / reviewer 类角色 | 产出实现并独立审查 |
| OpenSpec 审查 | `openspec_reviewer` | 检查对象产物和证据完整性 |

## 从原型吸收什么

- 路由、专业判断、工具调用和放行检查应该拆开。
- 每个工具角色只管理一个外部能力和稳定合同。
- 输出应结构化，方便下游角色消费。
- 写操作和高风险动作必须有明确确认点。

## 不从原型直接复制什么

- 不复制对方的文件名作为本地 Agent ID。
- 不把对方的角色数量当作本地必须实现的数量。
- 不做旧本地名称到目标名称的一一映射。
- 本地目标结构统一看 [[我的五层模型和Xuetao对比]] 和 [[目标agent注册表]]。
