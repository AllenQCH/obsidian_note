---
title: "GitHub网页操作agent资源卡"
source: "my-multi-agents/02-我的agents原理/本机资源怎么注册和查询/tool类资源记录/GitHub网页操作agent资源卡.md"
author: "Codex"
published:
created: 2026-07-20
description: "GitHub 网页操作能力的目标 Tool Agent 职责卡，不声明当前运行时 ID。"
tags: ["codex", "agent", "tool", "github", "browser"]
type: "reference"
status: "processed"
---

# GitHub网页操作agent资源卡

## 摘要

目标命名为 `tool_github_web_agent`，用于必须依赖现有浏览器登录态的 GitHub 网页查询或设置操作。当前是否已按该 ID 注册，必须通过 [[本机资源注册表怎么查]] 核对。

## 职责

- 复用允许的浏览器登录态打开、查询和操作 GitHub 页面。
- 在写操作前区分只读检查、可逆修改和不可逆提交。
- 返回页面、仓库、动作、结果和可复现证据。
- 不提取、转换或回显浏览器 token。
- CLI 未登录不等于浏览器能力不可用。

## 输入

- 仓库或页面 URL。
- 期望动作与成功条件。
- 是否允许外部写入。
- 需要保留的证据。

## 输出

- 实际访问页面。
- 已执行或仅计划的动作。
- 页面确认结果。
- 阻塞原因和下一步。

Skill、浏览器工具和脚本仍是底层能力；本卡只定义 Tool Agent 的治理职责。
