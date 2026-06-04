---
title: "GitHub 同步说明"
source: "Codex工作台/同步配置/GitHub同步说明.md"
author: "Allen"
published: 
created: 2026-05-07
description: "目标仓库："
tags: ["obsidian-note", "codex", "workflow", "cli"]
type: "workflow"
status: "processed"
---
# GitHub 同步说明

目标仓库：

```text
https://github.com/AllenQCH/obsidian_note
```

## 当前状态

本地仓库已和 GitHub 仓库连通，并已完成首次推送。

当前本地 remote：

```text
origin github-personal:AllenQCH/obsidian_note.git
```

说明：本机通过 `~/.ssh/config` 中的 `github-personal` SSH alias 认证 GitHub。

## 日常同步

在本地仓库中运行：

```zsh
cd /Users/heytea/Documents/Obsidian\ Vault
git pull --rebase
git add .
git commit -m "docs: update codex notes"
git push
```

如果只是查看状态：

```zsh
cd /Users/heytea/Documents/Obsidian\ Vault
git status --short --branch
```

## 认证方式

当前可用方式是 SSH alias：

```zsh
ssh -T github-personal
```

如果后续改用 HTTPS，推荐安装并使用 GitHub CLI：

```zsh
gh auth login
```

不要把 token 写进笔记、脚本或 Git remote URL。

## 摘要

- 待整理。

## 核心内容

- 待补充。

## 可执行动作

- [ ] 待确认。

## 相关链接

- [[Obsidian Notes]]
- [[Codex 工作台]]
