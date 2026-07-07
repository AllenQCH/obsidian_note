---
title: "最新multi-agent流程总览"
source: "/Users/heytea/.codex/config.toml; /Users/heytea/.codex/agents/docs/four-layer-runtime-map.md; /Users/heytea/.codex/agents/docs/agent-workflows.md"
author: "Codex"
published:
created: 2026-07-07
description: "按当前已注册运行态重新整理个人 Codex multi-agent 的四层流程、硬门禁、路由组和收口规则。"
tags: ["codex", "agent", "workflow", "registry", "overview"]
type: "workflow"
status: "processed"
---

# 最新multi-agent流程总览

## 摘要

这篇是当前版本的总入口，只按已经落地的运行态说话。

当前结论：

- `~/.codex/config.toml` 是唯一 active 真源。
- 已启用 26 个 agent：`control` 2 个，`stage` 6 个，`tool` 17 个，`gate` 1 个。
- 统一模型仍然是四层：`control -> stage -> tool -> gate`。
- 开发类任务已经加上两道硬门禁：改代码前必须过 `gate_design_confirmed`，commit / push / pipeline 前必须过 `gate_test_passed`。
- 后续不需要继续抽象设计，优先拿真实任务验证和补具体工具线。

一句话版本：

```text
先路由，再规划；先确认，再执行；先测试，再提交；最后只汇报有证据的状态。
```

## 核心内容

### 1. 当前运行态真源

判断一个 agent 是否真的启用，只看：

```text
/Users/heytea/.codex/config.toml
```

不算 active 的东西：

- Obsidian 草案
- `.draft.*` 文件
- workflow / harness 文档
- OpenSpec 或 prompt 模板

所以用户说“做成 agent / 整理成 agent / 新增 agent”时，默认交付不是写一篇说明，而是：

```text
~/.codex/agents/<layer>/<agent>.toml
+ ~/.codex/config.toml 里的 [agents.<name>] 注册项
+ ~/.codex/agents/docs/agent-registry.md 更新
```

### 2. 最新统一流程

当前所有 active agent 都收敛到这条链：

```text
user request
-> control_request_router
-> control_stage_orchestrator
-> stage_task_planner 或 stage_investigation_planner
-> gate_stage_evaluator(gate_design_confirmed)  # 仅改代码任务，硬门禁
-> stage_execution_runner
-> 一个或多个 tool_* operator
-> stage_test_runner                         # 代码改动后，测试角色
-> gate_stage_evaluator(gate_test_passed)    # commit / push / pipeline 前硬门禁
-> stage_integration_orchestrator
-> stage_closeout_reporter
```

这条链的关键点：

- `control` 只判断走哪条路，不做工具动作。
- `stage` 管阶段目标、证据和推进，不吞掉具体工具逻辑。
- `tool` 只做一个小的操作能力。
- `gate` 只给 `go / warn / block`，不替代执行。
- `closeout` 只汇报已验证事实，不补脑不存在的完成状态。

### 3. 四层 agent 清单

#### Control

| agent | 作用 |
| --- | --- |
| `control_request_router` | 判断任务类型、缺失输入和候选链路 |
| `control_stage_orchestrator` | 维护当前阶段，选择下一批 stage / tool / gate |

#### Stage

| agent | 作用 |
| --- | --- |
| `stage_task_planner` | 已知目标任务的输入、输出、工具链规划 |
| `stage_investigation_planner` | 原因不明任务的最小证据集和假设拆分 |
| `stage_execution_runner` | 按已选链路执行，记录事实；改代码不自行 commit / push |
| `stage_test_runner` | 代码改动后的测试角色，负责测试设计、执行和 pass / fail |
| `stage_integration_orchestrator` | 汇总多工具、多产物、多仓库结果 |
| `stage_closeout_reporter` | 最终收口，汇报证据、路径、链接和剩余风险 |

#### Tool

| agent | 作用 |
| --- | --- |
| `tool_sso_operator` | 检查或准备 HeyTea SSO |
| `tool_dbauto_operator` | 准备 dbauto 导出运行环境 |
| `tool_dbauto_sql_operator` | 国内 dbauto 只读 SQL / 元数据查询 |
| `tool_excel_operator` | Excel / CSV 提取、去重、生成文件 |
| `tool_obsidian_operator` | 本地 Obsidian 笔记写入、移动、整理 |
| `tool_github_sync_operator` | Obsidian 改完后的 GitHub 同步 |
| `tool_github_web_operator` | GitHub 网页设置和浏览器确认类动作 |
| `tool_trace_log_operator` | traceId 时间线和第一异常点整理 |
| `tool_cls_log_query_operator` | 腾讯云 CLS 日志查询和第一错误证据提取 |
| `tool_xxljob_execute_once_operator` | 固定发票 XXL-Job `jobId=280` 执行一次 |
| `tool_weekly_report_operator` | 蓝鲸周报只读查询和格式化 |
| `tool_gmail_classifier_operator` | Gmail Inbox label 分类 |
| `tool_personal_migration_curator` | 个人 agent / skill 可迁移资源整理 |
| `tool_invoice_application_full_flow_delete_operator` | 发票申请单全链路删除包生成 |
| `tool_auth_permission_seed_operator` | HSP 权限种子 SQL 和无权限链路诊断 |
| `tool_intl_pof_sh_confirm_operator` | 海外 POF 收货单满数量确认 curl 包准备 |
| `tool_bk_pipeline_operator` | 蓝鲸需求流水线和服务子流水线操作 |

