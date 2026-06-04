入口很清楚了：

config.toml

只是注册表，真正厉害的是它旁边那组文档和 agent 定义一起工作。我继续补读 4 份关键文档：多 agent 总说明、工作 流、stage gate、contract，再结合几个 agent 配置，提炼出这套体系为什么稳定。

•

Explored

└

Read

openspec-multi-agent.md

,

openspec-stage-gates.md

,

agent-workflows.md

,

openspec-agent-contracts.md



•

这套东西的关键已经很清楚了：不是只有 agent 名单，而是“注册表 + 路由文档 + gate + contract + 风险矩阵”一起工作。我再补最后两块：工具风险 矩阵，以及 2-3 个代表性 agent 的 prompt 设计，这样经验总结会更扎实。

•

Explored

└

Read

workflow-router.toml

,

tool-agent-matrix.md

,

repo-implementer.toml

,

openspec-reviewer.toml

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

•

我研究完了，这套东西好用，不是因为“agent 多”，而是因为它把

编排系统

做完整了。核心入口在

/Users/heytea/Documents/xuetao的agetns/.codex/

config.toml:1

，但真正让它稳定的是旁边这一整组规则文档和 agent 定义： -

/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-multi-agent.md:1

-

/Users/heytea/Documents/xuetao的agetns/my归档/docs/agent-workflows.md:1

-

/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-stage-gates.md:1

-

/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-agent-contracts.md:1

-

/Users/heytea/Documents/xuetao的agetns/my归档/docs/tool-agent-matrix.md:1

我对这套架构的理解

它本质上是 4 层，不只是 agent 列表：

1.

路由层 -

workflow_router

- 只判断当前 stage、最小缺口、推荐后续 agent - 明确禁止写文件和直接改代码 - 参考：

/Users/heytea/Documents/xuetao的agetns/.codex/agents/workflow-router.toml:1

2.

阶段层 -

investigation_planner

-

initiative_planner

-

plugin_project_planner

-

workspace_preparer

-

repo_implementer

-

integration_orchestrator

-

openspec_reviewer

- 这层不是按工具拆，而是按生命周期拆

3.

工具层 -

dbauto_operator

-

trace_log_operator

-

wiki_operator

-

gitlab_mr_operator

-

yapi_operator

- 这层只负责某个 CLI 或系统动作，不负责主流程决策

4.

协议/门禁层 - contract - stage gates - tool risk matrix - 这层才是它稳定的原因，不是装饰

为什么这套做得好

我总结有 6 条经验，比较值得学。

1.

toml

只做注册表，不承载全部逻辑

config.toml

只声明： - 有哪些 agent - 每个 agent 的一句职责 - 指向哪个具体

toml

这很对。 很多人喜欢把路由逻辑、协议、执行规则都塞进一个大配置里，后面非常难维护。 这套做法是： - 注册表归注册表 - 工作流归工作流文档 - contract 归 contract - gate 归 gate 职责很干净。

2.

路由层非常克制

workflow_router

不写文件、不改代码、不接管执行，只做： - 当前阶段判断 - 最小缺失输入识别 - 推荐下游 agent - 按 gate 思考是否允许继续 这点很关键。 很多系统的 router 一不小心就变成半个 planner、半个 implementer，最后层次就塌了。

3.

阶段 agent 和工具 agent 分得很清楚 文档里写得很明确： - 阶段 Agent：负责对象、阶段、gate、文档、路径边界 - 工具 Agent：负责具体 CLI 的证据获取或 dry-run 这个边界非常值钱。 因为它避免了最常见的问题： - 一个 agent 一边在想“做什么” - 一边又在执行“怎么做” - 还顺便决定“能不能过” 这样一重就失控了。

4.

Gate 不是附属物，而是主流程的一部分

/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-stage-gates.md:1

做得很好，尤其有三点： - 每个阶段都有明确 gate - gate 统一输出

go / warn / block

- gate 不只看 readiness，还看

context isolation

这比普通“review 一下”强很多。 它不是看 agent 有没有干活，而是看： - 当前上下文是不是串味了 - 路径是不是跑偏了 - 文档和证据是不是齐了 - 是否允许 override 这就让系统更像流程机，而不是聊天机器人。

5.

Contract 非常统一

/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-agent-contracts.md:1

把所有子 agent 限定成统一形状： -

agent

-

input

-

output.facts

-

output.decision

-

output.next_actions

-

output.artifacts_to_update

这件事非常重要。 因为没有统一 contract，supervisor 根本没法稳定消费子 agent 结果，只能靠读自然语言猜。

6.

工具层有风险矩阵，不只是能力矩阵

/Users/heytea/Documents/xuetao的agetns/my归档/docs/tool-agent-matrix.md:1

不只是列“谁能干什么”，还列： - sandbox - default mode - high-risk actions 这说明它不只是设计了能力，还设计了边界。 这是很多 agent 系统真正缺的东西。

我认为最值得你借鉴的 5 条

如果压缩成最实用的经验，我建议你直接拿走这 5 条：

1.

先做

router + stage + operator + gate

四层，再谈 prompt 优化 先把结构拉开，不要先改话术。

2.

config.toml

只做目录和索引 不要把所有逻辑塞到一个配置里。

3.

每个 agent 都只做一类决策 - router 只路由 - stage agent 只负责阶段对象 - operator 只负责工具动作 - reviewer/gate 只负责放行判断

4.

一定要做统一 contract 否则后面 agent 越多越乱。

5.

一定要做风险矩阵 尤其是你这种会碰： - SSO - dbauto - 发布 - 文档写回 - 外部系统操作 没有高风险动作边界，后面一定出问题。

这套体系的局限

它也不是没有代价。

1.

文档和协议比较重 前期定义成本高。

2.

适合流程明确、对象明确、审计要求高的场景 比如： - OpenSpec - 需求对象 - investigation/initiative/plugin project 不太适合纯发散创作场景。

3.

对“共享对象模型”依赖比较强 它能稳定，是因为它围绕： - investigation - initiative - plugin project 这几个对象展开。 如果你的系统没有清晰对象中心，直接照搬会显得重。

给你的结论

这套东西真正值得学的，不是“有很多 agent”，而是下面这个组合： -

toml

做注册表 - 文档定义 workflow - schema 定义 contract - gate 控制阶段推进 - risk matrix 控制工具边界 一句话总结：

它不是一个 agent 列表，而是一个可审计、可编排、可收敛的多 agent 运行系统。

如果你要往你自己的体系里迁移，我建议优先抄这 4 个点：

1.

workflow_router

2.

openspec-stage-gates

3.

openspec-agent-contracts

4.

tool-agent-matrix

这 4 个是骨架。