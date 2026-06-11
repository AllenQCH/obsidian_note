---
title: "Active Agent调用示例词典"
source: "/Users/heytea/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-07
description: "把常见用户说法直接翻译成 active agent 链，避免后续靠猜路由。"
tags: ["codex", "agent", "workflow", "phrasebook"]
type: "workflow"
status: "processed"
---

# Active Agent调用示例词典

## 摘要

这篇笔记解决的是一个特别实际的问题：

> 用户平时不会说“请调用 `stage_task_planner`”，而是会说“帮我查一下表结构”“启动导出任务”“先帮我分析一下原因”。

所以这篇的作用就是：

- 把自然说法翻译成任务类型
- 再映射到当前 active agent 链

以后如果你想快速判断一句话大概会路由到谁，先看这篇。

## 核心内容

### 一条使用原则

不要从词面死记 agent 名字。

应该按这个顺序理解：

```text
用户怎么说
-> 他真正想做什么
-> 属于哪类任务
-> 该走哪条 active agent 链
```

### 常见说法到 agent 链的映射

| 用户常见说法 | 实际任务类型 | 首选 active agent 链 | 最容易搞错的边界 |
|---|---|---|---|
| `启动导出任务` | dbauto export bootstrap | `control_request_router -> stage_task_planner -> tool_sso_operator -> tool_dbauto_operator` | 通常只是先把环境拉起，不代表导出完成 |
| `看下 dbauto 能不能用了` | dbauto readiness check | `control_request_router -> stage_task_planner -> tool_sso_operator -> tool_dbauto_operator` | readiness 和业务导出结果不是一回事 |
| `帮我查一下这张表结构` | dbauto 只读元数据查询 | `control_request_router -> stage_task_planner -> tool_sso_operator -> tool_dbauto_sql_operator` | 优先用 `SHOW CREATE TABLE` / `SHOW COLUMNS` |
| `帮我列一下这个实例有哪些库` | dbauto 列数据库 | `control_request_router -> stage_task_planner -> tool_dbauto_sql_operator` | 这是 metadata listing，不等于随便执行 SQL |
| `帮我查一下这个库有哪些表` | dbauto 列表 | `control_request_router -> stage_task_planner -> tool_dbauto_sql_operator` | 库名必须明确 |
| `把 Excel 里的 goodsCode 和 goodsName 提出来并去重` | Excel 提取去重 | `control_request_router -> stage_task_planner -> tool_excel_operator` | 先确认真实表头和 JSON 路径 |
| `帮我重新生成一个去重后的新表` | Excel 新文件生成 | `control_request_router -> stage_task_planner -> tool_excel_operator` | 输出路径要明确 |
| `帮我把这些内容整理到 Obsidian` | 本地 Obsidian 写入 | `control_request_router -> stage_task_planner -> tool_obsidian_operator` | 本地写入不等于同步 GitHub |
| `顺手同步到 GitHub` | Obsidian 写完后的同步 | `control_request_router -> stage_integration_orchestrator -> tool_obsidian_operator -> tool_github_sync_operator` | 同步前最好先看一眼本地产物 |
| `为什么这次结果不对` | investigation | `control_request_router -> stage_investigation_planner` | 不要直接跳 execution |
| `你先帮我分析一下原因` | investigation | `control_request_router -> stage_investigation_planner` | 先证据，后执行 |
| `我怀疑是登录态有问题` | investigation，SSO 是候选证据点 | `control_request_router -> stage_investigation_planner -> tool_sso_operator` | 先核实，不要直接把 SSO 当根因 |

### 三组最容易混淆的话

#### 1. 导出 和 查库表 不是一回事

```text
启动导出任务
!=
帮我查一下库/表结构
```

区别是：

- 导出环境准备走 `tool_dbauto_operator`
- 查库表或只读 SQL 走 `tool_dbauto_sql_operator`

#### 2. 写 Obsidian 和 同步 GitHub 不是一回事

```text
整理到 Obsidian
!=
同步到 GitHub
```

区别是：

- 本地写入用 `tool_obsidian_operator`
- 同步才加 `tool_github_sync_operator`

#### 3. 执行任务 和 排查问题 不是一回事

```text
帮我执行一下
!=
帮我看看为什么不对
```

区别是：

- 执行型任务从 `stage_task_planner` 起
- 排查型任务从 `stage_investigation_planner` 起

### 你后面可以怎么用这篇

如果以后你看到一句用户说法不太确定，可以先只做最小判断：

1. 这是 export 还是 SQL
2. 这是本地写入还是同步
3. 这是执行还是 investigation

只要这三个先分清，大部分路由都不会偏。

## 可执行动作

1. 以后如果对一句话到底该走哪个 agent 还有点模糊，先回来看这篇。
2. 如果后面新增 active agent，可以继续按这篇的格式补“用户常见说法 -> agent 链”。
3. 如果 investigation 任务后面要转 trace-log draft 实操，直接跳到 [[26-trace-log真实任务执行卡片]]。

## 相关链接

- [[19-Active Agent实战速查表]]
- [[08-本地Multi-Agent Registry]]
- [[05-dbauto导出工作流样板]]
- [[18-dbauto只读SQL工作流样板]]
- [[09-Investigation排查工作流样板]]
- [[16-tool_trace_log_operator-专题总览]]
- [[26-trace-log真实任务执行卡片]]
