---
title: "Xuetao Agent体系研究总结"
source: "conversation: Codex chat 2026-06-03"
author: "Codex"
published:
created: 2026-06-03
description: "基于 /Users/heytea/Documents/xuetao的agetns 的多 Agent 体系分析，提炼可迁移到个人 Codex 工作台的架构经验。"
tags: ["codex", "agent", "workflow", "openspec", "architecture"]
type: "tech-note"
status: "processed"
---

# Xuetao Agent体系研究总结

## 摘要

这套体系好用，不是因为 agent 多，而是因为它把多 agent 运行系统拆成了完整的 4 个模块：注册表、工作流、门禁、协议。`config.toml` 只做入口索引，真正的稳定性来自 `workflow_router + stage gates + structured contract + tool risk matrix` 的组合。

对我当前个人 Codex 体系最有价值的，不是照抄全部 agent 名称，而是复用它的组织方式：先定义阶段，再定义 gate，再定义 operator 边界，最后才挂载具体能力。

## 核心内容

### 先记住一个前提：Xuetao 原命名和你本地命名不是一套

这篇笔记主要解释的是 Xuetao 原体系，所以正文里大部分仍然保留他的原名字，例如：

- `workflow_router`
- `investigation_planner`
- `dbauto_operator`
- `openspec_reviewer`

但你本地 `~/.codex` 现在已经改成了“层级前缀命名”，目的是一眼看出这个 agent 属于哪一层。

先记这张对照表就够了：

| Xuetao / 旧风格 | 你本地 / 前缀风格 | 所属层 |
|---|---|---|
| `request_router` / `workflow_router` | `control_request_router` | control |
| `stage_orchestrator` | `control_stage_orchestrator` | control |
| `planning_agent` | `stage_task_planner` | stage |
| `investigation_agent` / `investigation_planner` | `stage_investigation_planner` | stage |
| `execution_agent` | `stage_execution_runner` | stage |
| `integration_agent` | `stage_integration_orchestrator` | stage |
| `closeout_agent` | `stage_closeout_reporter` | stage |
| `gate_evaluator` | `gate_stage_evaluator` | gate |
| `sso_operator` | `tool_sso_operator` | tool |
| `dbauto_operator` | `tool_dbauto_operator` | tool |
| `excel_operator` | `tool_excel_operator` | tool |
| `obsidian_operator` | `tool_obsidian_operator` | tool |
| `github_sync_operator` | `tool_github_sync_operator` | tool |

你后面读这篇笔记时，建议这样看：

1. 先把 Xuetao 的名字当“原始案例”。
2. 再把它映射到你自己的四层前缀体系。
3. 学的是“职责拆分方法”，不是逐字照抄名字。

### 研究对象

- 主入口：[config.toml](/Users/heytea/Documents/xuetao的agetns/.codex/config.toml:1)
- Agent 列表目录：[.codex/agents](/Users/heytea/Documents/xuetao的agetns/.codex/agents)
- 多 Agent 总说明：[openspec-multi-agent.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-multi-agent.md:1)
- 默认执行链路：[agent-workflows.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/agent-workflows.md:1)
- 阶段门禁：[openspec-stage-gates.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-stage-gates.md:1)
- 统一协议：[openspec-agent-contracts.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-agent-contracts.md:1)
- 工具风险矩阵：[tool-agent-matrix.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/tool-agent-matrix.md:1)

### 这套体系真正的强点

#### 1. `config.toml` 只做注册表

`config.toml` 只负责声明：

- 有哪些 agent
- 每个 agent 的一句话职责
- 对应的配置文件路径
- 每 new 一个 agent，都会加入到这个字典中

它不承担复杂流程逻辑，也不承担详细协议。这让配置层保持稳定，后面新增 agent 时只是在索引层扩展，不会把整个系统改得很脆。

#### 2. 路由层很克制

`workflow_router` 的职责被刻意限制为：

- 识别当前 stage
- 找最小缺失输入
- 推荐后续 stage agent / tool agent
- 按 gate 判断是否允许继续

