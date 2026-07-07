---
title: "本机已启用agent注册表"
source: "/Users/heytea/.codex/config.toml"
author: "Codex"
published:
created: 2026-06-07
description: "记录当前个人 ~/.codex multi-agent 的四层命名、职责边界、输入输出重点和调用关系。"
tags: ["codex", "agent", "workflow", "registry"]
type: "workflow"
status: "processed"
---

# 本机已启用agent注册表

## 摘要

这篇笔记是你当前本地 `~/.codex` multi-agent 的总清单。

它只服务一个目的：

> 以后你看 `config.toml`、看 agent 文件名、看 workflow 文档时，能快速知道每个 agent 属于哪一层、负责什么、不能做什么。

当前体系已经按四层收敛：

```text
control
stage
tool
gate
```

并且 `~/.codex/config.toml` 已经是唯一配置真源，不再维护 `config.template.toml`。

完整统一流程看：

- [[所有agent四层结构和统一流程]]

当前所有 active agent 都应遵循这条链：

```text
control_request_router
-> control_stage_orchestrator
-> stage_task_planner / stage_investigation_planner
-> stage_execution_runner
-> tool_* operator
-> stage_test_runner（代码改动后）
-> gate_stage_evaluator
-> stage_integration_orchestrator
-> stage_closeout_reporter
```

### 任务工作流怎么跑映射入口

`my-multi-agents/03-我的agent用例/补充案例-任务工作流/` 里的样板已经对应到 multi-agents 文档层：

- multi-agents 总映射：`/Users/heytea/.codex/agents/docs/obsidian-workflow-mapping.md`
- 工作流总入口：`/Users/heytea/.codex/agents/docs/agent-workflows.md`
- 快速路由入口：`/Users/heytea/.codex/agents/docs/active-agent-quickstart.md`

当前已对应的样板包括：

- [[Obsidian写入和GitHub同步怎么跑]]
- [[为什么Obsidian写入和同步要分开]]
- [[问题排查先查什么证据]]

## 核心内容

### 当前命名规则

统一规则：

```text
<layer>_<domain>_<role>
```

当前层级前缀：

- `control_`
- `stage_`
- `tool_`
- `gate_`

### 1. Control 层

#### `control_request_router`

作用：

- 识别当前任务类型
- 补最少缺失输入
- 选择下一条 stage 流程

真实例子：

- 你说“启动 dbauto 导出任务，环境 bj”时，它先判断这不是 Excel 处理，也不是 Obsidian 写笔记，而是一个 `dbauto export bootstrap` 任务。
- 你说“帮我把 Excel 里的 goodsCode、goodsName 提出来并去重”时，它会先把任务归到 `excel_json_extraction`，而不是直接相信字段路径。

不会做：

- 不执行工具
- 不直接写文件
- 不判断业务是否真正完成

#### `control_stage_orchestrator`

作用：

- 维护当前 stage 状态
- 选择这一步要跑哪些 stage / tool agent
- 指定对应 gate

真实例子：

- 在 dbauto 任务里，它会把当前阶段推进到 `execution`，并明确这一步要串 `stage_execution_runner -> tool_sso_operator -> tool_dbauto_operator`。
- 在 Obsidian 写入任务里，它会先让本地写笔记，再进入 `gate_stage_evaluator(gate_obsidian_sync_ready)`，而不是一上来就跑 GitHub 同步。

不会做：

- 不替代 tool agent 执行具体工具动作

### 2. Stage 层

#### `stage_task_planner`

作用：

- 把用户请求翻译成可执行计划
- 给出最小 tool chain
- 说明 required inputs / artifacts

真实例子：

- 在 Excel 提取任务里，它会先要求确认：真实表头是不是 `shot_json`、JSON 记录路径是什么、输出文件要放哪里。
- 在 dbauto 任务里，它会把链路定成 `tool_sso_operator -> tool_dbauto_operator`，而不是把“导出完成”也提前当成已知事实。

#### `stage_investigation_planner`

作用：

- 为不确定任务定义最小证据集
- 分离已确认事实和假设
- 为后续 planning / execution 做准备

真实例子：

