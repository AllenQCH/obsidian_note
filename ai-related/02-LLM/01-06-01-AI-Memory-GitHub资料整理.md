---
title: "01-07-AI-Memory-GitHub资料整理"
source: "GitHub repository research"
author: "Allen"
published:
created: 2026-07-21
description: "从 GitHub 资料整理 AI Memory / Agent Memory 的概念、分层、工程实现和学习路线。"
tags: ["obsidian-note", "tech-note", "llm", "memory", "agent", "rag", "knowledge-graph"]
type: "tech-note"
status: "processed"
aliases: ["AI Memory GitHub资料", "Agent Memory资料整理", "LLM Memory资料整理"]
---

# 01-07-AI-Memory-GitHub资料整理

## 摘要

AI Memory 不是简单保存聊天记录，而是让 AI Agent 能够在多轮对话、多次任务、长期使用中保留有价值的信息，并在合适的时候重新取用。

它通常包含：

- 短期记忆：当前任务状态、最近对话、临时推理信息。
- 长期记忆：用户偏好、项目背景、稳定事实、历史决策。
- 情景记忆：某次任务发生了什么、做过哪些操作、结果如何。
- 语义记忆：从历史信息中抽取出来的事实、概念和关系。
- 程序记忆：可复用的做事流程、工具使用经验、决策规则。
- 检索机制：判断什么时候该回忆什么，常见方案包括向量检索、关键词检索、知识图谱和混合检索。

## 核心理解

### Memory 和 Context 的区别

Context 是模型当前能看到的输入内容，受上下文窗口限制；Memory 是外部系统保存的信息，可以跨会话存在。

工程上更重要的是：Memory 不是越多越好，而是要解决“写什么、怎么写、什么时候取、取出来是否可信、什么时候删除”的问题。

### AI Memory 的常见分层

| 层级                | 作用      | 常见存储                        | 典型内容               |
| ----------------- | ------- | --------------------------- | ------------------ |
| Working memory    | 当前任务工作区 | Prompt / runtime state      | 当前目标、计划、工具结果、临时约束  |
| Episodic memory   | 事件和经历   | 文档库、日志库、向量库                 | 某次对话、某次任务执行过程、失败原因 |
| Semantic memory   | 稳定知识    | 向量库、关系数据库、知识图谱              | 用户偏好、项目事实、实体关系     |
| Procedural memory | 做事方法    | Markdown、规则库、workflow、skill | 操作步骤、工具使用规则、复盘经验   |
| Meta memory       | 记忆管理策略  | 配置、评估记录                     | 什么该记、什么不该记、过期策略    |

### 为什么 Agent 需要 Memory

没有 memory 的 Agent 会有几个明显问题：

- 每次对话都像第一次见用户。
- 无法复用之前做过的项目背景调查。
- 多步骤任务中容易丢失中间状态。
- 无法从失败任务中沉淀经验。
- 无法形成个人化助手或项目级助手。

### Memory 系统的关键问题

- 写入：哪些内容值得进入长期记忆？
- 压缩：长对话如何变成简洁、可检索的事实或经验？
- 召回：什么时候检索 memory，检索多少，如何排序？
- 校验：被召回的记忆是否过期、冲突或错误？
- 更新：新事实和旧事实冲突时怎么处理？
- 删除：用户隐私、无效信息、过期偏好如何清理？
- 可解释：Agent 为什么用了这条记忆，来源是什么？

## GitHub 资料清单

### 1. Agent_Memory_Techniques

