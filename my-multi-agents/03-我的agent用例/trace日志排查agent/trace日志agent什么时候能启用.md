---
title: "trace日志agent什么时候能启用"
source: "conversation: Codex chat 2026-06-07; updated 2026-07-20"
author: "Codex"
published:
created: 2026-06-07
description: "tool_trace_log_agent 按目标名称迁移并标记 active 前的验证清单。"
tags: ["codex", "agent", "workflow", "trace", "investigation", "registry"]
type: "workflow"
status: "processed"
---

# trace日志agent什么时候能启用

## 摘要

只有目标 ID、运行时注册、能力入口和真实案例验证同时成立，才能把 `tool_trace_log_agent` 标记为 active。旧 ID 是否运行过不能代替新 ID 的迁移验证。

## 启用条件

| 条件 | 最小证据 |
| --- | --- |
| Agent TOML 存在 | 目标路径可读，职责和合同完整 |
| 全局注册存在 | `config.toml` 有对应 `[agents.<name>]` |
| 底层能力可调用 | 真实日志查询或导出入口成功 |
| 输入校验有效 | 缺 traceId/环境/时间窗时能安全拒绝 |
| 输出合同稳定 | 时间线、第一异常、事实/推断/缺口字段齐全 |
| 案例验证通过 | 至少三个差异明显的真实案例可复现 |
| 安全边界明确 | 默认只读，不泄露凭据和敏感日志 |
| 目录校验通过 | 注册表、引用和 catalog 校验无漂移 |

## 判定

- 条件全部满足：可以标记 active。
- 能力可用但目标注册未迁移：记录为“底层能力可用”，不能标记目标 Agent active。
- 真实能力无法运行：状态为 blocked/pending，并记录第一个具体错误和可验证的解除条件。