- 如果后面你说“为什么 dbauto 启动了但没有真正导出”，它应该先把这个任务转成 investigation：先区分是登录态问题、runtime 问题，还是业务导出步骤没走完。
- 如果你说“这个 Excel 为什么提取结果不对”，它会先要求样例行、真实表头、错误输出，而不是直接重跑脚本碰运气。

#### `stage_execution_runner`

作用：

- 按顺序协调 tool chain
- 跟踪执行状态
- 区分“准备完成”和“业务完成”

真实例子：

- 在 dbauto 任务里，它负责先跑 SSO，再跑 dbauto wrapper，并记住 `RESULT=READY` 只代表环境 ready。
- 在 Excel 任务里，它负责收集“提取行数 / 去重行数 / 无效 JSON 行数”，再交给后面的 gate 和 closeout。

#### `stage_integration_orchestrator`

作用：

- 协调多 tool / 多产物的依赖关系
- 判断是否准备好进入 handoff 或 closeout

真实例子：

- 在 dbauto 任务里，它会把两个前置结果合起来看：`tool_sso_operator` 说登录可用，`tool_dbauto_operator` 说 runtime 可用，于是它才能得出“环境已准备好，但导出未必已完成”。
- 如果后面有更多多步工具链，比如“先写 Obsidian，再跑同步，再生成总结”，它就负责把多段结果整成一个可交接状态。

#### `stage_closeout_reporter`

作用：

- 汇总最终状态
- 写回最终产物
- 明确说明做到哪一步

真实例子：

- 在 Excel 任务里，它最终应该说清楚：输出文件路径是什么、提取了多少行、去重后多少行、有没有无效 JSON。
- 在 dbauto 任务里，它最终应该说清楚：现在只是环境 ready，还是已经开始导出，还是已经拿到业务导出结果。

### 3. Tool 层

#### `tool_sso_operator`

作用：

- 检查或准备本地 SSO 登录态

真实例子：

- 跑 `sso_opencli.py --status` 看当前国内登录态是否有效。
- 如果无效，就触发一次交互式登录准备，但它不会替你宣称 dbauto 已经可用。

#### `tool_dbauto_operator`

作用：

- 启动或检查 dbauto 运行环境
- 只报告 readiness，不冒充导出完成

真实例子：

- 跑 `run_dbauto_export_agent.sh --env bj`，检查后端、Browser Bridge、dbauto 页面和插件 UI 是否起来。
- 就算脚本最后回了 `RESULT=READY`，它也只能说“环境 ready”，不能直接说“导出完成”。

#### `tool_dbauto_sql_operator`

作用：

- 通过现有 opencli + dbauto SQL 脚本执行只读查询或元数据查看
- 明确区分“列库表”和“真正执行只读 SQL”

真实例子：

- 跑 `dbauto_sql_query.py --list-common-instances` 看国内常用实例。
- 跑 `dbauto_sql_query.py --instance hsp-ids --db center_hsp_invoice --sql "SHOW CREATE TABLE hsp_goods_rate"` 查看表结构。
- 它只能做只读 SQL，不能把写 SQL 当成普通查询执行。

#### `tool_excel_operator`

作用：

- 执行 Excel JSON 提取和去重
- 输出明确的输入/输出路径和结果统计

真实例子：

- 跑 `extract_json_fields_from_excel.py`，从某个 `.xlsx` 里抽 `goodsCode`、`goodsName`，去重后生成新文件。
- 它应该把“实际表头、records-path、提取行数、去重行数、输出文件路径”一起回报，而不是只吐一个文件名。

#### `tool_obsidian_operator`

作用：

- 只负责本地 Obsidian vault 文件变更

真实例子：

- 把这次 agent 拆分计划整理成 `Codex工作台/xx.md` 这样的笔记。
- 它只负责本地文件的创建和更新，不负责 Git commit / push。

#### `tool_github_sync_operator`

作用：

- 在 gate 允许后，执行 Obsidian GitHub 同步脚本

真实例子：

