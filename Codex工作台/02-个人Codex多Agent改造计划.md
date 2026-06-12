---
title: "个人Codex多Agent改造计划"
source: "conversation: Codex chat 2026-06-03"
author: "Codex"
published:
created: 2026-06-03
description: "基于 Obsidian 的 agent 拆分思想与 Xuetao 样例体系，为个人 ~/.codex 工作台制定的多 Agent 改造计划与第一阶段实施顺序。"
tags: ["codex", "agent", "workflow", "plan", "architecture"]
type: "workflow"
status: "processed"
---

# 个人Codex多Agent改造计划

## 摘要

这篇笔记现在要同时承担两个作用：

1. 记录这次个人 `~/.codex` 多 Agent 改造到底做了什么；
2. 以后你如果继续扩展 agent，可以把它当成执行蓝图和复盘入口。

这次改造最初的目标，不是一次性启用完整多 agent 系统，而是先按 Obsidian 的拆分方式，把个人 `~/.codex` 工作台补出稳定骨架。整体最早分三步：

1. 先沉淀研究结论和计划；
2. 先落地骨架文件，不立即切换主配置；
3. 先把 `sso-login`、`dbauto-export-agent`、`excel-json-analysis` 这三类高价值能力收敛到 `operator` 层。

第一阶段当时设定的成功标准是：本地已经存在可继续演进的 `control / stage / tool / gate / contract / matrix` 骨架，而不是已经全量替换当前工作流。

但按 2026-06-07 的真实状态看，这一步已经走完了“只有骨架”的阶段，当前已经进入：

> 主配置已切到四层命名体系，运行态和说明文档都已落地；后续重点是继续扩具体能力，而不是再讨论是否搭骨架。

## 核心内容

### 先用一句话理解当前状态

如果只用一句话总结你现在的进度，就是：

> 架构骨架、命名规则、主配置、说明文档和 4 个实操样板都已经落地；后面要做的，不再是“从 0 到 1 建框架”，而是“继续往具体能力和具体 workflow 上扩展”。

同时再补一个现在非常重要的判断习惯：

> 是否真正进入运行态，只看 `~/.codex/config.toml`。有些对象已经有草案，但还不是 active agent。

另外，开发场景的中文展示名现在统一为：

- `新项目开发` = `new_feature_from_scratch`
- `迭代开发` = `iterative_feature_development`
- `迭代再开发` = `existing_feature_continuation`

### 这篇计划以后怎么用

以后你可以把这篇笔记按 3 种视角来读：

#### 1. 实施前

当你准备继续拆新 agent 时，先看：

- `目标架构`
- `严格实施规则`
- `实施前检查清单`

这时的目标不是回顾历史，而是确认你接下来要加的 agent 应该放哪一层、按什么规则命名、能不能直接进主配置。

#### 2. 实施中

当你正在新增 agent 或改 workflow 时，先看：

- `阶段计划`
- `实施中推进顺序`
- `当前执行状态`

这时的目标是避免边做边漂移，确保目录、命名、config、docs、Obsidian 是一起推进的。

#### 3. 实施后

当你想复盘“现在本机到底已经改到哪”时，先看：

- `当前执行状态`
- `实施后验收清单`
- `下一步扩展方向`

这时的目标是快速判断哪些已经是事实，哪些还只是后续计划。

### 目标架构

#### 1. 控制层

- `control_request_router`
- `control_stage_orchestrator`

控制层只负责任务分流、阶段识别和状态推进，不做具体外部系统动作。

#### 2. 阶段层

- `stage_investigation_planner`
- `stage_task_planner`
- `stage_execution_runner`
- `stage_integration_orchestrator`
- `stage_closeout_reporter`

阶段层负责阶段目标、边界和产物，不直接承载所有工具动作。

#### 3. 操作层

当前已经 active：

- `tool_sso_operator`
- `tool_dbauto_operator`
- `tool_dbauto_sql_operator`
- `tool_excel_operator`
- `tool_obsidian_operator`
- `tool_github_sync_operator`
- `tool_trace_log_operator`
- `tool_xxljob_execute_once_operator`
- `tool_weekly_report_operator`

当前只是候选或后续方向：

