---
title: "Agent 编排平台对比：n8n、Coze、百炼、Dify"
source: "official docs: n8n, Coze Studio, 阿里云百炼, Dify; researched 2026-05-12"
author: "Allen"
published:
created: 2026-05-12
description: "对 n8n、Coze、阿里云百炼、Dify 四类 Agent 编排平台的定位、编排模型、知识库、工具插件、发布调用和适用场景做结构化整理。"
tags: ["ai-infra", "agent", "workflow", "orchestration", "rag", "tool-calling"]
type: "tech-note"
status: "processed"
---

# Agent 编排平台对比：n8n、Coze、百炼、Dify

## 摘要

这四个平台都可以做 Agent / AI Workflow 编排，但它们的出发点不同：

| 平台 | 核心定位 | 编排主线 | 更适合 |
| --- | --- | --- | --- |
| n8n | 自动化工作流 + AI 节点 | 传统 workflow 节点中嵌入 LangChain Agent / Chain / Tool | 连接大量 SaaS、API、内部系统，把 AI 当作自动化流程的一环 |
| Coze | Agent / AI App 可视化开发平台 | Agent、App、Workflow 三类项目资源，工作流可被 Agent 调用 | 快速做面向用户的智能体、助手、插件化 Bot、对话式应用 |
| 阿里云百炼 | 云厂商 AI 应用构建平台 | Agent、Workflow、高代码应用三种模式 | 国内企业云上应用、通义模型、知识库、插件、MCP、API 集成 |
| Dify | LLM App / Agent / Workflow 开发平台 | Chatflow / Workflow 画布 + Agent 节点 + Tool / Knowledge / Plugin | 自托管或团队级 LLM 应用，重视 RAG、工具、API 化和可观测调试 |

一句话区分：

- n8n：先是自动化平台，再增强 AI Agent。
- Coze：先是 Agent / Bot 平台，再提供 Workflow 和插件。
- 百炼：先是云上大模型服务平台，再提供应用构建与企业集成。
- Dify：先是 LLM 应用开发平台，再把 Agent、Workflow、Knowledge、Tool 统一成 App Runtime。

## 核心内容

### 1. n8n

#### 平台定位

n8n 本质是 workflow automation 平台。它的 AI 能力建立在 LangChain JS 集成之上，用“Cluster nodes”表达 LLM、Agent、Memory、Tool、Retriever、Vector Store 等概念。传统 n8n 节点依然是主干，AI 节点是可插拔的能力。

#### Agent 编排模型

n8n 的 AI Agent 适合放在工作流中作为一个智能决策节点：

```text
Chat Trigger / Webhook / Cron
→ 普通 n8n 节点
→ AI Agent / Chain
→ Tool / API / SaaS 节点
→ 后续自动化动作
```

关键知识点：

- Agent 可以访问工具集合，并根据用户输入决定使用哪些工具。
- Tools Agent 实现 LangChain tool calling 接口，工具 schema 会交给模型判断。
- `System Message` 用于约束 Agent 决策。
- `Max Iterations` 用于限制模型循环次数，避免无限推理或成本失控。
- Chat Trigger 每条消息都会触发一次 workflow execution，适合按执行次数估算成本。

#### Memory / RAG

n8n 的 Memory 分两类：

- 对话 memory：Simple Memory、Redis Chat Memory、Postgres Chat Memory、Zep、Xata 等。
- 向量检索：Simple Vector Store、PGVector、Pinecone、Qdrant、Supabase、Zep 等。

需要注意：

- Simple Memory 适合快速开始；生产场景更常用 Redis / Postgres / Zep 等外部 memory。
- Simple Vector Store 是开发用途更强的内存向量库，n8n 文档提示其数据不持久，且 memory key 是实例级全局的，不应放敏感内容。
- Vector Store 可以直接作为 AI Agent 的 tool，也可以通过 Retriever / QA Tool 间接接入。

#### 工具与集成

n8n 的优势是工具生态广。AI Agent 可以通过：

- HTTP Request
- Code node
- Call n8n Workflow
- 大量内置 SaaS 节点
- 社区节点

把模型接到外部系统。因此 n8n 更像“自动化编排器 + AI 决策节点”，而不是纯 Agent Runtime。

#### 观测与评测

n8n 提供 workflow execution 视图，也提供 AI evaluations。评测的思路是用测试数据集跑 workflow，用多样输入覆盖边界情况，并比较模型或 prompt 变更前后的表现。

#### 适用判断

适合：

- 业务系统自动化、通知、审批、数据同步。
- 让 Agent 调用很多 SaaS / API。
- 用 AI 决策补强已有流程。

不优先适合：

- 高度复杂的多 Agent 状态机。
- 对长期记忆、跨 workflow agent state、细粒度 agent trace 要求很高的系统。

