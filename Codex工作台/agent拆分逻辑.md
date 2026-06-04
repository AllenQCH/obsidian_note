## 一句话结论

你这套设计的方向是对的，而且比很多“一个 supervisor + 一堆泛化 agent”的方案更成熟。**它的本质不是“按能力拆 agent”，而是“按阶段、边界、风险、产物协议”四维一起拆。** 真正应该继续强化的，不是再多造 agent，而是把它收敛成：

> **1 个总路由层 + 3 类执行层（阶段 agent / 工具 agent / 审核 gate agent）+ 统一 contract + 统一状态机**

也就是从“agent 列表”升级成“可验证的 workflow system”。

---

# 1. 我从你本地文件里看到的核心拆分逻辑

你这套不是随便拆的，已经隐含了很清晰的架构思想。

---

## 1）你当前的拆分主轴：不是按“职能名称”拆，而是按“工作流阶段”拆

从这些文件能看出来：

- `/Users/heytea/Downloads/.codex/contracts/agents/workflow-router.schema.json`
    
- `/Users/heytea/Downloads/my归档/docs/openspec-agent-contracts.md`
    
- `/Users/heytea/Downloads/my归档/docs/openspec-stage-gates.md`
    

核心 agent 明显围绕生命周期展开：

- `workflow_router`
    
- `investigation_planner`
    
- `initiative_planner`
    
- `catalog_repo_selector`
    
- `workspace_preparer`
    
- `repo_implementer`
    
- `integration_orchestrator`
    
- `openspec_reviewer`
    
- `plugin_project_planner`
    
- `knowledge_base_operator`
    
- `archive_operator`
    

这说明你的拆分不是“代码 agent / 文档 agent / 搜索 agent”这种粗分类，而是：

### 你实际上在做一个阶段驱动系统

即：

1. **先识别当前处在哪个 stage**
    
2. **再调用对应 stage 的 agent**
    
3. **每个 stage 输出标准化 decision / next_actions / artifacts**
    
4. **通过 gate 判断能否进入下一阶段**
    

这比市面上很多“让一个总 agent 自己想下一步”更稳。

---

## 2）你不是只拆“角色”，还拆了“风险边界”

`tool-agent-matrix.yaml` 很关键。这里不是简单登记工具，而是把 agent 和风险策略绑定了：

例如：

- `bk_operator`：高风险动作要 dry-run + explicit confirmation
    
- `wiki_operator`：publish/move/update 要 dry-run
    
- `xxljob_operator`：trigger/rundates 要显式确认
    
- `archive_operator`：移动/删除历史目录必须 dry-run
    

这说明你已经意识到：

> agent 不只是“会什么”，还要定义“默认允许做什么、什么必须升权、什么必须确认”。

这点非常对。 很多市面方案只做 capability registry，不做 risk registry，结果一上生产就容易失控。

---

## 3）你已经有“协议优先”的意识，这非常值钱

`openspec-agent-contracts.md` 里已经明确了统一协议：

顶层固定：

- `agent`
    
- `input`
    
- `output`
    

输出固定：

- `facts`
    
- `decision`
    
- `next_actions`
    
- `artifacts_to_update`
    

这其实是在做一件很重要的事：

> **把 agent 从“会说话的提示词角色”变成“可编排的结构化节点”**

这一步是很多团队卡住的地方。 因为没有统一协议，就只能靠 prompt 里“你帮我写清楚点”，最后 supervisor 根本没法稳定消费子 agent 输出。

你这里已经走在对的路上了。

---

## 4）你还有一个非常成熟的点：把“上下文污染”纳入 gate

`openspec-stage-gates.md` 里最值得肯定的，不是 go/warn/block，而是这几个字段：

- `context_isolation_status`
    
- `override_allowed`
    
- `required_inputs`
    
- `required_artifacts`
    

尤其这句意思很关键：

- `clean`
    
- `warn`
    
- `polluted`
    

