---
title: "trace日志agent晋升评审"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "保留 trace-log 从 draft 进入 active 前的历史晋升评审表，现在主要用于周期性复盘输出质量。"
tags: ["codex", "agent", "trace", "investigation", "review"]
type: "workflow"
status: "processed"
---

# trace日志agent晋升评审

## 摘要

前面你已经有：

- 激活门槛清单
- 真实案例模板
- 填写样例

但真到了“已经攒了几次真实 case，要不要升 active”的时候，还缺一个很关键的东西：

> 一份固定的评审表，避免最后还是靠主观感觉拍板。

这篇就是补这一层。

它的作用是：

- 当真实 case 积累到 3 个以上时
- 用同一张表逐项检查
- 最后得出“继续保持 draft”还是“可以进 active”

## 核心内容

### 什么时候用这张表

只有当下面这些都成立时，才适合用它：

1. 已经有至少 3 个真实 trace 排查 case
2. 这些 case 都尽量按现有模板沉淀
3. 你现在真的要判断 `tool_trace_log_agent` 能不能写进 `config.toml`

### 评审前先准备什么

建议先把这些材料放一起看：

- `tool_trace_log_agent.draft.toml`
- workflow 草案
- 最小执行入口草案
- 真实案例模板
- 填写样例
- 至少 3 个真实 case 记录

### 评审表应该检查哪些维度

#### 1. Case 清单是否足够

要看：

- 一共评了几个真实 case
- 这些 case 是否都按标准化入口进入
- 是否都复用了同一批核心字段

#### 2. 执行入口是否已经足够稳定

要看：

- 输入是不是已经不用每次重新发明
- `raw_text` / `export_file` / `platform_copy` 这些来源是否可说明
- 是否还经常出现“先大段人工重组输入，才能开始分析”

如果还经常这样，就还不算稳定。

#### 3. Contract 是否稳定

重点看这些核心字段有没有稳定复用：

- `trace_found`
- `timeline_built`
- `first_anomaly_found`
- `first_anomaly_service`
- `root_cause_confidence`
- `needs_more_evidence`

如果字段老在改名、改含义，就还不该晋升。

#### 4. Gate 能不能稳定消费

这里看的是：

- `gate_stage_evaluator_agent` 能不能比较自然地吃下结果
- 是不是能稳定得出 `go / warn / block`
- 要不要每次都靠额外大段人工解释

#### 5. 边界有没有漂移

这里重点防止它越界。

要看：

- 是否始终只是证据提取
- 有没有开始接管 workflow
- 有没有把“建议下一步查什么”偷偷变成“直接开修复方案”

#### 6. 不确定性有没有被诚实保留

要看：

- 缺的证据有没有一直写出来
- 第一异常点和最终根因有没有明确区分
- 有没有过度自信的情况

### 最后的结论怎么下

如果以上核心评审项都通过，才适合给出：

- `promote_to_active`

只要有一项核心评审没过，更合理的结论应该是：

- `stay_draft`
- 或 `collect_more_cases`

也就是说：

> 这张表不是为了帮它“更容易晋升”，而是为了防止它被过早晋升。

### 这张表和前面几篇怎么配合

你可以这样记：

- [[trace日志agent什么时候能启用]]
  - 定义晋升标准
- [[trace日志真实案例模板]]
  - 记录真实 case
- [[trace日志案例填写示例]]
  - 告诉你一条 case 怎么填
- 本篇
  - 当 case 足够后，统一做正式评审

也就是：

> `14` 讲标准，`15/22` 讲怎么积累证据，`23` 讲最后怎么审。

## 可执行动作

1. 现在先不用急着填这张表，等你真的积累到 3 个以上真实 case 再用。
2. 真到准备激活那一步时，优先先按这张表逐项过，而不是直接改 `config.toml`。

## 相关链接

- [[trace日志agent什么时候能启用]]
- [[trace日志真实案例模板]]
- [[trace日志案例填写示例]]
- [[trace日志agent是做什么的]]
