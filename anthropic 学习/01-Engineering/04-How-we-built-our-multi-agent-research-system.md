# How we built our multi-agent research system

- 原文链接：https://www.anthropic.com/engineering/multi-agent-research-system
- 推荐理由：多 agent 编排的经典案例，特别适合你这种关注 agent 能力连续性、任务分工、工具边界和生产可用性的人。
- 阅读日期：2026-07-08

## 阅读关注点
- multi-agent 架构
- orchestrator-worker pattern
- delegation / task boundaries
- prompt engineering
- tool design
- evaluation
- production reliability

## 一句话总结
Anthropic 这篇文章的核心不是“multi-agent 很强”，而是：**multi-agent 真正能进 production，靠的是 orchestrator-worker 架构、清晰 delegation、强 tool design、严肃 eval、可观测性与 reliability engineering。**

## 中英对照笔记

### 1. Benefits of a multi-agent system
**English**
Research is open-ended and path-dependent. A fixed pipeline cannot handle complex topics well. Subagents explore different directions in parallel with separate context windows, then compress findings for the lead agent.

**中文**
研究任务是 **open-ended**、**path-dependent** 的，固定流水线很难覆盖复杂主题。**Subagents** 的价值在于：带着各自独立的 **context window** 并行探索不同方向，再把结果压缩后交给 **lead agent**。

**我的理解**
- 搜索的本质是 **compression**。
- multi-agent 的核心收益不是“更像人类团队”这种抽象比喻，而是**把更多 token 和更多并行探索花在真正复杂的问题上**。
- 这类架构尤其适合 **breadth-first queries**，不太适合强依赖共享上下文、强串行依赖的任务。

### 2. Architecture overview for Research
**English**
Their Research system uses an **orchestrator-worker pattern**. A **lead agent** analyzes the query, writes the plan to **Memory**, spawns parallel **subagents**, and later hands results to a **CitationAgent** for citations.

**中文**
他们的 Research 系统采用 **orchestrator-worker pattern**。一个 **lead agent** 先分析问题，把计划写入 **Memory**，并行创建多个 **subagents**，最后再交给 **CitationAgent** 补 citation。

**我的理解**
- 这里最关键的不是“多开几个 agent”，而是**明确的职责拆分**。
- `lead agent` 负责：规划、调度、判断是否继续研究、最终汇总。
- `subagents` 负责：独立搜索、分析、压缩返回。
- `CitationAgent` 负责：把 claim 和 source 严格对齐，保证 groundedness。
- 文章还提到把 plan 存进 **Memory**，是因为 context 超长后会被截断，plan 不能丢。

### 3. Prompt engineering and evaluations for research agents
**English**
Early agents often spawned too many subagents, searched forever, used bad queries, or selected the wrong tools. Anthropic says **prompt engineering** was their primary lever.

**中文**
早期 agent 容易失控：
- 简单问题也开很多 subagents
- 为不存在的信息无限搜索
- search query 又长又差
- tool 选错

Anthropic 说，他们最主要的改进抓手是 **prompt engineering**。

**文中最关键的几条 prompting 原则**
1. **Think like your agents**
   - 先观察 agent 逐步怎么做，再改 prompt。
   - 他们会搭模拟环境，用真实 prompt 和真实 tools 看 failure mode。
2. **Teach the orchestrator how to delegate**
   - 给 subagent 的任务描述里，要写清：
     - objective
     - output format
     - tools / sources
     - task boundaries
   - 不然就会重复劳动、漏信息、误分工。
3. **Scale effort to query complexity**
   - 复杂问题才配更多 subagents 和更多 tool calls。
   - 简单问题不要过度投资。
4. **Tool design and selection are critical**
   - **agent-tool interface** 和工具描述非常重要。
   - tool description 写不好，agent 会一路跑偏。
5. **Let agents improve themselves**
   - Claude 4 可以反过来参与 prompt engineering 和 tool description rewrite。
6. **Start wide, then narrow down**
   - 先广搜，再逐步缩窄，而不是一开始就写超长 query。
7. **Guide the thinking process**
   - 他们明确使用 **extended thinking** 和 **interleaved thinking**。
8. **Parallel tool calling transforms speed and performance**
   - 并行有两层：
     - lead agent 并行拉起多个 subagents
     - subagent 内部并行调用多个 tools
   - 文中说这能让复杂研究任务耗时最多下降 **90%**。

### 4. Effective evaluation of agents
**English**
Multi-agent systems are hard to evaluate because different runs may take different valid paths. Anthropic recommends small-sample evals, **LLM-as-judge**, and human evaluation.

