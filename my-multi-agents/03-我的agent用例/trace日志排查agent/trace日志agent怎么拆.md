---
title: "trace日志agent怎么拆"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "基于现有 trace-log-analysis skill，整理一个未来可落地的 tool_trace_log_agent 候选拆分草案。"
tags: ["codex", "agent", "skill", "workflow", "trace", "investigation"]
type: "workflow"
status: "processed"
---

# trace日志agent怎么拆

## 摘要

这篇笔记不是在说“现在已经有 `tool_trace_log_agent` 了”。

它要解决的问题是：

> 如果你下一步真的要把 `trace-log-analysis` 往 agent 方向落地，应该怎么拆，才不会重新做出一个很重的大 agent？

当前结论很明确：

- `trace-log-analysis` 很值得 agent 化
- 但现在还没正式落地成你本地 `~/.codex` 的一个 `tool_*_agent` agent
- 所以最合理的下一步不是直接上手乱写 TOML，而是先把边界、输入输出和在五类体系里的位置写清楚

## 核心内容

### 为什么它值得 agent 化

`trace-log-analysis` 已经具备 3 个很强的特征：

1. 使用频率高
2. 输入输出模式相对稳定
3. 在 `investigation` 流程里位置很明确

它最常见的输入其实很固定：

- `traceId`
- 环境 / 集群
- 时间范围
- 服务名或业务动作
- 原始日志文本 / 平台搜索结果 / 导出文件

它最常见的输出也很固定：

- 调用链时间线
- 第一异常点
- 根因候选
- 传播噪音
- 下一步建议

这已经很接近一个标准 `tool_*_agent` agent 的形态了。

### 它在五类模型里应该放哪

它应该放在：

```text
tool 层
```

也就是未来的名字应该更像：

```text
tool_trace_log_agent
```

而不是：

- 放进 `stage`
- 做成一个新的 router
- 或者做成一个“会自己查日志、自己下结论、自己决定下一步”的大 agent

原因很简单：

- 它本质上是在执行“日志证据提取和整理”这类具体动作
- 它不该自己接管整个 investigation 流程

### 它未来最合理的职责边界

未来如果真的落成 `tool_trace_log_agent`，它最合理的职责应该是：

1. 按 `traceId` 或原始日志输入重建时间线
2. 标出第一异常点
3. 区分根因候选和传播噪音
4. 给出证据化输出

它不该负责：

1. 判断整个任务属于 investigation 还是 execution
2. 决定下一步是不是直接修代码
3. 决定要不要切到别的工具链
4. 把不确定结论伪装成确定根因

也就是说，它应该是：

> 证据提取者

而不是：

> 整个排查流程的总指挥

### 如果落地，它最适合接在哪条链路里

未来最自然的链路应该是：

```text
control_request_router_agent
-> stage_investigation_planner_agent
-> control_stage_orchestrator_agent(stage=investigation)
-> tool_trace_log_agent
-> gate_stage_evaluator_agent(gate_investigation_ready)
-> control_stage_orchestrator_agent or stage_version_delivery_agent
```

如果 investigation 同时需要多类证据，也可以是：

```text
control_request_router_agent
-> stage_investigation_planner_agent
-> control_stage_orchestrator_agent(stage=investigation)
-> tool_trace_log_agent
-> tool_dbauto_agent
-> gate_stage_evaluator_agent(gate_investigation_ready)
-> control_stage_orchestrator_agent or stage_version_delivery_agent
```

这条链最关键的地方是：

- `stage_investigation_planner_agent` 决定“先查什么证据”
- `tool_trace_log_agent` 只负责把日志证据整理出来
- `gate_stage_evaluator_agent` 判断“当前证据够不够”

### 它未来最适合的输入输出契约

#### 建议输入

- `trace_id`
- `env`
- `time_range`
- `service_hint`
- `raw_logs`
- `platform_results`

#### 建议输出

- `timeline_summary`
- `first_anomaly`
- `root_cause_candidates`
- `cascade_symptoms`
- `missing_evidence`
- `recommended_next_checks`

如果你后面要真的落 TOML，这些字段就很适合变成它的 contract baseline。

### 为什么现在先不要急着直接实现

因为虽然它值得做，但现在还差两个前置判断：

#### 1. 证据入口还不够确定性

当前 `trace-log-analysis` 更偏“分析方法 skill”，并不是一个已经绑定稳定 CLI / API 的执行器。

也就是说，现在还没像下面这些一样稳定：

- `sso-login -> sso_opencli.py`
- `dbauto-export-agent -> run_dbauto_export_agent.sh`
- `excel-json-analysis -> extract_json_fields_from_excel.py`

所以如果现在直接强行写 `tool_trace_log_agent.toml`，很容易出现：

- 名字先有了
- 但真实执行入口还不稳

#### 2. investigation 样板刚落地，还需要再观察

你现在已经有：

- [[问题排查先查什么证据]]

这篇已经把 investigation 的主线讲清楚了。

更稳的做法是：

1. 先用这篇样板继续观察几轮真实 investigation 任务
2. 看 `trace-log-analysis` 到底是最常用证据工具，还是只在部分场景命中
3. 再决定它是不是下一批最优先落地的 `tool_*_agent`

### 真要落地时，建议按这个顺序推进

1. 先补一版 `tool_trace_log_agent` 的 contract 草案
2. 再补一版 trace investigation workflow example
3. 再决定它的真实执行入口到底是什么
4. 最后才落 `tool_trace_log_agent.toml`
5. 落完以后再补进 `config.toml`、registry、reading guide

这个顺序很重要，因为它能避免：

- 先有配置
- 后补理解

### 当前最务实的判断

如果只说结论：

- `trace-log-analysis` 是目前最值得继续 agent 化的 skill 候选
- 但现在更适合先作为“候选拆分草案”，而不是立即注册进 `config.toml`

这和前面那几个已经落地的 `tool_*_agent` 不同：

- 它的“该不该做”已经很清楚
- 它的“现在是不是马上实现”还需要再收一层证据

## 可执行动作

1. 后面一旦出现真实 traceId 排查任务，优先用它验证这份草案是否合理。
2. 如果连续几次 investigation 都依赖它，就把它提升到下一批正式 agent 化候选。
3. 真要落地时，先补 contract 和 workflow，再写 TOML。
4. 真要决定能不能升 active 时，先对照 [[trace日志agent什么时候能启用]]，不要凭感觉推进。

## 相关链接

- [[问题排查先查什么证据]]
- [[什么时候把skill做成agent]]
- [[trace日志agent输入输出约定]]
- [[trace日志agent什么时候能启用]]
- [[trace日志agent是做什么的]]
- [[我的Codex多agent改造计划]]
- [[Xuetao多agent体系总结]]
