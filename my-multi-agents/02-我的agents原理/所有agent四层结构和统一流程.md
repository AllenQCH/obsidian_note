---
title: "所有agent四层结构和统一流程"
source: "/Users/heytea/.codex/agents/docs/four-layer-runtime-map.md"
author: "Codex"
published:
created: 2026-07-05
description: "把本机 config.toml 中已注册的所有 active agent 按 control、stage、tool、gate 四层结构和统一做事流程整理成一张总图。"
tags: ["codex", "agent", "workflow", "registry"]
type: "workflow"
status: "processed"
---

# 所有agent四层结构和统一流程

## 摘要

这篇笔记回答一个问题：

> 本机所有 active agent 怎么统一到同一套做事流程里？

当前运行态真源仍然是：

```text
/Users/heytea/.codex/config.toml
```

结论是：现在所有已注册 agent 都可以归入同一条流程。

```text
用户请求
-> control_request_router 先判断任务类型（改代码则标 will_change_code）
-> control_stage_orchestrator 选择阶段和下一批 agent
-> stage_task_planner / stage_investigation_planner 定义边界
-> gate_stage_evaluator(gate_design_confirmed) 改代码前必须人工确认（硬门禁）
-> stage_execution_runner 只改代码，不 commit/push
-> tool_* agent 做具体动作
-> stage_test_runner 测试角色主导：设计+执行测试，判 pass/fail
-> gate_stage_evaluator(gate_test_passed) 测试通过才允许 commit/push（硬门禁）
-> stage_integration_orchestrator 汇总多工具结果
-> stage_closeout_reporter 收口说明
```

> 2026-07-07 加固：凡是改代码的开发流程，都强制两道硬门禁——改代码前人工确认 `gate_design_confirmed`、代码后由测试角色 `stage_test_runner` 主导且 `gate_test_passed` 通过才 push。详见 [[开发流程强制门禁改造]]。

重点不是把每个场景做成一个大 agent，而是让 controller 从任务类型找到正确的小 agent 链。

## 四层结构

### Control：先判断该走哪条路

| agent | 做什么 |
| --- | --- |
| `control_request_router` | 判断用户请求属于哪类任务，补最少缺失信息，推荐下一条 agent 链 |
| `control_stage_orchestrator` | 维护当前阶段，选择 stage / tool / gate 的下一步 |

### Stage：定义当前阶段怎么做

| agent | 做什么 |
| --- | --- |
| `stage_task_planner` | 已知目标的执行型任务，先规划输入、输出、工具链 |
| `stage_investigation_planner` | 原因不明的问题，先定义证据链，不直接执行 |
| `stage_execution_runner` | 按顺序跑已选工具，记录执行事实；改代码只在确认后，且不自行 commit/push |
| `stage_test_runner` | 测试角色：给改动代码设计+执行测试，判 pass/fail，卡住 commit/push |
| `stage_integration_orchestrator` | 多个工具或多份产物之间做汇总和交接 |
| `stage_closeout_reporter` | 最终说明做到了哪里、有哪些证据、还剩什么 |

### Tool：只做一个具体动作

| agent | 对应任务 |
| --- | --- |
| `tool_sso_operator` | 检查或准备 SSO 登录态 |
| `tool_dbauto_operator` | 准备 dbauto 导出环境，不代表导出完成 |
| `tool_dbauto_sql_operator` | 查 dbauto 库表和只读 SQL |
| `tool_excel_operator` | Excel / CSV 提取、去重、生成结果文件 |
| `tool_obsidian_operator` | 本地 Obsidian 笔记写入、移动、整理 |
| `tool_github_sync_operator` | Obsidian 改完后同步 GitHub |
| `tool_github_web_operator` | 通过网页操作 GitHub 仓库设置或动作 |
| `tool_trace_log_operator` | 根据 traceId 还原时间线和第一异常点 |
| `tool_cls_log_query_operator` | 查腾讯云 CLS 日志行和 message |
| `tool_xxljob_execute_once_operator` | 固定发票 XXL-Job `280` 的执行一次流程 |
| `tool_weekly_report_operator` | 查询蓝鲸周报信息并格式化 |
| `tool_gmail_classifier_operator` | Gmail 收件箱 label 分类 |
| `tool_personal_migration_curator` | 整理可迁移的个人 agent / skill 资源 |
| `tool_invoice_application_full_flow_delete_operator` | 生成发票申请单全链路删除包 |
| `tool_auth_permission_seed_operator` | 生成或诊断 HSP 权限种子 SQL |
| `tool_intl_pof_sh_confirm_operator` | 海外 POF 收货单满数量确认 curl 包准备 |
| `tool_bk_pipeline_operator` | 蓝鲸需求流水线 / 服务子流水线操作 |