它明确不写文件、不改代码、不接管执行。这个边界非常关键，因为很多系统一开始就让 router 顺手做规划和执行，后面会变成一个失控的“大脑代理”。

#### 3. 阶段 agent 与工具 agent 分层清楚

这套体系不是按“日志 agent / 文档 agent / 搜索 agent”这种表层名称拆，而是先区分：

- 阶段 agent（stage agent）：负责对象、阶段、文档、边界、handoff
- 工具 agent（tool agent）：负责某个 CLI 或系统动作

比如：

- `initiative_planner` / `investigation_planner` / `workspace_preparer` 属于阶段层
- `dbauto_operator` / `trace_log_operator` / `wiki_operator` 属于工具层

这让“做什么”和“怎么做”两类决策不会混在一个 agent 里。

#### 4. Gate 被当成主流程的一部分

这套体系不是“最后 review 一下”，而是在每个关键阶段前都用 gate 统一判断：

- `go`
- `warn`
- `block`

而且 gate 不只看文件是否存在，还看：

- `context_isolation_status`
- `required_inputs`
- `required_artifacts`
- `override_allowed`

这说明它在解决的不只是流程完整性，还包括上下文污染和错误路径复用。

#### 5. Contract 非常统一

所有子 agent 被约束为统一输出形状：

- `agent`
- `input`
- `output.facts`
- `output.decision`
- `output.next_actions`
- `output.artifacts_to_update`

这一步把 agent 从“会说话的提示词角色”变成“可编排的结构化节点”。没有这个协议，上层 orchestrator 最后还是得读自然语言猜意思，系统会越来越脆。

#### 6. 工具层不是能力矩阵，而是风险矩阵

`tool-agent-matrix.md` 不只登记“谁能做什么”，还登记：

- sandbox 模式
- 默认执行模式
- 高风险动作
- 是否要求 dry-run 或人工确认

这说明它很重视外部系统边界，尤其适合会碰到 SSO、dbauto、发布、文档写回、调度触发这类高风险动作的工作台。

### 对我自己的可迁移经验

#### 应该直接学习的 4 个骨架

1. `workflow_router`
2. `stage-gates`
3. `agent-contracts`
4. `tool-agent-matrix`

这 4 个骨架比具体 agent 名称更重要。

#### 最值得复用的组织原则

1. 先定阶段，再挂 agent。
2. 先定 gate，再放执行权限。
3. 先定 contract，再追求智能。
4. operator 只执行，不决定主流程。
5. router 只分流，不顺手干活。

#### 不建议照抄的部分

这套体系围绕 OpenSpec 的对象模型非常强，比如 investigation / initiative / plugin-project。我的个人 Codex 工作台不一定需要复制这些对象名，更合理的做法是保留它的分层方式，替换成自己的阶段对象。

### 实操案例：按他的真实流程看一遍

前面那几条总结如果只看抽象概念，确实容易看不懂。更直观的理解方式，是直接看“一个请求进来以后，系统到底怎么流转”。下面这些例子都严格按他的 [agent-workflows.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/agent-workflows.md:1) 和相关 gate / contract 文档来解释。

#### 案例 1：排查一个 traceId 问题

用户输入：

```bash
/investigate traceId=xxx env=intl 常规加单超时
```

真实链路：

```text
workflow_router
-> investigation_planner
-> trace_log_operator / dbauto_operator / catalog_repo_selector
-> openspec_reviewer
```

具体发生的事情：

1. `workflow_router`
   先判断这是 `investigation_planning`，不是正式需求开发，也不是插件项目。
   它会检查最小锚点有没有齐：
   - `traceId`
   - `env`
   - 问题现象

2. `investigation_planner`
   开始维护 `investigations/inv-*` 这类对象。
   它会负责：
   - 建或读 investigation 目录
   - 维护 `links.yaml`
   - 维护 `findings.md`
   - 记录根因候选

3. `trace_log_operator`
   去查 trace、日志签名、snapshot。
   它不负责判断“最终根因是什么”，它只负责拿证据。

4. `dbauto_operator`
   如果怀疑和数据库状态有关，就补充只读查询证据。

