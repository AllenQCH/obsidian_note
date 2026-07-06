---
title: "为什么Obsidian写入和同步要分开"
source: "conversation: Codex chat 2026-06-05"
author: "Codex"
published:
created: 2026-06-05
description: "说明为什么需要把 Obsidian 本地写入与 GitHub 同步从 AGENTS 默认规则中拆开，并下沉为 gate/operator 骨架。"
tags: ["codex", "agent", "workflow", "obsidian", "github"]
type: "tech-note"
status: "processed"
---

# 为什么Obsidian写入和同步要分开

## 摘要

原先 `~/.codex/AGENTS.md` 中的规则是：只要改了 `/Users/heytea/Documents/obsidian_note` 下的文件，就默认执行 `auto_sync_to_github.sh`。这条规则在使用体验上没问题，但在多 agent 拆分理论下，它把“本地写入”和“远端同步”绑成了一个动作，职责层级不对。

这次调整的目标不是取消自动同步，而是把它改造成：AGENTS 只保留原则，真正执行由 `gate_stage_evaluator(gate_obsidian_sync_ready) -> tool_github_sync_operator` 决定。

## 核心内容

### 原规则的问题

原规则相当于：

```text
修改 Obsidian 文件 -> 直接执行 GitHub 同步脚本
```

这有 3 个问题：

1. 把本地写入和远端发布耦合在一起；
2. 没有 gate 判断是否真的应该同步；
3. 把具体脚本执行逻辑写在了 AGENTS 总规则里，层级过高。

### 按拆分理论应该怎么理解

按当前个人多 agent 架构：

- `tool_obsidian_operator`
  只负责本地 Obsidian 笔记写入、更新、移动、删除。
- `gate_stage_evaluator(gate_obsidian_sync_ready)`
  负责判断：
  - 是否真的触碰了 Obsidian 主库文件
  - 是否应该进入 GitHub 同步
  - 是否存在只读/纯分析场景
- `tool_github_sync_operator`
  只负责调用 `/Users/heytea/Documents/obsidian_note/scripts/auto_sync_to_github.sh`

新的链路是：

```text
tool_obsidian_operator
-> gate_stage_evaluator(gate_obsidian_sync_ready)
-> tool_github_sync_operator
```

### 这次已经做的调整

#### 1. 修改 `~/.codex/AGENTS.md`

把“直接运行脚本”改成：

- 默认进入 Obsidian 同步后置流程
- 只有 gate 允许时才执行同步脚本
- 若发生 `pull --rebase` 冲突、认证失败或远端拒绝，先报告再决定

#### 2. 新增两个 tool operator 骨架

新增：

- `~/.codex/agents/operator/tool_obsidian_operator.toml`
- `~/.codex/agents/operator/tool_github_sync_operator.toml`

#### 3. 补齐配套规则

已更新：

- `~/.codex/config.toml`
- `~/.codex/agents/docs/agent-workflows.md`
- `~/.codex/agents/docs/stage-gates.md`
- `~/.codex/agents/docs/agent-contracts.md`
- `~/.codex/agents/docs/tool-agent-matrix.md`

补充说明：

- 早期确实存在 `config.template.toml` 过渡阶段
- 但按当前真实状态，它已经移除，主配置真源只剩 `~/.codex/config.toml`

### 为什么这种拆法更稳

1. 本地落笔记和远端发布职责分离。
2. 后续如果 GitHub 同步策略变化，不需要改 Obsidian 写入逻辑。
3. 失败处理路径更清楚。
4. 更符合之前确定的：
   - router
   - stage
   - tool
   - gate
   - contract

## 可执行动作

1. 后续真正启用这套 Obsidian 同步骨架时，优先通过 gate 再调用同步脚本。
2. 若未来要改成手动同步、延迟同步或分仓同步，只改 `tool_github_sync_operator` 和 gate，不改 `tool_obsidian_operator`。
3. 若未来要把 Obsidian 同步纳入更完整的阶段层，可在 `execution` 或 `closeout` 阶段调用这条链路。

## 相关链接

- [[我的Codex多agent改造计划]]
- [[我的.codex目录里有什么]]
- [[本机已启用agent注册表]]
- [[哪些agent已启用哪些还只是草稿]]
- [[Xuetao多agent体系总结]]
- [[agent拆分逻辑]]