这不是普通流程控制，而是在防：

- 错 initiative
    
- 错 repo
    
- 错历史结论
    
- 跨任务上下文串味
    

这说明你的系统不是只想“跑通”，而是想“长期可维护、可追责、可复现”。

---

# 2. 你当前这套拆分的本质模型

如果我帮你抽象，你现在其实是这四层：

---

## A. 路由层

代表：

- `workflow_router`
    

职责：

- 识别用户请求属于哪个 stage
    
- 补最小上下文
    
- 推荐下一个 agent
    
- 决定是否 delegate
    

这是典型 **triage/router**。

---

## B. 阶段规划层

代表：

- `investigation_planner`
    
- `initiative_planner`
    
- `plugin_project_planner`
    

职责：

- 在某个阶段内决定需要哪些输入
    
- 缺什么锚点
    
- 下一步该调哪些子 agent
    
- 当前阶段是否 handoff-ready
    

这是典型 **stage planner**。

---

## C. 执行/工具层

代表：

- `catalog_repo_selector`
    
- `workspace_preparer`
    
- `repo_implementer`
    
- `knowledge_base_operator`
    
- `archive_operator`
    
- 各类 `*_operator`
    

职责：

- 真正去查、改、拉、写、执行
    
- 受权限和风险约束
    
- 输出结构化结果
    

这是典型 **operator / worker**。

---

## D. 审核与门禁层

代表：

- `openspec_reviewer`
    
- 各类 gate 评估逻辑
    

职责：

- 判断能不能过阶段
    
- 判断上下文是否污染
    
- 判断是否缺文档、缺事实、缺验证
    
- 决定 go/warn/block
    

这是典型 **evaluator / reviewer / gatekeeper**。

---

# 3. 你这套和市面主流方案的对照

我查了几类比较典型的公开方案，和你的设计对一下。

---

## 1）Anthropic：推荐“简单可组合模式”，先 workflow，后 agent

Anthropic 那篇 **Building Effective Agents** 的核心观点很明确：

- 先用最简单方案
    
- workflow 适合定义清楚的任务
    
- agent 适合高不确定性任务
    
- 不要一开始就上复杂框架
    
- 常见模式包括：
    

- prompt chaining
    
- routing
    
- orchestrator-worker
    
- evaluator-optimizer
    

### 跟你的对应关系

你的系统几乎完整覆盖了这几个模式：

- `workflow_router` = routing
    
- 阶段 agent 串联 = prompt chaining / workflow
    
- `repo_implementer` 等 = worker
    
- `openspec_reviewer` + stage gates = evaluator-optimizer
    

### 结论

**你的方向比 Anthropic 推荐的“简单、可组合模式”高度一致。**

而且你比很多人更进一步： 你不只是 pattern，还把它们绑定到了业务产物和文件结构上。

---

## 2）OpenAI Agents SDK：两种核心模式

OpenAI 文档里强调两种常见编排：

- **agents as tools**
    

- manager 保持控制权
    
- specialist 只是完成子任务
    

- **handoffs**
    

- triage agent 把控制权直接切给 specialist
    

### 跟你的对应关系

你现在偏向这两者混合：

- `workflow_router` 很像 triage / handoff 起点
    
- 各 operator 又像被 manager 调用的 tool-agents
    

### 我对你的建议

你这类业务系统里，**优先用 “agents as tools”，少用完全 handoff**。

原因很简单：

- 你有强 stage 概念
    
- 有强 artifact 更新要求
    
- 有强风险控制
    
- 有上下文污染问题
    

如果让 specialist 完全接管对话，很容易：

- 丢阶段上下文
    
- 丢主流程状态
    
- 输出形态漂移
    
- 越权
    

所以你的主系统更适合：

> **Router / Orchestrator 持有主状态，子 agent 只返回结构化结果**

而不是完全自由 handoff。

---

## 3）LangGraph：workflow + orchestrator-worker + evaluator

LangGraph 文档把模式分得很清楚：

