---
title: "我的multi-agent模型总览"
source: "my-multi-agents/02-我的agents原理/我的multi-agent模型总览.md"
author: "Codex"
published:
created: 2026-07-09
description: "当前 personal multi-agents 运行态整理：四层结构（Control/Stage/Tool/Gate）、成员清单、统一运行流与两道硬门禁、按任务形状的路由组，以及与文档落盘规范的衔接。含三张 mermaid 图。"
tags: ["codex", "agent", "workflow", "overview"]
type: "workflow"
status: "processed"
---

# 我的multi-agent模型总览

## 摘要

当前 multi-agents 模型的运行态现状，直接取自 `~/.codex/config.toml`（运行时真相）。

- 结构：四层 + 单一入口 + 门禁贯穿。控制层分诊 → 阶段层干活 → 工具层执行具体操作 → 门禁层放行/拦截。
- 运行时：模型 `gpt-5.5`(medium)，`max_threads=4`，`max_depth=1`。

| 层 | 数量 | 成员 | 职责 |
|---|---|---|---|
| Control 控制 | 2 | `control_request_router`、`control_stage_orchestrator` | 分类路由 + 阶段编排，决定下一步走谁 |
| Stage 阶段 | 6 | task_planner、investigation_planner、execution_runner、test_runner、integration_orchestrator、closeout_reporter | 真正推进任务的角色 |
| Tool 工具 | 17 | `tool_*` operators | 每个只干一件具体的事 |
| Gate 门禁 | 1 | `gate_stage_evaluator` | 一个评估器，多条门禁规则(go/warn/block) |

## 图 1：四层架构总览

```mermaid
flowchart TB
  U["用户请求"] --> L1
  subgraph L1 [Control 控制层]
    router["control_request_router 分类/路由"]
    orch["control_stage_orchestrator 阶段编排"]
    router --> orch
  end
  subgraph L2 [Stage 阶段层 6 角色]
    tp["stage_task_planner 开发规划"]
    ip["stage_investigation_planner 排查规划"]
    er["stage_execution_runner 执行/改码"]
    tr["stage_test_runner 测试主导"]
    io["stage_integration_orchestrator 集成"]
    cr["stage_closeout_reporter 收口"]
  end
  subgraph L3 [Tool 工具层 17 operators]
    tools["tool_sso / dbauto / dbauto_sql / trace_log / cls_log / bk_pipeline / xxljob / excel / obsidian / github_* / weekly_report / gmail / auth_seed / invoice_delete / intl_pof / migration"]
  end
  subgraph L4 [Gate 门禁层]
    gate["gate_stage_evaluator go/warn/block"]
  end
  orch --> L2
  er --> tools
  L2 --> gate
  gate -.放行或拦截.-> orch
```

## 图 2：统一运行流（含两道硬门禁）

所有任务默认走的主干；开发类任务的两道硬门禁在此。

```mermaid
flowchart TB
  U["用户请求"] --> R["control_request_router"]
  R --> O["control_stage_orchestrator"]
  O --> P{"任务性质"}
  P -->|"已知目标/开发"| TP["stage_task_planner"]
  P -->|"报错/traceId/排查"| IP["stage_investigation_planner"]
  TP --> G1{{"gate_design_confirmed 改码前人工确认"}}
  IP --> G1
  G1 -->|"go"| ER["stage_execution_runner 只改码"]
  ER --> TL["tool_* operators 执行动作"]
  ER --> TR["stage_test_runner 设计并跑测试"]
  TR --> G2{{"gate_test_passed 提交前必须测试通过"}}
  G2 -->|"block: 没跑/失败"| ER
  G2 -->|"go"| INT["stage_integration_orchestrator"]
  INT --> CO["stage_closeout_reporter 收口"]
```

## 图 3：控制器怎么路由（按任务形状，不按工具名）

`control_request_router` 先判断 task_shape，再落到对应工具链。现有路由组：

```mermaid
flowchart LR
  R["router 按 task_shape 分诊"] --> A["dbauto_export → sso+dbauto"]
  R --> B["dbauto_readonly_sql → sso+dbauto_sql"]
  R --> C["log_investigation → cls_log+trace_log"]
  R --> D["release_pipeline → sso+bk_pipeline"]
  R --> E["scheduled_ops → sso+xxljob"]
  R --> F["invoice_dml_package → dbauto_sql+invoice_delete"]
  R --> G["permission_ops → dbauto_sql+auth_seed"]
  R --> H["intl_pof_receipt_confirm → dbauto+intl_pof"]
  R --> I["obsidian_knowledge_work → obsidian+github_sync"]
  R --> J["weekly_report / gmail_ops / github_web_ops / migration"]
```

## 门禁规则（一个 gate agent，多条规则）

`gate_stage_evaluator` 按当前阶段套不同规则：

- `gate_design_confirmed` — 改任何代码前，必须人工确认详细方案
- `gate_test_passed` — commit/push/流水线前，test role 必须判定通过（「没跑」=「失败」）
- `gate_execution_ready` / `gate_investigation_ready` / `gate_integration_ready` / `gate_closeout_ready` / `gate_obsidian_sync_ready` — 各阶段就绪校验

## 工具层 17 个 operator（按用途）

- 登录/环境：`tool_sso_operator`、`tool_dbauto_operator`
- 数据查询：`tool_dbauto_sql_operator`
- 日志排查：`tool_cls_log_query_operator`、`tool_trace_log_operator`
- 发布/调度：`tool_bk_pipeline_operator`、`tool_xxljob_execute_once_operator`
- 本地处理：`tool_excel_operator`
- 知识库：`tool_obsidian_operator`、`tool_github_sync_operator`、`tool_github_web_operator`
- 业务专用：`tool_auth_permission_seed_operator`、`tool_invoice_application_full_flow_delete_operator`、`tool_intl_pof_sh_confirm_operator`
- 其它：`tool_weekly_report_operator`、`tool_gmail_classifier_operator`、`tool_personal_migration_curator`

## 和文档落盘的衔接

阶段层角色运行时：**读静态**（`codex-workspace/openspec/` 的 rules/standards/templates），**写动态**（具体服务 `openspec/active/<需求>/iterations/`），收口时把最终版折叠进服务 `specs/`。这套四层 agent 正是文档规范的执行者。

## 相关链接

- [[所有agent四层结构和统一流程]]
- [[开发流程强制门禁改造]]
- [[需求文件夹方案怎么组织]]
- [[本机已启用agent注册表]]
- [[用户说法对应哪个agent]]
