# The "think" tool: Enabling Claude to stop and think in complex tool use situations

- 原文链接：https://www.anthropic.com/engineering/claude-think-tool
- 推荐理由：理解为何让模型显式停下来思考，常常比盲目增加工具数量更重要。
- 阅读日期：2026-07-07

## 阅读关注点
- tool use
- think tool vs extended thinking
- policy-heavy environments
- sequential decision making
- 可靠性提升

## 一句话总结
这篇文章的核心是：**在长链 tool use 和高约束环境里，给模型一个明确的“停下来整理规则与信息”的 scratchpad，往往能显著提升一致性、合规性和多步决策质量；但它不是通用银弹。**

## 中英对照笔记

### 1. Extended thinking update
**English**
Anthropic adds an update first: in most cases, they now recommend using **extended thinking** instead of a dedicated **think tool**, because it integrates better and performs better overall.

**中文**
文章一开头先更新了立场：大多数情况下，他们现在更推荐用 **extended thinking**，而不是单独的 **think tool**，因为整体集成和表现更好。

**我的理解**
- 这很关键：这篇文章不是在说“think tool 永远最好”，而是在解释**为什么这种模式有效、以及它适合哪些场景**。

### 2. What is the "think" tool?
**English**
The **think tool** gives Claude a dedicated extra step during response generation to stop and think, especially after seeing tool outputs.

**中文**
**think tool** 的作用，是让 Claude 在生成响应过程中多一个明确的“停下来想一想”的步骤，尤其适合在读取了 tool output 之后再做判断。

**我的理解**
- 它和 **extended thinking** 的区别在于：
  - extended thinking 更偏行动前整体思考
  - think tool 更偏**执行中、读完外部信息后、做下一步前**的局部推理/复核

### 3. When it helps most
**English**
Anthropic says the think tool is most useful for:
- tool output analysis
- policy-heavy environments
- sequential decision making

**中文**
Anthropic 认为 think tool 最适合三类场景：
- **tool output analysis**
- **policy-heavy environments**
- **sequential decision making**

**我的理解**
- 这三个场景有一个共同点：**错误往往不是不会做，而是太快往下走、没停下来检查。**
- think tool 的价值，本质上是给 agent 一个显式的“复盘/核对节点”。

### 4. Performance on τ-Bench
**English**
On τ-Bench, the think tool significantly improved Claude 3.7 Sonnet in complex customer-service domains, especially when paired with an optimized prompt.

**中文**
在 **τ-Bench** 上，think tool 对 Claude 3.7 Sonnet 在复杂客服场景里有明显提升，尤其是和优化过的 prompt 搭配时。

**文中关键信号**
- airline domain 中，think tool + optimized prompt 相比 baseline 有明显提升
- retail domain 中，即使没有额外 prompt，单有 think tool 也能带来增益
- 文章强调：难领域更依赖“怎么教它思考”，简单领域可能只给 think 空间就够了

**我的理解**
- 单有工具不够，**prompting the use of the tool** 也很关键。
- 尤其在 rule-heavy / policy-heavy 场景里，think tool 最好配合明确示例。

### 5. Performance on SWE-Bench
**English**
A similar think tool was also added to their SWE-Bench setup and contributed to performance gains.

**中文**
他们在 **SWE-Bench** 场景里也加入了类似 think tool，并观察到性能提升。

**我的理解**
- coding 场景里的 think，不只是“想答案”，更像：
  - 看完 repo / test result 之后
  - brainstorm 多个修复思路
  - 评估哪种最简单、最有效
- 这和你做 coding / multi-agent orchestration 时非常相关。

### 6. Implementation best practices
**English**
Anthropic recommends:
- strategic prompting with domain-specific examples
- placing complex think guidance in the system prompt

**中文**
Anthropic 建议：
- 用 **domain-specific examples** 教它怎么用 think
- 如果 think 的指导很复杂，把它放在 **system prompt** 里，而不是只写在 tool description 中

**我的理解**
- tool description 只说“你可以想”，是不够的。
- 真正有效的是告诉它：
  - 什么时候必须 think
  - think 时应该列什么检查项
  - 如何把复杂规则拆成决策步骤

### 7. When not to use the think tool
**English**
The think tool is not useful for:
- non-sequential tool calls
- simple instruction following

**中文**
think tool 不适合：
- **non-sequential tool calls**
- **simple instruction following**

**我的理解**
- 这篇文章很克制：不是让所有 agent 都加 think。
- 如果任务本来就简单，think 反而会增加 prompt 长度和 token 成本。

## 最重要的 3 个观点
1. **think tool 的真正价值，是给 agent 一个显式 scratchpad 来复核规则、信息和下一步。**
2. **think tool + 好 prompt，比“单纯给它一个 think 能力”更重要。**
3. **think 适合长链、顺序决策、规则复杂的任务，不适合所有 tool use。**

## 可以迁移到我自己工作流/产品里的点
- 给 agent/operator 明确设计“停顿点”，尤其在读完 tool output 之后。
- 在 system prompt 中显式写出 think checklist，而不是只写“请仔细思考”。
- 对 policy-heavy 或高风险任务，把 think 作为强制步骤，而不是 optional。
- 对简单任务不要滥加 think，避免 token 浪费和流程变慢。

## 仍然没想明白的问题
- 在真实多 agent 系统里，think 应该以内置推理、tool、还是 checkpoint 形式存在？
- think 的内容是否应该持久化，还是只做即时 scratchpad？
- 对 coding / operator 场景，哪些节点最值得强制 think？

## 想继续延伸阅读的关键词
- think tool
- extended thinking
- scratchpad reasoning
- τ-Bench
- policy-heavy environments
- sequential decision making

## 相关链接
- [[Anthropic 学习总览]]
- [[01-Engineering/_index|01-Engineering]]
- [[01-Building-effective-agents]]
- [[02-Effective-context-engineering-for-ai-agents]]
- [[04-How-we-built-our-multi-agent-research-system]]
- [[my-multi-agents总览]]