- prompt chaining
    
- parallelization
    
- routing
    
- orchestrator-worker
    
- evaluator-optimizer
    
- agents
    

### 跟你的对应关系

你最接近的是：

### 模式一：Routing

`workflow_router`

### 模式二：Orchestrator-worker

`initiative_planner` / `integration_orchestrator` 调 worker

### 模式三：Evaluator-optimizer

`openspec_reviewer` + `gate_*`

### 结论

你现在**不是缺模式**，而是要把模式收敛成一个统一 runtime。

---

## 4）AutoGen：handoff / mixture-of-agents / reflection

AutoGen 公开了几类模式：

- Handoffs
    
- Reflection
    
- Mixture of Agents
    
- Group chat
    
- Debate
    

### 这里要分清哪些适合你，哪些不适合你

#### 适合你的

- **handoff**：可以用，但要受控
    
- **reflection**：很适合 `repo_implementer -> reviewer -> implementer` 这种改码审查循环
    

#### 不太适合你的主链路

- **group chat**
    
- **debate**
    
- **mixture of agents**
    

原因： 你的场景不是开放式创作，也不是高发散式研究。 你是：

- 有明确 stage
    
- 有明确目录结构
    
- 有明确产物
    
- 有明确权限边界
    

所以不需要让多个 agent 在群聊里“商量”。 那样 token 大、延迟高、可追责差。

---

# 4. 对你当前拆分的评价：优点与问题

---

## 优点

### 1）拆分维度是对的

你不是纯 capability 拆分，而是：

- stage
    
- risk
    
- artifact
    
- context boundary
    

一起拆。

### 2）协议意识很强

已经接近“可机编排”的形态。

### 3）很适合工程场景

尤其适合：

- repo/需求/工单驱动
    
- 多系统联动
    
- 变更风险敏感
    
- 需要强审计
    

### 4）gate 概念非常成熟

这比“reviewer 看一眼”强多了。

---

## 当前问题

### 1）agent 数量开始变多，但层级还没完全定型

现在容易出现两个风险：

- 名字很多，但有些职责边界重叠
    
- planner / operator / reviewer 可能相互串职责
    

比如：

- `initiative_planner`
    
- `workflow_router`
    
- `integration_orchestrator`
    

如果不定义清楚，可能都在做“下一步计划”。

---

### 2）有 contract，但还没完全变成状态机

现在 schema 很清楚，但我更建议你补一层：

- stage transition table
    
- 每个 stage 可进入哪些下一个 stage
    
- 哪些 gate 是硬依赖
    
- 哪些 agent 只能在某 stage 调用
    

不然系统会有“看似结构化，但其实自由跳转”的问题。

---

### 3）工具 agent 与业务阶段 agent 还可以再解耦

现在有些 operator 同时带一点业务语义、又带一点工具语义。

更稳的方式是：

- **业务 agent 负责“为什么做、做到什么程度”**
    
- **工具 agent 负责“怎么调用外部系统”**
    

不要混。

---



















# 5. 我给你的“最佳拆分逻辑”

这是我认为最适合你这套场景的版本。

---

## 最佳拆分原则：四层模型

---

## 第一层：Control Plane（控制平面）

只保留少量 agent。

建议只有这几个：

### 1. `request_router`

职责：

- 识别任务类型
    
- 判断入口 stage
    
- 提取最小输入
    
- 指定主流程
    

替代或收敛你现在的 `workflow_router`。

---

### 2. `stage_orchestrator`

职责：

- 持有当前任务状态
    
- 决定当前 stage 应调用哪些 agent
    
- 汇总结果
    
- 决定是否进入下阶段
    

这层不要下沉到具体业务工具。

---

### 3. `gate_evaluator`

职责：

- 对每个阶段做 go/warn/block
    
- 检查 context isolation
    
- 检查 artifact completeness
    
- 检查 override policy
    

这层独立出来，不要散在各 agent 里。

