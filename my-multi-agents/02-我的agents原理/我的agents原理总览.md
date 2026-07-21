---
title: "我的agents原理总览"
source: "my-multi-agents/02-我的agents原理"
author: "Codex"
published:
created: 2026-07-20
description: "个人 multi-agent 五类 Agent 模型、运行边界和相关原理文档入口。"
tags: ["codex", "agent", "workflow", "index"]
type: "workflow"
status: "processed"
---

# 我的agents原理总览

## 摘要

本目录说明的是目标架构：所有运行角色都是 Agent，并通过名称前缀标识所在层；Skill、MCP、Script 是可被 Agent 调用的能力。最重要的三条边界是：Router 不推进阶段、Workflow 不亲自做阶段工作、Gate 不修改交付物。

## 推荐阅读

1. [[我的multi-agent模型总览]]
2. [[所有agent五层结构和统一流程]]
3. [[目标agent注册表]]
4. [[目标agent怎么用]]
5. [[用户说法对应哪个agent]]
6. [[开发流程强制门禁改造]]
7. [[OpenSpec证据链怎么用]]
8. [[什么时候把skill做成agent]]

## 文档真源边界

- 本目录：目标职责、命名、流程和迁移原则。
- `~/.codex/config.toml`：实际注册状态。
- `~/.codex/agents/<layer>/*.toml`：实际 Agent prompt。
- `~/.codex/agents/docs/agent-registry.md`：运行时登记说明。