### Gate：统一判断能不能继续

| agent | 做什么 |
| --- | --- |
| `gate_stage_evaluator` | 统一输出 `go / warn / block`，判断执行、排查、同步、收口是否满足条件 |

## controller 应该怎么路由

| 用户想做什么 | controller 应该归类 | 主要工具链 |
| --- | --- | --- |
| 启动或检查 dbauto 导出环境 | `dbauto_export` | `tool_sso_operator -> tool_dbauto_operator` |
| 查库表、表结构、只读 SQL | `dbauto_readonly_sql` | `tool_sso_operator -> tool_dbauto_sql_operator` |
| 查 traceId、CLS、message、日志异常 | `log_investigation` | `tool_cls_log_query_operator -> tool_trace_log_operator` |
| 处理 Excel / CSV | `local_file_processing` | `tool_excel_operator` |
| 写 Obsidian 或同步 GitHub | `obsidian_knowledge_work` | `tool_obsidian_operator -> tool_github_sync_operator` |
| 创建、打开、重跑蓝鲸流水线 | `release_pipeline` | `tool_sso_operator -> tool_bk_pipeline_operator` |
| 执行一次 XXL-Job | `scheduled_ops` | `tool_sso_operator -> tool_xxljob_execute_once_operator` |
| 查周报 | `weekly_report` | `tool_sso_operator -> tool_weekly_report_operator` |
| 整理 Gmail 分类 | `gmail_ops` | `tool_gmail_classifier_operator` |
| 操作 GitHub 网页 | `github_web_ops` | `tool_github_web_operator` |
| 权限种子 SQL 或无权限排查 | `permission_ops` | `tool_dbauto_sql_operator -> tool_auth_permission_seed_operator` |
| 发票申请单删除包 | `invoice_dml_package` | `tool_dbauto_sql_operator -> tool_invoice_application_full_flow_delete_operator` |
| 海外 POF 收货确认准备 | `intl_pof_receipt_confirm` | `tool_dbauto_operator -> tool_intl_pof_sh_confirm_operator` |
| 个人 agent/skill 迁移整理 | `personal_framework_migration` | `tool_personal_migration_curator` |

## 最容易混淆的边界

- 说了 `dbauto` 不等于都用 `tool_dbauto_operator`。
  - 导出环境用 `tool_dbauto_operator`
  - 查库表和只读 SQL 用 `tool_dbauto_sql_operator`
- 查 CLS 日志行不等于 trace 根因分析。
  - 先用 `tool_cls_log_query_operator` 拿日志证据
  - 再用 `tool_trace_log_operator` 做时间线和第一异常点
- 写 Obsidian 不等于同步 GitHub。
  - 本地写入用 `tool_obsidian_operator`
  - 过 gate 后才用 `tool_github_sync_operator`
- tool agent 不判断整个任务完成。
  - 最终是否能收口，由 `gate_stage_evaluator` 和 `stage_closeout_reporter` 负责。

## 相关链接

- [[本机已启用agent注册表]]
- [[已启用agent怎么用]]
- [[用户说法对应哪个agent]]
- [[任务工作流总览]]
- [[哪些agent已启用哪些还只是草稿]]