---

## 第二层：Stage Agents（阶段 agent）

每个 agent 只负责一个生命周期阶段。

建议保留 5~7 个，不要太多。

### 推荐：

- `investigation_agent`
    
- `initiative_agent`
    
- `workspace_agent`
    
- `implementation_agent`
    
- `integration_agent`
    
- `closeout_agent`
    
- `plugin_project_agent`（如果插件链路长期独立）
    

注意： 这里建议把 `planner + implementer + reviewer` 的名字收敛成**阶段视角**，不要让命名同时表达策略和动作。

例如：

- 不一定要叫 `initiative_planner`
    
- 可以统一叫 `initiative_agent`
    
- 它内部再决定调用 repo selector / kb operator / reviewer
    

这样对外的主语义更稳。

---

## 第三层：Operator Agents（工具/系统操作 agent）

这是你 `tool-agent-matrix.yaml` 那层，应该长期保留，而且要更“薄”。

比如：

- `bk_operator`
    
- `dbauto_operator`
    
- `trace_log_operator`
    
- `wiki_operator`
    
- `alidocs_operator`
    
- `gitlab_mr_operator`
    
- `yapi_operator`
    
- `xxljob_operator`
    
- `knowledge_base_operator`
    
- `archive_operator`
    

原则：

### operator 不做三件事

1. 不判断全局阶段
    
2. 不决定业务下一步
    
3. 不直接改总状态机
    

只做：

- 接任务
    
- 执行
    
- 回报结构化结果
    
- 附带风险标签
    

---

## 第四层：Reviewer / Guard Agents

这层单独存在，不混进业务 agent。

建议至少保留：

- `spec_reviewer`
    
- `change_reviewer`
    
- `context_isolation_reviewer`
    
- `evidence_reviewer`
    

如果不想太多，也可以物理上只有 1 个 reviewer agent，逻辑上按 mode 切换。

---

# 6. 最佳拆分不是“更多 agent”，而是“更少 agent + 更强协议”

如果你问我最核心的一句建议：

## 不要继续横向加角色名

而要纵向强化这 5 件事：

### 1. 统一状态机

定义：

- stage enum
    
- stage transition table
    
- allowed agents per stage
    
- required artifacts per stage
    
- required gates per transition
    

---

### 2. 统一 contract

你已经有雏形了，建议继续强化到：

### 所有 agent 强制输出

- `agent`
    
- `run_id`
    
- `stage`
    
- `input`
    
- `facts`
    
- `decision`
    
- `evidence`
    
- `next_actions`
    
- `artifacts_to_update`
    
- `risks`
    
- `handoff_recommendation`
    

---

### 3. 统一 evidence 模型

你现在有 `facts`，很好，但还可以补：

- fact 是什么
- evidence 从哪来 
- current_task / reference_only
    
- confidence
    
- stale_after
    

尤其适合防历史污染。

---

### 4. 统一 risk policy

把 `tool-agent-matrix.yaml` 再升级一下：

每个 operator 定义：

- default mode
    
- requires dry-run?
    
- requires explicit confirmation?
    
- max scope
    
- irreversible actions
    
- allowed stages
    
- audit fields required
    

---

### 5. 统一 artifact registry

你现在已经在要求更新 artifacts 了。建议再做成注册表：

每个 stage 规定：

- 必须存在的文档
    
- 可选文档
    
- 由谁生成
    
- 何时更新
    
- 哪个 gate 检查
    

---

# 7. 后续实现逻辑：我建议分 4 期落地

---

## Phase 1：先把“概念 agent 系统”收敛成“状态机系统”

目标：先稳定，不先炫技。

### 做什么

1. 定义统一 `Stage` 枚举
    
2. 定义 `Transition` 表
    
3. 明确每个 stage：
    

- allowed agents
    
- required artifacts
    
- required gates
    

5. 把 `workflow_router` 输出直接映射到 stage state
    

### 产出

- `stages.yaml`
    
