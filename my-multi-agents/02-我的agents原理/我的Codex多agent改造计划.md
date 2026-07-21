---
title: "我的Codex多agent改造计划"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "从当前运行态迁移到五类 Agent 目标架构的分批计划。"
tags: ["codex", "agent", "workflow", "migration"]
type: "workflow"
status: "processed"
---

# 我的Codex多agent改造计划

## 摘要

改造应分为“文档收敛、运行态盘点、分批迁移、端到端验证”四步。本轮只执行第一步。不能仅把名称批量加上 `_agent`：Controller、Workflow、Stage 和 Tool 的 prompt、引用、路由输出、注册项必须同步迁移。

## 迁移阶段

| 阶段 | 动作 | 完成证据 |
| --- | --- | --- |
| 1. 文档收敛 | 固定五类 Agent、目标名称和职责 | 本目录无旧目标名称和错误状态声明 |
| 2. 运行态盘点 | 读取配置、TOML、注册表、脚本引用 | 当前/目标差异清单 |
| 3. 分批迁移 | 先 Control/Workflow/Gate，再 Stage，最后 Tool | 每批配置校验和最小调用通过 |
| 4. 流程验证 | 跑四类请求的路由与至少一条开发闭环 | 可复现任务证据 |

## 运行态改造范围

- 新增或更新 `~/.codex/agents/<layer>/*.toml`。
- 更新 `~/.codex/config.toml` 的 `[agents.<name>]`。
- 更新 Agent 间引用、允许调用关系和输出 schema。
- 更新 `~/.codex/agents/docs/agent-registry.md`。
- 运行目录一致性校验与路由样例。

## 迁移原则

- 一批只改一类职责，避免出现无法定位的跨层回归。
- 保留短兼容期只在确有调用方需要时使用；不能长期维护双名称。
- 外部写入、发布和生产操作的授权边界不因改名而放宽。
- 所有“active”结论都必须来自当前配置与验证，不来自设计文档。
