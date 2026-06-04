---
author: "Allen"
---

这些词本质上都属于：
```text
AI Runtime Infrastructure
```
即：
> “AI 系统运行时基础设施”

它们并不是“某一个具体产品”。
而是：AI 系统中的核心运行层 概念。

你可以把它理解成：
在传统后端里
- JVM Runtime
- Tomcat Runtime
- Spring Runtime
负责：管理程序运行

而 AI 时代：
开始出现：
- Agent Runtime
- Memory Runtime
- Tool Runtime
负责：管理 AI 的运行
# 一、为什么会出现这些 Runtime

这是核心。
因为：
LLM 本身只会：
```text
输入文本
→ 输出文本
```

但真正 AI Agent 系统需要：
- 会思考
- 会记忆
- 会调用工具
- 会多步骤执行
- 会工作流编排
- 会长期运行
于是：
必须有：Runtime 层  帮忙管理。
# 二、什么是 Runtime（先理解本质）
Runtime 本质上：
```text
管理“运行过程”
```
例如：
## JVM Runtime
负责：
- 类加载
- GC
- 内存
- 线程
- 执行栈
## Spring Runtime
负责：
- Bean 生命周期
- IOC
- AOP
- Context
## AI Runtime
负责：
- Prompt
- Context
- Memory
- Tool
- Workflow
- State
- Agent
所以：
```text
Runtime = 执行过程管理器
```

# 三、Agent Runtime 是什么
这是现在最核心的。

# 本质
Agent Runtime：
```text
管理 Agent 如何运行
```

它负责：
```text
思考
→ 调工具
→ 再思考
→ 再执行
```

整个循环。
# 举个例子
用户：
```text
“帮我查询库存并发钉钉”
```

Agent 不会直接输出。
而是：
## 第一步
决定：
```text
需要调用库存工具
```
## 第二步
执行：
```text
inventory_tool()
```
## 第三步
拿到结果。
## 第四步
决定：
```text
需要调用钉钉工具
```
## 第五步
发送消息。
这个：
```text
“思考 → 行动 → 观察”
```
循环。
就是：
```text
Agent Runtime
```
# Agent Runtime 典型能力

## 1）Tool Calling
管理工具调用。
## 2）State
管理状态。
例如：
```text
当前步骤
当前上下文
```

## 3）Planning
管理任务拆解。
## 4）Context
管理上下文窗口。
## 5）Loop
管理：
```text
Agent 是否继续思考
```
# 四、Memory Runtime 是什么
这个特别关键。
# 本质
```text
管理 AI 的“记忆”
```

因为：
LLM 本身：
```text
没有真正记忆
```
每次请求：
都是：
```text
无状态
```
于是：
Memory Runtime 出现。
# 它负责什么
## 1）短期记忆
例如：
当前会话：
```text
最近20轮对话
```
## 2）长期记忆
例如：
```text
用户喜欢Java
用户在做履约系统
```

## 3）摘要压缩
因为 context 有限制。
所以：
```text
旧对话
→ summary
→ memory
```
## 4）记忆检索
例如：
```text
相关历史
→ retrieve
→ 拼回context
```

# 为什么重要
因为：
没有 Memory Runtime：
Agent 会：
```text
“失忆”
```
# 五、Tool Runtime 是什么

这是 AI Agent 最关键基础设施之一。
# 本质
```text
管理工具如何被 AI 调用
```
因为：
LLM 不会直接：
- 查数据库
- 发HTTP
- 调钉钉
- 调库存
所以：
必须有：
```text
Tool Runtime
```
# Tool Runtime 负责：
## 1）Tool Registry
注册工具。
例如：

```json
{
  "name": "query_inventory",
  "description": "查询库存"
}
```
## 2）Schema
定义参数。
## 3）Tool Routing
决定调用哪个工具。
## 4）Tool Execution
真正执行。
## 5）权限
限制工具。
例如：
```text
AI不能删库
```

# 为什么现在 MCP 火
因为 MCP 本质上：
就是：
```text
Tool Runtime 标准化
```
# 六、Workflow Runtime 是什么
这个你会特别熟悉。
# 本质
```text
管理 AI 工作流执行
```
例如：
```text
开始
↓
LLM
↓
条件判断
↓
调用工具
↓
RAG
↓
输出
```

Workflow Runtime 负责：
- 节点执行
- DAG
- 分支
- 状态
- 重试
- 超时
- 编排
# 它其实很像：
- Camunda
- Flowable
- Airflow
只是：
节点从：
```text
HTTP调用
```
变成：
```text
LLM节点
```
# 七、MCP Runtime 是什么
这个是最近最火的。

# MCP 是什么
MCP：

```text
Model Context Protocol
```

由 Anthropic 推动。
# 本质
```text
AI 与外部世界通信的标准协议
```
# 为什么需要 MCP
以前：
每个 Agent：
```text
都自己接工具
```
导致：
```text
Tool接口混乱
```
于是：
MCP 希望统一：
```text
AI Tool 标准
```
# MCP Runtime 负责：
## 1）连接 MCP Server
例如：
- GitHub MCP
- Slack MCP
- 钉钉 MCP
## 2）管理协议
例如：
```text
discover tool
call tool
resource
prompt
```
## 3）上下文传输
## 4）权限
## 5）生命周期
# 八、它们之间关系是什么
这是核心。
# 一个完整 AI 系统：
```text
用户
 ↓

Agent Runtime
（大脑）

 ↓

Workflow Runtime
（流程）

 ↓

Tool Runtime
（工具）

 ↓

MCP Runtime
（协议）

 ↓

外部系统
```
同时：
```text
Memory Runtime
```
贯穿整个系统。
# 九、你可以类比 Java 世界

|AI Runtime|Java世界类似物|
|---|---|
|Agent Runtime|Spring 容器 + 调度器|
|Memory Runtime|Redis + Session|
|Tool Runtime|SPI + RPC|
|Workflow Runtime|BPM引擎|
|MCP Runtime|HTTP/gRPC协议层|
# 十、为什么这些概念现在特别重要
因为 AI 正在从：
```text
ChatBot
```
进入：
```text
Agent System
```
而：
```text
Agent ≠ Prompt
```
真正 Agent 背后：
其实是一整套：
```text
Runtime Infrastructure
```
这也是：
为什么：
- LangGraph
- Dify
- MCP
- AgentScope
- CrewAI

开始越来越像：
```text
“AI 操作系统”
```
