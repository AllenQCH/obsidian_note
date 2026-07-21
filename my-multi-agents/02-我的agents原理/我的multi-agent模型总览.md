---
title: "我的multi-agent模型总览"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "个人 Codex multi-agent 目标模型的职责、控制流和命名规范。"
tags: ["codex", "agent", "workflow", "architecture"]
type: "workflow"
status: "processed"
---

# 我的multi-agent模型总览

## 摘要

本模型用五类 Agent 组成一套可恢复、可验证的任务执行系统。`control` 管入口和状态机，`workflow` 管一类任务的阶段定义，`stage` 对阶段成果负责，`tool` 执行受治理的具体能力，`gate` 做只读放行判断。

```text
control -> workflow -> stage -> tool
                    -> gate
```

## 为什么有两个 Control Agent

| Agent | 只回答什么问题 | 生命周期 |
| --- | --- | --- |
| `control_request_router_agent` | “这个请求属于哪个 Workflow？” | 请求入口执行一次；重分类时再执行 |
| `control_stage_orchestrator_agent` | “这个 Workflow 当前在哪一步，下一步是谁，失败后如何重试或恢复？” | 从开始持续到任务收口 |

它们不是两个重复 Router。前者是分类器，后者是状态机；合并会让入口判断同时持有长任务状态，职责和上下文都会膨胀。

## Agent 与能力

| 对象 | 运行身份 | 典型入口 |
| --- | --- | --- |
| Agent | 有职责、上下文、输出合同的执行主体 | TOML + `[agents.<name>]` |
| Skill | 可复用操作说明 | `SKILL.md` |
| MCP | 外部工具协议 | `[mcp_servers.<name>]` |
| Script | 确定性底层实现 | 可执行文件 |

## 命名规范

```text
control_<responsibility>_agent
workflow_<responsibility>_agent
stage_<responsibility>_agent
tool_<capability>_agent
gate_<responsibility>_agent
```

名称必须同时表达“在哪一层”和“负责什么”。Agent ID 统一以 `_agent` 结尾；Skill 与 MCP 保留各自已有名称，不追加 Agent 后缀。

## 上下文流动

1. Router 输出 `selected_workflow` 和选择理由。
2. Workflow 提供阶段图、必需产物、Gate 和结束条件。
3. Orchestrator 持有当前阶段、重试次数、阻塞原因和恢复点。
4. Stage 读取最小必要上下文并提交结构化产物。
5. Gate 只读产物，输出 `go`、`warn` 或 `block` 及证据缺口。
6. Tool 返回可复现的事实和证据，不替上层决定流程。
