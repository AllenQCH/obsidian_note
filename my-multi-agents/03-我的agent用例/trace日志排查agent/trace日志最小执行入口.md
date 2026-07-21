---
title: "trace日志最小执行入口"
source: "conversation: Codex chat 2026-06-07; updated 2026-07-20"
author: "Codex"
published:
created: 2026-06-07
description: "一次标准化 trace 调查开始前必须具备的最小输入。"
tags: ["codex", "agent", "trace", "investigation", "contract"]
type: "workflow"
status: "processed"
---

# trace日志最小执行入口

## 摘要

一次标准化 trace 调查至少需要可定位请求的标识、环境、时间范围和一个真实证据来源。输入不完整时先补证据，不用代码推断伪装成日志事实。

## 最小输入

```yaml
trace_id: string
environment: string
time_range:
  start: datetime
  end: datetime
source_type: platform | exported_file | raw_logs
source_ref: string
service_hint: string | null
symptom: string
```

## 开始条件

- `trace_id` 或等价请求标识可检索。
- 环境和时间范围明确。
- `source_ref` 指向可读取的真实日志来源。
- 用户症状或期望行为足够判断异常。

## 拒绝条件

- 只有一段脱离时间和服务上下文的文本。
- 需要生产日志但当前能力没有访问权限。
- 输入包含应当隐藏的凭据或敏感信息。
- 用户要求用推测结果冒充真实查询结果。

满足条件后按 [[trace日志真实任务怎么记录]] 执行并落证据。
