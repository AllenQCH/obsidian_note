---
title: xuetao openspec总览
aliases: ["xuetao openspec总览"]
source: /Users/heytea/Documents/xuetao_openspec
author: 笨笨
published:
created: 2026-07-22
description: 归档 Xuetao OpenSpec 的整体定位、目录职责、对象模型和执行流程。
tags: [openspec, codex, multi-agent, workflow]
type: workflow
status: archived
---

# xuetao openspec总览

## 摘要

`xuetao_openspec` 是 Xuetao 的 OpenSpec 工作区。它不是一个单纯的规范文档仓，而是一个**跨 repo 的 AI 开发工作台 / 控制面**。本篇只记录来源工程，不代表 Allen 当前 OpenSpec 的职责或用法。

它负责把自然语言需求、蓝鲸链接、trace、日志、DB、知识库、GitLab、YApi、业务 repo、Codex agents 串成一套可路由、可检查、可归档的工作流。

一句话：**xuetao_openspec 负责“怎么干活”。**

## 核心内容

### 顶层结构

```text
xuetao_openspec/
├─ .codex/              # Codex agent 控制面
├─ .agents/             # 可复用 agent skills
├─ bin/                 # 稳定 CLI 入口
├─ tools/               # 外部系统工具实现
├─ catalogs/            # repo / service / domain 目录
├─ docs/                # 工作流与架构文档
├─ workspaces/          # cn / intl 共享只读代码基座
├─ initiatives/         # 正式需求工作区
├─ investigations/      # 排查对象
├─ plugin-projects/     # 插件 / 自动化项目
├─ knowledge/           # 外部知识库索引与经验沉淀
├─ archive/             # 历史对象归档
├─ templates/           # 对象模板
└─ tests/               # 路由和 agent 输出测试
```

### 每个目录的作用

| 目录 | 作用 | 我的理解 |
|---|---|---|
| `.codex/` | Codex agent 配置、contracts、tool-agent matrix | 控制面核心，决定谁负责路由、谁负责工具、谁做 review |
| `.agents/` | 可复用 agent skills | 把一些 OpenSpec 阶段能力封装成可复用技能 |
| `bin/` | 稳定命令入口 | 给人和 agent 调用的统一 CLI 层，例如 route、check、sync、bk、dbauto、trace-log |
| `tools/` | 外部系统工具实现 | 真正对接蓝鲸、日志、DB、Wiki、GitLab、YApi 等系统的代码 |
| `catalogs/` | repo 目录和服务目录 | 用来判断一个需求影响哪些仓库、环境、领域和 serviceKey |
| `docs/` | 架构、流程、对象说明 | 给人和 agent 读的规则书，不建议全部常驻上下文 |
| `workspaces/` | `cn` / `intl` 共享只读代码基座 | 排查时读代码用；不能当正式需求实现工作区 |
| `initiatives/` | 正式业务需求工作区 | 有蓝鲸需求号，承载设计、实现、测试、发布、closeout，可包含 `repos/` |
| `investigations/` | 排查对象 | 承载现象、证据、根因候选、handoff，可升级为 initiative |
| `plugin-projects/` | 插件或自动化项目 | 承载 explore、design、implement、verify、release |
| `knowledge/` | 外部知识库索引和经验 | 支持先 search 再 bounded fetch，不默认整库读进上下文 |
| `archive/` | 历史需求、草稿、问题、tooling 归档 | 清理 active 工作区，同时保留可追溯资料 |
| `templates/` | 对象模板 | 创建 initiative / investigation / plugin project 时生成标准文件 |
| `tests/` | 路由和 agent 输出测试 | 防止 route、contract、agent 输出格式被改坏 |

### 对象模型

原始版主要有 3 类 active object：

