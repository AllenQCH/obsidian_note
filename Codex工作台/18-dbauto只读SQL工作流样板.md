---
title: "dbauto只读SQL工作流样板"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "用一个国内 dbauto 只读 SQL 场景，说明 tool_dbauto_sql_operator 在四层体系里应该怎么串联和受控。"
tags: ["codex", "agent", "workflow", "dbauto", "sql"]
type: "workflow"
status: "processed"
---

# dbauto只读SQL工作流样板

## 摘要

这篇笔记解决的是一个新补上的高频场景：

> 当你要在国内 dbauto 页面里查实例、列库表、或者执行只读 SQL 时，这个能力在你本地四层 agent 体系里应该怎么挂？

当前最合理的拆法不是把它并进 `tool_dbauto_operator`。

因为这两件事本质不同：

- `tool_dbauto_operator` 负责 export runtime bootstrap
- `tool_dbauto_sql_operator` 负责 read-only SQL query

所以更稳的方式是把它单独拆成一个新的 `tool_*`。

## 核心内容

### 当前本机验证状态

这次不是只补文档，我还做了一轮本机只读验证。

已确认：

- `opencli doctor -v` 可以正常完成
- `dbauto_sql_query.py --help` 可以正常完成
- `dbauto_sql_query.py --list-common-instances` 已真实拿到 3 个常用实例
- `dbauto_sql_query.py --instance hsp-ids --list-dbs` 已真实拿到 3 个数据库
- `dbauto_sql_query.py --instance hsp-ids --db center_hsp_invoice --list-tables` 已真实拿到 invoice 相关表清单
- `dbauto_sql_query.py --instance hsp-ids --db center_hsp_invoice --sql "SHOW CREATE TABLE hsp_goods_rate"` 已成功
- `dbauto_sql_query.py --instance hsp-ids --db center_hsp_invoice --sql "SHOW COLUMNS FROM hsp_goods_rate"` 已成功

这说明现在已经可以确认：

- 这个 operator 已经不是纸面设计
- 它已经具备真实的列实例、列库、列表、查表结构能力

但这次也补出一个很重要的边界：

- `DESC hsp_goods_rate` 会被页面接口拒绝，返回 `不支持的查询语法类型!`

也就是说，当前最准确的判断是：

> 这个 operator 在本机已经可真实使用，但要优先走 dbauto 页面明确支持的只读语法，而不是把所有 MySQL 只读语法都默认当成可用。

### 当前推荐链路

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator(stage=execution)
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_sql_operator
-> gate_stage_evaluator(gate_execution_ready)
-> stage_closeout_reporter
```

### 这条链里每一步干什么

#### 1. `control_request_router`

它先判断这是不是：

- dbauto export bootstrap
- 还是 dbauto read-only SQL

如果用户说的是：

- 查实例
- 列库表
- 看表结构
- 执行只读 SQL

那就不应该路由到 `tool_dbauto_operator`，而应该路由到 `tool_dbauto_sql_operator`。

#### 2. `stage_task_planner`

它要先把这次任务定清楚：

- 目标实例是什么
- 数据库是什么
- 是列库表，还是直接查 SQL
- SQL 是否只读

这一层最关键的边界是：

> 不要把“想查数据”和“允许执行任何 SQL”混成一件事。

#### 3. `tool_sso_operator`

它负责：

- 确认国内 SSO 登录态

因为 dbauto SQL 页面仍然依赖统一登录和 opencli Browser Bridge。

#### 4. `tool_dbauto_sql_operator`

它负责：

- 列常用实例
- 列数据库
- 列表
- 执行只读 SQL

当前本机验证过、优先推荐的 schema 查询写法是：

- `SHOW CREATE TABLE <table>`
- `SHOW COLUMNS FROM <table>`
- `SHOW TABLES LIKE '<table>'`

它的真实执行入口已经存在：

- `python3 ~/.codex/skills/dbauto-sql-query/scripts/dbauto_sql_query.py`

所以它现在已经不只是“适合落成 `tool_*`”，而是已经正式落成并进入 active runtime。

#### 5. `gate_stage_evaluator`

这里最重要的判断是：

- 目标实例/库/表是不是足够明确
- 当前是不是只读 SQL
- 有没有实际结果可以交付

典型结果：

- `go`：目标明确，结果已出
- `warn`：只查到了元数据，但用户目标还要再缩小
- `block`：目标不清楚，或者用户其实想执行写 SQL

#### 6. `stage_closeout_reporter`

最后应该说清楚：

- 查的是哪个实例
- 哪个数据库
- 是列库表还是执行 SQL
- 有什么结果
- 还缺什么信息

### 为什么要单独拆成新 operator

如果不拆，容易出现两个问题：

1. 把 dbauto export 和 dbauto SQL 混成同一种能力
2. 后面 read-only SQL 的安全边界不清楚

而单独拆开以后，这个边界就很清楚：

- `tool_dbauto_operator`：环境 / runtime / export 准备
- `tool_dbauto_sql_operator`：只读 SQL / 元数据查询

### 当前最实用的结论

如果只记一句：

> `dbauto-sql-query` 已经不是“下一批候选”，而是已经正式落成 `tool_dbauto_sql_operator`，并完成了本机真实只读验证。

## 可执行动作

1. 后面再遇到国内 dbauto 查库表或只读 SQL，优先按这条链理解。
2. 不要把它和 `tool_dbauto_operator` 混用。
3. 对写 SQL 需求，仍然按工单或人工确认路径处理，不放进这个 operator。
4. 如果只是想看表结构，优先用 `SHOW CREATE TABLE` 或 `SHOW COLUMNS`，不要默认用 `DESC`。

## 相关链接

- [[08-本地Multi-Agent Registry]]
- [[05-dbauto导出工作流样板]]
- [[09-Investigation排查工作流样板]]
- [[10-Skill与Agent包装判断]]
- [[17-当前成果总清单]]