- `tool_lark_doc_operator`
- `tool_lark_sheet_operator`
- `tool_release_doc_operator`

#### 4. Gate 层

- `gate_stage_evaluator`

gate 层只负责 `go / warn / block` 放行判断，不执行具体工具动作。

#### 5. 协议层

- 统一 `contract`
- 统一 `gate output`
- 统一 `tool-agent-matrix`
- 统一 `state transition`

### 第一阶段计划

#### 阶段 A：文档先行

产出：

- Obsidian 研究总结笔记
- Obsidian 改造计划笔记

目标：

- 把架构决策和实施顺序沉淀到知识库
- 避免后续边改边漂移

#### 阶段 B：建立本地骨架

产出路径：

- `~/.codex/agents/README.md`
- `~/.codex/agents/docs/agent-workflows.md`
- `~/.codex/agents/docs/stage-gates.md`
- `~/.codex/agents/docs/agent-contracts.md`
- `~/.codex/agents/docs/tool-agent-matrix.md`

目标：

- 先建立一个不影响当前运行环境的骨架
- 让后续 agent 扩展有稳定落点

补充说明：

- 这里最早确实走过 `config.template.toml` 过渡方案。
- 但按当前真实状态看，这一步已经收敛完成，后续不再恢复模板双轨维护。

#### 阶段 C：第一批 agent 落地

第一批文件：

- `control_request_router.toml`
- `control_stage_orchestrator.toml`
- `gate_stage_evaluator.toml`
- `tool_sso_operator.toml`
- `tool_dbauto_operator.toml`
- `tool_excel_operator.toml`

目标：

- 先把“控制层 + 高复用 operator”落地
- 不急着落地完整阶段 agent

### 实施前检查清单

如果你后面继续加新的 agent，建议每次先过一遍这张表：

1. 这次新增的是 `control`、`stage`、`tool` 还是 `gate`？
2. 它是不是只做一件事？
3. 它有没有把“分流 / 执行 / 放行 / 收口”混在一起？
4. 它需不需要先补一条 workflow 文档，而不是直接写 TOML？
5. 它是不是应该先复用已有 script / skill，而不是重新发明执行入口？
6. 它加进来以后，`config.toml`、`agents/docs`、Obsidian 入口笔记要不要同步更新？

如果这 6 个问题里有 2 个以上答不上来，通常说明这个 agent 还没拆干净。

### 实施中推进顺序

以后继续扩展时，默认按这个顺序推进最稳：

1. 先决定这个能力属于哪一层。
2. 再决定它的边界和命名。
3. 先补 workflow / gate / contract 说明。
4. 再落 TOML 文件。
5. 再登记到 `~/.codex/config.toml`。
6. 再补 Obsidian 的解释性笔记和阅读入口。

这样做的好处是：不会出现“配置已经改了，但人已经看不懂了”的情况。

### 严格实施规则

1. 不直接在没有文档与边界说明的情况下改当前 `~/.codex/config.toml` 的有效运行逻辑。
2. 先写 workflow / contract / 骨架说明，再决定是否接入主配置；不要再恢复 `config.template.toml` 双轨切换思路。
3. operator 只调用现有已验证 skill / script，不重新发明执行器。
4. 所有新 agent 必须遵守统一 contract。
5. 高风险动作必须进 `tool-agent-matrix`。

### 2026-06-12 补充：周报查询 operator

本次新增 active tool agent：

- `tool_weekly_report_operator`

定位：

- 只读查询蓝鲸 `智慧门店/b1af00` 的周报相关任务；
- 按 `relation=CREATED`、TASK、预计开始/结束时间都落在目标周内的规则过滤；
- 本周工作从工时插件 `records[].jobContent` 提取；
- 下周工作按同口径任务输出，无任务时结合上下文输出 `请假` 或 `暂无已安排任务`；
- 后三周需求通过任务关联对象 `issue_relation` 读取需求名称。

边界：

- 不提交工时；
- 不变更任务状态；
- 不创建任务；
- 不填写 AliDocs 表格。

补充当前已经验证过的本地规则：

