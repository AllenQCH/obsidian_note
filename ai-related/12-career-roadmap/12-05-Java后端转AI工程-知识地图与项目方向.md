---
title: "12-05-Java后端转AI工程-知识地图与项目方向"
source: "conversation: 2026-05-15 后端转 AI 工程整理"
author: "笨笨"
published:
created: 2026-05-15
description: "把 Java 后端转 AI 的学习重点重新排序：先学什么、后学什么、不要先学什么，以及最值得做的项目。"
tags: ["ai-related", "roadmap", "agent", "rag", "ai-application"]
type: "note"
status: "processed"
aliases: ["AI工程知识地图", "Java后端转AI项目方向"]
---

# 12-05-Java后端转AI工程-知识地图与项目方向

## 摘要

这篇笔记只解决两个问题：

1. **到底先学什么，后学什么？**
2. **第一批项目做什么最值？**

如果你已经是 Java 后端，不要把路线想成“去补算法”。
更现实的主线是：

```text
Python 工程能力
-> Prompt / RAG
-> Agent / Workflow
-> MCP / Tool Calling
-> 企业 AI 应用
```

## 核心内容

### 一、最适合当前背景的主线

你已有的优势通常是：

- Java 后端
- 微服务 / 分布式
- SQL
- MQ
- ES
- 线上排障和业务系统经验

这些经验最适合迁移到：

- AI Application Engineer
- AI Agent Engineer
- AI Backend / AI Infra

而不是优先去走：

- 模型训练
- 底层 CUDA
- 论文研究
- 数学推导路线

### 二、知识优先级：先学什么

#### 第一优先级：马上就会用到

| 主题           | 你要学到什么程度                                   |
| ------------ | ------------------------------------------ |
| Python       | 能写 AI glue code，能读改项目                      |
| Prompt       | 会写结构化输入输出，不只会聊天式 prompt                    |
| RAG          | 懂 chunk / embedding / recall / rerank 基本链路 |
| FastAPI      | 能把模型能力包装成服务                                |
| Tool Calling | 能让模型调用工具而不是只输出文字                           |

#### 第二优先级：开始做复杂系统时补

| 主题 | 为什么重要 |
| --- | --- |
| LangChain / LangGraph | 帮你理解 agent loop、state、workflow |
| MCP | 让模型与外部工具 / 系统对接更规范 |
| Memory | 让 agent 有状态，不只是一次性问答 |
| Workflow | 让系统从“单次调用”走向“可编排流程” |

#### 第三优先级：知道即可，不要先重投入

| 主题               | 当前建议              |
| ---------------- | ----------------- |
| Transformer 细节   | 了解基本原理即可          |
| 微调 / LoRA / RLHF | 先知道边界，不必先做        |
| 量化 / 推理优化        | 更偏 infra 进阶阶段     |
| 多 Agent          | 单 Agent 跑顺之前别过早投入 |
| 多模态              | 先把文本场景做扎实         |

### 三、最值得做的第一批项目

#### 方向 1：RAG 知识库
适合原因：
- 企业真实需求最多
- 能练检索、切块、召回、生成全链路
- 容易做成能展示的 demo

#### 方向 2：AI SQL Agent
适合原因：
- 和后端 / 数据库经验强相关
- 很容易体现业务价值
- 可以直接连接真实查询场景

#### 方向 3：AI 排障 Agent
适合原因：
- 很吃业务经验和排障经验
- 容易把日志、SQL、配置、SOP 接进来
- 比纯聊天机器人更有作品集价值

#### 方向 4：SOP / 工作流 Agent
适合原因：
- 企业流程天然适合 Agent 化
- 能练 Tool Calling、人工确认、步骤编排
- 更接近真正可落地的企业助手

### 四、一个更现实的学习顺序

#### 第 1 个月
重点：
- Python
- FastAPI
- OpenAI / Anthropic SDK
- Tool Calling

目标：
```text
能写最小 AI 服务
```

#### 第 2 个月
重点：
- RAG
- embedding
- 向量数据库
- LangChain / 基础编排

目标：
```text
做出一个可运行的知识库或检索增强 demo
```

#### 第 3 个月
重点：
- Agent
- Workflow
- Memory
- MCP

目标：
```text
做出一个接近真实业务流程的 Agent demo
```

### 五、最重要的提醒

不要平均用力。

真正有效的做法是：

- 先抓高频、能落地的知识
- 再用一个项目把它们串起来
- 不要在“以后可能有用”的知识上过早深挖

## 可执行动作

- [ ] 把自己的学习清单按 `马上学 / 之后学 / 先了解` 三列重排一遍。
- [ ] 从 `RAG 知识库 / AI SQL Agent / AI 排障 Agent / SOP Agent` 中只选 1 个先做。
- [ ] 如果做项目时发现自己一直在补理论，说明项目太大了，先缩成最小 demo。

## 相关链接

- [[12-00-AI工程学习路线-索引]]
- [[12-01-Java后端转AI工程-定位与方向]]
- [[12-02-AI工程所需Python能力]]
- [[12-03-Java后端转AI工程-三个月路线]]
- [[12-04-Java后端转AI工程-资料与学习模式]]
- [[02-01-RAG-总览]]
- [[01-langgraph]]
- [[LLM Runtime]]