5. `catalog_repo_selector`
   根据上下文判断受影响 repo 候选，给出 `serviceKey` 和候选仓库。

6. `openspec_reviewer`
   最后检查：
   - 当前证据够不够
   - investigation 路径是否正确
   - 有没有上下文污染
   - 能不能升级成正式 initiative

这个案例最重要的观察点：

- `workflow_router` 不亲自查日志
- `trace_log_operator` 不亲自决定后续流程
- `investigation_planner` 不自己去执行数据库查询
- `openspec_reviewer` 不去补证据，只判断是否可继续

也就是说，每层只做自己的事。

#### 案例 2：新建一个正式需求对象

用户输入：

```bash
/initiative create p45_7028 overseas-mdc-fix intl <bk-link>
```

真实链路：

```text
workflow_router
-> bk_operator
-> initiative_planner
-> catalog_repo_selector
-> workspace_preparer
```

具体发生的事情：

1. `workflow_router`
   判断当前是 `initiative_planning`，不是排查，也不是直接改代码。

2. `bk_operator`
   先去蓝鲸需求系统拿正式元信息，比如：
   - 需求号
   - 标题
   - 链接
   - 相关元数据

3. `initiative_planner`
   负责创建或更新 initiative 的骨架文档，比如：
   - `overview.md`
   - `design.md`
   - `tasks.md`
   - `links.yaml`

4. `catalog_repo_selector`
   判断这个需求影响哪些 repo，顺手给出 `serviceKey` 和依赖顺序。

5. `workspace_preparer`
   最后检查能不能进入实施准备，比如：
   - `repos/` 结构是否合理
   - 分支名是否合理
   - 开工条件是否满足

这个案例最重要的观察点：

- 先建对象，再选 repo，再准备 workspace
- 不会一上来就让 `repo_implementer` 去改代码
- 需求对象和 repo 选择是分开的

这说明他这套系统把“需求建模”和“代码实施”切成了两个阶段。

#### 案例 3：进入单 repo 实施

用户输入：

```bash
/initiative implement p45_7028 intl:job-hsp-mdc 修复重试逻辑
```

真实链路：

```text
workspace_preparer
-> repo_implementer
-> openspec_reviewer
```

这里和前面最大的不同是：这一步已经不是新建需求对象，而是进入某个明确 repo 的实施阶段。

具体发生的事情：

1. `workspace_preparer`
   先看 `gate_repo_ready` 是否通过。
   它重点检查：
   - 当前 repo 是否明确
   - 当前路径是不是在 `initiatives/<需求>/repos/<repo>`
   - 有没有先读 initiative 文档

2. `repo_implementer`
   真正开始在单个 repo 内实施或分析。
   它被强约束为：
   - 只能在当前 repo 内工作
   - 不能乱读其他 initiative 当当前证据
   - 要先读 workspace 和 repo 上下文

3. `openspec_reviewer`
   最后复核：
   - 代码风险
   - 测试缺口
   - OpenSpec 是否有回写遗漏
   - 路径边界有没有越界

这个案例最重要的观察点：

- `repo_implementer` 不是一个“全能开发 agent”
- 它前面有 `workspace_preparer` 卡边界
- 它后面有 `openspec_reviewer` 做收口

也就是：实施 agent 被前后两个角色夹住，不容易失控。

#### 案例 4：插件项目不是普通需求

用户输入：

```bash
/plugin create 20260521 codex-agent-router
```

真实链路：

```text
workflow_router
-> plugin_project_planner
-> knowledge_base_operator
-> openspec_reviewer
```

这个案例很能看出“按对象类型和阶段拆”的味道。

具体发生的事情：

1. `workflow_router`
   判断当前是 `plugin_project_planning`。

2. `plugin_project_planner`
   维护的是 `plugin-projects/plugin-*` 这套对象，而不是普通 initiative。

3. `knowledge_base_operator`
   去外部知识库搜资料、拉引用、登记参考内容。

4. `openspec_reviewer`
   检查插件项目结构、权限和验证缺口。

