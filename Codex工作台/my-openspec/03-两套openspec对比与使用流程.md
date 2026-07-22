---
title: 两套openspec对比与使用流程
source: Codex工作台/my-openspec/03-两套openspec对比与使用流程.md
author: 笨笨
published:
created: 2026-07-22
description: 对比 xuetao_openspec 与 AllenQCH/openspec 的职责边界，并给出真实需求场景下的推荐使用流程。
tags: [openspec, workflow, codex, multi-agent, delivery]
type: workflow
status: processed
---

# 两套openspec对比与使用流程

## 摘要

两套 OpenSpec 最大的区别不是“新旧版本功能多少”，而是**职责被重新切分了**：

- [[01-xuetao_openspec]]：完整控制面，负责路由、agent、工具、工作区和执行过程。
- [[02-我的openspec]]：轻量事实面，负责项目、需求、服务绑定、结果收集和不可变归档。

所以，后来的 `AllenQCH/openspec` 不应该被理解成“把原始版所有能力重写了一遍”，而应该被理解成：

> 从原始版复杂控制面里抽出一个更稳定、更容易维护、更适合审计的 OpenSpec 核心层。

## 核心内容

### 总体对比

| 维度 | xuetao_openspec 原始版 | 我的 openspec 后来版 |
|---|---|---|
| 定位 | AI 开发工作台 / 控制面 | 项目级事实面 / 归档工具 |
| 负责问题 | 怎么路由、怎么查证据、怎么调 agent、怎么执行 | 事实是什么、哪个项目参与、哪个服务完成、证据在哪里 |
| 目录复杂度 | 高 | 低 |
| 是否有 `.codex/agents` | 有 | 无 |
| 是否有 `tools/*` | 有 | 无 |
| 是否有 `catalogs/*` | 有 | 无 |
| 是否有 `workspaces/*/repos` | 有 | 无 |
| 是否有项目级 `projects/` | 没有明显独立建模 | 有，是核心对象之一 |
| initiative 的含义 | 正式需求工作现场 | 中央需求协调对象 |
| 是否 clone 业务 repo | 是，正式需求在 `initiatives/<id>/repos/*` | 否，只记录服务仓 URL、路径、分支、commit |
| archive 的含义 | 历史工作区归档 / 清理 active 对象 | 从指定 commit 抽取服务仓 OpenSpec 的不可变快照 |
| 适合 Allen 怎么用 | 做需求、排查、agent 编排、外部系统取证 | 做规范事实层、交付登记、最终审计归档 |

### 容易混淆的目录

#### 1. `initiatives/`

| 项 | 原始版 | 后来版 |
|---|---|---|
| 目录含义 | 正式需求工作区 | 中央需求 + 项目绑定 |
| 典型路径 | `initiatives/p35_xxx-需求-cn/repos/*` | `initiatives/_shared/<initiativeKey>/` |
| 是否写代码 | 可以，且只能在当前 initiative 的 `repos/` 写 | 不写业务代码 |
| 核心文件 | `overview.md`、`design.md`、`tasks.md`、`testing.md`、`rollout.md`、`closeout.md`、`repos/` | `initiative.yaml`、`project-map.yaml`、`binding.yaml` |
| 我的理解 | 工作现场 | 登记簿 / 协调中心 |

#### 2. `bin/`

| 项 | 原始版 | 后来版 |
|---|---|---|
| 数量 | 很多，约几十个 | 主要一个：`bin/openspec` |
| 作用 | 路由、检查、外部系统调用、同步、创建对象 | 管对象、检查、收集结果、归档 |
| 典型命令 | `route-task`、`check-command-input`、`bk`、`dbauto`、`trace-log`、`kb-search` | `init-project`、`init-initiative`、`bind-service`、`archive-initiative` |

#### 3. `archive/`

| 项 | 原始版 | 后来版 |
|---|---|---|
| 核心用途 | 归档旧需求、草稿、问题、tooling 历史 | 形成不可变交付快照 |
| 归档依据 | 工作区清理和历史保留 | 完整 commit SHA + 服务仓 OpenSpec 路径 |
| 关注点 | 不让 active 工作区膨胀 | 可审计、可复现、可验证 |

#### 4. `workspaces/`

原始版有：

```text
workspaces/cn/repos/*
workspaces/intl/repos/*
```

后来版没有。

这说明后来版不再负责：

