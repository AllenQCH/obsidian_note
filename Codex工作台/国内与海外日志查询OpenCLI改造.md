---
title: "国内与海外日志查询OpenCLI改造"
source: "Codex工作台/国内与海外日志查询OpenCLI改造.md"
author: "heytea"
published:
created: 2026-07-13
description: "记录国内和海外日志查询从运行时网页探索收敛为统一 heytea-log OpenCLI Adapter 的实现、调用和安全边界。"
tags: ["codex", "agent", "workflow", "opencli", "logging"]
type: "workflow"
status: "processed"
---

# 国内与海外日志查询OpenCLI改造

## 摘要

国内与海外日志查询已统一到 LogTracer OpenCLI Adapter。Agent 不再默认临时拼接 `opencli browser eval` 请求，而是通过 `opencli heytea-log topics/query` 完成 Topic 发现和只读日志查询。

现有 `tool_cls_log_query_operator` ID 保留，以兼容原有 multi-agent 路由；它的底层公共能力已经升级为国内、海外双区域查询。

## 核心内容

### 能力分层

```text
Hermes / Codex 路由
-> tool_cls_log_query_operator
-> opencli heytea-log topics/query
-> LogTracer getLogCluster/searchPost
-> 结构化日志行
-> tool_trace_log_operator / trace-log-analysis
```

Operator 负责区域、环境、安全边界和证据契约；OpenCLI Adapter 负责确定性请求；trace 分析能力负责时间线和首个异常判断。

### Topic 查询

```bash
opencli heytea-log topics --region-scope cn --contains hsp
opencli heytea-log topics --region-scope intl --contains hsp
```

### 日志查询

```bash
opencli heytea-log query cn --env prod --trace-id <traceId> --minutes 60 -f json
opencli heytea-log query intl --env prod --trace-id <traceId> --minutes 60 -f json
```

支持的查询输入三选一：

- `--trace-id <id>`
- `--message <text>`
- `--query <LogTracer表达式>`

### 默认 Topic

| 区域 | 生产 | 测试 |
| --- | --- | --- |
| 国内 | `prod-hsp` | `heyteago-test-stg` |
| 海外 | `prod-intl-uswest-hsp-k8s-log` | `heyteago-test-intl-app` |

默认 Topic 只适用于 HSP。其他业务域应先用 `topics` 查询，再通过 `--topic` 指定准确名称或 UUID。

### 安全边界

- 仅提供日志只读查询，不修改日志平台状态。
- `region_scope` 必须为 `cn` 或 `intl`。
- 默认时间窗口 60 分钟，单次最多 50 行。
- 历史事故可使用成对的 ISO `--from/--to` 绝对时间，最大范围 90 天；避免相对时间窗口滚动后误判无日志。
- 日志正文默认最多返回 2000 字符，避免生产数据和上下文过度读取。
- 不输出 cookie、token、session 或无关日志。
- 空结果只证明当前 Topic、查询和时间范围内没有命中。
- 原腾讯 CLS 页面只在用户给出可工作的 CLS URL，或现有标签页有结果而 LogTracer 无法表达目标时作为兜底。

### 验证结果

- 两个 Adapter 均通过 `opencli validate`。
- `opencli list` 可以发现 `heytea-log/query` 和 `heytea-log/topics`。
- 国内/海外、生产/测试四个默认 Topic 均完成真实只读验证。
- 国内和海外各抽取一条 ERROR 验证了统一字段契约，未在文档中保存日志正文。
- 自检脚本：`tasks/20260713-log-query-opencli/verify_log_adapter.mjs`。

## 可执行动作

- 国内 HSP trace 查询优先直接使用 `heytea-log query cn`。
- 海外 HSP trace 查询优先直接使用 `heytea-log query intl`。
- 非 HSP 场景先用 `heytea-log topics` 查准确 Topic。
- 查询结果需要根因分析时，继续交给 `tool_trace_log_operator`，不要把最后一条 ERROR 直接当根因。

## 相关链接

- [[Skill放在哪里以及怎么维护]]
- [[我的.codex目录里有什么]]
- [[Codex agent会读取哪些上下文]]