这个案例最重要的观察点：

- 他没有强行让普通需求 agent 去兼容插件项目
- 而是给插件项目单独一条阶段链路

所以这套系统不是单纯按“能力”拆，而是按“对象 + 阶段”一起拆。

### 用一句更白话的话解释他的流转逻辑

你可以把它理解成 4 个岗位接力：

1. `workflow_router`
   像前台分诊，先判断你来的是哪一类事情。

2. `stage agent`
   像当前阶段负责人，决定这一步应该补什么、写什么、调哪些工具。

3. `tool operator`
   像专职办事员，去查日志、查数据库、查蓝鲸、查文档，但不负责拍板。

4. `reviewer / gate`
   像质检和放行人，判断能不能进入下一步。

如果只记一句：

> **router 不干活，stage agent 定流程，operator 拿证据，reviewer 决定放不放行。**

这样再回头看他那套 `config.toml + docs + agents`，就容易理解很多。

### 如果把他的案例翻译成你本地四层名字，会长什么样

比如你自己的 dbauto 导出准备流，如果按你本地名字表达，可以写成：

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator(stage=execution)
-> stage_execution_runner
-> tool_sso_operator
-> tool_dbauto_operator
-> gate_stage_evaluator(gate_execution_ready)
-> stage_closeout_reporter
```

这里最关键的不是名字变长了，而是你一眼就能知道：

- `control_*` 负责分流和编排
- `stage_*` 负责阶段推进
- `tool_*` 负责真正动工具
- `gate_*` 负责判断能不能继续

这就是你现在本地体系比“纯自然语言命名”更容易维护的地方。

### 再进一步：每一层到底“收什么，吐什么”

如果前面的流程你还是觉得抽象，可以把它理解成一条装配线。装配线上的每个人都不是“自由发挥聊天”，而是：

- 收固定类型的输入
- 做固定范围内的事
- 交固定类型的输出

#### 1. `workflow_router` 收什么，吐什么

它收到的东西通常很简单：

- 用户原话
- 少量锚点
  - 例如 `traceId`
  - 例如 `需求号`
  - 例如 `plugin 名称`

它吐出来的不是最终答案，而是这种判断：

- 当前属于哪个 stage
- 最小还缺什么
- 推荐下一个 agent 是谁

你可以把它理解成：

> “这不是干活的人，这是分诊台。”

它不会说“根因就是数据库慢”，它只会说：

- 这是 investigation
- 先去查日志
- 如果需要，再查数据库

#### 2. `stage agent` 收什么，吐什么

它收到的东西是：

- router 判好的阶段
- 当前对象路径
- 当前任务目标
- 已经拿到的部分证据

它吐出来的是：

- 当前阶段该补什么
- 需要调哪些 operator
- 当前阶段是否 ready

所以 `investigation_planner` 不会替你去跑 trace-log 命令，`initiative_planner` 也不会直接去改代码。它们更像：

> “阶段负责人，负责决定这一步应该长成什么样。”

#### 3. `operator` 收什么，吐什么

它收到的东西通常是很具体的任务：

- 查这个 traceId
- 查这个数据库实例
- 查这个蓝鲸需求
- 查这个 wiki 页面

它吐出来的是：

- 结构化事实
- 原始证据路径
- dry-run 结果
- 风险提示

所以 operator 更像：

> “专业办事员，只跑腿，不拍板。”

它不会说“应该升级成正式 initiative”，它只会说：

- 我查到了 3 条日志签名
- 我查到了 1 次数据库慢查询
- 结果文件在某个路径

#### 4. `reviewer/gate` 收什么，吐什么

它收到的是前面所有人的产出：

- 当前对象文档
- 当前证据
- 当前路径
- 当前阶段结果

它吐出来的是非常克制的结论：

- `go`
- `warn`
- `block`

你可以把它理解成：

> “不是再干一遍活，而是判断这一步能不能继续。”

它不会替你补日志，也不会替你选 repo。它只会说：

- 可以继续
- 能继续，但有风险
- 先别继续，缺关键输入

### 一个完整例子：把排查流程拆成输入/输出

还拿 `traceId` 排查看一遍，不过这次用“输入/输出”的方式看。

用户说：

```text
查一下这个 traceId，海外加单超时
```

#### Step 1：`workflow_router`

输入：

- 用户原话
- `traceId`
- `env=intl`

输出：

- `stage = investigation_planning`
- `missing_minimum_inputs = []`
- `recommended_agents = [investigation_planner, trace_log_operator, dbauto_operator]`

#### Step 2：`investigation_planner`

输入：

- 当前 stage
- 当前 task goal
- 当前 investigation 是否已存在

输出：

- `target_path = investigations/inv-xxx`
- `missing_anchors = []`
- `tool_agents_needed = [trace_log_operator, dbauto_operator, catalog_repo_selector]`

#### Step 3：`trace_log_operator`

输入：

- `traceId`
- `env`

输出：

- trace snapshot
- 错误签名
- 时间范围
- 相关服务名

#### Step 4：`dbauto_operator`

输入：

- 数据库实例
- 查询目标

输出：

- 只读查询结果
- 慢 SQL 证据
- 查询日志 ID

#### Step 5：`openspec_reviewer`

输入：

- investigation 文档
- trace 证据
- DB 证据
- repo 候选

输出：

- `go/warn/block`
- 还缺什么
- 能不能升级成正式 initiative

这样一拆，你就能看见：

- 每一步的输入都比上一步更具体
- 每一步的输出都只负责一小块
- 没有谁在一个节点里同时“分诊 + 查证据 + 做判断 + 改代码”

这就是它为什么稳。

### 如果不用这套拆分，会乱成什么样

为了让你更容易理解，我反过来举一个“坏例子”。

假设只有一个“大 agent”，用户一上来就说：

```text
帮我查这个海外加单超时 traceId
```

这个大 agent 可能会同时做 6 件事：

1. 自己猜这是排查任务
2. 自己跑日志查询
3. 自己跑 DB 查询
4. 自己猜影响 repo
5. 自己判断根因
6. 自己判断是否该建正式需求

短期看起来很聪明，但很快会出问题：

- 日志查少了，没人发现
- DB 查询条件错了，没人兜底
- 把历史 initiative 当成当前结论引用了
- 还没拿够证据就开始下根因结论
- 最后到底是谁判断“可以升级”也不清楚

所以这套体系真正避免的是：

> **一个 agent 又当大脑、又当执行员、又当质检员。**

### 用你更熟的场景类比一下

如果套到你自己的场景，比如：

- `sso-login`
- `dbauto 导出`
- `excel 提取`

你可以这样理解：

#### 错误做法

一个 agent 包办：

- 先判断要不要登录
- 再自己去登录
- 再自己启动 dbauto
- 再自己判断导出完成没有
- 最后再自己决定要不要同步结果

#### 更好的做法

- `router`
  判断这是导出类任务
- `planning agent`
  判断要先登录，再准备 dbauto，再执行导出
- `sso_operator`
  只解决登录
- `dbauto_operator`
  只解决 dbauto 环境准备或导出动作
- `gate/reviewer`
  判断是不是已经真的完成

所以你可以把 Xuetao 这套体系当成一个模板：

> 不是为了造很多 agent，而是为了强制把“判断、执行、放行”拆开。

### 最后再压缩成一句最容易记的话

如果你现在只想记住最简单的一版，就记这个：

1. `workflow_router`
   先判断“这是什么事”

2. `stage agent`
   再判断“这一步该怎么干”

3. `operator`
   真正去执行“具体动作”

4. `reviewer/gate`
   最后判断“能不能继续往下走”

如果某个 agent 同时干了这 4 件事里的 3 件以上，那它大概率就太重了。

### 把他的体系翻译成你自己的场景

如果前面还是偏“看别人家的系统”，那下面这段就是直接翻成你自己的语境。这样你可以更容易判断：为什么我们后来给你拆成 `router / planning / execution / operator / gate`。

#### 场景 1：`sso-login + dbauto 导出`

你现在最熟的链路其实是：

1. 先确认有没有 SSO 登录态
2. 再启动 dbauto 的本地工具
3. 再打开或准备导出界面
4. 最后判断“环境准备完成了没有”

如果按 Xuetao 那套思路，这条链应该这样拆：

```text
request_router
-> planning_agent
-> stage_orchestrator(stage=execution)
-> execution_agent
-> sso_operator
-> dbauto_operator
-> gate_evaluator(gate_execution_ready)
```

具体怎么理解：

##### `request_router`

收到：

- “启动导出任务”
- “帮我准备 dbauto 导出”

它只判断：

- 这是导出类任务
- 当前应该进入 `planning` 或 `execution`
- 下一步不是 `excel_operator`，而是 `sso_operator + dbauto_operator`

它不做：

- 登录
- 启动脚本
- 判断导出是否真的完成

##### `planning_agent`

它负责把用户原话翻成一个最小执行链：

- 先查登录态
- 如果没登录，走登录准备
- 再准备 dbauto runtime
- 最后再判断是否 ready

它吐出来的不是执行结果，而是：

- `selected_operator_chain = [sso_operator, dbauto_operator]`
- `required_inputs = [platform/env]`
- `required_artifacts = [runtime_status]`

##### `sso_operator`

它只负责：

- 查登录态
- 打开登录页面
- 等待用户完成登录

它不负责：

- 启动 dbauto
- 打开导出插件
- 判断导出业务成功

##### `dbauto_operator`

它只负责：

- 启动后端脚本
- 检查 runtime 是否起来
- 打开导出 UI

它不负责：

- 决定当前是不是该先登录
- 判断最终任务是不是算完成

##### `gate_evaluator`

最后只判断：

- 当前是否真的进入了“导出环境 ready”
- 还是只是“SSO 成功了，但 dbauto 没起来”
- 或者“dbauto 起了，但导出动作还没开始”

这个拆法最重要的好处是：

> 你以后想换登录方式，只改 `sso_operator`；想换 dbauto 启动脚本，只改 `dbauto_operator`；主流程不需要重写。

#### 场景 2：`excel-json-analysis`

这个场景比 dbauto 更简单，所以更适合看清楚“为什么有的能力本来就应该是 operator”。

用户说：

```text
把这个 Excel 里的 JSON 字段提出来，去重，再生成新文件
```

如果按 Xuetao 风格来拆：

```text
request_router
-> planning_agent
-> stage_orchestrator(stage=execution)
-> execution_agent
-> excel_operator
-> gate_evaluator(gate_execution_ready)
```

这里最关键的是：

- `excel_operator` 本身已经很接近一个理想 operator 了
- 它的职责很纯：
  - 读输入文件
  - 提取字段
  - 去重
  - 写输出文件

所以这个案例能帮你看懂一件事：

> 不是所有能力都要再拆。

如果某个能力天然就是：

- 输入明确
- 输出明确
- 不依赖复杂上下文
- 不需要自己决定下一步

那它天生就更适合做 `operator`，而不是再包成一个重型 stage agent。

#### 场景 3：`Obsidian 写入 + GitHub 同步`

这个例子是我们最近刚帮你拆开的，所以特别适合反过来理解 Xuetao 的体系。

以前直觉式做法是：

```text
写 Obsidian 文件 -> 直接执行 auto_sync_to_github.sh
```

这看起来省事，但职责是混着的。

按我们现在改完后的思路，它被拆成：

```text
request_router
-> planning_agent
-> stage_orchestrator(stage=execution)
-> execution_agent
-> obsidian_operator
-> gate_evaluator(gate_obsidian_sync_ready)
-> github_sync_operator
```

这里你就能很清楚看见 Xuetao 那套思想怎么落到了你的系统上：

##### `obsidian_operator`

只负责：

- 本地 Markdown 文件写入/更新/移动/删除

不负责：

- `git pull --rebase`
- `git push`
- 远端冲突处理

##### `gate_obsidian_sync_ready`

只判断：

- 这次是不是实际改了 Obsidian 文件
- 当前是不是应该进入 GitHub 同步
- 当前是不是只是分析任务，不该同步

##### `github_sync_operator`

只负责：

- 调用同步脚本
- 回报：
  - 是否成功
  - 是否冲突
  - 是否远端拒绝

这个例子最能说明“为什么要拆”：

如果不拆，`obsidian_operator` 就会同时干：

- 本地写文件
- 判断是否需要同步
- 拉远端
- 处理冲突
- 推送 GitHub

那它马上就会变成一个重型 agent。

#### 场景 4：如果以后你补 `release-workflow`

再往后你如果想把：

- 提测文档
- Obsidian 记录
- GitHub 同步
- 甚至流水线链接整理

串成一个完整流程，那也应该按同样思路拆：

```text
request_router
-> planning_agent
-> stage_orchestrator
-> execution_agent
-> release_doc_operator / obsidian_operator / github_sync_operator
-> gate_evaluator
```

而不是做一个“大而全的提测 agent”把：

- 收集信息
- 写文档
- 同步 Obsidian
- 发 GitHub
- 判断是否完成

全部揉在一起。

### 你现在可以怎么判断一个 agent 是不是太重

以后你只要问自己 4 个问题：

1. 它是不是在判断任务类型？
2. 它是不是在决定下一步流程？
3. 它是不是在执行具体工具动作？
4. 它是不是还在判断能不能放行？

如果一个 agent 同时回答了 3 个“是”，那它大概率就该拆。

比如：

- `excel_operator`
  通常只会命中第 3 个，所以它不重。

- “一个能自己登录、自己启动 dbauto、自己判断导出完成、自己同步结果”的 agent
  会同时命中 2、3、4，甚至 1，所以它一定偏重。

### 最后一版最接地气的理解

如果完全用你自己的语言讲：

- `router`
  像“先判断这是导出任务、笔记任务、还是表格处理任务”

- `planning_agent`
  像“决定要先登录，再启动，再导出；或者先解析 Excel，再去重，再写文件”

- `execution_agent`
  像“监督这一串动作按顺序执行，但自己不下场当具体工具”

- `operator`
  像“真正去登录、真正去跑脚本、真正去写文件的人”

- `gate/reviewer`
  像“最后判断这一步到底算不算完成”

如果你用这套理解回去看 Xuetao 的体系，基本就不会再只看到一堆 agent 名字，而能看出它的运行秩序。

## 可执行动作

1. 以这套体系为蓝本，在 `~/.codex/agents/` 下先建立最小骨架。
2. 第一批先定义：
   - `control_request_router`
   - `control_stage_orchestrator`
   - `gate_stage_evaluator`
   - `tool_sso_operator`
   - `tool_dbauto_operator`
   - `tool_excel_operator`
3. 在本地先补齐 4 份文档：
   - `agent-workflows.md`
   - `stage-gates.md`
   - `agent-contracts.md`
   - `tool-agent-matrix.md`
4. 当前个人 `~/.codex` 已进一步落到：
   - 控制层：`control_request_router`、`control_stage_orchestrator`
   - 阶段层：`stage_investigation_planner`、`stage_task_planner`、`stage_execution_runner`、`stage_integration_orchestrator`、`stage_closeout_reporter`
   - gate 层：`gate_stage_evaluator`
   - tool 层：`tool_sso_operator`、`tool_dbauto_operator`、`tool_excel_operator`、`tool_obsidian_operator`、`tool_github_sync_operator`
5. 当前目录结构也已按层拆到：
   - `agents/control/`
   - `agents/stage/`
   - `agents/gate/`
   - `agents/operator/`
   - `agents/docs/`

## 相关链接

- [[00-Agent体系阅读顺序概览]]
- [[01-1-Xuetao-Agent分层清单]]
- [[01-2-四层模型与Xuetao扩展层对比]]
- [[08-本地Multi-Agent Registry]]
- [[agent拆分逻辑]]
- [[agent 拆分新逻辑]]
- [[Codex Agent 能力与读取链路图]]
- [[02-个人Codex多Agent改造计划]]
