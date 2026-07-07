# Effective context engineering for AI agents

- 原文链接：https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- 推荐理由：理解 prompt/context 不是“多给点上下文”这么简单，而是一门工程学。
- 阅读日期：2026-07-07

## 阅读关注点
- context 组织
- attention budget
- just-in-time retrieval
- compaction / memory / sub-agents
- 长任务信息传递

## 一句话总结
这篇文章的核心是：**随着 agent 变长、变复杂，真正要工程化管理的已经不是 prompt 本身，而是整个 context state——也就是在有限 attention budget 下，如何持续给模型最小但最高信号密度的信息集合。**

## 中英对照笔记

### 1. Context engineering vs. prompt engineering
**English**
Prompt engineering focuses on writing instructions. **Context engineering** is about curating and maintaining the full set of tokens that enter model inference over time.

**中文**
prompt engineering 关注的是“怎么写提示词”。**context engineering** 关注的是：随着任务推进，如何持续整理、筛选、维护进入模型推理的整套 token 集合。

**我的理解**
- 这里的 context 不只是 system prompt。
- 它还包括：tools、MCP、external data、message history、memory、运行时检索结果等。
- 所以 context engineering 更像一门**状态管理工程学**。

### 2. Why context engineering matters
**English**
Context is a finite resource. As context grows, models experience **context rot** and attention gets diluted.

**中文**
context 是有限资源。随着上下文变长，模型会出现 **context rot**，注意力被稀释，召回与长程推理精度下降。

**我的理解**
- 文章把 context 说成一种有限的 **attention budget**，这个比“上下文窗口更大就行”要重要得多。
- 就算未来 context window 更大，context pollution 和 relevance 问题也不会自动消失。

### 3. The anatomy of effective context
**English**
Good context engineering means finding the smallest possible set of high-signal tokens that maximizes the chance of the desired outcome.

**中文**
好的 context engineering，本质上是在找：**最小的一组高信号 token**，但又能最大化你想要的结果概率。

**我的理解**
- 文章对 system prompt 的建议很重要：不要写得过于硬编码，也不要高空泛化。
- 最佳状态是“足够具体，但仍保留 heuristic 弹性”。
- 对 tools 的要求也一样：功能不要重叠太多，接口和描述必须清晰。

### 4. Context retrieval and agentic search
**English**
Anthropic increasingly favors **just-in-time** context strategies: keep lightweight references (paths, queries, links), and let agents load the needed data at runtime using tools.

**中文**
Anthropic 越来越偏向 **just-in-time** 的 context 策略：平时只保留轻量级引用（路径、查询、链接等），真正需要时再让 agent 用 tools 动态加载数据。

**我的理解**
- 这和“先把所有资料塞进上下文”是相反的思路。
- 更像人类：不背全文，而是保留索引、书签、文件系统、查询入口，按需取用。
- 文中用 Claude Code 举例，说它可以用 Bash 的 `head` / `tail` 等命令分析大数据，而不把整个对象塞进 context。

### 5. Hybrid strategy
**English**
The best agents may use a hybrid strategy: retrieve some data up front for speed, then let the model autonomously explore further when needed.

**中文**
最有效的 agent 往往会用 hybrid strategy：
- 一部分数据 upfront 放进 context，保证速度
- 另一部分由 agent 运行时自主探索

**我的理解**
- 文中直接提到 Claude Code 就是这种混合模式：
  - `CLAUDE.md` upfront 进 context
  - 其他内容通过 glob / grep 等方式按需探索
- 这和你现在做个人 agent 体系的思路非常贴：规范文件 upfront，具体材料运行时探索。

### 6. Long-horizon tasks
**English**
For long-horizon tasks, Anthropic highlights three techniques:
- **Compaction**
- **Structured note-taking / memory**
- **Sub-agent architectures**

**中文**
对长时间跨度任务，Anthropic 强调三种关键技术：
- **Compaction**
- **Structured note-taking / memory**
- **Sub-agent architectures**

#### Compaction
**English**
Summarize a nearly full context window and restart with the compressed summary.

**中文**
当上下文快满时，先高保真压缩总结，再带着 summary 重开新窗口。

**我的理解**
- compaction 的关键不是“缩短”，而是**高保真保留关键决策、bug、依赖和未解决问题**。
- 文章还提到一种轻量方式：直接清理历史 tool result。

#### Structured note-taking
**English**
Persist notes outside the context window and pull them back later when needed.

**中文**
把关键进展写进 context window 外部的 memory / note 文件，后面再按需回读。

**我的理解**
- 这和你在 Hermes / Obsidian / personal workflow 里做的很多事情天然一致。
- 文中甚至提到像 `NOTES.md`、to-do list、memory tool 这种简单机制，价值就已经非常大。

#### Sub-agent architectures
**English**
Specialized sub-agents can do deep work in clean context windows, then return condensed summaries to the main agent.

**中文**
专门化的 sub-agents 可以在干净 context 里完成深度探索，再把压缩后的结果交回主 agent。

**我的理解**
- 这是在 context 受限时做能力扩展的另一条路。
- 本质上是：把“细节上下文”隔离在 sub-agent 内部，让主 agent 保持聚焦。

### 7. Conclusion
**English**
The guiding principle remains the same: find the smallest set of high-signal tokens that maximize the likelihood of the desired outcome.

**中文**
总原则始终没变：找到最小但高信号密度最高的 token 集合，最大化你想要的结果。

**我的理解**
- 这篇文章最适合当你以后设计 agent memory、handoff、context trimming、文件探索策略时的理论底座。

## 最重要的 3 个观点
1. **context engineering 管的不是 prompt，而是整套上下文状态。**
2. **context 是有限 attention budget，越多不一定越好。**
3. **长任务的核心手段是 compaction、memory 和 sub-agent，而不是一味等更长 context window。**

## 可以迁移到我自己工作流/产品里的点
- 把规范、目录、提示拆成“upfront context”和“runtime retrieval”两层。
- 给长任务默认加上 compaction / summary / handoff 机制。
- 用外部 memory / NOTES 文件承接长期状态，而不是让主上下文无限膨胀。
- 对多 agent 场景，优先让 sub-agent 返回压缩产物，而不是把所有细节都灌回主线程。

## 仍然没想明白的问题
- 哪些内容最适合 upfront 放进 context，哪些更适合 just-in-time？
- compaction 的最佳粒度怎么定，才不会既丢关键信息又让 summary 变噪音？
- 在 coding task 里，sub-agent 的 context 隔离和主 agent 的全局一致性怎么平衡？

## 想继续延伸阅读的关键词
- context engineering
- attention budget
- context rot
- just-in-time retrieval
- compaction
- structured note-taking
- sub-agent architectures

## 相关链接
- [[Anthropic 学习总览]]
- [[01-Engineering/_index|01-Engineering]]
- [[01-Building-effective-agents]]
- [[04-How-we-built-our-multi-agent-research-system]]
- [[Hermes agent总览]]
- [[my-multi-agents总览]]