1. 在线提测文档创建必须按需求区域落到固定目录：国内需求放《国内迭代》，海外需求放《海外迭代》；目录无法解析时阻断创建，不退回空间根目录。
2. 需要内部系统登录时，优先走 `opencli` Browser Bridge 路径，由 `tool_sso_operator` 调用 `~/.codex/skills/sso-login/scripts/sso_opencli.py`；只有 opencli 不适配或工具有独立 OAuth / CLI 认证要求时，才走专用登录方式。
3. 人工控制规则已经从“每个阶段固定确认”调整为“按风险暂停”。确定性、可逆、只读、本地执行或用户已经显式要求的动作默认自动推进；只有路由/分支/目标项目/目标目录歧义、破坏性 Git、主干合并、环境晋级、审批放行、在线文档删除/移动等动作才必须暂停确认。
4. 开发流程里的人工确认默认合并为一次性授权包；迭代开发中分支不再作为常规确认项，而是默认 `fetch origin`、切 `master`、`pull --ff-only origin master`，再按既定规则创建规范需求分支。只有非 `master` 来源分支、分支名无法生成、涉及仓库不明确、远端同名分支新建/复用歧义或分支状态冲突时才人工确认。
5. 迭代开发默认采用“前置人工控制区 + 后续自主闭环”：路由确认、需求/设计确认需要人工把关；默认路由交付是输出启动命令和完整 prompt，由用户自行开新窗口粘贴，不再单独确认“是否启动独立窗口”。确认后 agent 自主建分支、写代码、写测试规则、跑测试，测试通过后自主 commit/push，并在已要求提测时继续创建 BK 流水线和在线提测文档。测试失败时先自动定位，只有修复方案会改变已确认设计、扩大范围、改变接口契约，或需要接受失败继续推进时，才回到人工确认。
6. 迭代再开发默认采用“前期续改目标确认 + 后续自主闭环”：先复用已有 OpenSpec、分支、历史提交、测试记录、提测文档和流水线记录，重点确认本次续改目标与是否改变原设计；确认后 agent 自主改代码、补测试、跑验证，测试通过后 commit/push。默认不新建 BK 流水线；如果新增服务、仓库、部署单元或服务分支条目，优先补进原有需求流水线；已有提测文档只在涉及服务、设计、接口、前端对接、外部对接、测试范围、风险说明或验证证据变化时更新。
7. 新增 `codex-downloads/openspec` 统一归档层：`/Users/heytea/Documents/HeyTea/code/codex-downloads/openspec/` 用来做跨项目需求总索引，汇总最近需求、涉及仓库、分支、commit、测试、流水线、提测文档、前端对接和外部对接。它不替代服务级 OpenSpec；服务级 OpenSpec 仍随各服务代码提交。

8. 当前主配置真源只有 `~/.codex/config.toml`，不要再恢复 `config.template.toml` 双轨维护。
9. `closeout` 仍然属于 `stage` 层，不单独再造第五层。
10. active / draft 必须分开维护：已经注册进 `config.toml` 的才算 active，只有 `.draft.*`、workflow 草案或 contract 草案的不算运行态。
11. `2026-06-11` 起新增 `tool_xxljob_execute_once_operator`：它是一个窄边界的生产运维 tool agent，只允许通过 opencli 对生产 XXL-Job `jobId=280` 执行 `执行一次`，禁止保存 `更新任务` 和修改任何任务配置。

### 第一阶段完成后的下一步

这是当时第一阶段刚完成时的原始想法：

1. 为 `dbauto-export-agent` 增加薄编排层，改成：
   - `tool_sso_operator`
   - `tool_dbauto_operator`
   - 上层 workflow 串联
2. 把 `sso-login` 从共享 skill 语义进一步固化成 shared operator。
3. 当时还保留过“视稳定性再决定是否合并进主配置”的想法。

这部分基于当前事实需要更新一下：

- 第 1 条已经完成到可用骨架和 workflow 样板层，不再是“待开始”。
- 第 3 条对应的历史分叉也已经关闭，因为 `config.template.toml` 已经移除，当前只有主 `config.toml`。

所以你现在更真实的“下一步”应该是：

