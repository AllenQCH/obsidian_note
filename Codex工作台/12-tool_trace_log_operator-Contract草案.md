---
title: "tool_trace_log_operator Contract草案"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "为未来可能落地的 tool_trace_log_operator 整理字段级 contract 草案，便于后续真正实现 TOML 和 workflow。"
tags: ["codex", "agent", "contract", "trace", "investigation"]
type: "workflow"
status: "processed"
---

# tool_trace_log_operator Contract草案

## 摘要

这篇笔记的目标非常单一：

> 如果你后面真的要实现 `tool_trace_log_operator`，它的输入输出字段应该长什么样？

前面的 [11-tool_trace_log_operator候选拆分草案](./11-tool_trace_log_operator候选拆分草案.md) 已经把“为什么值得做”和“应该放在哪一层”讲清楚了。

这篇往前再走一步，只做字段级 contract 草案。

它不是当前运行配置的一部分，也不是说现在已经注册进了 `config.toml`。

## 核心内容

### 先对齐：它应该遵守什么总规则

如果未来真的落地，它应该继续遵守你本地现有 agent contract 的总形状：

```json
{
  "agent": "tool_trace_log_operator",
  "input": {},
  "output": {
    "facts": [],
    "decision": {},
    "next_actions": [],
    "artifacts_to_update": [],
    "risks": []
  }
}
```

也就是说：

- 不要自己发明一套完全不同的返回格式
- 不要把自然语言长文塞进顶层结构
- 先保持和你现在 `tool_*` agent 的 contract 风格一致

### 建议输入字段

#### 必选候选

- `trace_id`
- `env`

原因：

- 大多数 trace 排查都离不开这两个锚点

#### 常见可选

- `time_range`
- `service_hint`
- `action_hint`
- `raw_logs`
- `platform_results`
- `log_source_type`

建议理解：

- `time_range`：缩小排查窗口
- `service_hint`：告诉 agent 优先关注哪个服务
- `action_hint`：告诉 agent 这是下单、导出、库存还是别的业务动作
- `raw_logs`：用户直接贴的原始文本
- `platform_results`：日志平台检索结果或导出结果
- `log_source_type`：例如 `raw_text`、`export_file`、`platform_copy`

### 建议输出字段

未来如果落地，`decision` 里最值得固定的字段可以是这些：

- `trace_found`
- `timeline_built`
- `first_anomaly_found`
- `root_cause_confidence`
- `needs_more_evidence`

其中：

- `trace_found`：到底有没有找到这个 trace
- `timeline_built`：有没有成功按时间把调用链梳出来
- `first_anomaly_found`：有没有定位到第一异常点
- `root_cause_confidence`：当前根因判断置信度
- `needs_more_evidence`：是否还缺证据

### 更细一层：建议 facts 字段长什么样

`facts` 最适合放已经被验证的观察结果，不放推测。

建议颗粒度：

- `trace_id=<value>`
- `env=<value>`
- `timeline_services=[gateway, order-service, inventory-service]`
- `first_anomaly_service=<service>`
- `first_anomaly_timestamp=<ts>`
- `first_anomaly_signature=<short message>`
- `missing_hops=[...]`
- `evidence_source=<raw_text|platform_results|export_file>`

重点是：

- facts 只写观察到的东西
- 不要把“我猜是数据库慢”这种推测写进 facts

### 更细一层：建议 decision 字段长什么样

一个更完整的 `decision` 草案可以是：

```json
{
  "trace_found": true,
  "timeline_built": true,
  "first_anomaly_found": true,
  "first_anomaly_service": "inventory-service",
  "root_cause_confidence": "medium",
  "needs_more_evidence": true
}
```

这里的重点不是字段多，而是让上层 stage 或 gate 能直接消费。

比如：

- `needs_more_evidence=true`
  说明 investigation 还不能收口
- `root_cause_confidence=low`
  说明 closeout 不能装作已经定位清楚

### 建议 next_actions 字段怎么写

`next_actions` 应该偏“下一步该查什么”，而不是“直接修什么”。

比较合适的内容：

- `补查 inventory-service 同时间窗口原始日志`
- `确认 trace 是否跨环境`
- `补充失败请求的 requestId / 下游服务名`
- `检查第一次 timeout 前是否有重试`

不太合适的内容：

- `直接改代码`
- `马上重启服务`
- `先认定就是某服务问题`

因为那已经越过了 tool agent 的边界。

### 建议 risks 字段怎么写

`risks` 最适合放“当前结论还不稳”的原因。

比如：

- `日志来源只有截图摘要，没有原始文本`
- `缺少完整时间窗口`
- `trace 在当前环境未命中`
- `第一异常点可能只是症状，不一定是根因`

这类字段很有价值，因为它能提醒上层：

- 现在不能过度自信

### 一份可直接参考的示例

```json
{
  "agent": "tool_trace_log_operator",
  "input": {
    "trace_id": "abc123",
    "env": "intl",
    "service_hint": "order-service",
    "platform_results": "..."
  },
  "output": {
    "facts": [
      "trace_id=abc123",
      "env=intl",
      "timeline_services=[gateway, order-service, inventory-service]",
      "first_anomaly_service=inventory-service",
      "first_anomaly_timestamp=2026-06-07T10:01:15.142+08:00",
      "evidence_source=platform_results"
    ],
    "decision": {
      "trace_found": true,
      "timeline_built": true,
      "first_anomaly_found": true,
      "first_anomaly_service": "inventory-service",
      "root_cause_confidence": "medium",
      "needs_more_evidence": true
    },
    "next_actions": [
      "补查 inventory-service 同时间窗口原始日志",
      "确认 timeout 前是否存在第一次失败重试"
    ],
    "artifacts_to_update": [
      "investigation summary",
      "timeline snapshot"
    ],
    "risks": [
      "当前只能确认第一异常点，不能确认最终根因"
    ]
  }
}
```

### 当前最实用的结论

如果后面你真的要把 `trace-log-analysis` 往 agent 落地，这篇的作用就是：

1. 先别从空白开始想字段
2. 直接按这份 contract 草案收敛
3. 再去决定 TOML 怎么写、workflow 怎么接

这会比“先写一个名字，再慢慢补字段”稳很多。

## 可执行动作

1. 未来真正实现 `tool_trace_log_operator` 时，优先复用这份 contract 草案。
2. 如果后面真实 trace 排查任务暴露出新字段，再回头增补，而不是现在过度设计。
3. 真要落地前，可以把这篇和 [11-tool_trace_log_operator候选拆分草案](/Users/heytea/Documents/obsidian_note/Codex工作台/11-tool_trace_log_operator候选拆分草案.md:1) 一起看。
4. 真要决定是否可以写进运行态前，再对照 [[14-tool_trace_log_operator-激活门槛清单]] 逐条确认。

## 相关链接

- [[11-tool_trace_log_operator候选拆分草案]]
- [[14-tool_trace_log_operator-激活门槛清单]]
- [[16-tool_trace_log_operator-专题总览]]
- [[09-Investigation排查工作流样板]]
- [[10-Skill与Agent包装判断]]
- [[02-个人Codex多Agent改造计划]]
