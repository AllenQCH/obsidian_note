# Building effective agents

- 原文链接：https://www.anthropic.com/engineering/building-effective-agents
- 推荐理由：Anthropic 关于 agent 设计的代表作，适合作为整套学习的起点。
- 阅读日期：2026-07-07

## 阅读关注点
- agent 设计模式
- workflow vs agent
- augmented LLM
- 什么时候该加复杂度
- tool/interface 设计

## 一句话总结
这篇文章的核心不是“怎么堆框架做一个更复杂的 agent”，而是：**先用最简单、最可组合的模式解决问题，只有当单次调用或固定 workflow 明显不够时，才逐步升级到更自治的 agent。**

## 中英对照笔记

### 1. What are agents?
**English**
Anthropic distinguishes between **workflows** and **agents**. Workflows are predefined code paths orchestrating LLMs and tools. Agents dynamically direct their own processes and tool usage.

**中文**
Anthropic 把 agentic systems 分成两类：
- **workflows**：LLM 和 tools 走预定义代码路径
- **agents**：LLM 动态决定过程与工具使用方式

**我的理解**
- 这篇文章最重要的切分，不是“有没有 tool use”，而是**决策权在代码里还是在模型里**。
- 这能直接帮助判断：当前需求应该做固定流程，还是应该放权给 agent。

### 2. When (and when not) to use agents
**English**
Start with the simplest solution possible. Agentic systems trade cost and latency for better task performance. Often, a single optimized LLM call with retrieval and in-context examples is enough.

**中文**
先找**最简单可行**的方案。agentic systems 往往用更高的 cost 和 latency 换更好的任务表现。很多场景下，优化单次 LLM 调用、加 retrieval 和 in-context examples 就够了。

**我的理解**
- 不要先入为主觉得“agent 一定比 workflow 高级”。
- Anthropic 的态度很克制：**只有简单方案明显不够时，才加复杂度。**

### 3. When and how to use frameworks
**English**
Frameworks can speed up development, but they also add abstraction and can make systems harder to debug. Anthropic recommends starting from direct API usage and understanding what happens underneath any framework.

**中文**
框架能加速起步，但也会增加抽象层，导致更难 debug。Anthropic 建议先直接用 API 起步，如果用了框架，也要理解底层到底发生了什么。

**我的理解**
- 这和你现在关心“规范应该写在哪里、如何生效”很相关。
- 抽象层越厚，越容易把 prompt、tool contract、实际路由逻辑藏起来。

### 4. Building block: The augmented LLM
**English**
The foundational building block is the **augmented LLM**: an LLM plus retrieval, tools, and memory.

**中文**
最基础的 building block 是 **augmented LLM**：也就是带有 retrieval、tools、memory 的 LLM。

**我的理解**
- 后面的所有复杂模式，本质上都是在编排 augmented LLM。
- 文章还提到 MCP 作为接入第三方 tools 的一种方式，这说明 tool ecosystem 本身也被视为核心基建。

### 5. Workflow patterns
**English**
The article introduces several recurring workflow patterns:
- **Prompt chaining**
- **Routing**
- **Parallelization**
- **Orchestrator-workers**
- **Evaluator-optimizer**

**中文**
文章总结了几种高频可复用模式：
- **Prompt chaining**：串联多个步骤
- **Routing**：先分类，再走专门链路
- **Parallelization**：并行拆分或投票
- **Orchestrator-workers**：中心协调者动态拆任务给 worker
- **Evaluator-optimizer**：一个生成，一个评估，循环迭代

**我的理解**
- 这篇文章的价值很大一部分在于：它把“agent 设计”拆成了几种**可命名、可复用、可组合的模式**。
- 对你来说，最重要的是把这些模式从“概念”变成“什么时候用哪一种”的判断规则。

### 6. Agents
**English**
Agents are best for open-ended problems where the required number of steps cannot be predicted and a fixed path cannot be hardcoded. They must operate with environmental feedback in a loop and need clear stopping conditions and guardrails.

**中文**
Agents 最适合处理**开放式问题**：你无法提前预测需要多少步，也没法把固定路径硬编码进去。它们要在环境反馈中循环运行，同时需要明确的 stopping conditions 和 guardrails。

**我的理解**
- 文章强调：agent 不是神秘系统，通常就是“LLM + tools + loop + environment feedback”。
- 真正难的是：
  - toolset 怎么设计
  - stopping condition 怎么设
  - guardrail 怎么落

### 7. Summary principles
**English**
Anthropic ends with three principles:
- Maintain simplicity
- Prioritize transparency
- Carefully craft the agent-computer interface (ACI)

**中文**
Anthropic 最后给了三条总原则：
- 保持简洁
- 强调透明性
- 认真设计 **agent-computer interface (ACI)**

**我的理解**
- ACI 这个说法很值得记：它对应的其实就是你很在意的 tool contract、命令边界、文件接口、执行权限和可观测性。

## 最重要的 3 个观点
1. **先用简单模式，只有在必要时才升级复杂度。**
2. **workflow 和 agent 的关键区别是“决策权在代码里还是在模型里”。**
3. **成功的 agent 系统靠的是模式组合与清晰 ACI，而不是框架堆叠。**

## 可以迁移到我自己工作流/产品里的点
- 把自己的多 agent 设计先归类到固定模式：routing / orchestrator-workers / evaluator-optimizer 等。
- 为每类任务先判断：单次调用、workflow、还是 agent，避免默认走最复杂方案。
- 把 tool contract 和 operator 边界当成 ACI 来设计，而不只是“把命令接进去”。
- 在规范里显式写清 stopping conditions、handoff 方式和 escalation 条件。

## 仍然没想明白的问题
- 在实际 coding agent 中，orchestrator-workers 与 evaluator-optimizer 的边界怎么划最省？
- 当一个任务同时具备 routing 和 orchestrator 特征时，最稳定的组合是什么？
- Anthropic 在真实产品里如何决定“从 workflow 升级到 agent”的阈值？

## 想继续延伸阅读的关键词
- augmented LLM
- workflow vs agent
- orchestrator-workers
- evaluator-optimizer
- agent-computer interface
- tool contract

## 相关链接
- [[Anthropic 学习总览]]
- [[01-Engineering/_index|01-Engineering]]
- [[02-Effective-context-engineering-for-ai-agents]]
- [[03-The-think-tool]]
- [[04-How-we-built-our-multi-agent-research-system]]
- [[my-multi-agents总览]]
