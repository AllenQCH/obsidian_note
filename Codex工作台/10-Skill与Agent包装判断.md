---
title: "Skill与Agent包装判断"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "整理当前本地 skill 中，哪些已经适合包装成 agent，哪些更适合先保持 skill 形态，以及判断标准。"
tags: ["codex", "agent", "skill", "workflow", "architecture"]
type: "workflow"
status: "processed"
---

# Skill与Agent包装判断

## 摘要

这篇笔记解决一个很实际的问题：

> 你本地已经有很多 skill 了，到底哪些应该继续只是 skill，哪些已经值得再往上包一层 agent？

先说结论：

- `skill` 更像“能力入口”或“执行手册”
- `agent` 更像“在四层体系里占一个明确岗位”

不是所有 skill 都值得 agent 化。

真正值得包装成 agent 的，通常都满足这 3 个条件：

1. 高频复用
2. 输入输出边界稳定
3. 已经在 workflow 里有明确位置

## 核心内容

### 先区分：skill 和 agent 到底差在哪里

#### `skill`

更像：

- 一份能力说明
- 一个脚本入口
- 一个操作约定

它的重点是：

- “这个能力怎么用”
- “命中什么场景时调用”

#### `agent`

更像：

- 四层体系里的一个固定岗位
- 一个稳定的输入输出节点
- 一个可以被 router / stage / gate 编排的角色

它的重点是：

- “它在流程里负责哪一步”
- “它不能越界做什么”

所以你可以简单理解成：

> skill 解决“能不能做”，agent 解决“在系统里由谁来做”。

### 当前已经适合 agent 化，并且事实上已经落地的 skill

这几类已经很典型了：

#### 1. `sso-login` -> `tool_sso_operator`

为什么适合：

- 高频
- 边界很清楚
- 明确是很多 workflow 的前置条件

它在系统里的角色很稳定：

- 只负责登录态检查或准备
- 不负责后续业务完成判断

#### 2. `dbauto-export-agent` -> `tool_dbauto_operator`

为什么适合：

- 已有稳定 wrapper
- 输入输出边界清楚
- 在 dbauto 场景里是非常固定的一步

它在系统里的角色也很稳定：

- 只负责 runtime bootstrap / readiness
- 不负责宣布业务导出完成

#### 3. `excel-json-analysis` -> `tool_excel_operator`

为什么适合：

- 是确定性、本地化、可验证的处理动作
- 输入输出都比较清楚
- 已经有独立 workflow 样板

它很适合作为标准 `tool_*`：

- 读输入
- 产出结果
- 报告统计

#### 4. `dbauto-sql-query` -> `tool_dbauto_sql_operator`

为什么适合：

- 已有稳定脚本入口
- 只读 SQL 边界很清楚
- 和 dbauto export 是不同类型的动作

它最适合作为单独 `tool_*`：

- 列实例 / 列库表
- 执行只读 SQL
- 报告实例、数据库和结果摘要
#### 5. `obsidian-note-writing` + 本地 vault 写入约定 -> `tool_obsidian_operator`

为什么适合：

- 本地文件变更边界稳定
- 有固定 vault
- 有固定写作规范

这里的关键是：

- skill 提供写法和规范
- agent 提供“在四层体系里，谁负责真正写本地笔记”

#### 6. GitHub 同步脚本 -> `tool_github_sync_operator`

为什么适合：

- 是一个独立的后置动作
- 风险边界很明确
- 和 `tool_obsidian_operator` 应该拆开

它适合 agent 化，不是因为它复杂，而是因为：

- 它和“本地写笔记”是两种不同性质的动作

### 当前还不适合直接 agent 化，或者至少不急着 agent 化的 skill

#### 1. `obsidian-note-writing`

它现在更像：

- 写作规范 skill
- 风格与结构指导

它本身不一定需要再拆第二个 agent，因为它更像 `tool_obsidian_operator` 的“内部规则来源”，而不是另一个独立岗位。

#### 2. `trace-log-analysis`

