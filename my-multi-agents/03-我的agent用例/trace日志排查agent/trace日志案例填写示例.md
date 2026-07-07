---
title: "trace日志案例填写示例"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "给 trace-log 排查一份完整填写样例，方便下次真实 traceId 排查时直接照着填。"
tags: ["codex", "agent", "trace", "investigation", "sample"]
type: "workflow"
status: "processed"
---

# trace日志案例填写示例

## 摘要

前面你已经有两类东西了：

- 一份模板
- 一份最小执行入口规则

但真正开始用的时候，还是很容易卡在一个很现实的问题上：

> 我知道该记哪些字段了，但一条真实 trace case 到底填出来应该长什么样？

这篇就是为了解决这个问题。

它不给你新理论，只给你一份完整示范。

注意：

- 这不是一个真实线上事故结论
- 只是一个标准化填写样例
- 它本身不能直接算激活证据

## 核心内容

### 一份完整填写样例

#### 1. 任务锚点

- 请求摘要：排查海外 submit-order 请求为什么超时
- `trace_id`：`abc123def456`
- `env`：`intl`
- `service_hint`：`order-service`
- `action_hint`：`submit-order`
- `source_type`：`platform_copy`

#### 2. 输入形状

- 已提供输入：
  - `trace_id=abc123def456`
  - `env=intl`
  - `time_range=2026-06-07 10:00-10:10`
  - 来自 `gateway`、`order-service`、`inventory-service` 的平台复制结果
- 缺失输入：
  - `inventory-service` 完整堆栈
  - 同一分钟依赖指标
- `time_range`：`2026-06-07 10:00-10:10`
- 是否有 `raw_logs`：`false`
- 是否有 `platform_results`：`true`

#### 3. 已确认事实

- `trace_found`：`true`
- `timeline_built`：`true`
- `timeline_services`：
  - `gateway`
  - `order-service`
  - `inventory-service`
- `first_anomaly_found`：`true`
- `first_anomaly_service`：`inventory-service`
- `first_anomaly_timestamp`：`2026-06-07T10:01:15.142+08:00`
- `first_anomaly_signature`：`inventory client timeout after 3000ms`
- `missing_hops`：
  - `inventory-service downstream DB span not visible`
- `evidence_source`：`platform_copy`

#### 4. 决策字段

- `root_cause_confidence`：`medium`
- `needs_more_evidence`：`true`
- `cascade_symptoms`：
  - `order-service business exception wrapper`
  - `gateway returned request timeout summary`
- `recommended_next_checks`：
  - 补查 `inventory-service` 同一分钟原始日志
  - 确认 timeout 前是否已经发生重试
  - 确认同时间窗口 DB / Redis 延迟是否升高

#### 5. Gate 是否能稳定消费

- `gate_result`：`warn`
- 为什么是这个结果：
  - 第一异常点已经足够明确，能指导下一步继续排查
  - 但最终根因还没被完整证实，因为下游依赖证据还缺
- 是否足以交给 `stage_task_planner`：`true`
- 是否足以交给 `stage_closeout_reporter`：`true`

#### 6. 边界检查

- 是否只做了证据提取：`true`
- 是否避免接管 workflow：`true`
- 是否避免直接开修复方案：`true`
- 是否清楚表达了不确定性：`true`

#### 7. Contract 稳定性检查

- 是否复用了既有字段：`true`
- 是否需要新增字段：`false`
- 是否改了字段名：`false`
- 当前输出形状是否稳定：`true`

#### 8. 是否计入晋升证据

- 这次是否计入激活证据：`true`
- 为什么：
  - 输入已经归一化
  - 时间线已经梳出来
  - 第一异常点明确
  - gate 结果可判断
  - 不确定性没有被隐藏
- 下次还缺什么：
  - 再看下一次 case 能不能继续复用同一组字段

### 你真正使用时怎么照着填

下一次你拿到真实 `traceId` 时，建议顺序是：

1. 先用 [[trace日志最小执行入口]] 检查这次输入能不能算标准化入口
2. 再把这篇当作填写示范
3. 最后把真实内容沉淀到 [[trace日志真实案例模板]]

也就是说：

- `21` 负责判断能不能开始
- `22` 负责告诉你怎么填
- `15` 负责成为正式记录

### 当前最实用的价值

如果只记一句：

> 这篇不是新增规则，而是把前面的规则真正翻译成一份“你明天就可以照着写”的样例。

## 可执行动作

1. 下一次真实 trace case 来了，先打开这篇，不要再从空白开始写。
2. 如果后面发现有些字段经常填不出来，再回头调整 [[trace日志最小执行入口]] 或 [[trace日志真实案例模板]]。

## 相关链接

- [[trace日志最小执行入口]]
- [[trace日志真实案例模板]]
- [[trace日志agent什么时候能启用]]
- [[trace日志agent是做什么的]]