- 本地笔记已经确认写好后，再跑 `auto_sync_to_github.sh` 做 Git 同步。
- 如果遇到 `pull --rebase` 冲突、认证失败或远端拒绝，它只负责如实回报，不会把同步失败伪装成写笔记失败。

### 4. Gate 层

#### `gate_stage_evaluator`

作用：

- 统一输出 `go / warn / block`
- 判断这一步是否满足进入下一步的条件

真实例子：

- 在 Excel 任务里，它会看：源文件能不能读、JSON 字段有没有确认、输出文件有没有真的生成。
- 在 Obsidian 任务里，它会看：是不是确实改了 vault 文件，能不能继续进 `tool_github_sync_operator`。
- 在 dbauto 任务里，它会看：登录态和 runtime 到底是 `go`、`warn` 还是 `block`。

当前主要 gate 规则：

- `gate_execution_ready`
- `gate_investigation_ready`
- `gate_integration_ready`
- `gate_closeout_ready`
- `gate_obsidian_sync_ready`

这里要特别注意：

- 这些是 `gate_stage_evaluator` 使用的判定规则名
- 不是另外 5 个已经注册进 `config.toml` 的独立 gate agent

### 当前 registry 总览

| 层级 | Agents |
|---|---|
| control | `control_request_router`、`control_stage_orchestrator` |
| stage | `stage_task_planner`、`stage_investigation_planner`、`stage_execution_runner`、`stage_test_runner`、`stage_integration_orchestrator`、`stage_closeout_reporter` |
| tool | `tool_sso_operator`、`tool_dbauto_operator`、`tool_dbauto_sql_operator`、`tool_excel_operator`、`tool_obsidian_operator`、`tool_github_sync_operator`、`tool_github_web_operator`、`tool_trace_log_operator`、`tool_cls_log_query_operator`、`tool_xxljob_execute_once_operator`、`tool_weekly_report_operator`、`tool_gmail_classifier_operator`、`tool_personal_migration_curator`、`tool_invoice_application_full_flow_delete_operator`、`tool_auth_permission_seed_operator`、`tool_intl_pof_sh_confirm_operator`、`tool_bk_pipeline_operator` |
| gate | `gate_stage_evaluator` |

### trace-log 当前状态

#### `tool_trace_log_operator`

当前状态：

- 已正式注册进 `~/.codex/config.toml`
- 已有历史候选拆分草案
- 已有 contract 草案
- 已有最小执行入口草案
- 已有真实案例模板、填写样例和评审表

它的定位是：

- 负责 `traceId` 驱动的日志时间线重建、第一异常点定位和证据整理
- 当前已经是 active `tool_*` agent
- 历史草案文档保留为设计与复盘参考，不再表示它仍未启用

### 最常见的 4 条真实链路

#### 1. dbauto 导出准备

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator
-> stage_integration_orchestrator
-> stage_closeout_reporter
```

#### 2. Excel 提取去重

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_excel_operator
-> gate_stage_evaluator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

#### 3. Obsidian 写入并同步

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator
-> stage_execution_runner
-> tool_obsidian_operator
-> gate_stage_evaluator
-> tool_github_sync_operator
-> gate_stage_evaluator
-> stage_closeout_reporter
```

#### 4. Investigation 排查

```text
control_request_router
-> stage_investigation_planner
-> control_stage_orchestrator
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator
-> stage_task_planner or stage_closeout_reporter
```

## 可执行动作

1. 后续新增 agent 时，先决定层级前缀，再决定名字细节。
2. 如果某个 stage 开始承载太多“选对象”逻辑，再考虑单独引入 selector。
3. 如果某个 tool 后面经常跟着多 repo 执行与收口，再考虑引入 implement / integration 扩展层。

## 相关链接

- [[阅读顺序-先Xuetao再我的agents]]
- [[我的四层模型和Xuetao对比]]
- [[我的Codex多agent改造计划]]
- [[问题排查先查什么证据]]
- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[trace日志最小执行入口]]
- [[trace日志agent什么时候能启用]]
- [[trace日志案例填写示例]]
- [[trace日志agent晋升评审]]
- [[trace日志真实任务怎么记录]]
- [[trace日志agent是做什么的]]
- [[已落地能力总清单]]
