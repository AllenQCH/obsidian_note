---
title: "用户说法对应哪个agent"
source: "/Users/heytea/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-07
description: "把常见用户说法直接翻译成 active agent 链，避免后续靠猜路由。"
tags: ["codex", "agent", "workflow", "phrasebook"]
type: "workflow"
status: "processed"
---

# 用户说法对应哪个agent

## 摘要

这篇笔记解决的是一个特别实际的问题：

> 用户平时不会说“请调用 `stage_task_planner`”，而是会说“帮我查一下表结构”“启动导出任务”“先帮我分析一下原因”。

所以这篇的作用就是：

- 把自然说法翻译成任务类型
- 再映射到当前 active agent 链

完整四层总表看：[[所有agent四层结构和统一流程]]。

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
| `去 GitHub 网页上帮我改一下仓库设置` | GitHub 网页操作 | `control_request_router -> stage_task_planner -> tool_github_web_operator` | 外部仓库设置动作必须明确目标 |
| `帮我根据这个 traceId 看下哪里报错` | traceId 排查 | `control_request_router -> stage_investigation_planner -> tool_trace_log_operator` | 第一异常点比最后一个 ERROR 更重要 |
| `帮我去 CLS/日志平台查一下这个 trace` | CLS 日志查询 | `control_request_router -> stage_investigation_planner -> tool_cls_log_query_operator` | 优先用精确时间和 trace/message |
| `这个 message 你去日志里搜一下` | CLS message 查询 | `control_request_router -> stage_investigation_planner -> tool_cls_log_query_operator` | 不要把裸全文搜索当稳定证据 |
| `执行一次发票 XXL-Job` | 固定 XXL-Job 执行一次 | `control_request_router -> stage_task_planner -> tool_sso_operator -> tool_xxljob_execute_once_operator` | 只针对固定 job `280`，不能改任务配置 |
| `把周报信息查给我` | 蓝鲸周报查询 | `control_request_router -> stage_task_planner -> tool_weekly_report_operator` | 只读查询，不填表不改任务 |
| `整理本周周报内容` | 周报内容格式化 | `control_request_router -> stage_task_planner -> tool_weekly_report_operator` | 本周读取工时内容，下周读任务安排 |
| `帮我整理 Gmail 收件箱分类` | Gmail 分类 | `control_request_router -> stage_task_planner -> tool_gmail_classifier_operator` | 默认 dry-run，不删除邮件 |
| `把这些个人 agent/skill 资源整理成可迁移版本` | 个人资源迁移整理 | `control_request_router -> stage_task_planner -> tool_personal_migration_curator` | 不能发布公司材料、密钥、日志 |
| `帮我生成发票申请单全链路删除 SQL 包` | 发票申请单删除包 | `control_request_router -> stage_task_planner -> tool_dbauto_sql_operator -> tool_invoice_application_full_flow_delete_operator` | 只生成包，不执行写 SQL |
| `帮我生成权限种子 SQL` | HSP 权限种子 SQL | `control_request_router -> stage_task_planner -> tool_dbauto_sql_operator -> tool_auth_permission_seed_operator` | 不默认绑定个人生产权限或超管 |
| `海外收货单帮我组满数量收货 curl` | 海外 POF 收货确认准备 | `control_request_router -> stage_task_planner -> tool_dbauto_operator -> tool_intl_pof_sh_confirm_operator` | 默认生成 curl 和校验材料，执行 API 需授权 |
| `帮我创建/打开/重跑蓝鲸流水线` | 蓝鲸流水线操作 | `control_request_router -> stage_task_planner -> tool_sso_operator -> tool_bk_pipeline_operator` | 续开发默认复用原需求流水线 |
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
3. 如果 investigation 任务后面要转 trace-log draft 实操，直接跳到 [[trace日志真实任务怎么记录]]。

## 相关链接

- [[已启用agent怎么用]]
- [[所有agent四层结构和统一流程]]
- [[本机已启用agent注册表]]
- [[问题排查先查什么证据]]
- [[trace日志agent是做什么的]]
- [[trace日志真实任务怎么记录]]
