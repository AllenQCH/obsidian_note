---
title: "trace日志真实案例模板"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "为后续真实 traceId 排查任务准备统一记录模板，用来积累 tool_trace_log_operator 的激活证据。"
tags: ["codex", "agent", "workflow", "trace", "investigation", "template"]
type: "workflow"
status: "processed"
---

# trace日志真实案例模板

## 摘要

这篇笔记解决的是激活门槛之后的下一步问题：

> 既然说要至少积累 3 次真实 trace 排查案例，那每次到底该怎么记，才能真的变成晋升证据？

这篇不是新的理论说明，而是一份可直接复用的记录模板。

它的作用很明确：

- 让每次真实 trace 排查都按同一格式沉淀
- 让你后面判断 contract 是否稳定、gate 是否能消费，不再靠回忆
- 让 `tool_trace_log_operator` 的 draft 晋升条件有真实证据支撑

## 核心内容

### 什么时候用这份模板

当任务同时满足下面这些特征时，就适合按这份模板记录：

- 有明确 `traceId`
- 需要重建调用链时间线
- 需要找第一异常点
- 当前根因仍然有不确定性

也就是说，这份模板主要服务于：

- investigation 类型任务
- trace 日志证据提取
- draft 候选的真实验证

### 记录模板

#### 1. 任务锚点

- 请求摘要：
- `trace_id`：
- `env`：
- `service_hint`：
- `action_hint`：
- `source_type`：
  - `raw_text`
  - `export_file`
  - `platform_copy`

#### 2. 输入形状

- 已提供输入：
- 缺失输入：
- `time_range`：
- 是否有 `raw_logs`：
- 是否有 `platform_results`：

#### 3. 已确认事实

这里只写观察到的事实，不写猜测。

- `trace_found`：
- `timeline_built`：
- `timeline_services`：
- `first_anomaly_found`：
- `first_anomaly_service`：
- `first_anomaly_timestamp`：
- `first_anomaly_signature`：
- `missing_hops`：
- `evidence_source`：

#### 4. 决策字段

- `root_cause_confidence`：
- `needs_more_evidence`：
- `cascade_symptoms`：
- `recommended_next_checks`：

#### 5. Gate 是否能稳定消费

这里专门判断：

> 如果把这次结果交给 `gate_stage_evaluator(gate_investigation_ready)`，它能不能自然得出 `go / warn / block`？

记录：

- `gate_result`：
  - `go`
  - `warn`
  - `block`
- 为什么是这个结果：
- 是否足以交给 `stage_task_planner`：
- 是否足以交给 `stage_closeout_reporter`：

#### 6. 边界检查

这里是为了防止候选 agent 变重。

记录：

- 是否只做了证据提取：
- 是否避免接管 workflow：
- 是否避免直接开修复方案：
- 是否清楚表达了不确定性：

#### 7. Contract 稳定性检查

记录：

- 是否复用了既有字段：
- 是否需要新增字段：
- 是否改了字段名：
- 当前输出形状是否稳定：

#### 8. 是否计入晋升证据

最后明确写：

- 这次是否计入激活证据：
- 为什么：
- 下次还缺什么：

### 什么时候这次案例才算有效

至少要满足：

1. `traceId` 锚点明确
2. facts 和猜测分开
3. 核心 decision 字段复用稳定
4. 能判断 gate 怎么消费
5. 不确定性被明确写出来

如果这 5 条都做不到，这次案例就更像临时排查记录，而不是可用于晋升判断的标准证据。

### 这份模板和激活门槛的关系

你可以这样理解：

- [[trace日志agent什么时候能启用]] 解决“什么条件才可以升 active”
- 这篇解决“每一次真实案例怎么记，才能证明这些条件真的满足了”

也就是说：

> 14 是晋升标准，15 是证据采集模板。

### 当前最实用的用法

后面一旦出现真实 traceId 排查任务，你最稳的做法不是事后回忆，而是：

1. 先按这篇模板记录
2. 再回到 [[trace日志agent什么时候能启用]] 对照
3. 连续积累几次后，再判断是否可以升 active

## 可执行动作

1. 后面每次真实 trace 排查都尽量按这篇模板沉淀。
2. 连续几次案例后，回看哪些字段稳定，哪些字段总在变。
3. 只有当这份模板记录出来的案例已经足够稳定时，再考虑真正激活 `tool_trace_log_operator`。

## 相关链接

- [[trace日志agent什么时候能启用]]
- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[哪些agent已启用哪些还只是草稿]]
- [[trace日志agent是做什么的]]
- [[问题排查先查什么证据]]
