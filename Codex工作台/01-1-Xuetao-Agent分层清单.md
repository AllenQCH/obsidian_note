---
title: "Xuetao Agent分层清单"
source: "/Users/heytea/Documents/xuetao的agetns/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-07
description: "按控制层、阶段层、选择层、工具层、执行层和评审层整理 Xuetao 的 agent 字典，并说明每个 agent 的作用。"
tags: ["codex", "agent", "workflow", "xuetao", "reference"]
type: "workflow"
status: "processed"
---

# Xuetao Agent分层清单

## 摘要

这篇笔记把 Xuetao 的 `.codex/config.toml` 中注册的 agent 重新按层级整理。

注意：Xuetao 原始 `config.toml` 是一个平铺的 agent 字典，并没有在注册表里强制区分 `stage agent`、`tool agent`、`gate agent`。下面的分层是基于 agent 的 `name`、`description` 和职责边界整理出来的，目的是方便复盘和迁移到你自己的命名体系。

核心结论：

- `config.toml` 里所有 agent 都统一注册。
- 真正的层级，需要靠命名、description、workflow 文档和职责边界判断。
- 如果你自己重做，建议在名字里加层级前缀，例如 `control_`、`stage_`、`tool_`、`gate_`，这样复盘时不用猜。

## 核心内容

### 0. 原始注册方式

Xuetao 的主配置：

[config.toml](/Users/heytea/Documents/xuetao的agetns/.codex/config.toml:1)

里面的结构是：

```toml
[agents.workflow_router]
description = "..."
config_file = "agents/workflow-router.toml"

[agents.dbauto_operator]
description = "..."
config_file = "agents/dbauto_operator.toml"
```

也就是说，`router`、`planner`、`operator`、`reviewer` 都在同一个 `[agents]` 字典里平铺注册。

### 1. 控制层：决定任务怎么走

这一层不直接操作业务工具，主要负责识别阶段、判断缺什么、决定后续该找谁。

| Agent             | 作用                                      | 为什么归到这一层                  |
| ----------------- | --------------------------------------- | ------------------------- |
| `workflow_router` | 识别当前 OpenSpec 阶段、最小缺失输入、gate 和下游 agent。 | 它负责入口路由和阶段判断，是整个流程的第一层分诊。 |

对应文件：

- [workflow-router.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/workflow-router.toml:1)

### 2. 阶段层：推进某类工作对象

这一层负责某个阶段或某类工作对象的推进，例如立项、调查、插件项目、集成收口。它们通常会产出计划、证据、交接状态或阶段文档。

| Agent                      | 作用                                                                               | 为什么归到这一层                  |
| -------------------------- | -------------------------------------------------------------------------------- | ------------------------- |
| `initiative_planner`       | 创建或更新正式 OpenSpec initiative，包括 proposal、design、tasks、links、acceptance 和 rollout。 | 它负责需求/initiative 的规划阶段产物。 |
| `investigation_planner`    | 创建或推进 investigation 对象，记录锚点、证据、根因候选和交接准备状态。                                      | 它负责问题调查阶段，不直接等同于具体查日志工具。  |
| `plugin_project_planner`   | 推进 plugin project 的 explore、design、implement、verify、release 阶段。                  | 它是插件项目维度的阶段管理 agent。      |
| `integration_orchestrator` | 协调多 repo 集成、验收、rollout、rollback 和 closeout 证据。                                   | 它负责跨仓库集成和收口，是后段阶段编排。      |

对应文件：

- [initiative-planner.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/initiative-planner.toml:1)
- [investigation_planner.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/investigation_planner.toml:1)
- [plugin_project_planner.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/plugin_project_planner.toml:1)
- [integration-orchestrator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/integration-orchestrator.toml:1)

### 3. 选择层：选择对象或工具

这一层不是直接干业务动作，而是在多个可能对象里做选择，例如选仓库、选工具 operator、选择知识库引用。

| Agent                     | 作用                                               | 为什么归到这一层                          |
| ------------------------- | ------------------------------------------------ | --------------------------------- |
| `catalog_repo_selector`   | 从 OpenSpec catalog 中选择受影响仓库和 serviceKey，并处理环境歧义。 | 它不是实现代码，而是选择正确 repo / serviceKey。 |
| `tool_operator`           | 把工具需求路由到具体 CLI operator，并聚合结构化输出。                | 它本身是工具二级路由，不应替代具体 operator。       |
| `knowledge_base_operator` | 搜索、抓取、索引和链接外部知识库引用，避免把完整来源塞进上下文。                 | 它偏知识来源选择和索引，介于工具和选择之间。            |

对应文件：

- [catalog-repo-selector.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/catalog-repo-selector.toml:1)
- [tool-operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/tool-operator.toml:1)
- [knowledge_base_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/knowledge_base_operator.toml:1)

### 4. 工具层：调用具体外部系统或 CLI

这一层是真正的 tool/operator agent。它们通常绑定某个外部系统、CLI 或数据来源。特点是职责窄、模型多用 mini、输出结构化证据。

