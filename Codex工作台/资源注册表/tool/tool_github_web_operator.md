---
title: "tool_github_web_operator"
source: "/Users/heytea/.codex/agents/operator/tool_github_web_operator.toml"
author: "Codex"
created: 2026-07-01
description: "通过 opencli 复用本机 GitHub 浏览器登录态，处理仓库设置、可见性调整和需要 Confirm access 的 GitHub Web 操作。"
tags: ["codex", "tool", "github", "浏览器", "仓库设置", "权限确认", "obsidian"]
type: "resource"
status: "active"
---

# tool_github_web_operator

## 用途

这个 tool agent 用来处理 GitHub Web 侧操作，尤其是下面几类情况：

- `gh auth status` 没有登录
- 本机浏览器已经登录 GitHub，适合直接复用
- GitHub 要求 `Confirm access`
- 需要改仓库设置，例如可见性、权限、规则、协作者等

## 主要实现

- `~/.hermes/node/bin/opencli`
- `~/.codex/skills/opencli-browser-reuse/scripts/opencli_reuse.sh`
- `~/Documents/personal_migratory_agents/codex/agents/docs/github-web-operations-workflow-example.md`

## 默认规则

1. 先检查 `gh auth status`
2. 如果 `gh` 已登录且动作完全支持，可直接走 `gh`
3. 如果 `gh` 未登录，或 GitHub 进入 Web 二次确认，改走 `opencli`
4. 统一复用稳定 session：`opencli-explore`
5. 遇到密码、2FA、passkey、设备确认时必须停下并明确提示用户
6. 用户回复“好了”后再继续
7. 只有看到最终页面状态变化，才能声明成功

## 标签

- GitHub
- 浏览器
- 仓库设置
- 权限确认
- opencli

## 相关文件

- `~/.codex/agents/operator/tool_github_web_operator.toml`
- `~/Documents/personal_migratory_agents/docs/github-web-operator-agent-prompt.md`
- `~/Documents/personal_migratory_agents/codex/agents/docs/github-web-operations-workflow-example.md`