### 2. Coze

#### 平台定位

Coze / Coze Studio 是字节系 AI Agent 开发平台。Coze Studio 开源版定位为一站式 AI Agent 开发工具，官方文档强调 prompt、RAG、plugin、workflow 是核心能力。

Coze 的核心对象更偏“面向用户的 Agent / App”：

```text
Agent
App
Workflow
Plugin
Knowledge Base
Database
Prompt
API / SDK
```

#### Agent 编排模型

Coze 中 Agent 是对话式 AI 项目，可以在对话中由 LLM 自动调用插件或 workflow 来执行业务流程并生成回复。

Workflow 用于处理复杂逻辑和高稳定性任务，典型节点包括：

- LLM 节点
- 自定义代码节点
- 条件逻辑节点
- 插件节点
- 数据库 / 变量相关节点

从 Coze Studio 的开发文档看，Workflow 底层是基于 Eino 的 DAG，包含 control flow 和 data flow。节点是 workflow 的基本执行单元，至少包含 start 和 end。

#### 知识库 / RAG

Coze 把知识库作为 Agent / App / Workflow 的可配置资源之一。适合把知识库、插件、workflow 作为 Agent 的能力组件，而不是只做一个裸 RAG 问答。

#### 插件与工具

Coze Studio 插件分为：

- 官方内置插件
- 自定义插件
- 商业版插件

插件可以加到 Agent，也可以在 Workflow 的插件节点中使用。官方 Wiki 提到部分插件需要配置 OAuth / PAT / 第三方凭据，部署开源版时需要额外配置，不能默认假设所有插件开箱可用。

#### 发布与调用

Coze Studio 支持 API 和 Chat SDK。调用特点：

- 需要 Personal Access Token。
- Chat API 支持 conversation，上下文可以随 conversation 传递。
- `user_id` 用于区分用户，不同用户的上下文、数据库和 memory 数据隔离。
- Workflow API 要求 workflow 已发布。
- Workflow 支持普通调用和流式调用；部分场景需要关联 agent。

#### 适用判断

适合：

- 快速做 Bot / Agent / AI App。
- 业务人员或产品同学参与搭建。
- 需要插件、知识库、workflow 一起包装成面向用户的智能体。

需要注意：

- 开源版与商业版插件、能力可能存在差异。
- 部署到公网要评估安全风险，尤其是注册、Python 执行环境、SSRF、权限隔离等。
- Workflow API 有发布状态、请求大小、超时等限制。

### 3. 阿里云百炼

#### 平台定位

阿里云百炼是云厂商的大模型服务平台，应用构建模式主要包括：

- 智能体（Agent）应用
- 工作流（Workflow）应用
- 高代码应用

官方文档的选型逻辑很清楚：

- Agent：提示词驱动，自主理解意图、制定决策，并调用知识库、MCP 服务等工具。
- Workflow：可视化节点编排，把复杂任务串成稳定、可控、可复现的链路。
- 高代码：面向专业开发者，用 Python 构建和部署 AI 后端服务。

#### Agent 编排模型

百炼 Agent 更偏“云上托管的自主决策应用”：

```text
用户输入
→ 模型理解意图
→ 规划任务
→ 调用知识库 / 插件 / MCP 服务
→ 汇总结果
→ 生成回复
```

适合开放式对话，例如客服、知识问答、任务助理、旅行规划。

#### Workflow 编排模型

Workflow 更偏“确定性流程”：

```text
输入
→ 节点 A
→ 条件判断
→ 节点 B / C
→ 输出
```

适合报告生成、订单处理、多步骤审批、数据标注等固定流程自动化。

#### 知识库 / RAG

百炼知识库能力比较企业化：

- 支持文档、表格、图片等知识类型。
- 支持多轮对话改写，把上下文相关问题改写成独立查询。
- 支持向量模型、排序模型、相似度阈值、最大召回数量。
- 支持“必定调用”和“智能调用”两种知识库调用方式。
- 支持知识库过滤和对话摘要总结。

注意点：

- 召回内容会占用模型上下文窗口，需要控制切片长度和召回数量。
- 最大召回数量提升可能提高答案覆盖率，但会增加输入 token 成本。
- 知识库创建后数据源不可更改，单个知识库不支持同时使用多个数据源。

#### 插件与工具

百炼插件是工具集合，插件下可包含多个 API。类型包括：

- 官方插件
- 三方插件
- 自定义插件

官方插件例子包括 Python 代码解释器、计算器、图片生成、夸克搜索、二维码生成、GitHub 搜索等。

插件调用机制要分清：

- 在 Agent / Assistant API 中，模型根据用户输入、工具名和工具描述判断是否调用。
- 在 Workflow 中，插件作为工作流节点按预设流程执行，不是由模型自主规划。