#### Gate

| agent | 作用 |
| --- | --- |
| `gate_stage_evaluator` | 统一按规则输出 `go / warn / block` |

### 4. 任务怎么路由

controller 先看任务形状，不按关键词硬套工具。

| 用户想做什么 | 任务形状 | 主要链路 |
| --- | --- | --- |
| 启动或检查 dbauto 导出环境 | `dbauto_export` | `tool_sso_operator -> tool_dbauto_operator` |
| 查库表、表结构、只读 SQL | `dbauto_readonly_sql` | `tool_sso_operator -> tool_dbauto_sql_operator` |
| 查 trace / CLS / message | `log_investigation` | `tool_cls_log_query_operator -> tool_trace_log_operator` |
| 处理 Excel / CSV | `local_file_processing` | `tool_excel_operator` |
| 写 Obsidian / 同步 GitHub | `obsidian_knowledge_work` | `tool_obsidian_operator -> tool_github_sync_operator` |
| 创建、打开、重跑蓝鲸流水线 | `release_pipeline` | `tool_sso_operator -> tool_bk_pipeline_operator` |
| 执行一次 XXL-Job | `scheduled_ops` | `tool_sso_operator -> tool_xxljob_execute_once_operator` |
| 查周报 | `weekly_report` | `tool_sso_operator -> tool_weekly_report_operator` |
| 整理 Gmail 分类 | `gmail_ops` | `tool_gmail_classifier_operator` |
| 操作 GitHub 网页 | `github_web_ops` | `tool_github_web_operator` |
| 权限种子 SQL / 无权限排查 | `permission_ops` | `tool_dbauto_sql_operator -> tool_auth_permission_seed_operator` |
| 发票申请单删除包 | `invoice_dml_package` | `tool_dbauto_sql_operator -> tool_invoice_application_full_flow_delete_operator` |
| 海外 POF 收货确认准备 | `intl_pof_receipt_confirm` | `tool_dbauto_operator -> tool_intl_pof_sh_confirm_operator` |
| 个人 agent / skill 迁移整理 | `personal_framework_migration` | `tool_personal_migration_curator` |

### 5. 开发类任务的新流程

开发类任务包括：

- `new_feature_from_scratch`，中文叫 `新项目开发`
- `iterative_feature_development`，中文叫 `迭代开发`
- `existing_feature_continuation`，中文叫 `迭代再开发`
- 任务中途发现需要改代码的 bug fix

默认流程：

```text
路由 / 分类
-> 需求、影响面、证据分析
-> 设计或修复方案确认
-> gate_design_confirmed  # 人工硬确认
-> 建分支 / 复用分支
-> 实现
-> stage_test_runner 设计并执行测试
-> gate_test_passed       # 测试通过硬门禁
-> commit / push
-> 需要提测或流水线时再进入 BK / AliDocs / OpenSpec 收口
-> closeout
```

这里的懒人原则是：确认点前置，后面自动跑完；但任何代码改动都不能跳过设计确认和测试通过。

### 6. 三个最容易混淆的边界

#### dbauto 导出环境和只读 SQL 不是一个工具

```text
导出环境 ready -> tool_dbauto_operator
查库表 / 表结构 / 只读 SQL -> tool_dbauto_sql_operator
```

#### 写 Obsidian 和同步 GitHub 是两步

```text
本地写入 -> tool_obsidian_operator
同步 GitHub -> gate_obsidian_sync_ready -> tool_github_sync_operator
```

#### CLS 日志行和 trace 根因整理不是一件事

```text
查可见日志行 -> tool_cls_log_query_operator
整理 trace 时间线和第一异常点 -> tool_trace_log_operator
```

## 可执行动作

1. 想快速回忆当前体系，先看这篇，再看 [[本机已启用agent注册表]]。
2. 真正执行任务时，用 [[用户说法对应哪个agent]] 做自然语言到链路的速查。
3. 如果是开发类任务，必须同时看 [[开发流程强制门禁改造]]。
4. 后续新增 agent 时，只更新运行态注册表和对应 Obsidian 入口，不再新增大而全的抽象说明。

## 相关链接

- [[本机已启用agent注册表]]
- [[所有agent四层结构和统一流程]]
- [[已启用agent怎么用]]
- [[用户说法对应哪个agent]]
- [[开发流程强制门禁改造]]
- [[OpenSpec证据链怎么用]]