- `transitions.yaml`
    
- `agent_registry.yaml`
    
- `artifact_registry.yaml`
    

### 结果

agent 不再是自由漂移角色，而是状态机节点。

---

## Phase 2：把 contract 和 gate 彻底产品化

目标：让 supervisor 真能稳定消费子 agent。

### 做什么

1. 所有 agent 输出统一 schema
    
2. 所有 gate 输出统一 schema
    
3. 补一个 `execution_log` / `run_trace`
    
4. 每次 delegate 都附：
    

- stage
    
- task_goal
    
- allowed scope
    
- artifact context
    
- risk policy
    

### 结果

你就有了真正的“可审计多 agent runtime”。

---

## Phase 3：重构 agent 边界

目标：减少重叠，降低维护成本。

### 建议收敛方式

#### 控制层

- `request_router`
    
- `stage_orchestrator`
    
- `gate_evaluator`
    

#### 阶段层

- `investigation_agent`
    
- `initiative_agent`
    
- `workspace_agent`
    
- `implementation_agent`
    
- `integration_agent`
    
- `closeout_agent`
    
- `plugin_project_agent`
    

#### 工具层

保留现有 operator

#### 审核层

- `reviewer`
    

### 好处

- 名称稳定
    
- 层次清晰
    
- 容易写文档
    
- 容易替换底层模型或框架
    

---

## Phase 4：再考虑高级能力

目标：在稳定后再加复杂度。

### 可以加的

1. `reflection loop`
    

- implementer → reviewer → implementer
    

3. `parallel workers`
    

- 多 repo 并行分析
    

5. `evidence scoring`
    

- 证据质量打分
    

7. `memory partition`
    

- stage memory / task memory / reference memory 分离
    

9. `policy engine`
    

- 高风险动作统一审批
    

### 不建议现在就上的

- group chat
    
- debate
    
- fully autonomous swarm
    
- 太重的 multi-agent conversation
    

你这个场景不需要它们。

---

# 8. 我建议你最终采用的编排模式

如果只给一个最优组合，我建议是：

## 总体模式

**Router + State Machine + Orchestrator-Worker + Reviewer/Gate**

具体就是：

### 主链路

1. `request_router`
    
2. `gate_route_required`
    
3. `stage_orchestrator`
    
4. 当前 `stage_agent`
    
5. 所需 `operator_agents`
    
6. `reviewer/gate_evaluator`
    
7. 决定是否转下一 stage
    

### 局部增强

- repo 实施时加 reflection
    
- 多 repo 检索时加 parallel workers
    
- 高风险操作时强制 dry-run + confirmation
    

这是我认为最适合你业务的“最佳拆分逻辑”。

---

# 9. 如果你要一句更落地的组织原则

## 应该这样拆

### 按“决策层级”拆

- 谁判断现在在哪一步
    
- 谁决定下一步干什么
    
- 谁真正执行动作
    
- 谁负责审核放行
    

### 不要这样拆

- 一个 agent 既路由、又规划、又执行、又审核
    

---

# 10. 最后给你的明确建议

## 保留的思路

你现在这些设计里，最该保留的是：

- stage-based 拆分
    
- gate-based 控制
    
- contract-first 输出
    
- operator 风险矩阵
    
- context isolation 检查
    

## 要调整的点

最该优化的是：

- 把 agent 名称收敛成层次化体系
    
- 把 schema 继续升级成状态机
    
- 把 planner/operator/reviewer 的职责进一步拉开
    
- 尽量用 orchestrator 持有主状态，不让 specialist 接管全局
    

---

如果你愿意，我下一步可以直接继续帮你做两件更实的事，二选一：

1. **基于你现有文件，直接产出一版“最佳 agent 架构图 + 分层表 + 状态机表”**
    
2. **直接帮你写成一份可落地的设计文档（Markdown），放到你本地目录里**
    

如果你选 2，我可以直接生成一份完整文档。 (2/2)