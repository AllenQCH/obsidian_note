---
title: "八个开发职责agent"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "八个开发职责 Stage Agent 的输入、步骤、输出和完成边界。"
tags: ["codex", "agent", "stage", "development"]
type: "reference"
status: "processed"
---

# 八个开发职责agent

## 摘要

八个职责 Agent 覆盖产品澄清、设计、前后端实现、测试设计、代码审查、本地集成测试和版本交付。每个 Agent 只对自己的阶段产物负责，流程顺序由 Workflow 定义，状态推进由 Orchestrator 管理。

## 职责表

| Agent | 主要输入 | 核心步骤 | 必须输出 |
| --- | --- | --- | --- |
| `stage_product_owner_agent` | 历史文档、新需求、现有行为 | 对齐目标、范围、文案、验收和未决问题，持续澄清到可开发 | `requirement.md` 或等价需求产物 |
| `stage_backend_designer_agent` | 已确认需求、代码与接口现状 | 梳理改动点、数据模型、接口、兼容、依赖、风险和回归面 | `design.md`、改动清单 |
| `stage_backend_developer_agent` | 设计、任务清单、仓库规范 | 最小实现、单元测试、构建与错误处理 | 代码 diff、单测和验证证据 |
| `stage_frontend_developer_agent` | 文案、交互、后端契约、现有设计系统 | 页面实现、状态处理、接口联调、可访问性和前端验证 | 前端 diff、验证证据 |
| `stage_test_case_designer_agent` | 需求与设计 | 独立设计正常、异常、边界和回归用例，明确数据准备 | `test-cases.md` |
| `stage_code_reviewer_agent` | diff、需求、设计、测试 | 独立检查缺陷、回归、安全、可维护性和测试缺口 | `review.md`，按严重度排序 |
| `stage_test_runner_agent` | 测试用例、改动、服务清单 | 启动依赖和服务、准备隔离数据、跨服务联调、执行正式验证 | `verification.md`、日志与结果证据 |
| `stage_version_delivery_agent` | 已通过测试的产物、部署信息 | 解析服务/依赖、准备材料、发布、部署、观察、归档 | `delivery.md`、流水线/部署/归档证据 |

## 共同约束

- 输入不足时返回缺口，不伪造事实。
- 交付物必须可被 Gate 独立读取。
- 外部写入、生产动作、发布和部署仍需遵守确认边界。
- Stage 不直接修改 Workflow 状态，只向 Orchestrator 返回结果。
