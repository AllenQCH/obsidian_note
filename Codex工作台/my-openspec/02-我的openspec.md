---
title: 我的openspec
source: Codex工作台/my-openspec/02-我的openspec.md
author: 笨笨
published:
created: 2026-07-22
description: 解释 AllenQCH/openspec 后来版的整体定位、目录职责、核心流程和与原始版的差异。
tags: [openspec, workflow, archive, schema, coordination]
type: workflow
status: processed
---

# 我的openspec

## 摘要

`AllenQCH/openspec` 是后来的 OpenSpec 版本。本地路径是：

```text
/Users/heytea/Documents/myHeytea/code/openspec
```

它不是 `xuetao_openspec` 的完整增强版，而是把原始版里最核心的“对象、schema、模板、校验、归档”抽出来，变成一个更薄的：

> **项目级规范、跨项目需求协调、问题排查和不可变历史归档工具。**

一句话：**我的 openspec 负责“把事实、绑定、证据和最终快照管清楚”。**

## 核心内容

### 顶层结构

```text
openspec/
├─ projects/        # 项目登记与项目级规范
├─ initiatives/     # 中央需求与项目绑定
├─ investigations/  # 排查对象
├─ archive/         # 不可变历史归档
├─ schemas/         # JSON Schema
├─ templates/       # 项目规范模板
├─ openspec_cli/    # Python CLI 核心实现
├─ bin/             # CLI 入口
├─ tests/           # 单元测试
├─ README.md        # 使用说明
├─ AGENTS.md        # Agent 操作边界
├─ pyproject.toml   # Python 包配置
└─ requirements.txt # 依赖
```

### 每个目录的作用

| 目录 / 文件 | 作用 | 我的理解 |
|---|---|---|
| `projects/` | 登记项目，以及项目级通用规范 | 先有 project，后面 initiative 才能绑定项目 |
| `initiatives/` | 跨项目需求协调对象 | 中央事实在 `_shared`，项目目录只放 binding |
| `investigations/` | 排查对象 | 记录问题、证据、结论，可 promote 为 initiative |
| `archive/` | 不可变归档 | 从服务仓指定 commit 抽取 OpenSpec 快照，并生成 hash |
| `schemas/` | JSON Schema | 约束 project、initiative、binding、investigation、archive 的结构 |
| `templates/` | 项目规范模板 | `init-project` 时生成 requirement、design、testing、CR、delivery 规范 |
| `openspec_cli/` | CLI 实现 | `cli.py` 负责命令，`core.py` 负责业务逻辑 |
| `bin/` | 命令入口 | 目前主要是 `bin/openspec` |
| `tests/` | 单元测试 | 验证多项目归档、排查升级、完整 commit 约束等核心流程 |
| `README.md` | 快速使用说明 | 说明对象结构和命令流程 |
| `AGENTS.md` | 给 agent 的规则 | 强调这是事实面，不是 Multi-Agent 控制面 |

### 它明确不做什么

`AGENTS.md` 里已经写得很清楚：

| 不做什么 | 原因 |
|---|---|
| 不注册 Workflow / Stage / Tool / Gate Agent | 它不是 multi-agent 控制面 |
| 不把业务服务源码 clone 到 Initiative 目录 | 业务源码 source of truth 在服务仓 |
| 不保存密码、Cookie、Token、生产数据导出 | 只保存规范事实和交付证据 |
| 不把本地 checkout 路径写进元数据 | 本地路径只作为归档时的临时参数 |
| 归档不接受短 commit | 必须从完整 commit 读取不可变快照 |

### 核心对象结构

```text
projects/<projectKey>/
initiatives/_shared/<initiativeKey>/
initiatives/<projectKey>/<initiativeKey>/binding.yaml
investigations/<projectKey|_unassigned>/<investigation>/
archive/initiatives/_shared/<initiativeKey>/revisions/rNNN/
```

#### 1. `projects/<projectKey>/`

保存项目级规范：

```text
projects/project-a/
├─ project.yaml
├─ README.md
└─ standards/
   ├─ requirement.md
   ├─ backend-design.md
   ├─ testing.md
   ├─ code-review.md
   └─ delivery.md
```

含义：项目维度的长期规则，不随单个需求变化。

#### 2. `initiatives/_shared/<initiativeKey>/`

保存中央需求事实：

```text
initiatives/_shared/DEMO-100-example-shared/
├─ initiative.yaml
├─ project-map.yaml
├─ overview.md
└─ closeout.md
```

