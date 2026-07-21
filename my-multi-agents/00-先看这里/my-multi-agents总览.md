---
title: "my-multi-agents总览"
source: "my-multi-agents/00-先看这里/my-multi-agents总览.md"
author: "Codex"
published:
created: 2026-07-05
description: "个人 multi-agent 目标架构与研究资料的总入口。"
tags: ["codex", "agent", "workflow", "index"]
type: "workflow"
status: "processed"
---

# my-multi-agents总览

## 摘要

这里记录的是个人 Codex multi-agent 的**目标架构**，不是当前运行态清单。目标模型包含五类 Agent：`control`、`workflow`、`stage`、`tool`、`gate`；所有本地 Agent 都用 `<layer>_<responsibility>_agent` 命名。

是否已经运行，必须以 `~/.codex/config.toml` 和对应 TOML 文件为准，不能以本目录的设计文档为准。

## 最短阅读路径

1. [[最新multi-agent流程总览]]
2. [[所有agent五层结构和统一流程]]
3. [[目标agent注册表]]
4. [[用户说法对应哪个agent]]
5. [[开发流程强制门禁改造]]

## 内容分区

| 目录 | 内容 | 入口 |
| --- | --- | --- |
| `00-先看这里` | 当前确认的目标设计、范围和下一步 | [[最新multi-agent流程总览]] |
| `01-Xuetao-agent原型` | 外部原型的原始事实和可迁移原则 | [[Xuetao agent原型总览]] |
| `02-我的agents原理` | 本地五层模型、职责、命名和证据边界 | [[我的agents原理总览]] |
| `03-我的agent用例` | 具体任务如何进入五层链路 | [[我的agent用例总览]] |

## 当前边界

- 这轮只确认架构与文档，不代表已完成运行时注册。
- 暂不增加独立 subflow；需要时由 Workflow Agent 编排 Stage Agent。
- Skill、MCP、Script 是能力，不与 Agent 混用命名。
- 运行时迁移时再逐项核对 TOML、注册表、引用和验证脚本。
