---
title: "trace日志排查总览"
source: "my-multi-agents/02-我的agents原理/trace日志排查agent/trace日志排查总览.md"
author: "Codex"
published:
created: 2026-07-05
description: "multi-agents 中 trace 日志排查 agent 的设计、案例模板、样例和执行卡片入口。"
tags: ["codex", "agent", "trace", "investigation", "index"]
type: "workflow"
status: "processed"
---

# trace日志排查总览

## 摘要

这组笔记现在归到 [[my-multi-agents总览]] 下面，定位是 `tool_trace_log_operator` 和日志排查链路的专题材料。

它不是一套独立框架，而是本机 multi-agents 运行态中的一条工具链：

```text
control_request_router
-> stage_investigation_planner
-> tool_cls_log_query_operator
-> tool_trace_log_operator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

- [[trace日志agent是做什么的]]
- [[trace日志真实任务怎么记录]]
- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[trace日志agent什么时候能启用]]
- [[trace日志真实案例模板]]
- [[trace日志最小执行入口]]
- [[trace日志案例填写示例]]
- [[trace日志agent晋升评审]]