**中文**
multi-agent 很难评估，因为不同运行可能走出**不同但同样合理**的路径。Anthropic 推荐：
- 先从小样本 eval 开始
- 用 **LLM-as-judge**
- 保留 human evaluation

**我的理解**
- 不能只问“它有没有按我预设的步骤做”。
- 更应该问：
  - factual accuracy 对不对
  - citation accuracy 对不对
  - completeness 够不够
  - source quality 好不好
  - tool efficiency 合不合理
- 文中强调：即使有自动 eval，人工测试依然能发现 source bias、奇怪 edge case 和不合理行为。

### 5. Production reliability and engineering challenges
**English**
Agents are stateful, long-running, and non-deterministic. Small failures can cascade badly. Anthropic emphasizes durable execution, resume, tracing, observability, careful deployment, and future asynchronous execution.

**中文**
agent 系统是 **stateful**、**long-running**、**non-deterministic** 的。小故障会被放大。Anthropic 特别强调：
- durable execution
- resume from failure
- tracing
- observability
- rainbow deployments
- future asynchronous execution

**我的理解**
- 这是全文最有工程价值的一段。
- 普通软件的小 bug，在 agent 系统里可能直接把整条执行链带偏。
- 所以不能只会“跑起来”，还得会：
  - 存状态
  - 做 checkpoint
  - 出错恢复
  - 观察 decision pattern
  - 平滑部署新旧版本
- 他们现在的瓶颈之一是 **synchronous execution**：lead agent 要等 subagents 返回后再继续。未来 **asynchronous execution** 会更强，但会引入结果协调、状态一致性、错误传播的新复杂度。

### 6. Appendix
**English**
The appendix suggests end-state evaluation, long-horizon conversation management with memory/summaries, and letting subagents write outputs to a filesystem or external artifact store.

**中文**
附录里有几个很实用的建议：
- 对会改状态的 agent，优先做 **end-state evaluation**
- 超长对话靠 **summary + memory + handoff** 管理
- 让 subagent 直接把产物写到 **filesystem** 或外部 artifact store，减少“传话游戏（game of telephone）”造成的信息失真

## 最重要的 3 个观点
1. **multi-agent 的核心不是“多”，而是清晰分工。**
   - 真正有效的是 `lead agent / subagent / citation agent` 这类职责拆分，而不是盲目增 agent 数量。
2. **prompt engineering + tool design 是控制 multi-agent 行为的主杠杆。**
   - 尤其是 delegation、tool description、query strategy、effort budgeting。
3. **prototype 到 production 的难点不在 demo，而在 reliability。**
   - statefulness、resume、tracing、deployment、evaluation 才是最后真正卡人的地方。

## 可以迁移到我自己工作流/产品里的点
- 给 orchestrator / stage agent 的任务拆解模板补齐 4 个固定字段：
  - objective
  - output format
  - tools / sources
  - task boundaries
- 单独把 `tool description` 当成可优化对象，而不是把 tool 只当函数调用。
- 为复杂任务建立 effort scaling heuristics：
  - 简单任务少 agent、少 tool calls
  - 复杂任务才并行扩容
- 对长任务补 `checkpoint / resume / tracing` 思路，而不是只关注 prompt。
- 对结果汇总链路增加“最终引用/证据对齐”的独立步骤，避免总结越来越失真。
- 对多 agent 结果，优先考虑 artifact / filesystem 交付，而不是所有内容都通过主 agent 转述。

## 仍然没想明白的问题
- Anthropic 在 production 中到底如何定义 subagent 的 budget 上限、超时和回收策略？
- 如果切到真正 asynchronous multi-agent，状态一致性和错误传播是怎么控的？
- CitationAgent 和主研究 agent 之间的接口具体长什么样？
- 在 coding 任务里，哪些部分真的值得 multi-agent 化，哪些又会因为共享上下文需求太高而不划算？

## 想继续延伸阅读的关键词
- orchestrator-worker pattern
- delegation heuristics
- tool ergonomics
- LLM-as-judge
- end-state evaluation
- long-horizon conversation management
- asynchronous multi-agent execution
- artifact-based agent handoff

## 相关链接
- [[Anthropic 学习总览]]
- [[01-Engineering/_index|01-Engineering]]
- [[01-Building-effective-agents]]
- [[02-Effective-context-engineering-for-ai-agents]]
- [[03-The-think-tool]]
- [[Hermes agent总览]]
- [[my-multi-agents总览]]
