---
title: "my-openspec总览"
aliases: ["my-openspec总览"]
source: "my-openspec/00-my-openspec总览.md"
author: "笨笨"
published:
created: 2026-07-22
description: "当前 my-openspec 的唯一入口，说明职责、事实源、阅读顺序和与 Multi-Agent 的边界。"
tags: ["openspec", "codex", "workflow", "architecture"]
type: "project-note"
status: "evergreen"
---

# my-openspec总览

## 摘要

`my-openspec` 是项目级规范、跨项目需求协调、问题调查和不可变历史归档工具。它不负责选择 Agent 或推进 Workflow；Multi-Agent 通过统一上下文和受治理 CLI 能力与它连接。

当前资料只描述 `AllenQCH/my-openspec`。Xuetao 的旧 OpenSpec 已独立放入 [[xuetao-library总览]]，不再参与当前操作说明。

## 阅读顺序

1. [[my-openspec当前架构和对象模型]]
2. [[my-openspec CLI与归档流程]]
3. [[my-openspec与Multi-Agent串联及迁移]]
4. [[Multi-Agent与OpenSpec边界]]

## 当前边界

| 位置 | 职责 |
| --- | --- |
| 项目内 `openspec/` | 开发期间持续更新的服务级事实 |
| `projects/<projectKey>/` | 项目登记和长期规范 |
| `initiatives/_shared/<initiativeKey>/` | 一个需求唯一的中央协调对象 |
| `initiatives/<projectKey>/<initiativeKey>/binding.yaml` | 项目、服务、分支、Commit 和证据绑定 |
| `investigations/` | 不依赖需求号的问题调查对象 |
| `archive/.../revisions/rNNN/` | 从精确 Commit 生成的不可变快照 |

## 事实源

- 当前仓库：`/Users/heytea/Documents/myHeytea/code/my-openspec`
- GitHub：`https://github.com/AllenQCH/my-openspec`
- 使用说明：仓库根目录 `README.md`
- Agent 边界：仓库根目录 `AGENTS.md`
- 迁移规则：仓库根目录 `move-guidence.md`
- CLI：仓库内 `bin/openspec`

## 可执行动作

- 操作前从本页进入，不使用 Xuetao 历史笔记中的旧命令。
- 迁移或重命名仓库前完整阅读 `move-guidence.md`。
- 修改对象或归档前运行工作区校验。

## 相关链接

- [[my-multi-agents总览]]
- [[Multi-Agent与OpenSpec边界]]
- [[xuetao-library总览]]