1. 继续把高频业务能力拆成更细的 `tool_*` 或 `stage_*`。
2. 决定哪些 workflow 已经需要单独沉淀成专门样板。
3. 决定哪些 skill 需要进一步包装成 agent。
4. 继续整理 `~/.codex` 根目录里非运行态的备份 / 缓存 / 历史文件。

## 可执行动作

1. 本轮先完成阶段 A 与阶段 B，以及阶段 C 的最小骨架。
2. 完成本轮后，优先验证文件存在性和关键字段正确性。
3. 下一轮再决定是否启用主配置和扩展阶段 agent。

### 实施后验收清单

以后每次你改完一轮多 agent 结构，可以按这张表验收：

1. `~/.codex/config.toml` 是否仍然是唯一真源。
2. agent 文件是否都落在正确层级目录下。
3. 命名是否全部符合 `control_ / stage_ / tool_ / gate_` 前缀。
4. `agents/docs` 里的 workflow、gate、contract、matrix 是否同步更新。
5. Obsidian 入口笔记是否还能让你快速看懂这轮变化。
6. 至少有一个真实案例能证明这轮拆分不是纸上架构。

### 当前执行状态（2026-06-03）

- 已完成：阶段 A
  - 已新增研究总结笔记
  - 已新增改造计划笔记
- 已完成：阶段 B
  - 已在 `~/.codex/agents/` 下新增骨架文档与 registry 模板
- 已完成：阶段 C 的第一批最小骨架
  - 已新增 `control_request_router.toml`
  - 已新增 `control_stage_orchestrator.toml`
  - 已新增 `gate_stage_evaluator.toml`
  - 已新增 `tool_sso_operator.toml`
  - 已新增 `tool_dbauto_operator.toml`
  - 已新增 `tool_excel_operator.toml`
- 已完成：主配置合并
  - 已将旧的 `config.template.toml` 方案收敛进主 `~/.codex/config.toml`
  - 已通过 TOML 解析验证
- 已完成：Obsidian 同步后置流程下沉
  - 已将 `~/.codex/AGENTS.md` 中的 Obsidian 同步规则改成“原则 + gate/operator 执行”
  - 已新增 `tool_obsidian_operator.toml`
  - 已新增 `tool_github_sync_operator.toml`
  - 已补 `gate_stage_evaluator(gate_obsidian_sync_ready)` 这条规则用法、workflow 链路与 tool matrix
- 已完成：阶段层第二批骨架
  - 已新增 `stage_task_planner.toml`
  - 已新增 `stage_execution_runner.toml`
  - 已补 `gate_stage_evaluator(gate_planning_ready)` 这条规则用法
  - 已合并进主 `~/.codex/config.toml`
- 已完成：阶段层第三批骨架
  - 已新增 `stage_investigation_planner.toml`
  - 已新增 `stage_integration_orchestrator.toml`
  - 已新增 `stage_closeout_reporter.toml`
  - 已补 `gate_stage_evaluator(gate_investigation_ready)` 这条规则用法
  - 已补 `gate_stage_evaluator(gate_integration_ready)` 这条规则用法
  - 已补 `gate_stage_evaluator(gate_closeout_ready)` 这条规则用法
  - 已合并进主 `~/.codex/config.toml`
- 已完成：agent 目录按层级重组
  - 已按 `control/ stage/ gate/ operator/ docs/` 拆分 `~/.codex/agents/`
  - 已同步更新主 `~/.codex/config.toml` 的 `config_file` 路径
  - 已通过全部 TOML 解析验证
- 已完成：四层前缀命名收敛
  - 已统一改成 `control_ / stage_ / tool_ / gate_` 前缀
  - 已移除 `config.template.toml`，当前以 `~/.codex/config.toml` 为唯一配置真源
- 已完成：阶段层 baseline 补齐
  - 当前阶段层已覆盖 `investigation / planning / execution / integration / closeout`
- 已完成：实操样板补齐
  - 已新增 `dbauto 导出工作流样板`
  - 已新增 `Obsidian 写入与 GitHub 同步工作流样板`
  - 已新增 `Excel 提取去重工作流样板`
- 已完成：阅读入口与本地 registry 强化
  - 已补 `00-Agent体系阅读顺序概览`
  - 已补 `08-本地Multi-Agent Registry`
  - 已为主要 agent 增加真实案例说明和常见链路
