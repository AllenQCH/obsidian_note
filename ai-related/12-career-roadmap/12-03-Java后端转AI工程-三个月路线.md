---
title: "12-03-Java后端转AI工程-三个月路线"
source: "conversation: 2026-05-15 后端转 AI 工程整理"
author: "Codex"
published:
created: 2026-05-15
description: "按月推进的 Java 后端转 AI 工程学习路线，强调项目化学习而不是脱离业务刷语法。"
tags: ["ai-related", "roadmap", "python", "agent", "rag", "tech-note"]
type: "note"
status: "processed"
aliases: ["AI工程三个月路线", "后端转AI学习路线"]
---

# 12-03-Java后端转AI工程-三个月路线

## 摘要

- 最有效的路线不是“先学半年 Python 再碰 AI”，而是边做 AI 项目边补 Python。
- 三个月的目标应该逐步从“能写 Python 服务”推进到“能做 Agent / RAG 项目”，最后进入“能做业务落地型 AI 系统”。
- 最适合当前背景的项目，不是通用玩具，而是贴近现有业务系统的排障、知识库和 SOP 自动化场景。

## 核心内容

### 第一个月：补齐 Python 工程能力

目标：

```text
Python 能替代 Java 写简单服务
```

学习重点：

- Python 基础语法
- FastAPI
- `async/await`
- `requests` / `httpx`
- Pydantic

项目建议：

- 做一个 AI Chat API
- 支持基本会话和流式输出

完成标准：

- 能独立读改 Python Web 服务代码
- 能定位简单异常
- 能接一个 LLM SDK 把接口跑通

### 第二个月：进入 AI 工程核心区

学习重点：

- OpenAI SDK
- LangChain
- [[01-langgraph]]
- [[02-01-RAG-总览]]

项目建议：

- 做一个企业知识库 Agent
- 至少覆盖文档切块、向量化、召回、生成

完成标准：

- 理解 RAG 全链路
- 会做基础 Prompt / Context 工程
- 能把检索和模型调用串成一条服务链路

### 第三个月：开始工程化差异化

学习重点：

- MCP
- Tool Calling
- Memory
- Workflow
- 多 Agent

项目建议：

- 做一个自动排查生产问题 Agent
- 输入现象、日志、SQL 或报错后，输出排查步骤和建议

这个方向特别适合已有发票、履约、订单、调度等业务经验，因为这些领域通常都具备：

- SOP
- SQL 排查链路
- 配置检查项
- 人工决策流程

它们本来就是 Agent 最容易落地的场景。

## 可执行动作

- [ ] 第一个月先把“最小可用 Python 服务”做出来，不要停留在语法学习。
- [ ] 第二个月把知识库 Agent 做成可运行 demo，而不是只看概念。
- [ ] 第三个月尽量选择贴近真实业务的排障或辅助决策场景，形成作品集。

## 相关链接

- [[12-00-AI工程学习路线-索引]]
- [[12-01-Java后端转AI工程-定位与方向]]
- [[12-02-AI工程所需Python能力]]
- [[12-04-Java后端转AI工程-资料与学习模式]]
- [[12-05-Java后端转AI工程-知识地图与项目方向]]
- [[01-langgraph]]
- [[02-01-RAG-总览]]