| 对象 | 路径 | 用途 |
|---|---|---|
| `initiative` | `initiatives/<demand-id>-<slug>-<env>/` | 正式业务需求，必须有蓝鲸需求号，负责实现、测试、发布、closeout |
| `investigation` | `investigations/inv-<date>-<slug>-<env>/` | 线上排查或问题分析，记录证据与根因，必要时升级为 initiative |
| `plugin-project` | `plugin-projects/plugin-<date>-<slug>/` | 插件、skill、MCP、自动化工具等非业务需求项目 |

### 路径边界

这是 xuetao_openspec 最关键的规则：

| 场景 | 合法代码位置 | 禁止 |
|---|---|---|
| 排查读代码 | `workspaces/<env>/repos/<repo>` | 在共享基座里改代码 |
| 正式需求改代码 | `initiatives/<initiative>/repos/<repo>` | 到别的历史 clone 或 workspaces 里混改 |
| 插件项目改代码 | `plugin-projects/<project>/repos/<repo>` | 混用业务 initiative 的 repos |

所以，`workspaces/` 是只读基座；`initiatives/<id>/repos/` 才是正式需求的实现现场。

### 请求如何流转

```text
用户自然语言 / slash command
  ↓
bin/route-task / bin/check-command-input
  ↓
workflow_router 判断对象、阶段、gate、推荐 agents
  ↓
Stage Agents 判断阶段、补对象文档、判断能否继续
  ↓
Tool Agents 通过 bin/* 调用蓝鲸、日志、DB、Wiki 等工具
  ↓
openspec_reviewer 检查边界、风险、readiness
  ↓
主代理写回 OpenSpec 对象或进入实现
```

常见路由：

| 用户意图 | 进入对象 | 典型工具 |
|---|---|---|
| trace / 报错 / 告警 / 超时 | `investigation` | `trace-log`、`dbauto`、`catalog_repo_selector` |
| 蓝鲸正式需求 | `initiative` | `bk`、`new-initiative`、`sync-workspace` |
| 插件 / MCP / 自动化工具 | `plugin-project` | `new-plugin-project`、`knowledge_base_operator` |
| 外部文档检索 | `knowledge` | `kb-search`、`kb-fetch`、`kb-link` |

### 正式需求流程

```text
蓝鲸需求 / 用户输入
  ↓
/initiative create
  ↓
创建 initiatives/<需求号>-<slug>-<env>/
  ↓
记录 links.yaml、overview、review、design、tasks
  ↓
用 catalogs 判断影响 repo
  ↓
在 initiative 自己的 repos/ 下 fresh clone
  ↓
基于 master 建需求分支
  ↓
改代码、跑测试、生成 testing.md
  ↓
rollout / closeout
  ↓
必要时归档到 archive/
```

### 排查流程

```text
traceId / 报错 / 线上现象
  ↓
/investigate
  ↓
创建 investigations/inv-...
  ↓
links.yaml 记录环境、锚点、候选 repo
  ↓
只读 workspaces/<env>/repos/*
  ↓
查日志、查 DB、看代码链路
  ↓
findings.md 写证据和结论
  ↓
关闭排查或 promote 为 initiative
```

## 可执行动作

### 最常用入口

```bash
bin/list-commands
bin/route-task --json '<你的请求>'
bin/check-command-input '<你的请求>'
bin/validate-workspace
```

### 创建排查

```bash
bin/route-task --json '/investigate traceId=abc env=intl 常规加单超时'
bin/check-command-input '/investigate traceId=abc env=intl 常规加单超时'
bin/new-investigation 20260521 regular-order-timeout intl '常规加单超时排查'
```

### 创建正式需求

```bash
bin/route-task --json '/initiative create p45_7028 overseas-mdc-fix intl https://bk/link'
bin/check-command-input '/initiative create p45_7028 overseas-mdc-fix intl https://bk/link 海外MDC修复'
bin/new-initiative p45_7028 overseas-mdc-fix intl 'https://bk/link' '海外MDC修复'
```

## 相关链接

- [[xuetao-library总览]]
- [[xuetao与my-openspec历史对比]]
- [[my-openspec总览]]
- [[飞书需求群与本地Multi-Agent联动]]
- [[Codex agent会读取哪些上下文]]
