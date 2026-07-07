---
title: "已启用agent怎么用"
source: "/Users/heytea/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-07
description: "把当前 active agent 按任务入口、调用顺序和禁止越界点压缩成一篇实战速查表。"
tags: ["codex", "agent", "workflow", "quickstart"]
type: "workflow"
status: "processed"
---

# 已启用agent怎么用

## 摘要

这篇笔记只解决一个最实际的问题：

> 现在你本地已经有一批 active agent 了，但真到要用的时候，到底应该先想到谁？

这篇不再讲很多抽象概念，而是直接按“任务类型 -> 先走哪条链”来记。

如果你以后只想最快回忆当前 active agent 怎么用，优先看这篇。

完整四层总表看：[[所有agent四层结构和统一流程]]。

## 核心内容

### 一条总原则

当前 active runtime 的最短理解方式是：

```text
用户任务
-> control 判断是什么任务
-> stage 决定怎么推进
-> tool 真正干活
-> gate 判断能不能继续
-> closeout 说明做到哪一步
```

注意：

- `closeout` 不是第五层
- 它仍然属于 `stage` 层的 `stage_closeout_reporter`

### 当前 active agent 一览

#### Control

- `control_request_router`
- `control_stage_orchestrator`

#### Stage

- `stage_task_planner`
- `stage_investigation_planner`
- `stage_execution_runner`
- `stage_integration_orchestrator`
- `stage_closeout_reporter`

#### Tool

- `tool_sso_operator`
- `tool_dbauto_operator`
- `tool_dbauto_sql_operator`
- `tool_excel_operator`
- `tool_obsidian_operator`
- `tool_github_sync_operator`
- `tool_github_web_operator`
- `tool_trace_log_operator`
- `tool_cls_log_query_operator`
- `tool_xxljob_execute_once_operator`
- `tool_weekly_report_operator`
- `tool_gmail_classifier_operator`
- `tool_personal_migration_curator`
- `tool_invoice_application_full_flow_delete_operator`
- `tool_auth_permission_seed_operator`
- `tool_intl_pof_sh_confirm_operator`
- `tool_bk_pipeline_operator`

#### Gate

- `gate_stage_evaluator`

### 1. 如果你要启动 dbauto 导出环境

最短记法：

```text
dbauto export bootstrap
-> tool_sso_operator
-> tool_dbauto_operator
```

完整链路：

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

你要记住的关键点：

- 这个链路的目标通常是“环境 ready”
- 不是“导出结果已经拿到”

也就是说：

> `tool_dbauto_operator` 做的是 bootstrap，不是业务导出完成确认。

### 2. 如果你要在 dbauto 页面查库、列表或看表结构

最短记法：

```text
dbauto read-only SQL
-> tool_sso_operator
-> tool_dbauto_sql_operator
```

完整链路：

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_sql_operator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

当前已经真实验证过的动作：

- 列常用实例
- 列数据库
- 列表
- `SHOW CREATE TABLE`
- `SHOW COLUMNS`

当前要记住的边界：

- `DESC ...` 现在不稳定，页面接口会拒绝

所以如果只是想看表结构，优先用：

- `SHOW CREATE TABLE <table>`
- `SHOW COLUMNS FROM <table>`
- `SHOW TABLES LIKE '<table>'`

### 3. 如果你要做 Excel 提取和去重

最短记法：

```text
excel extraction
-> tool_excel_operator
```

完整链路：

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_excel_operator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

你要记住的关键点：

- 不要直接相信用户口头说的字段名一定就对
- 先确认真实表头、JSON 路径、输出文件位置

收口时应该明确：

- 输入文件路径
- 输出文件路径
- 提取行数
- 去重后行数

### 4. 如果你要写 Obsidian 笔记

最短记法：

```text
local obsidian write
-> tool_obsidian_operator
```

如果还要同步 GitHub：

```text
tool_obsidian_operator
-> gate_stage_evaluator(gate_obsidian_sync_ready)
-> tool_github_sync_operator
```