- 已完成：trace operator 接入与历史设计线沉淀
  - 已新增 `11-tool_trace_log_operator候选拆分草案`
  - 已新增 `12-tool_trace_log_operator-Contract草案`
  - 已在 `~/.codex/agents/` 下收敛为正式 active 文件：
    - `operator/tool_trace_log_operator.toml`
    - `docs/trace-log-investigation-workflow-example.md`
  - 已注册进 `~/.codex/config.toml`
- 已完成：active / draft 状态拆分说明
  - 已补 `13-Active与Draft状态矩阵`
  - 已明确“只有 `~/.codex/config.toml` 中注册的 agent 才算 active”
  - 已把 `tool_trace_log_operator` 切入 active runtime，并把旧草案保留为历史设计参考
- 已完成：通用本地闭环测试规范
  - 已新增 `~/.codex/agents/docs/local-closure-testing-workflow.md`
  - 已将“真实入口 -> 真实内部链路 -> 仅 mock 外部依赖 -> 本地业务结果验证”沉淀为通用测试 agent 规则
  - 已同步更新 `agent-workflows.md`、`stage-gates.md`、`agent-contracts.md`、`active-agent-quickstart.md` 与 docs index
  - 该规范用于测试 agent 在生成测试用例后执行本地闭环验证，不绑定单一业务项目
  - 已补默认提交候选口径：若本地闭环资产已隔离、可复用、已在 OpenSpec 记录并真实用于闭环验证，则默认跟正式需求代码、测试、OpenSpec 一起进入提交候选，不再默认排除
- 已完成：分层映射边界规则
  - 已在 `agent-workflows.md` 增加“Layered Mapping Boundary”
  - 默认规则：`center` / repository-facing 层不吸收上层展示 DTO 的属性重命名；展示兼容和字段别名优先放在 `manager` / `backend` / `convert` 层处理
  - 仅当 SQL 条件、返回列、持久化契约或真实下层领域结构本身有问题时，才把改动下推到 `center`
- 已完成：codex-downloads 统一 OpenSpec 归档层
  - 已新增 `/Users/heytea/Documents/HeyTea/code/codex-downloads/openspec/README.md`
  - 已新增统一需求索引模板 `templates/demand-index-template.md`
  - 已建立 `active/`、`archived/`、`attachments/` 三类归档目录
  - 已同步 multi-agents 规则：跨仓库需求、前端/外部对接、流水线证据、提测文档和最近工作总览应维护统一索引；服务级 OpenSpec 仍保留在服务仓库内
- 待继续：是否继续整理 `~/.codex` 根目录中的备份/缓存结构，以及是否为具体业务流补更细的 workflow 示例

### 下一步扩展方向

按照当前真实状态，后面最值得继续做的是：

1. 补更细的业务 workflow 样板，而不是先增加很多新名字。
2. 从高频 skill 中挑出真正值得 agent 化的对象。
3. 为 investigation 类任务补一个更完整的真实案例。
4. 继续把“本地运行配置”和“人能读懂的说明文档”保持同步。
5. 如果再出现新的 draft candidate，先补状态矩阵，再决定要不要注册进运行态。

## 相关链接

- [[00-Agent体系阅读顺序概览]]
- [[08-本地Multi-Agent Registry]]
- [[05-dbauto导出工作流样板]]
- [[06-Obsidian写入与GitHub同步工作流样板]]
- [[07-Excel提取去重工作流样板]]
- [[09-Investigation排查工作流样板]]
- [[10-Skill与Agent包装判断]]
- [[11-tool_trace_log_operator候选拆分草案]]
- [[12-tool_trace_log_operator-Contract草案]]
- [[21-tool_trace_log_operator-最小执行入口草案]]
- [[22-tool_trace_log_operator-填写样例]]
- [[23-tool_trace_log_operator-晋升评审表]]
- [[26-trace-log真实任务执行卡片]]
- [[13-Active与Draft状态矩阵]]
- [[01-Xuetao-Agent体系研究总结]]
- [[04-Obsidian同步规则拆分说明]]
- [[agent拆分逻辑]]
- [[agent 拆分新逻辑]]
- [[Skill目录与维护规范]]
