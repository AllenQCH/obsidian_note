---
title: "为什么Obsidian写入和同步要分开"
source: "conversation: Codex chat; updated 2026-07-20"
author: "Codex"
published:
created: 2026-06-05
description: "说明本地 Obsidian 修改与远端 GitHub 同步为什么必须拆成两个 Tool Agent。"
tags: ["codex", "agent", "workflow", "obsidian", "github"]
type: "tech-note"
status: "processed"
---

# 为什么Obsidian写入和同步要分开

## 摘要

Obsidian 写入是本地可逆文件操作，GitHub 同步包含 commit/push 等外部写入。两者风险、失败恢复和授权边界不同，所以由 `tool_obsidian_agent` 与 `tool_github_sync_agent` 分别负责，中间由 Gate 检查同步条件。

## 对比

| 维度 | Obsidian 写入 | GitHub 同步 |
| --- | --- | --- |
| 影响范围 | 本地 vault | 远端仓库和协作者 |
| 可逆性 | 通常可通过 Git 恢复 | push 后会改变共享历史状态 |
| 验证 | YAML、链接、diff | commit、remote、push 结果 |
| 失败恢复 | 修正文档后重验 | 处理认证、冲突或远端拒绝 |
| 授权 | 明确的本地编辑任务可执行 | 外部写操作遵守确认合同 |

## 目标链路

```text
tool_obsidian_agent
-> gate_stage_evaluator_agent(obsidian_sync_ready)
-> tool_github_sync_agent
```

`obsidian_sync_ready` 是 Gate 规则，不是独立 Agent。它至少检查：

- 修改只发生在授权 vault 范围。
- YAML、链接和 Git diff 已验证。
- 没有凭据或不应同步的敏感信息。
- 用户已授权需要的外部 Git 动作。
- 同步失败时有明确恢复点。

## 结果语义

- 本地写入成功、未同步：报告“本地完成，远端未执行”。
- 同步失败：保留本地修改，报告第一个具体错误。
- 同步成功：同时记录本地文件和远端 commit/push 证据。

完整案例见 [[Obsidian写入和GitHub同步怎么跑]]。
