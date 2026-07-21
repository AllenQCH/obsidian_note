---
title: "trace日志排查总览"
source: "my-multi-agents/03-我的agent用例/trace日志排查agent"
author: "Codex"
published:
created: 2026-07-20
description: "trace 日志 Tool Agent 的目标职责、合同、案例和运行态验证入口。"
tags: ["codex", "agent", "trace", "investigation", "index"]
type: "workflow"
status: "processed"
---

# trace日志排查总览

## 摘要

这组笔记是 `workflow_bug_investigation_agent` 的一个工具能力专题。目标 Tool Agent 使用 `tool_trace_log_agent` 命名；是否已经按该 ID active，必须通过运行时注册表核对，不能从专题文档推断。

## 目标调用链

```text
control_request_router_agent
-> workflow_bug_investigation_agent
-> control_stage_orchestrator_agent
-> stage_investigation_planner_agent
-> 日志查询 Tool Agent
-> tool_trace_log_agent
-> gate_stage_evaluator_agent
```

日志查询负责取得原始事实，trace 分析负责重建时间线和第一异常点，调查 Stage 负责综合根因假设，Gate 判断证据是否足以进入修复或收口。

## 阅读入口

- [[trace日志agent是做什么的]]
- [[trace日志agent输入输出约定]]
- [[trace日志最小执行入口]]
- [[trace日志真实任务怎么记录]]
- [[trace日志真实案例模板]]
- [[trace日志案例填写示例]]
- [[trace日志agent什么时候能启用]]
- [[trace日志agent晋升评审]]