你要记住的关键点：

- 写笔记和 Git 同步不是一件事
- 本地文件改完，不代表可以直接同步

更准确地说：

> `tool_obsidian_operator` 只负责本地写入，`tool_github_sync_operator` 才负责同步。

### 5. 如果你遇到“现象不对，但还不知道为什么”

最短记法：

```text
investigation
-> stage_investigation_planner
-> 再决定是否调用某个 tool_*
```

这里最重要的不是马上执行工具，而是先分清：

- 哪些是事实
- 哪些只是猜测
- 最小证据集是什么

### 6. 如果你要查 trace 或 CLS 日志

最短记法：

```text
log investigation
-> tool_cls_log_query_operator
-> tool_trace_log_operator
```

你要记住的关键点：

- CLS 负责查日志行和 message
- trace-log 负责还原时间线和第一异常点
- 不要只看最后一个 ERROR 就下根因结论

### 7. 如果你要做交付、流水线或运维动作

常见链路：

```text
release pipeline
-> tool_sso_operator
-> tool_bk_pipeline_operator
```

其他已启用工具：

- `tool_xxljob_execute_once_operator`：固定发票 XXL-Job `280` 的执行一次流程。
- `tool_weekly_report_operator`：查询蓝鲸周报信息。
- `tool_intl_pof_sh_confirm_operator`：海外 POF 收货确认 curl 包准备。

这类动作的共同边界：

- 能改外部状态的动作必须有明确目标和授权。
- `stage_closeout_reporter` 要说清楚只是打开/创建/触发，还是已经看到状态结果。

### 8. 如果你要生成 SQL 包或权限材料

常见链路：

```text
dbauto read-only evidence
-> tool_dbauto_sql_operator
-> domain-specific package operator
```

当前已启用：

- `tool_auth_permission_seed_operator`：权限种子 SQL 和无权限链路诊断。
- `tool_invoice_application_full_flow_delete_operator`：发票申请单全链路删除包。

共同边界：

- 默认只生成材料，不执行生产写 SQL。
- 读库证据走 `tool_dbauto_sql_operator`。

### 9. 如果你要整理个人资源或 Gmail

当前已启用：

- `tool_gmail_classifier_operator`：Gmail 收件箱 label 分类。
- `tool_personal_migration_curator`：个人 agent / skill 资源迁移整理。
- `tool_github_web_operator`：GitHub 网页设置或动作。

这些也都必须走同一套流程：

```text
control -> stage -> tool -> gate -> closeout
```

如果这一步没做好，就很容易把 investigation 误做成 execution。

### 每层最容易犯的错

#### Control 层常见错误

- 一上来就直接选 tool，不先判断任务类型

#### Stage 层常见错误

- 没有先定清楚需要什么输入，就直接推进 execution

#### Tool 层常见错误

- 把 tool agent 当成完整 workflow

#### Gate 层常见错误

- gate 没做判断，只是机械放行

#### Closeout 常见错误

- 把“准备好了”说成“已经完成了”

### 最实用的记忆法

如果你后面懒得记很多名字，只记这 4 句就够：

1. `control` 负责判断任务是什么。
2. `stage` 负责决定下一步怎么推进。
3. `tool` 负责真正执行。
4. `gate` 负责把关，`closeout` 负责讲清楚做到哪。

## 可执行动作

1. 以后先不要从文件名猜 agent 做什么，先按这篇速查。
2. 真遇到 dbauto 场景时，先区分是 export bootstrap，还是 read-only SQL。
3. 真遇到“不知道为什么错了”的场景时，先走 investigation，不要直接 execution。
4. 如果 investigation 后面要继续推进 trace-log 复盘，直接接 [[trace日志真实任务怎么记录]]，不要自己重新拼顺序。

## 相关链接

- [[trace日志agent是做什么的]]
- [[trace日志真实任务怎么记录]]

- [[本机已启用agent注册表]]
- [[已落地能力总清单]]
- [[问题排查先查什么证据]]
