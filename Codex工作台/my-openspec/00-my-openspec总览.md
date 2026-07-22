---
title: my-openspec总览
source: Codex工作台/my-openspec/00-my-openspec总览.md
author: 笨笨
published:
created: 2026-07-22
description: 对比 xuetao_openspec 原始版与 AllenQCH/openspec 后来版，说明两者定位、目录职责与使用流程。
tags: [openspec, codex, multi-agent, workflow, architecture]
type: index
status: processed
---

# my-openspec总览

## 摘要

这个专题用于解释两套 OpenSpec：

- [[01-xuetao_openspec]]：原始版，大而全，是跨 repo 的 AI 开发工作台 / 控制面。
- [[02-我的openspec]]：后来的 `AllenQCH/openspec`，更薄，是项目级事实面、跨项目需求协调器和不可变归档工具。
- [[03-两套openspec对比与使用流程]]：把两者放在一起看，回答“什么时候用哪个、真实需求怎么串起来”。

一句话：**xuetao_openspec 负责怎么干活，我的 openspec 负责把事实、绑定、证据和最终快照管清楚。**

## 核心内容

### 两套 OpenSpec 的定位

| 项 | xuetao_openspec | 我的 openspec |
|---|---|---|
| 本质 | AI 开发工作台 / 控制面 | 项目级 OpenSpec 事实面 / 归档器 |
| 关注点 | 路由、agent、工具、工作区、执行边界 | project、initiative、binding、commit、archive |
| 是否调 agent | 是，`.codex/agents` + contracts + gates | 否，明确不注册 Workflow / Stage / Tool / Gate Agent |
| 是否查外部系统 | 是，蓝鲸、日志、DB、Wiki、GitLab、YApi 等 | 否，只管理 OpenSpec 对象与归档 |
| 是否放业务 repo | 是，`initiatives/<id>/repos/*` 是正式需求实现现场 | 否，不把业务源码 clone 到 initiative |
| 最适合阶段 | 从需求进入、排查、实现、测试、发布全过程 | 需求事实登记、服务绑定、结果收集、最终归档 |

### 推荐阅读顺序

1. 先看 [[01-xuetao_openspec]]，理解原始版为什么复杂：它是完整控制面。
2. 再看 [[02-我的openspec]]，理解后来版为什么变薄：它只做事实面与归档。
3. 最后看 [[03-两套openspec对比与使用流程]]，按真实需求场景建立心智模型。

## 可执行动作

### 后续如果要继续完善这个专题

| 动作 | 说明 |
|---|---|
| 补架构图 | 把两套 OpenSpec 的职责画成 GitDiagram / SVG，不用丑 Mermaid |
| 补命令手册 | 把 `bin/openspec` 的常用命令单独整理成速查表 |
| 补真实案例 | 用一个蓝鲸需求演示：登记 project → initiative → binding → collect → archive |
| 接入 Hermes 开发流 | 把这个 OpenSpec 事实面接入 Allen 默认需求交付流水线 |

## 相关链接

- [[01-xuetao_openspec]]
- [[02-我的openspec]]
- [[03-两套openspec对比与使用流程]]
- [[01openspec]]
- [[飞书需求群与本地Multi-Agent联动]]
- [[Codex规则放哪里以及常用命令]]
