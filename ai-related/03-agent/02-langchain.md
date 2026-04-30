# LangChain 是什么

LangChain 可以理解成一个 **LLM 应用 / Agent 开发框架**。  
它本身不是模型，也不是 MCP，也不是底层工作流引擎；它更像一层高层 SDK，用来把模型、上下文、工具、Agent 循环和状态管理整理成统一开发方式。

一句话记忆：

> LangChain 解决的是“如何更方便地开发基于 LLM 的应用和 Agent”。

## 它主要解决什么问题

如果自己从零搭一个 Agent 系统，通常要自己处理这些事情：

- 接不同模型厂商，接口不统一
- 组织 prompt、历史消息、tool 结果和运行时状态
- 定义 tool schema，并把函数暴露给模型
- 手写 agent loop
- 做结构化输出、错误处理和上下文压缩

LangChain 的价值就是把这些常见工程问题抽象掉，让你不用每次都从头手搓。

## 核心组成

### 1. Models

LangChain 提供统一的 model interface，用来适配 OpenAI、Anthropic、Google 等不同 provider。

你可以把它理解成：

```text
业务代码
  -> LangChain model 接口
  -> 具体模型提供商
```

所以 LangChain 不是模型本身，而是模型之上的一层抽象。

### 2. Context / Prompt

LangChain 不只是管 prompt template，更重要的是管 **context engineering**：

- system prompt
- 用户输入
- 历史消息
- tool 描述
- tool 执行结果
- memory
- 运行时状态

关键点不是“写一句 prompt”，而是“在正确的时机，把正确的信息交给模型”。

### 3. Tools

Tool 本质上是被标准化包装后的函数能力。

例如：

- 查天气
- 查数据库
- 调内部 API
- 发消息
- 执行代码

LangChain 会帮你把这些函数整理成模型可调用的工具，并统一输入输出结构。

### 4. Agents

Agent 可以理解成“模型 + tools + 循环控制”。

一个典型 agent loop 大致是：

```text
1. 调模型
2. 模型决定直接回答，或者请求调用 tool
3. 如果调用 tool，就执行工具并把结果喂回模型
4. 持续循环，直到得到最终答案
```

所以 LangChain 的 agent，本质上是把 `LLM + tool loop` 这套流程封装了。

### 5. Middleware

这是 LangChain v1 很重要的一层，可以理解成 Agent 执行流程里的拦截器。

它通常用来做：

- 动态调整 prompt
- 控制当前可用 tools
- 扩展 state
- 插入 guardrails
- 压缩对话历史

如果用后端类比，它有点像：

- Interceptor
- Filter
- AOP around advice

## LangChain 现在的重点

LangChain 这个名字里虽然有 `Chain`，但它现在的重心已经明显更偏向 **Agent 开发**，而不只是把几个步骤串起来。

可以这样理解：

- 早期：大家更强调 chain
- 现在：LangChain 更像一个高层 Agent 框架

## 和 LangGraph 的关系

LangChain 和 LangGraph 不是简单替代关系，而更像上下层关系：

```text
LangChain：高层开发接口
  -> LangGraph：底层 orchestration / runtime
```

LangChain 更适合：

- 快速搭 Agent
- 用统一抽象接模型和 tools
- 中低复杂度的 LLM 应用

LangGraph 更适合：

- 复杂状态机
- 明确节点和边的编排
- durable execution
- human-in-the-loop
- 长任务恢复

简单记：

> LangChain 在上，LangGraph 在下。

## 和 Tool Calling 的关系

这两个不要混。

- Tool calling 是模型能力
- LangChain 是对这种能力的工程封装

LangChain 做的事情包括：

- 定义 tool schema
- 把 tool 暴露给模型
- 执行模型请求的工具
- 把工具结果回填到 agent loop

所以可以记成：

> Tool calling 是能力，LangChain 是框架封装。

## 和 MCP 的关系

MCP 不是 LangChain 的内核概念，也不是它必须依赖的前提。

更准确的理解是：

- MCP 提供外部能力
- LangChain 负责组织和调用这些能力

如果一个 MCP server 暴露了多个能力，从 LangChain 视角看，通常还是要映射成 agent 可用的 tool。

## LangChain 解决的是哪一层问题

从分层看，大致可以这样理解：

```text
LLM 层
  -> 负责生成和 tool calling

Tool / MCP 层
  -> 提供外部能力

LangGraph 层
  -> 负责状态、节点、边、持久化和恢复

LangChain 层
  -> 提供更高层、更易用的开发接口
```

所以 LangChain 解决的不是模型训练、推理引擎或者 MCP 协议本身，而是：

> 应用开发者如何更方便地组织这些能力。

## 适合什么场景

LangChain 比较适合：

- 快速做一个 Agent 原型
- 给模型接 tools
- 多模型切换实验
- 不想自己手写完整 agent loop
- 想先用高层抽象把系统跑起来

如果你一开始追求的是可控性和复杂流程执行，通常需要继续往 LangGraph 下沉。

## 最简记忆版

- LangChain 是 LLM 应用 / Agent 开发框架
- 它统一组织 model、context、tools、agent、middleware、state
- 它不是模型，不是 MCP，不是底层 runtime
- 它和 LangGraph 的关系是“上层接口 vs 底层执行引擎”
- 它和 tool calling 的关系是“工程封装 vs 模型能力”

## 一张图记住

```text
用户输入
  -> LangChain
     - 管 context
     - 接 model
     - 注册 tools
     - 跑 agent loop
     - 用 middleware 控制行为
  -> LangGraph
     - state
     - node / edge
     - persistence
     - resume / HITL
  -> Tool / MCP / 外部系统
```

## 一句话总结

LangChain 本质上是一个 **Agent 应用开发框架**。  
它把模型、上下文、工具、Agent 循环和中间控制点统一起来，让开发者更快搭出可用的 LLM 应用；当需要更底层、更精细的流程控制时，通常会进一步落到 LangGraph。
