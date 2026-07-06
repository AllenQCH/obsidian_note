---
title: "trace日志agent什么时候能启用"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "为 tool_trace_log_operator 从 draft 晋升为 active 前补一份明确的激活门槛与验证清单。"
tags: ["codex", "agent", "workflow", "trace", "investigation", "registry"]
type: "workflow"
status: "processed"
---

# trace日志agent什么时候能启用

## 摘要

这篇笔记只解决一个问题：

> `tool_trace_log_operator` 什么时候才算可以从 draft 晋升成 active？

前面你已经有：

- 候选拆分草案
- contract 草案
- investigation workflow 草案

但还缺一层非常关键的判断：

> 到底满足什么条件，才可以真的写进 `~/.codex/config.toml`？

这篇就是把这层补清楚。

当前结论先说在前面：

- 它现在仍然只是 draft
- 现在还不应该注册进运行态
- 后面要不要升 active，不靠感觉，靠清单

## 核心内容

### 激活总原则

只有当下面几类条件都满足时，`tool_trace_log_operator` 才应该进入 active：

1. 执行入口足够确定
2. 多次真实 investigation 证明 contract 稳定
3. gate 能稳定消费它的输出
4. 它仍然保持 `tool_*` 边界，不越界
5. 它能明确表达不确定性

### 1. 执行入口足够确定

这条的意思不是“理论上能分析日志”。

而是：

- 你已经知道它到底怎么跑
- 输入来源不会每次都完全变形
- 它能说清楚这次证据来自哪里

至少要能稳定覆盖这些入口之一：

- 用户直接贴原始日志
- 用户给导出的日志文件
- 用户给日志平台复制结果

如果现在每次都还是：

- 先人工判断用什么方式看
- 再临时决定怎么组织输入

那就还不算稳定执行入口。

### 2. 多次真实 investigation 证明 contract 稳定

这条很关键。

不是写出一份好看的 contract 草案就够了，而是至少要有几次真实任务证明这份字段真的好用。

建议最低标准：

- 至少 3 次真实 trace 排查任务
- 都能稳定复用同一批核心字段

最值得固定的 decision 字段仍然是：

- `trace_found`
- `timeline_built`
- `first_anomaly_found`
- `first_anomaly_service`
- `root_cause_confidence`
- `needs_more_evidence`

如果每排查一次都想改字段名、改字段含义，那就说明它还没稳定。

### 3. gate 能稳定消费它的输出

也就是说，上层 `gate_stage_evaluator(gate_investigation_ready)` 看到它的结果后，能比较自然地做出三种判断：

- `go`
- `warn`
- `block`

比如：

- `go`：已经知道第一异常点，足够决定下一步查哪里
- `warn`：第一异常点知道了，但根因还不够稳
- `block`：trace 没找到，或者时间线根本拼不起来

如果每次都还要靠大段人工解释，gate 才能看懂，那这个 agent 还不够成熟。

### 4. 它必须一直保持 tool 边界

这是最容易漂移的地方。

它可以做的是：

- 抽日志证据
- 重建时间线
- 标第一异常点
- 提醒缺什么证据

它不该做的是：

- 自己决定整个任务该怎么路由
- 自己扮演 investigation planner
- 直接宣布“根因已经确认”
- 直接指挥“马上改代码”

一句话说：

> 它是证据提取者，不是排查总控。

### 5. 它必须能诚实表达不确定性

trace 排查很容易出现一个错觉：

- 第一个 timeout 看起来像根因

但很多时候它只是症状。

所以它要能稳定输出：

- 当前只是第一异常点
- 还不是最终根因
- 缺少哪些证据
- 下一步应该补查什么

如果它开始经常把“第一异常点”说成“已经确认根因”，就不适合升 active。

### 最低激活证据清单

真要升 active，至少要同时具备这些东西：

1. 一份稳定的 draft TOML
2. 一份 workflow 草案
3. 一份 contract 草案
4. 至少 3 次真实排查案例，证明同一套输入输出形状能复用
5. 一次明确结论：可以正式写入 `~/.codex/config.toml`

### 真正晋升时的动作顺序

建议顺序：

1. 先确认上面的激活条件已经满足
2. 再把 `tool_trace_log_operator.draft.toml` 升级为正式 TOML
3. 再写进 `~/.codex/config.toml`
4. 再同步更新：
   - 本地 registry
   - workflow
   - contract
   - tool matrix
5. 最后更新 Obsidian 对应笔记

### 当前状态判断

按现在已有证据看，它还不该升 active。

主要还差：

- 执行入口还不够稳定
- 没有记录到足够多的真实 trace 排查案例
- gate 消费它的输出还没有经过多轮验证

所以现在最合理的状态仍然是：

> 值得重点培养的 draft candidate，但暂不注册进运行态。

## 可执行动作

1. 后面一旦出现真实 traceId 排查任务，就拿这篇清单逐条对照。
2. 如果连续几次真实任务都证明这套 contract 和 workflow 稳定，再考虑晋升。
3. 在晋升前，不要因为已经有 draft TOML 就误以为它已经“差不多可以用了”。
4. 记录真实案例时，优先按 [[trace日志真实案例模板]] 沉淀，避免事后回忆失真。

## 相关链接

- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[哪些agent已启用哪些还只是草稿]]
- [[trace日志真实案例模板]]
- [[trace日志agent是做什么的]]
- [[问题排查先查什么证据]]
- [[本机已启用agent注册表]]
