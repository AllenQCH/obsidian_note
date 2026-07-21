---
title: "所有agent五层结构和统一流程"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "五类 Agent 的完整结构、控制关系和统一执行流程。"
tags: ["codex", "agent", "workflow", "architecture", "gate"]
type: "workflow"
status: "processed"
---

# 所有agent五层结构和统一流程

## 摘要

“五层”表示五类职责，不表示每个请求都必须机械经过五个节点。固定入口是 Router；选中 Workflow 后，由 Orchestrator 根据阶段图调用 Stage、Tool 和 Gate，直到完成、阻塞或取消。

## 结构图

```mermaid
flowchart TB
    U["用户请求"] --> R["control_request_router_agent"]
    R --> WI["workflow_iterative_feature_development_agent"]
    R --> WR["workflow_rewrite_iterative_feature_development_agent"]
    R --> WB["workflow_bug_investigation_agent"]
    R --> WP["workflow_solve_personal_problem_agent"]

    WI --> O["control_stage_orchestrator_agent"]
    WR --> O
    WB --> O
    WP --> O

    O --> S["stage_*_agent"]
    S --> T["tool_*_agent"]
    S --> C["Skill / MCP / Script"]
    S --> G["gate_stage_evaluator_agent"]
    G -->|go / warn| O
    G -->|block| S
```

## 五类 Agent

| 层 | 决策范围 | 不负责 |
| --- | --- | --- |
| Control | 请求分类、状态推进、重试、恢复、收口 | 业务设计和工具细节 |
| Workflow | 一类任务的阶段图、顺序、必需产物和 Gate | 亲自执行每个阶段 |
| Stage | 一个阶段的专业判断和交付物 | 改写全局流程 |
| Tool | 单一外部或本地能力的安全执行 | 决定业务是否完成 |
| Gate | 依据规则和证据判定是否放行 | 修复产物或执行操作 |

## 开发主链的最小骨架

```mermaid
flowchart LR
    P["产品澄清"] --> D["后端设计"]
    P --> TC["测试用例设计"]
    D --> GD["设计门禁"]
    TC --> GD
    GD --> DEV["前端/后端开发"]
    DEV --> CR["独立 Code Review"]
    CR --> IT["本地联调与正式测试"]
    IT --> GT["测试门禁"]
    GT --> VD["版本交付"]
    VD --> GC["交付收口门禁"]
```

这是阶段关系骨架，不是四个 Workflow 的最终逐步定义。某阶段是否跳过必须由 Workflow 条件明确表达，例如无前端改动时不调用前端 Stage。

## 统一状态

Orchestrator 至少维护：

```text
selected_workflow
current_stage
stage_status
required_artifacts
gate_result
retry_count
blocked_reason
resume_from
```

状态只能由 Orchestrator 推进；Stage 和 Tool 返回结果，Gate 返回判定，均不能私自跳阶段。
