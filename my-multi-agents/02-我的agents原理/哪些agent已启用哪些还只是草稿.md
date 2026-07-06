---
title: "哪些agent已启用哪些还只是草稿"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "用一张状态矩阵整理当前本地 multi-multi-agents架构与运行态里哪些 agent 已启用，以及还有哪些历史草案或参考文档。"
tags: ["codex", "agent", "workflow", "registry", "architecture"]
type: "workflow"
status: "processed"
---

# 哪些agent已启用哪些还只是草稿

## 摘要

这篇笔记解决一个很实际的问题：

> 现在你本地已经有一批 active agent，也保留了一些历史草案文档。以后怎么一眼看出哪些已经真正接入运行态？

先记最重要的一条：

> **只有写进 `~/.codex/config.toml` 的 agent，才算 active。**

其他即使已经有：

- TOML 草案
- workflow 草案
- contract 草案

也仍然只是 draft，不算当前运行态的一部分。

## 核心内容

### 判断规则

#### Active

满足：

1. 已写进 `~/.codex/config.toml`
2. 有正式 `config_file`
3. 已进入当前四层体系的说明文档

#### 历史草案 / 参考文档

满足任一：

1. 只有 Obsidian 设计笔记
2. 只有本地 `.draft.toml` 或 `.draft.md`
3. 已有 contract / workflow 草案，但未注册进 `config.toml`

### 当前 Active Matrix

| 层级 | Agent | 当前状态 | 说明 |
|---|---|---|---|
| control | `control_request_router` | active | 总入口，负责分流 |
| control | `control_stage_orchestrator` | active | 阶段推进与编排 |
| stage | `stage_task_planner` | active | 执行型计划 |
| stage | `stage_investigation_planner` | active | 排查型计划 |
| stage | `stage_execution_runner` | active | 执行链协调 |
| stage | `stage_integration_orchestrator` | active | 多结果整合 |
| stage | `stage_closeout_reporter` | active | 最终收口 |
| tool | `tool_sso_operator` | active | SSO 登录态准备 |
| tool | `tool_dbauto_operator` | active | dbauto runtime bootstrap |
| tool | `tool_dbauto_sql_operator` | active | dbauto 只读 SQL 与元数据查询 |
| tool | `tool_excel_operator` | active | Excel / JSON 提取去重 |
| tool | `tool_obsidian_operator` | active | 本地 Obsidian 写入 |
| tool | `tool_github_sync_operator` | active | GitHub 同步 |
| gate | `gate_stage_evaluator` | active | 统一 go / warn / block |

### 当前 Draft Matrix

| 层级 | Candidate | 当前状态 | 已有资产 | 为什么还不是 active |
|---|---|---|---|---|
| trace-log 历史设计线 | archived reference | active support docs + 旧候选草案/contract/案例模板/评审表 | `tool_trace_log_operator` 已接入 active runtime；这些文档保留为设计与复盘参考，不再表示当前运行态仍是 draft |

### 当前最重要的边界

#### 1. 有历史草案笔记，不等于当前还是 draft

比如：

- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[trace日志最小执行入口]]
- [[trace日志agent什么时候能启用]]
- [[trace日志真实案例模板]]
- [[trace日志案例填写示例]]
- [[trace日志agent晋升评审]]
- [[trace日志真实任务怎么记录]]
- [[trace日志agent是做什么的]]

这些笔记保留的是设计和收敛过程，不再表示它现在仍然是 draft。

#### 2. 真正的 active 判断仍然只看 `config.toml`

所以以后如果你怀疑某个 agent 到底算不算已经落地，只做一个判断：

1. 打开 [config.toml](/Users/heytea/.codex/config.toml:1)
2. 看里面有没有它

有：

- 才算 active

没有：

- 就仍然是 draft / 设想 / 预备方案

### 一张最实用的阅读顺序

如果你今天是为了判断“这个 agent 现在到底能不能用”，按这个顺序看最快：

1. [config.toml](/Users/heytea/.codex/config.toml:1)
2. [[本机已启用agent注册表]]
3. 这篇 `13-Active与Draft状态矩阵`
4. 如果是历史设计线，再去看：
   - [[trace日志agent怎么拆]]
   - [[trace日志agent输入输出约定]]
   - [[trace日志最小执行入口]]
   - [[trace日志agent什么时候能启用]]
   - [[trace日志案例填写示例]]
   - [[trace日志agent晋升评审]]

### 当前最实用的结论

如果只说一句：

> 你现在的体系已经有一套稳定的 active 主干，同时也保留了一些历史设计线用于复盘，这其实是好事，不是混乱。

因为这说明你已经开始把“架构思考”和“运行态接入”分开处理了。

## 可执行动作

1. 以后新增 active agent 时，先改 `config.toml`，再回头更新这篇矩阵。
2. 如果保留历史设计文档，优先标清它是“archived reference”而不是当前运行态。
3. 不要再把 `tool_trace_log_operator` 当成 draft 示例来讲。

## 相关链接

- [[阅读顺序-先Xuetao再我的agents]]
- [[本机已启用agent注册表]]
- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[trace日志最小执行入口]]
- [[trace日志agent什么时候能启用]]
- [[trace日志真实案例模板]]
- [[trace日志案例填写示例]]
- [[trace日志agent晋升评审]]
- [[trace日志真实任务怎么记录]]
- [[trace日志agent是做什么的]]
- [[我的Codex多agent改造计划]]