它很有潜力变成 `tool_trace_log_operator`，但现在还差一个条件：

- 你本地四层体系里还没有把它真的落成稳定 operator

所以目前更准确的状态是：

- 值得 agent 化
- 但尚未正式落地

也就是说，现在它仍然应该被当成 draft candidate 看，而不是 active tool agent。

#### 3. `release-workflow`

它现在更像一个大 workflow skill，而不是一个单点 operator。

原因是它里面混了很多事情：

- 收集信息
- 组织文档
- 关联流水线
- 可能还带外部页面打开

如果直接把它包成一个单 agent，反而容易又回到“大而重”的问题。

更合理的方向是：

- 先拆清楚里面到底有哪些固定步骤
- 再决定拆成 `tool_release_doc_operator`、`tool_pipeline_locator_operator` 之类的小角色

#### 4. `dws` / 各类 `lark-*`

这类 skill 的特点是：

- 能力很强
- 覆盖面很大
- 原子动作非常多

它们更像“工具箱”，不是天然适合直接一对一变成单个 agent。

更合适的方式通常是：

- 先从真实高频流程里抽一条链
- 再把那条链需要的固定动作包成专门 operator

而不是把整个 `lark-doc` 或整个 `dws` 直接等价成一个 agent。

### 一张最实用的判断表

| 类型 | 现在建议 | 原因 |
|---|---|---|
| `sso-login` | 已 agent 化 | 高频、边界稳、前置条件明确 |
| `dbauto-export-agent` | 已 agent 化 | runtime 启动边界清楚 |
| `dbauto-sql-query` | 已 agent 化 | 只读 SQL 和元数据查询边界清楚，已有稳定脚本 |
| `excel-json-analysis` | 已 agent 化 | 本地确定性处理，非常适合 tool agent |
| `obsidian-note-writing` | 暂不单独 agent 化 | 更像 `tool_obsidian_operator` 的规范来源 |
| `trace-log-analysis` | 值得下一步 agent 化 | investigation 场景需要，但本地还未正式落地 |
| `release-workflow` | 先拆，再 agent 化 | 现在太像“大 workflow skill” |
| `dws` / `lark-*` | 不建议整体 agent 化 | 工具面太宽，应该按具体高频流程拆 |

### 以后判断一个 skill 要不要包装成 agent，就看这 5 条

1. 它是不是在很多任务里反复出现？
2. 它的输入输出是不是已经稳定？
3. 它在四层流程里是不是已经有明确位置？
4. 把它包成 agent 后，边界会更清楚，还是会更重？
5. 如果不包成 agent，当前系统是不是已经开始反复“靠人脑临时记住它该在什么时候用”？

如果前 3 条大多是“是”，第 4 条是“更清楚”，第 5 条也是“是”，那就非常值得 agent 化。

## 可执行动作

1. 继续保持当前已经落地的 5 个 `tool_*` agent，不要再把它们并回大 skill。
2. 下一批最值得考虑 agent 化的是 `trace-log-analysis`。
3. `release-workflow` 不要急着整体 agent 化，先拆步骤再说。
4. `dws` / `lark-*` 这类大 skill，优先按高频场景拆，不要整包映射成一个 agent。
5. 真开始推进 `trace-log-analysis` 时，先按 [[26-trace-log真实任务执行卡片]] 跑真实 case，再决定要不要晋升 active。

## 相关链接

- [[00-Agent体系阅读顺序概览]]
- [[02-个人Codex多Agent改造计划]]
- [[08-本地Multi-Agent Registry]]
- [[13-Active与Draft状态矩阵]]
- [[16-tool_trace_log_operator-专题总览]]
- [[21-tool_trace_log_operator-最小执行入口草案]]
- [[22-tool_trace_log_operator-填写样例]]
- [[23-tool_trace_log_operator-晋升评审表]]
- [[26-trace-log真实任务执行卡片]]
- [[17-当前成果总清单]]
- [[18-dbauto只读SQL工作流样板]]
- [[09-Investigation排查工作流样板]]
- [[Skill目录与维护规范]]
