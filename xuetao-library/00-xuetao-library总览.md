---
title: "xuetao-library总览"
aliases: ["xuetao-library总览"]
source: "xuetao-library/00-xuetao-library总览.md"
author: "Codex"
published:
created: 2026-07-24
description: "集中保存 Xuetao OpenSpec 和 Multi-Agent 原型资料，与 Allen 当前运行资料彻底分离。"
tags: ["xuetao", "openspec", "multi-agent", "archive"]
type: "note"
status: "evergreen"
---

# xuetao-library总览

## 摘要

`xuetao-library` 是 Xuetao 资料的独立历史库。这里的 Agent ID、工作流、目录和命令只描述来源工程，不代表 Allen 当前运行时。

## 分类

| 分类 | 内容 | 当前事实入口 |
| --- | --- | --- |
| `openspec/` | Xuetao OpenSpec 控制面与历史对比 | [[my-openspec总览]] |
| `multi-agent/` | Xuetao Agent 原型、分层和设计原则 | [[my-multi-agents总览]] |

## 使用边界

- 研究设计来源时读这里。
- 操作当前系统时不要从这里复制 Agent ID、路径或命令。
- 历史对比笔记统一标记为 `status: archived`。
- 当前运行事实仍以本机配置、Agent TOML 和当前 `my-openspec` 仓库为准。

## 相关链接

- [[xuetao openspec总览]]
- [[xuetao multi-agent总览]]
- [[my-openspec总览]]
- [[my-multi-agents总览]]
