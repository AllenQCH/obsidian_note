---
title: "Obsidian写入和GitHub同步怎么跑"
source: "conversation: Codex chat 2026-06-05"
author: "Codex"
published:
created: 2026-06-05
description: "用一个 Obsidian 写入后同步 GitHub 的完整例子，说明 tool_obsidian_operator、tool_github_sync_operator 和 gate_stage_evaluator 的边界。"
tags: ["codex", "agent", "workflow", "obsidian", "github"]
type: "workflow"
status: "processed"
---

# Obsidian写入和GitHub同步怎么跑

## 摘要

这篇笔记讲一个很常见的动作：让 Codex 把内容写到 Obsidian，然后同步到 GitHub。

这条流程看起来简单，但很适合作为 agent 拆分例子。因为它天然包含两个不同性质的动作：

- 写 Obsidian：本地文件变更
- 同步 GitHub：外部仓库状态变更

这两个动作不能混在一个 operator 里。否则一旦失败，你很难知道是“笔记没写好”，还是“GitHub 没推上去”。

## 核心内容

### 用户入口

用户说：

```text
把这次 agent 拆分计划整理到 Obsidian，并同步到 GitHub
```

### 推荐链路

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator(stage=execution)
-> stage_execution_runner
-> tool_obsidian_operator
-> gate_stage_evaluator(gate_obsidian_sync_ready)
-> tool_github_sync_operator
-> gate_stage_evaluator(gate_closeout_ready)
-> stage_closeout_reporter
```

### 这条链每一步到底干什么

#### 1. `control_request_router`

它先判断用户想要什么。

它看到的是：

- 用户要写 Obsidian
- 用户还提到了 GitHub 同步
- 这是本地文件写入 + 后置同步流程

它输出的应该是：

- `task_type = obsidian_write_with_sync`
- `primary_operator = tool_obsidian_operator`
- `followup_operator = tool_github_sync_operator`

它不应该直接写笔记，也不应该直接跑同步脚本。

#### 2. `stage_task_planner`

它负责决定写到哪里、写成什么结构。

比如这类 Codex 相关笔记，默认应该落到：

```text
/Users/heytea/Documents/obsidian_note/Codex工作台/
```

它还要规划：

- 标题是什么
- YAML frontmatter 怎么写
- 摘要怎么开头
- 是否需要加 `[[内部链接]]`
- 写完以后是否进入同步 gate

它不应该自己提交 Git，也不应该越过 gate 直接 push。

#### 3. `control_stage_orchestrator`

它把当前阶段推进到 `execution`。

这里它只做调度，不干具体活：

- 先让 `tool_obsidian_operator` 写本地笔记
- 写完后进入 `gate_stage_evaluator(gate_obsidian_sync_ready)`
- gate 放行后才进入 `tool_github_sync_operator`

#### 4. `stage_execution_runner`

它负责保证顺序。

顺序必须是：

1. 先写 Obsidian 本地文件
2. 确认确实有 vault 文件变更
3. 再决定是否同步 GitHub

这里最重要的一点是：

> 本地笔记写好了，不等于 GitHub 已经同步。

#### 5. `tool_obsidian_operator`

它只做本地 Obsidian 文件操作。

它可以做：

- 新增 Markdown 笔记
- 更新已有笔记
- 调整本地 note 内容
- 添加 frontmatter、摘要、内部链接

它不应该做：

- `git add`
- `git commit`
- `git push`
- 写到 Obsidian vault 之外

它输出的结果应该是具体文件路径，例如：

```text
/Users/heytea/Documents/obsidian_note/Codex工作台/2026-06-05-xxx.md
```

#### 6. `gate_stage_evaluator`

这里用的是：

```text
gate_stage_evaluator(gate_obsidian_sync_ready)
```

这里的 `gate_obsidian_sync_ready` 是 `gate_stage_evaluator` 使用的规则名，它只回答一个问题：

> 现在是否允许进入 GitHub 同步？

典型结果有三种。

`go`：

- 这次确实改了 Obsidian vault 文件
- 文件路径在 `/Users/heytea/Documents/obsidian_note` 内
- 同步脚本存在

`warn`：

- 本地笔记写完了
- 但当前变更很多，或者用户可能想先人工检查

`block`：

- 这次没有改 Obsidian 文件
- 文件路径不在主 vault 内
- 只是分析任务，不应该跑同步

#### 7. `tool_github_sync_operator`

它只做同步。

当前真实入口是：

```bash
/Users/heytea/Documents/obsidian_note/scripts/auto_sync_to_github.sh
```

这个脚本的行为是：

- 如果有本地变更，就 `git add -A` 并提交
- 拉取 `origin main` 状态
- 如果本地和远端分叉，就阻塞
- 如果只是本地 ahead，就 push

它不应该做：

- 自动解决冲突
- 强推
- 把同步失败说成本地写入失败

#### 8. `stage_closeout_reporter`

最后收口时要分开说两件事。

本地写入结果：

```text
已写入 Obsidian：
/Users/heytea/Documents/obsidian_note/Codex工作台/xxx.md
```

GitHub 同步结果：

```text
已执行同步脚本，并推送到 origin/main
```

或者：

```text
Obsidian 本地笔记已写入，但 GitHub 同步因为分叉被阻塞，需要人工处理 rebase/merge。
```

### 为什么要这么拆

如果不拆，一个大 agent 会同时做：

1. 判断写哪里
2. 写笔记
3. 判断是否同步
4. commit
5. push
6. 汇报结果

这个问题是：任何一步失败都会混在一起。

拆开以后：

- `tool_obsidian_operator` 只负责本地笔记质量
- `gate_stage_evaluator` 只负责判断是否能同步
- `tool_github_sync_operator` 只负责 GitHub 同步
- `stage_closeout_reporter` 只负责把两个结果讲清楚

## 可执行动作

1. 后续所有“写 Obsidian + 同步”的任务，都按这条链执行。
2. 如果只是写本地笔记，不要默认跑 `tool_github_sync_operator`，除非规则或用户要求。
3. 如果 sync 脚本提示分叉，不要强推，应该让用户人工处理。

## 相关链接

- [[我的Codex多agent改造计划]]
- [[为什么Obsidian写入和同步要分开]]
- [[Xuetao多agent体系总结]]