#### 适用判断

适合：

- 国内云上部署和企业级管控。
- 与通义模型、阿里云知识库、插件、MCP、API 生态结合。
- 需要可视化工作流，也需要高代码补充的团队。

需要注意：

- 控制台功能、国际版访问、API 调用可能存在区域与账号限制。
- 插件兼容性、知识库规格、计费和调用限制应以控制台实际配置为准。

### 4. Dify

#### 平台定位

Dify 是 LLM 应用开发平台，核心是把模型、知识库、工具、插件、workflow/chatflow、Agent 统一到应用画布与运行时中。

它的抽象更接近：

```text
App
→ Workflow / Chatflow
→ Node
→ LLM / Agent / Tool / Knowledge / Code / Condition
→ API / Web App / MCP Server / Tool
```

#### Agent 编排模型

Dify 的 Agent node 让 LLM 自主控制工具，按任务需要迭代决定调用哪些工具。

关键点：

- 支持 Function Calling 和 ReAct 两类策略。
- Function Calling 适合原生工具调用能力强的模型。
- ReAct 用 Thought → Action → Observation 结构显式推理。
- Agent node 可以配置模型、工具、指令、上下文、最大迭代次数、memory 窗口。
- 输出包含 final answer、tool outputs、reasoning trace、iteration count、success status、agent logs。

#### Workflow / Chatflow 编排

Dify Workflow / Chatflow 支持：

- 串行执行
- 并行执行
- 节点复用
- Iteration / Loop
- Jinja2 变量引用
- User Input 自定义输入字段
- 文件输入与后续 Doc Extractor / Vision / Code node 处理

单一路径默认有节点数量限制，自托管可通过环境变量调整。

#### Knowledge / RAG

Dify Knowledge 是可集成到应用的自有数据集合，典型 RAG 流程是：

```text
用户问题
→ 检索知识库
→ 将相关内容作为增强上下文
→ LLM 生成回答
```

知识库创建过程包括：

- 上传本地文件、同步 Notion、网页或创建空知识库。
- 配置 chunk。
- 指定索引方法和检索设置。
- 等待处理完成。

应用层还能配置 retrieval setting，并可启用 citation / attribution。

#### 工具与插件

Dify tools 使 LLM 能访问实时数据和执行动作。工具类型包括：

- Plugin Tool
- Custom Tool
- Workflow Tool
- MCP Tool

重要特性：

- Custom Tool 可通过 OpenAPI / Swagger 导入。
- Workflow Tool 可把 workflow 封装成可复用工具。
- MCP Tool 可把 MCP server 暴露的资源导入为工具。
- Plugin 是 workspace 级组件，安装后可被 workspace 内应用复用。

#### 发布与调用

Dify 应用可作为：

- Web App
- Backend API
- MCP Server
- 其他 Dify 应用中的 tool

这使 Dify 比较适合作为团队内部 LLM App Runtime。

#### 适用判断

适合：

- 构建内部 LLM 应用、客服、知识库问答、复杂 chatflow。
- 需要 RAG、工具、插件、API 化、可视化调试。
- 需要自托管、团队协作、插件化模型供应商。

需要注意：

- Agent 的可靠性取决于工具描述、策略选择、迭代限制和模型 function calling 能力。
- Workflow 的可控性强于 Agent，但灵活性弱于 Agent 自主规划。

## 横向对比

### 编排哲学

| 维度 | n8n | Coze | 阿里云百炼 | Dify |
| --- | --- | --- | --- | --- |
| 第一性定位 | 自动化 workflow | Agent / Bot / AI App | 云上大模型应用平台 | LLM App Runtime |
| 编排方式 | 节点流 + LangChain Cluster nodes | Agent / App / Workflow | Agent / Workflow / 高代码 | Workflow / Chatflow + Agent node |
| Agent 自主性 | 中等，嵌在流程里 | 较强，Agent 可调插件和 workflow | 较强，Agent 自主规划并调工具 | 较强，Agent node 自主调工具 |
| 流程确定性 | 强 | 中到强 | 强 | 强 |
| RAG 抽象 | Vector Store / Retriever / Tool | Knowledge Base | 企业知识库 | Knowledge Base |
| 工具生态 | n8n 节点生态最强 | 插件 + workflow | 官方 / 三方 / 自定义插件 + MCP | Plugin / Custom / Workflow / MCP Tool |
| 工程可控性 | 自动化工程强 | 产品化强 | 云平台管控强 | LLM 应用工程强 |

### 选型建议

如果目标是“把 AI 嵌入自动化流程”：

- 优先看 n8n。
- 典型场景：收到邮件后分类、查 CRM、生成回复、发 Slack / 飞书 / 钉钉、写回表格。