| Agent | 作用 | 为什么归到这一层 |
|---|---|---|
| `bk_operator` | 操作 BlueKing CLI，获取需求、任务、流水线、用户和 worklog 证据。 | 明确绑定 BlueKing 工具。 |
| `dbauto_operator` | 操作 DBAuto/Archery CLI，获取数据库元数据、历史和受限查询证据。 | 明确绑定 DBAuto / Archery 工具。 |
| `trace_log_operator` | 操作 trace-log CLI，做日志搜索、trace 分析、降噪和快照。 | 明确绑定日志工具。 |
| `wiki_operator` | 操作 wiki/Confluence CLI，做页面查找、dry-run 发布、附件和受控更新。 | 明确绑定 wiki 工具。 |
| `alidocs_operator` | 操作单文档 Alidocs CLI，做元数据、可访问性探测、快照和验证。 | 明确绑定单篇阿里文档。 |
| `alidocs_drive_operator` | 操作 Alidocs Drive CLI，做文件夹列表和原文件下载。 | 明确绑定阿里文档云盘/目录。 |
| `gitlab_mr_operator` | 操作 GitLab MR CLI，查 MR、diff、讨论、Bugbot 报告和讨论验证。 | 明确绑定 GitLab MR。 |
| `yapi_operator` | 操作 YApi CLI，做项目/token 查询、Swagger 导入、接口分类和菜单更新。 | 明确绑定 YApi。 |
| `xxljob_operator` | 操作 XXL-Job CLI，查 job 日志、dry-run 触发和受控日期窗口执行。 | 明确绑定 XXL-Job。 |
| `gaia_attendance_operator` | 操作 Gaia attendance CLI，查额度、考勤，并在明确确认后提交。 | 明确绑定考勤系统。 |

对应文件：

- [bk_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/bk_operator.toml:1)
- [dbauto_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/dbauto_operator.toml:1)
- [trace_log_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/trace_log_operator.toml:1)
- [wiki_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/wiki_operator.toml:1)
- [alidocs_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/alidocs_operator.toml:1)
- [alidocs_drive_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/alidocs_drive_operator.toml:1)
- [gitlab_mr_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/gitlab_mr_operator.toml:1)
- [yapi_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/yapi_operator.toml:1)
- [xxljob_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/xxljob_operator.toml:1)
- [gaia_attendance_operator.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/gaia_attendance_operator.toml:1)

### 5. 执行层：准备工作区和修改仓库

这一层会更接近“实际开发执行”。它不是纯工具读取，而是会检查工作区、分析仓库或推进实现。

| Agent                | 作用                                           | 为什么归到这一层                     |
| -------------------- | -------------------------------------------- | ---------------------------- |
| `workspace_preparer` | 验证 initiative 工作区、repo 路径、分支名和上下文隔离是否准备好。    | 它是实现前的工作区准备 gate / preparer。 |
| `repo_implementer`   | 在当前 initiative 的 repos 目录下，针对单个 repo 做实现或分析。 | 它真正进入 repo 范围，属于具体实现执行。      |

对应文件：

- [workspace-preparer.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/workspace-preparer.toml:1)
- [repo-implementer.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/repo-implementer.toml:1)

### 6. 评审层：检查风险和完整性

这一层不负责做实现，也不负责调用具体外部系统；它负责看结果是否符合边界、是否缺测试、是否能进入下一阶段。

| Agent | 作用 | 为什么归到这一层 |
|---|---|---|
| `openspec_reviewer` | 评审 OpenSpec 工作的实现风险、路径边界、准备状态和缺失测试。 | 它是 reviewer / gate 性质，负责检查而不是执行。 |

对应文件：

- [openspec-reviewer.toml](/Users/heytea/Documents/xuetao的agetns/.codex/agents/openspec-reviewer.toml:1)

### 分层总览表

| 层级 | Agents |
|---|---|
| 控制层 | `workflow_router` |
| 阶段层 | `initiative_planner`、`investigation_planner`、`plugin_project_planner`、`integration_orchestrator` |
| 选择层 | `catalog_repo_selector`、`tool_operator`、`knowledge_base_operator` |
| 工具层 | `bk_operator`、`dbauto_operator`、`trace_log_operator`、`wiki_operator`、`alidocs_operator`、`alidocs_drive_operator`、`gitlab_mr_operator`、`yapi_operator`、`xxljob_operator`、`gaia_attendance_operator` |
| 执行层 | `workspace_preparer`、`repo_implementer` |
| 评审层 | `openspec_reviewer` |

### 对你自己的迁移建议

如果你后续想避免“靠猜”，可以把自己的 agent 命名改成更显式的层级前缀。

推荐规则：

```text
<layer>_<domain>_<role>
```

示例：

```text
control_request_router
stage_investigation_planner
stage_execution_runner
tool_dbauto_operator
tool_obsidian_operator
gate_stage_evaluator
review_openspec_reviewer
```

这样即使所有 agent 仍然平铺注册在 `config.toml`，你也能从名字直接判断层级。

## 可执行动作

1. 以后看 Xuetao 的 agent 时，先从这篇清单判断它属于哪一层。
2. 如果要迁移到你的个人体系，优先迁移“职责边界”，不要照抄名字。
3. 如果要改你自己的 agent 命名，优先采用 `control_ / stage_ / tool_ / gate_ / review_` 前缀。

## 相关链接

- [[00-Agent体系阅读顺序概览]]
- [[01-Xuetao-Agent体系研究总结]]
- [[01-2-四层模型与Xuetao扩展层对比]]
- [[02-个人Codex多Agent改造计划]]
