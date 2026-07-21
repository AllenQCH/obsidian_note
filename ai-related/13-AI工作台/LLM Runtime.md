---
title: "LLM Runtime"
source: "conversation: Codex 2026-05-12"
author: "Allen"
published:
created: 2026-05-12
description: "LLM Runtime 是让大模型在 Agent 和 AI Infra 系统中稳定运行的一整套执行环境。"
tags: ["ai-infra", "llm", "runtime", "agent", "workflow"]
type: "tech-note"
status: "processed"
---

# LLM Runtime

## 摘要

LLM Runtime 不是模型本身，而是让大模型真正运行起来的一整套执行环境。

可以先记一句话：

> LLM Runtime = 让大模型真正运行起来的一整套执行环境。

如果用 Java 后端类比，LLM Runtime 类似 AI 应用里的 JVM：它管理 prompt、context、memory、tool calling、workflow、agent state、模型路由、streaming 和结果解析。Runtime 的核心不是“模型能力”，而是如何让模型在复杂系统里稳定、可控、可观测地运行。

```text
用户请求
    ↓
Prompt 组装
    ↓
Context 注入
    ↓
Memory / RAG
    ↓
Tool Calling
    ↓
模型推理
    ↓
结果解析
    ↓
Agent 决策
```

## 核心内容

### 类比 Java Runtime

Java 程序不等于 JVM。比如：

```java
System.out.println("hello");
```

真正执行时，需要经过：

```text
Java 代码
→ 编译
→ Class
→ JVM 加载
→ 内存管理
→ GC
→ 线程调度
→ 执行
```

JVM 是 Java Runtime，它负责执行环境、内存、生命周期、调度、IO、类加载和线程管理。

LLM Runtime 也类似：

| LLM Runtime 能力 | Java / JVM 类比 |
| --- | --- |
| Prompt 组装 | 类加载 |
| Context 管理 | 内存管理 |
| Token 控制 | 堆管理 |
| Tool Calling | JNI / 系统调用 |
| Memory | 缓存 |
| Workflow 执行 | 线程调度 / 工作流调度 |
| Agent State | Runtime State |
| 推理请求 | 方法执行 |
| 模型路由 | 类路由 / 依赖路由 |
| Streaming | IO 输出 |

所以 Runtime 要解决的不是“有没有模型”，而是：

```text
如何让模型在复杂系统里稳定运行
```

### 为什么需要 LLM Runtime

早期 Chat 模式很简单：

```text
用户
→ ChatGPT
→ 回复
```

现在 Agent 系统变成：

```text
用户
→ Agent
→ 查知识库
→ 调数据库
→ 调 API
→ 调工具
→ 多步推理
→ 长期记忆
→ Workflow
→ 返回结果
```

这时大模型已经不再是完整系统本身，而是系统中的一个推理组件。需要有一层 Runtime 管理整个运行过程。

### 1. Prompt Runtime

用户说：

```text
帮我分析订单失败原因
```

Runtime 通常不会直接把这句话发给模型，而是先组装：

```text
System Prompt
+ Agent Prompt
+ Workflow Prompt
+ Tool Definition
+ Memory
+ 历史对话
+ RAG 知识
+ 用户输入
```

最后形成一个大 prompt，再发给 LLM。

Prompt Runtime 的本质是 prompt 编排器，负责把当前任务需要的规则、上下文、工具定义和用户输入组织成模型能执行的输入。

### 2. Context Runtime

LLM 的关键约束是上下文窗口有限。因此 Runtime 要负责：

- 截断历史
- 摘要 memory
- RAG 检索
- token budgeting
- 长短期记忆管理

这层很像上下文操作系统，也类似 JVM 内存管理、Redis cache 和 session 管理的组合。

### 3. Tool Runtime

模型可能输出工具调用：

```json
{
  "tool": "query_order",
  "args": {
    "orderNo": "DH001"
  }
}
```

Runtime 要负责：

```text
解析 Tool Call
→ 找到真实工具
→ 执行工具
→ 返回结果
→ 再喂回模型
```

Tool Runtime 可以理解成 AI 世界的 RPC Runtime。它不仅负责执行，还要处理工具注册、schema 校验、权限控制、错误处理、重试和结果回填。

### 4. Agent Runtime

当目标变成：

```text
修复发票问题
```

Agent Runtime 会管理：

```text
分析问题
→ 决定下一步
→ 调工具
→ 检查结果
→ 再规划
→ 重试
→ 最终完成
```

这时 Runtime 已经很像任务调度系统或状态机，类似 Airflow、XXL-JOB、BPM、Saga。它管理的是“思考 - 行动 - 观察 - 再决策”的循环。

### 5. Workflow Runtime

如果任务被拆成：

```text
节点 A → 节点 B → 节点 C
```

Workflow Runtime 负责：

- 节点状态
- 输入输出
- 重试
- 并行
- 超时
- 条件判断

这已经非常接近工作流引擎。区别是传统工作流节点多是 HTTP、消息、数据库操作，而 AI 工作流里会出现 LLM 节点、RAG 节点、tool 节点和人工确认节点。

### 6. Model Runtime

企业 AI 系统里通常不会只有一个模型。Runtime 要决定使用：

- GPT
- Claude
- Qwen
- DeepSeek
- embedding 模型
- rerank 模型

Model Runtime 负责模型路由、fallback、retry、成本控制和延迟控制。

## 系统视角

完整 AI 系统可以理解为：

```text
                ┌──────────────┐
                │     User     │
                └──────┬───────┘
                       ↓
             ┌──────────────────┐
             │   LLM Runtime    │
             └──────────────────┘
               ↓      ↓      ↓
            Prompt   Tool   Memory
               ↓      ↓      ↓
            Workflow / Agent
                    ↓
                   LLM
```

Runtime 会越来越重要，因为模型能力正在通用化。真正拉开差距的往往不是单个 prompt 或单个模型，而是 orchestration、memory、tool use、workflow、planning、retrieval、state 和 execution 这些运行时能力。

AI 系统越来越像后端系统，本质原因是它正在变成推理驱动的分布式系统：

```text
以前：请求驱动
现在：LLM 推理驱动
```

## 可执行动作

- 看 AI Infra 产品或框架时，不只看模型接入，要拆开看 Prompt Runtime、Context Runtime、Tool Runtime、Agent Runtime、Workflow Runtime 和 Model Runtime。
- 设计 Agent 系统时，优先明确 Runtime 负责的状态、工具权限、上下文预算、重试策略和模型路由。
- 评估 Dify、LangGraph、MCP、AgentScope、CrewAI 等工具时，可以用“它解决了哪一层 Runtime 问题”作为分析框架。

## 相关链接

- [[AI-runtime]]
- [[infra项目]]
- [[Dify]]
- [[01-01-LLM-总览]]
- [[01-04-00-LLM-Context]]
- [[01-03-LLM-Prompt]]
