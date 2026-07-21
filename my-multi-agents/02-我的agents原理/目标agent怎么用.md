---
title: "目标agent怎么用"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "目标 Agent 的入口调用、单阶段调用和边界说明。"
tags: ["codex", "agent", "workflow", "usage"]
type: "workflow"
status: "processed"
---

# 目标agent怎么用

## 摘要

默认从 `control_request_router_agent` 进入完整 Workflow。用户也可以明确请求单一职责 Agent，例如只设计测试用例或只评审代码；此时 Router 仍负责把请求识别为窄任务，Orchestrator 只编排必要阶段，不需要预先建立独立 subflow。

## 默认入口

```text
用户请求
-> control_request_router_agent
-> workflow_*_agent
-> control_stage_orchestrator_agent
-> 必要的 stage / gate / tool
```

## 单一职责请求

| 用户意图 | 调用方式 | 边界 |
| --- | --- | --- |
| “只帮我整理测试用例” | 调用 `stage_test_case_designer_agent` | 不自动启动服务或交付 |
| “只在本地测试这次改动” | 调用 `stage_test_runner_agent` | 可启动 Docker/服务，但不自动发布 |
| “只做代码审查” | 调用 `stage_code_reviewer_agent` | 只读审查；修复需另行进入开发阶段 |
| “重新生成提测材料” | `stage_version_delivery_agent` 调用 `tool_test_delivery_document_agent` | 外部提交仍受确认边界约束 |
| “调整交付流程设计” | 维护 `stage_version_delivery_agent` 的阶段合同 | 属于框架变更，不等于执行交付 |

## 直接指定 Agent 的语义

用户直接说出 Agent ID 时，表示希望优先由该职责处理，不代表可以跳过安全确认、必要证据或上游输入。若缺少关键产物，Agent 应返回缺口并由 Orchestrator 决定回退到哪个阶段。