- 共享 master 基座保温；
- 跨 repo 代码检索；
- trace 链路排查；
- repo 准备；
- 需求实现工作区管理。

### 真实需求该怎么串

推荐组合不是二选一，而是分层使用：

```text
1. 用户 / 蓝鲸 / 飞书需求群
   ↓
2. Hermes / Codex / xuetao_openspec 思路做路由和上下文整理
   ↓
3. 我的 openspec 登记 project、central initiative、project binding
   ↓
4. 服务仓自己的 openspec/changes/<需求> 维护设计、实现、测试证据
   ↓
5. Hermes / Codex / 多 agent 在服务仓实现、测试、CR、发布
   ↓
6. 我的 openspec collect-project-result 回填完整 commit 和 evidence
   ↓
7. check complete / check archive ready
   ↓
8. archive-initiative 生成不可变快照
```

### 一个完整例子

#### Step 1：先创建项目

```bash
bin/openspec init-project dht-invoice '发票助手' cn
```

生成：

```text
projects/dht-invoice/
  project.yaml
  standards/
```

#### Step 2：创建中央需求

```bash
bin/openspec init-initiative \
  p35_15439-tax-code-rate-cn \
  p35_15439 '税收分类编码与税率获取优化' cn \
  --project dht-invoice
```

生成：

```text
initiatives/_shared/p35_15439-tax-code-rate-cn/
initiatives/dht-invoice/p35_15439-tax-code-rate-cn/binding.yaml
```

#### Step 3：绑定服务仓

```bash
bin/openspec bind-service \
  p35_15439-tax-code-rate-cn \
  dht-invoice \
  cn:dhtInvoice \
  git@example.com:team/dhtInvoice.git \
  openspec/changes/p35_15439-tax-code-rate \
  feature/p35_15439-tax-code-rate
```

#### Step 4：服务仓开发

在真实服务仓中维护：

```text
dhtInvoice/
  openspec/changes/p35_15439-tax-code-rate/
    proposal.md
    design.md
    tasks.md
    testing.md
    rollout.md
```

#### Step 5：回填结果

```bash
bin/openspec collect-project-result \
  p35_15439-tax-code-rate-cn \
  dht-invoice \
  cn:dhtInvoice \
  <完整commit-sha> \
  --test-evidence openspec/changes/p35_15439-tax-code-rate/testing.md \
  --delivery-evidence openspec/changes/p35_15439-tax-code-rate/rollout.md
```

#### Step 6：检查并归档

```bash
bin/openspec set-initiative-status p35_15439-tax-code-rate-cn completed
bin/openspec check-archive-ready p35_15439-tax-code-rate-cn
bin/openspec archive-initiative p35_15439-tax-code-rate-cn \
  --checkout cn:dhtInvoice=/absolute/path/to/dhtInvoice
```

## 可执行动作

### 我后面真正使用时的判断法

| 当前要做什么 | 应该优先用哪套思想 |
|---|---|
| 需求刚进来，不知道影响哪些 repo | 原始版：route / catalog / investigation 思路 |
| 要查 trace、日志、DB、Wiki | 原始版：tool agents + bin/tools |
| 要创建正式需求并进入代码实现 | 原始版：initiative workspace 思路，或 Hermes 当前需求交付流水线 |
| 要登记项目级规范 | 后来版：`init-project` |
| 要登记跨项目需求事实 | 后来版：`init-initiative` |
| 要记录某服务仓参与了需求 | 后来版：`bind-service` |
| 要记录最终 commit 和证据 | 后来版：`collect-project-result` |
| 要最终归档可审计历史 | 后来版：`archive-initiative` |

### 以后可以改进的方向

| 方向 | 说明 |
|---|---|
| 把我的 openspec 接入 Hermes 需求流水线 | 让需求创建后自动登记 project / initiative / binding |
| 给服务仓生成标准 `openspec/changes` 模板 | 避免中央仓和服务仓结构脱节 |
| 补 OpenSpec 架构图 | 画出控制面、事实面、服务仓、归档面的关系 |
| 建一个真实案例目录 | 用真实需求完整跑一遍，作为以后模板 |

## 相关链接

- [[00-my-openspec总览]]
- [[01-xuetao_openspec]]
- [[02-我的openspec]]
- [[飞书需求群与本地Multi-Agent联动]]
- [[01openspec]]
