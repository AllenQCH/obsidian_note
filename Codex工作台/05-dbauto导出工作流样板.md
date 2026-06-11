---
title: "dbauto导出工作流样板"
source: "conversation: Codex chat 2026-06-05"
author: "Codex"
published:
created: 2026-06-05
description: "把当前个人多 Agent 体系落到一个具体业务流：dbauto 导出，展示从 control_request_router 到 stage_integration_orchestrator 再到 stage_closeout_reporter 的完整链路。"
tags: ["codex", "agent", "workflow", "dbauto", "openspec"]
type: "workflow"
status: "processed"
---

# dbauto导出工作流样板

## 摘要

这篇笔记的目的，是把前面已经搭好的个人多 Agent 架构，落到一个最熟悉的具体业务流上：`dbauto 导出`。重点不是写脚本细节，而是看一遍：

- 谁判断任务类型
- 谁决定最小执行链
- 谁真正去登录和启动 dbauto
- 谁判断现在只是“环境 ready”，还是“导出已经完成”

如果把这条链看懂，前面那些 `control / stage / tool / gate` 的分层就会直观很多。

## 核心内容

### 用户入口

用户说：

```text
启动 dbauto 导出任务，环境 bj
```

### 当前推荐链路

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator(stage=execution)
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator(gate_execution_ready)
-> stage_integration_orchestrator
-> stage_closeout_reporter
```

### 这条链每一步到底干什么

#### 1. `control_request_router`

它先做分诊。

它看到：

- 用户想做的是 `dbauto 导出`
- 有环境线索 `bj`

它吐出来的应该是：

- 这是导出类任务
- 当前先进入 `planning` 或直接 `execution`
- 后面至少要调：
  - `stage_task_planner`
  - `tool_sso_operator`
  - `tool_dbauto_operator`

它不会直接去登录，也不会直接起脚本。

#### 2. `stage_task_planner`

它负责把用户原话翻成一个最小执行链。

这里它会判断：

1. 先确认 SSO
2. 再准备 dbauto runtime
3. 再判断是否 ready

它吐出来的应该是：

- `selected_operator_chain = [tool_sso_operator, tool_dbauto_operator]`
- `required_inputs = [env]`
- `required_artifacts = [runtime_status]`

它不会自己调用 `opencli`，也不会自己起 dbauto。

#### 3. `control_stage_orchestrator`

它负责把主状态推进到 `execution`，并选出这一步要跑的 agent。

它像一个流程调度员，不像干活的人。

#### 4. `stage_execution_runner`

它负责监督执行顺序：

1. 先跑 `tool_sso_operator`
2. 再跑 `tool_dbauto_operator`

这里最关键的认知是：

> `stage_execution_runner` 是“执行编排”，不是“执行工具”。

它自己不负责登录，也不负责启动后端脚本。

#### 5. `tool_sso_operator`

它只做一件事：解决登录态。

它调用的真实入口是：

```bash
python3 ~/.codex/skills/sso-login/scripts/sso_opencli.py --platform cn --status
```

或者需要时：

```bash
python3 ~/.codex/skills/sso-login/scripts/sso_opencli.py --platform cn
```

它吐出来的结果只应该是：

- 登录态是否有效
- 是否需要用户手动登录

它不应该越权去说：

- “dbauto 已经准备好了”
- “导出已经完成了”

#### 6. `tool_dbauto_operator`

它只做一件事：准备 dbauto runtime 和界面。

它调用的真实入口是：

```bash
~/.codex/skills/dbauto-export-agent/scripts/run_dbauto_export_agent.sh --env bj
```

或者只查状态：

```bash
~/.codex/skills/dbauto-export-agent/scripts/run_dbauto_export_agent.sh --env bj --status-only
```

它真正应该回报的是：

- 本地 FastAPI 后端是否起来
- Browser Bridge 是否健康
- dbauto 页面是否打开
- 插件 UI 是否打开
- wrapper 最终是不是给出了 `RESULT=READY`

这里最容易误判的一点是：

> `RESULT=READY` 只代表导出环境 ready，不代表业务导出一定已经完成。

#### 7. `gate_stage_evaluator`

它用 `gate_stage_evaluator(gate_execution_ready)` 做最后判断。

这里会有三种典型结果：

- `go`
  - SSO 有效
  - dbauto runtime 就绪
- `warn`
  - 环境准备好了，但用户还需要自己选任务、点导出
- `block`
  - 登录没过
  - Browser Bridge 不可用
  - env 不明确
  - 启动器失败

#### 8. `stage_integration_orchestrator`

这一步负责把前面两类前置结果收成一个可交接状态：

1. SSO 是否真的 ready
2. dbauto runtime 是否真的 ready

它最关键的价值是把下面两件事强行拆开：

- 环境是否准备好
- 业务导出是否完成

也就是说，它负责告诉后面的 closeout：

- 现在最多只能确认到哪一步
- 哪些事实已经有证据
- 哪些还只是后续用户操作或后续业务结果

如果没有这一层，`stage_closeout_reporter` 很容易被迫自己一边整合前置结果，一边写最终总结，久了就会变重。

#### 9. `stage_closeout_reporter`

这一步非常重要，因为它负责把“这次到底完成到哪”说清楚。

它要明确区分：

1. 只是登录准备完成
2. dbauto 运行环境准备完成
3. 导出动作已经开始
4. 导出结果已经真正完成

如果没有这一层，很多系统会把“环境已经准备好”误报成“业务任务已经完成”。

### 为什么这条链适合作为样板

因为它正好包含了你体系里最关键的 5 种动作：

1. 路由判断
2. 执行规划
3. 登录型 operator
4. 启动型 operator
5. gate 放行、integration 整合与 closeout 收口

这几步全串起来以后，你就能看见：

- router 和 operator 不该混
- operator 和 gate 不该混
- integration 和 closeout 也不该混
- runtime ready 和 task done 不该混

### 反过来看：如果不拆会发生什么

如果只有一个“大 agent”，它会同时做：

1. 判断是不是 dbauto 导出任务
2. 判断要不要登录
3. 去登录
4. 去起后端和 UI
5. 判断现在是不是完成了
6. 给用户写总结

这样的问题是：

- 一旦中间某一步失败，很难知道错在判断、执行还是收口
- 很容易把“环境准备完成”说成“导出完成”
- 后面想替换登录方式或 dbauto 启动脚本时，整个 agent 都得跟着改

## 可执行动作

1. 把这篇笔记当成第一个个人多 Agent 工作流样板。
2. 后续继续补：
   - `excel 提取工作流样板`
   - `Obsidian 写入 + GitHub 同步样板`
3. 以后只要出现类似“一个任务先准备条件，再调用工具，再判断完成度”的流程，都优先套这一套拆法。

## 相关链接

- [[02-个人Codex多Agent改造计划]]
- [[01-Xuetao-Agent体系研究总结]]
- [[04-Obsidian同步规则拆分说明]]
- [[03-个人.codex目录整理说明与清单]]