链接：[NirDiamant/Agent_Memory_Techniques](https://github.com/NirDiamant/Agent_Memory_Techniques)

定位：系统学习 AI Agent memory 的入门和进阶资料。

适合重点看：

- memory 技术分类
- 短期记忆和长期记忆的区别
- 认知架构中的 memory 设计
- 检索、路由、评估、生产化实践

学习价值：适合先用它建立完整知识地图，再回头细看具体技术。

### 2. Awesome-Agent-Memory

链接：[TeleAI-UAGI/Awesome-Agent-Memory](https://github.com/TeleAI-UAGI/Awesome-Agent-Memory)

定位：论文和系统综述型资料。

适合重点看：

- LLM Agent 长期记忆研究
- 多模态 Agent memory
- 持久召回和经验改进
- memory benchmark 和 evaluation

学习价值：适合了解学术方向和主流研究脉络。

### 3. Awesome-AI-Memory

链接：[IAAR-Shanghai/Awesome-AI-Memory](https://github.com/IAAR-Shanghai/Awesome-AI-Memory)

定位：AI Memory 相关论文、项目和文章集合。

适合重点看：

- memory-native AI system
- 长期记忆和推理结合
- RAG、知识图谱、agent memory 的交叉

学习价值：适合作为长期资料索引。

### 4. mem0

链接：[mem0ai/mem0](https://github.com/mem0ai/mem0)

定位：面向 AI Agent 的通用记忆层。

核心思想：

- 为用户、会话、Agent 维护长期记忆。
- 从对话中抽取偏好和事实。
- 在后续请求中自动召回相关 memory。

工程启发：

- memory 可以独立成一层服务，而不是写死在某个 Agent 里。
- 用户级 memory 和项目级 memory 应该分开。
- 记忆写入需要抽取、去重和更新，而不是原样保存所有对话。

### 5. agent-memory

链接：[neo4j-labs/agent-memory](https://github.com/neo4j-labs/agent-memory)

定位：用 Neo4j 图数据库实现 Agent memory。

核心思想：

- 用图结构保存实体、关系、偏好、事件和推理过程。
- 把 memory 分成短期、长期和推理相关记忆。
- 适合表达“谁和谁有什么关系”“某个项目包含哪些决策”。

工程启发：

- 如果 memory 里关系比文本更重要，知识图谱比纯向量库更合适。
- 图数据库适合做可解释召回，因为可以看到实体关系路径。

### 6. Graphiti

链接：[getzep/graphiti](https://github.com/getzep/graphiti)

定位：时间感知的知识图谱 memory。

核心思想：

- 把历史交互转成带时间属性的知识图谱。
- 支持事实随时间变化，而不是只保留一个静态结论。
- 适合处理“用户之前喜欢 A，现在改成 B”这类变化。

工程启发：

- Memory 需要时间维度。
- 不是所有旧记忆都要删除，有些需要标记生效时间和失效时间。

### 7. ReMe

链接：[agentscope-ai/ReMe](https://github.com/agentscope-ai/ReMe)

定位：本地优先、Markdown 友好的 Agent memory 方案。

核心思想：

- 用可读、可编辑的文件管理长期记忆。
- 让 memory 能被人查看、修改和组织。
- 更适合个人知识库、研究助手、开发助手。

工程启发：

- 对个人助手来说，Obsidian + Markdown 本身就可以是一种 memory backend。
- 人能直接编辑 memory，是可靠性和可控性的一部分。

### 8. Obsidian memory for AI

链接：[GitHub ai-memory-system topic](https://github.com/topics/ai-memory-system)

定位：围绕 Obsidian 和 AI memory 的项目集合。

工程启发：

- Obsidian Vault 可以作为长期知识库。
- AI 需要把对话、任务、项目背景整理成结构化笔记，而不是只保存聊天记录。
- 适合探索“个人知识库 + Agent”的工作流。

## 推荐学习路线

1. 先看 `Agent_Memory_Techniques`，建立 memory 分类和技术地图。
2. 再看 `Awesome-Agent-Memory` 和 `Awesome-AI-Memory`，补论文和研究脉络。
3. 看 `mem0`，理解产品级 memory layer 怎么抽象。
4. 看 `Graphiti` 和 `agent-memory`，理解知识图谱路线。
5. 看 `ReMe` 和 Obsidian 相关项目，思考本地 Markdown 知识库如何成为 Agent memory。

## 和 Obsidian 的结合思路

可以把 Obsidian 设计成个人 Agent memory 的长期层：

- `用户偏好.md`：保存长期稳定偏好，例如写作风格、工具偏好、学习目标。
- `项目背景.md`：保存每个项目的目标、技术栈、约束、关键决策。
- `任务日志.md`：保存每次任务做了什么、遇到什么问题、最后结果。
- `经验规则.md`：保存可复用流程，例如同步 GitHub、整理资料、写代码规范。
- `资料索引.md`：保存外部 GitHub、论文、文章链接。

关键是让 AI 不直接把所有内容塞进 memory，而是先做筛选和摘要：

- 稳定事实才进入长期记忆。
- 临时讨论只放任务日志。
- 重要经验沉淀成规则。
- 过期信息要标注状态。
- 来源链接要保留，方便追溯。

## 可执行动作

- [ ] 阅读 `Agent_Memory_Techniques` 的分类章节，整理一张 AI Memory 技术地图。
- [ ] 选一个工程实现方向：`mem0`、`Graphiti`、`Neo4j agent-memory`、`Markdown/Obsidian memory`。
- [ ] 设计自己的 Obsidian memory 分层：user、project、task、procedure、source。
- [ ] 做一个最小实验：从一次对话中抽取 5 条长期记忆，并写入 Markdown。
- [ ] 给每条 memory 增加来源、时间、置信度和过期规则。

## 相关链接

- [[01-06-00-LLM-Memory]]
- [[01-04-00-LLM-Context]]
- [[02-02-RAG-Retrieval召回与混合检索]]
- [[04-RAG-高级模式]]
- [[05-agent.md]]
