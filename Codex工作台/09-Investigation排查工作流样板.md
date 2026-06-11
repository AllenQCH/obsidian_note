---
title: "Investigation排查工作流样板"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "用一个“dbauto 启动了但没有真正导出”的排查例子，说明 stage_investigation_planner、gate_stage_evaluator(gate_investigation_ready) 和证据链是怎么工作的。"
tags: ["codex", "agent", "workflow", "investigation", "dbauto"]
type: "workflow"
status: "processed"
---

# Investigation排查工作流样板

## 摘要

前面的几个样板大多都是“已经知道要做什么”的执行型任务。

这篇笔记专门补另外一类情况：

> 你知道现象不对，但还不知道根因是什么。

这种场景就不该直接进入 `execution`，而应该先走 `investigation`。最典型的例子就是：

```text
为什么 dbauto 已经启动了，但是没有真正导出？
```

这时候最重要的不是立刻重跑，而是先把证据链补齐：

- 登录态到底是不是好的
- runtime 到底是不是好的
- 当前到底只是环境 ready，还是业务导出真的做完了

## 核心内容

### 用户入口

用户说：

```text
为什么 dbauto 已经启动了，但是没有真正导出？
```

### 当前推荐链路

```text
control_request_router
-> stage_investigation_planner
-> control_stage_orchestrator(stage=investigation)
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator(gate_investigation_ready)
-> stage_task_planner or stage_closeout_reporter
```

### 这条链每一步到底干什么

#### 1. `control_request_router`

它先判断：这不是普通执行任务，而是一个排查任务。

因为用户现在表达的是：

- 现象不对
- 但根因还不清楚

所以它不该直接走 `stage_task_planner -> execution`，而应该先把当前 stage 定位为 `investigation`。

#### 2. `stage_investigation_planner`

它先定义“这次到底要查什么证据”。

在这个例子里，它至少要拆出 3 个问题：

1. SSO 登录态是不是还有效
2. dbauto runtime 是不是真的 ready
3. 有没有任何证据证明“业务导出已经完成”

也就是说，这一步的关键不是直接下结论，而是先把“已知”和“未知”分开。

它应该吐出来的不是修复方案，而是这种排查范围：

- `selected_evidence_operators = [tool_sso_operator, tool_dbauto_operator]`
- `known_unknowns = [session_status, runtime_status, export_business_result]`

#### 3. `control_stage_orchestrator`

它把当前阶段推进到 `investigation`，并选出这一轮真正要跑的 agent：

- `tool_sso_operator`
- `tool_dbauto_operator`

这里它做的是调度，不是排查本身。

#### 4. `tool_sso_operator`

它负责回答一个很窄的问题：

> 当前统一登录态是不是有效？

比如它跑完以后，能告诉你：

- `session_status = ready`
- 或者 `login_required = true`

它的价值是把“登录有问题”这种可能性先单独隔离出来。

#### 5. `tool_dbauto_operator`

它负责回答另一个很窄的问题：

> dbauto 的本地运行环境到底有没有准备好？

它应该回报的是：

- 后端是否起来
- Browser Bridge 是否正常
- 页面是否打开
- wrapper 是否给出 `RESULT=READY`

但最关键的是：

> `RESULT=READY` 只能证明环境 ready，不能证明导出已经完成。

这正是 investigation 场景最容易误判的地方。

#### 6. `gate_stage_evaluator`

这里要用的是：

```text
gate_stage_evaluator(gate_investigation_ready)
```

它看的不是“问题有没有修好”，而是：

- 当前证据够不够支持一个可信结论
- 还是说现在仍然只是在猜

一个典型的 `go` 结论可能是：

- 登录态没问题
- runtime 也没问题
- 但没有任何证据证明用户已经完成了真正的导出动作

那这时候最合理的结论就不是“系统坏了”，而是：

- 当前只证明了环境 ready
- 还没有证明业务导出完成

#### 7. `stage_task_planner` 或 `stage_closeout_reporter`

这里要看 investigation 的结果。

如果排查后发现：

- 还缺一个明确的下一步动作

那就进入 `stage_task_planner`，把后续动作规划清楚。

比如：

- 让用户补一个导出动作的实际路径
- 或者补一个 UI 截图 / 导出结果证据

如果排查后已经足够得出结论：

- 当前只是环境准备完成
- 没有业务导出完成证据

那就可以直接进入 `stage_closeout_reporter`，把结论讲清楚。

### 为什么 investigation 这一层必须单独存在

如果没有这一层，系统很容易犯 3 种错：

1. 一看到问题，就直接重跑工具
2. 一看到 `RESULT=READY`，就误判“看起来没问题”
3. 一边收集证据，一边乱下结论

而 investigation 的价值就在于：

- 先限定证据范围
- 先区分事实和猜测
- 先判断“现在到底知不知道根因”

也就是说，这一层不是“多余的一步”，而是为了避免你把排查任务误做成执行任务。

### 你看这条链时要重点抓住什么

如果只记 3 句话，记这 3 句：

1. `investigation` 的目标不是立刻修，而是先把证据补齐。
2. `tool_*` 只能证明局部事实，不能自己宣布根因。
3. `gate_stage_evaluator(gate_investigation_ready)` 判断的是“证据够不够”，不是“问题修没修好”。

## 可执行动作

1. 以后凡是“现象不符合预期，但根因不清楚”的任务，优先考虑先走 `stage_investigation_planner`。
2. 不要把 `RESULT=READY` 直接当成业务完成证据。
3. 后面如果你补 `tool_trace_log_operator`，这篇就是最适合继续扩展的 investigation 样板。
4. 真拿到 traceId 任务时，不想自己重新组织顺序，直接跳到 [[26-trace-log真实任务执行卡片]]。

## 相关链接

- [[00-Agent体系阅读顺序概览]]
- [[02-个人Codex多Agent改造计划]]
- [[05-dbauto导出工作流样板]]
- [[08-本地Multi-Agent Registry]]
- [[13-Active与Draft状态矩阵]]
- [[16-tool_trace_log_operator-专题总览]]
- [[21-tool_trace_log_operator-最小执行入口草案]]
- [[22-tool_trace_log_operator-填写样例]]
- [[23-tool_trace_log_operator-晋升评审表]]
- [[26-trace-log真实任务执行卡片]]
- [[17-当前成果总清单]]
- [[01-Xuetao-Agent体系研究总结]]
