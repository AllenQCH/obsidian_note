---
title: "版本交付agent职责和步骤"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "stage_version_delivery_agent 的准备、服务解析、交付、观察和归档闭环。"
tags: ["codex", "agent", "delivery", "deployment", "pipeline"]
type: "workflow"
status: "processed"
---

# 版本交付agent职责和步骤

## 摘要

`stage_version_delivery_agent` 负责一个版本从交付准备到归档的完整闭环。它编排 Tool Agent 或公共能力，不吞并具体工具实现；必须明确本次需要发布的依赖包和 deploy 的具体服务。

## 六个阶段

```text
prepare
-> resolve_deploy_services
-> resolve_dependency_packages
-> deliver
-> observe
-> closeout
```

## 服务发现顺序

1. 当前 commit 和 diff。
2. 发生改动的服务目录。
3. `bootstrap.yml` 或 `bootstrap.yaml` 中的 `spring.application.name`。
4. 项目 `AGENTS.md` 的仓库分类。
5. 当前 `design.md` 和 `tasks.md`。
6. `docs/bk/*.json`、历史 `delivery.md` 或 BK API。

不同来源冲突时必须阻塞并请求确认，不能猜服务名或部署范围。

## 职责分解

| 阶段 | 主要动作 | 关键证据 |
| --- | --- | --- |
| `prepare` | 汇总 commit、权限 SQL、提测材料、验收和授权状态 | 交付前置清单 |
| `resolve_deploy_services` | 解析并确认 deploy 服务 | 服务名、仓库、来源依据 |
| `resolve_dependency_packages` | 解析依赖包与发布顺序 | 坐标、版本、依赖图 |
| `deliver` | 发布依赖、提交材料、触发对应流水线/服务部署 | 发布与流水线结果 |
| `observe` | 观察构建、部署、健康和关键回归 | 状态、日志、健康证据 |
| `closeout` | 写 `delivery.md`、迭代台账、AliDocs 和归档状态 | 完整交付记录 |

## 可组合 Tool Agent

- `tool_dependency_package_publisher_agent`
- `tool_test_delivery_document_agent`
- 其他已登记的权限、BK、文档或仓库能力，迁移后统一使用 `tool_<capability>_agent`。

显示远程计划不等于执行授权。依赖发布、流水线变更和服务部署必须保留各自的确认和证据边界。