含义：一个需求只有一个中央 `_shared` Initiative，即使它涉及多个项目。

#### 3. `initiatives/<projectKey>/<initiativeKey>/binding.yaml`

保存项目参与关系：

```yaml
serviceBindings:
  - serviceKey: shared:service-a
    repoUrl: git@example.com:team/service-a.git
    openSpecPath: openspec/changes/DEMO-100
    branch: feature/DEMO-100
    commitSha: null
    status: planned
```

含义：这个项目下，哪些服务仓参与了这个需求；服务仓内的 OpenSpec 路径在哪里；最终 commit 是什么。

#### 4. `archive/initiatives/_shared/.../revisions/rNNN/`

归档后的不可变快照：

```text
archive/initiatives/_shared/<initiativeKey>/revisions/r001/
├─ manifest.yaml
├─ initiative/
├─ project-bindings/
└─ project-openspec-snapshots/
```

含义：需求完成后，把中央事实、项目 binding、服务仓指定 commit 下的 OpenSpec 快照保存下来。

### CLI 命令

`bin/openspec` 当前支持：

| 命令 | 作用 |
|---|---|
| `init-project` | 初始化项目和项目级 standards |
| `init-initiative` | 创建中央 `_shared` initiative 和项目 binding |
| `bind-service` | 把某个服务仓绑定到某个项目 initiative |
| `collect-project-result` | 回填服务最终 commit、测试证据、交付证据 |
| `set-initiative-status` | 设置 initiative 状态 |
| `check-project-ready` | 检查单个项目是否 ready |
| `check-initiative-complete` | 检查整个 initiative 是否完成 |
| `check-archive-ready` | 检查是否可归档 |
| `new-investigation` | 创建排查对象 |
| `promote-investigation` | 把排查升级为正式需求 |
| `archive-initiative` | 生成不可变归档快照 |
| `search-history` | 查询历史归档 |
| `validate-workspace` | 校验工作区结构 |

### 核心流程

#### 1. 初始化项目

```bash
bin/openspec init-project project-a '示例项目' shared
```

生成项目规范。

#### 2. 创建中央需求

```bash
bin/openspec init-initiative \
  DEMO-100-example-shared \
  DEMO-100 '示例需求' shared \
  --project project-a
```

生成 `_shared` initiative 和 project binding。

#### 3. 绑定服务仓

```bash
bin/openspec bind-service \
  DEMO-100-example-shared project-a \
  shared:service-a git@example.com:team/service-a.git \
  openspec/changes/DEMO-100 feature/DEMO-100
```

登记服务仓的 OpenSpec 路径和分支。

#### 4. 服务仓内实际开发

真实实现不在 `AllenQCH/openspec` 里，而在服务仓自己的：

```text
service-a/openspec/changes/DEMO-100/
```

#### 5. 收集项目结果

```bash
bin/openspec collect-project-result \
  DEMO-100-example-shared project-a shared:service-a \
  <full-commit-sha> \
  --test-evidence openspec/changes/DEMO-100/testing.md \
  --delivery-evidence openspec/changes/DEMO-100/rollout.md
```

注意：commit 必须是完整 SHA，短 SHA 会被拒绝。

#### 6. 检查和归档

```bash
bin/openspec set-initiative-status DEMO-100-example-shared completed
bin/openspec check-archive-ready DEMO-100-example-shared
bin/openspec archive-initiative DEMO-100-example-shared \
  --checkout shared:service-a=/absolute/path/to/service-a
```

归档时本地路径只作为临时参数，不写入中央元数据。

## 可执行动作

### 当前本机验证结果

我实际跑过：

```bash
python3 -m unittest discover -s tests -v
bin/openspec validate-workspace
```

结果：

```text
Ran 3 tests ... OK
{
  "valid": true,
  "errors": []
}
```

### 后续可补的内容

| 动作 | 价值 |
|---|---|
| 补真实业务案例 | 用一个真实蓝鲸需求走完整登记和归档流程 |
| 补架构图 | 让 `project → initiative → binding → service openspec → archive` 更直观 |
| 补命令速查页 | 把 `bin/openspec` 常用命令做成可复制手册 |
| 接入 Hermes / Codex 工作流 | 让它成为需求交付流水线的事实面 |

## 相关链接

- [[00-my-openspec总览]]
- [[01-xuetao_openspec]]
- [[03-两套openspec对比与使用流程]]
- [[01openspec]]
- [[Codex规则放哪里以及常用命令]]