如果目标是“快速做一个可用智能体 / Bot”：

- 优先看 Coze。
- 典型场景：客服 Bot、个人助手、知识库问答、对话式业务入口。

如果目标是“国内企业云上应用 + 通义 / 阿里云生态”：

- 优先看阿里云百炼。
- 典型场景：企业知识库、业务助理、云上 API 集成、云资源权限和审计要求较强的场景。

如果目标是“自托管 LLM 应用平台 + RAG + Workflow + Agent”：

- 优先看 Dify。
- 典型场景：内部知识问答、业务流程智能化、API 化 LLM 应用、团队统一管理模型和插件。

### 和 LLM Runtime 的关系

这四个平台都可以拆成 Runtime 能力看：

| Runtime 能力 | n8n | Coze | 百炼 | Dify |
| --- | --- | --- | --- | --- |
| Prompt Runtime | Agent / Chain 配置 | Agent prompt / Prompt 资源 | Prompt 工程 / Agent 提示词 | Prompt / Instructions / Jinja2 |
| Context Runtime | Memory nodes / Chat Trigger | Conversation / user_id / context | 记忆 / 摘要 / 知识召回 | Memory / variables / app context |
| Tool Runtime | n8n nodes / HTTP / Code | Plugin / Workflow | 插件 / MCP 服务 | Tool / Plugin / MCP / Workflow Tool |
| Workflow Runtime | n8n workflow 引擎 | Eino DAG workflow | 可视化 Workflow | Workflow / Chatflow |
| Knowledge Runtime | Vector Store / Retriever | Knowledge Base | 知识库 | Knowledge |
| Model Runtime | 多模型节点 | 模型服务配置 | 通义 / 模型服务 | Model provider plugins |

## 可执行动作

- 学这些平台时，不要只看 UI，要按 Runtime 层拆：Prompt、Context、Tool、Workflow、Knowledge、Model、Observability。
- 做选型时先问：我要的是“流程自动化”“对话 Bot”“云上企业 AI 应用”，还是“自托管 LLM App 平台”。
- 设计生产 Agent 时，优先确认：工具权限、迭代上限、RAG 召回策略、上下文隔离、日志追踪、失败重试和人工确认。
- 对 n8n / Coze 这类低代码平台，不要把复杂长期状态全部塞进画布；需要明确哪些状态放外部数据库或专门 memory 服务。

## 来源

- n8n：[[n8n Docs - LangChain concepts in n8n]] https://docs.n8n.io/advanced-ai/langchain/langchain-n8n/
- n8n：[[n8n Docs - Tools AI Agent node]] https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/tools-agent/
- n8n：[[n8n Docs - AI memory]] https://docs.n8n.io/advanced-ai/examples/understand-memory/
- n8n：[[n8n Docs - Simple Vector Store]] https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.vectorstoreinmemory/
- n8n：[[n8n Docs - Evaluations]] https://docs.n8n.io/advanced-ai/evaluations/overview/
- Coze：[[Coze Studio Wiki - What is Coze Studio]] https://github.com/coze-dev/coze-studio/wiki/1.-What-is-Coze-Studio
- Coze：[[Coze Studio Wiki - Plugin Configuration]] https://github.com/coze-dev/coze-studio/wiki/4.-Plugin-Configuration
- Coze：[[Coze Studio Wiki - API Reference]] https://github.com/coze-dev/coze-studio/wiki/6.-API-Reference
- Coze：[[Coze Studio Wiki - Workflow backend mechanism]] https://github.com/coze-dev/coze-studio/wiki/11.-Add-new-workflow-node-types-%28backend%29
- 阿里云百炼：[[应用类型介绍]] https://help.aliyun.com/zh/model-studio/application-introduction
- 阿里云百炼：[[智能体应用]] https://help.aliyun.com/zh/model-studio/single-agent-application
- 阿里云百炼：[[知识库]] https://help.aliyun.com/zh/model-studio/rag-knowledge-base
- 阿里云百炼：[[插件概述]] https://help.aliyun.com/zh/model-studio/plug-in-overview
- Dify：[[Dify Docs - Agent node]] https://docs.dify.ai/en/use-dify/nodes/agent
- Dify：[[Dify Docs - Tools]] https://docs.dify.ai/en/use-dify/workspace/tools
- Dify：[[Dify Docs - Knowledge]] https://docs.dify.ai/en/use-dify/knowledge/create-knowledge/introduction
- Dify：[[Dify Docs - Orchestration Logic]] https://docs.dify.ai/en/use-dify/build/orchestrate-node

## 相关链接

- [[LLM Runtime]]
- [[AI-runtime]]
- [[Dify]]
- [[orchestration concept]]
- [[00-agent introduction]]
