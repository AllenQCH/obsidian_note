---
author: "Allen"
---

“Infra 项目”里的 Infra，其实是：Infrastructure（基础设施）的缩写。
在 AI、后端、平台工程里非常常见。
# 一、什么是 Infra 项目
Infra 项目本质上是：
> “给业务系统提供通用底层能力的系统。”

它通常：
- 不直接赚钱
- 不直接面对用户
- 不是业务功能
但：
```text
所有业务都依赖它
```

# 二、为什么需要 Infra
因为：
```text
重复问题太多了
```

例如你有 20 个微服务：
```text
订单系统
库存系统
履约系统
发票系统
物流系统
...
```
你会发现：
每个系统都要：
- 日志
- 配置
- 链路追踪
- MQ
- Redis
- 限流
- 权限
- 监控
- ID生成
- AI调用
- Tool调用
- Workflow

如果每个项目都自己写：
会变成：
```text
20套重复代码
```
于是就会出现：
```text
Infra（基础设施层）
```
# 三、从第一性原理理解 Infra
本质上：
Infra 解决的是：“复杂系统中的重复公共能力”问题。

因为大型系统一定会出现：
```text
横向共性
```
例如：

| 业务  | 是否都需要日志 |
| --- | ------- |
| 订单  | 需要      |
| 库存  | 需要      |
| 发票  | 需要      |
| 履约  | 需要      |
那：
```text
日志就不应该属于业务
```
而应该属于：
```text
Infra
```
# 四、典型 Infra 项目有哪些
你工作里其实已经天天在接触了。
## 1）配置中心 Infra
例如：
- Apollo
- Nacos
提供：
```text
配置
动态刷新
灰度
```

## 2）消息队列 Infra
例如：
- RabbitMQ
- Kafka 
- RocketMQ
提供：
```text
异步能力
削峰
解耦
```
## 3）日志监控 Infra
例如：
- ELK
- Prometheus
- SkyWalking
提供：
```text
日志
trace
metrics
```
## 4）网关 Infra
例如：
- Spring Gateway
- Kong
提供：
```text
鉴权
限流
路由
```
## 5）AI Infra（现在特别火）
例如：
- Dify
- LangGraph Runtime
- MCP Server
- Prompt Runtime
提供：
```text
LLM调用
Agent Runtime
Workflow
Memory
RAG
```
# 五、为什么 AI 圈现在特别爱说 Infra
因为 AI 行业已经开始：
```text
从“模型时代”
进入“工程时代”
```

以前：
大家关心：
```text
GPT-4强不强
```
现在：
大家关心：
```text
怎么稳定做AI系统
```
于是：
AI Infra 开始爆发。
# 六、AI Infra 到底是什么
例如：
你做一个 Agent。
你会发现需要：
```text
Prompt
Memory
Context
RAG
Tool
Workflow
LLM Router
日志
成本统计
```
这时候：
你其实就在开发：
```text
AI Infra
```
# 七、为什么很多大厂都在做 Infra
因为：
```text
Infra 可以服务无数业务
```
这是杠杆最大的地方。
举个例子：
你做：
```text
统一 AI SDK
```
之后：
所有业务：
- 客服
- AI助手
- 知识库
- 工作流
都能复用
所以 Infra 团队通常：
```text
技术影响力巨大
```
# 八、Infra 项目一般长什么样
这是关键。
## 传统业务项目
一般：
```text
controller
service
dao
```
围绕：
```text
订单
库存
履约
```
展开。

## Infra 项目
一般围绕：
```text
抽象能力
```
展开。
例如：
```text
sdk/
runtime/
gateway/
scheduler/
client/
tool/
workflow/
memory/
trace/
```

# 九、怎么写 Infra 项目（核心）
这是最重要部分。
# 第一原则：
```text
不要写业务
```
Infra 最大忌讳：
```text
混入业务逻辑
```
例如：
错误：
```java
if (shopId == 123) {
   ...
}
```

这是业务。
正确：

```java
RateLimiter
WorkflowEngine
ToolExecutor
```

这是基础能力。
# 第二原则：
```text
抽象共性
```
Infra 的核心：
```text
抽象
```
例如：
## 普通业务写法
```java
sendSms()
sendEmail()
sendDingTalk()
```
## Infra 写法
```java
NotificationSender
```
然后：
```text
SMS
Email
DingTalk
```
都是实现。

这就是：
```text
平台化抽象
```

# 第三原则：
```text
插件化
```
Infra 很重要的一点：
```text
可扩展
```
例如 AI Infra：
```text
LLMProvider
```
下面：
- OpenAI
- Claude
- Gemini
- Qwen
都是插件。
# 第四原则：
```text
Runtime 思维
```
这是高级 Infra 核心。
普通业务：
```text
执行功能
```
Infra：
```text
管理执行过程
```
例如：
Dify 不只是：
```text
调用 GPT
```
而是：
```text
管理：
Prompt
Context
Workflow
State
Memory
```
这叫：
```text
Runtime
```
# 十、你现在其实已经在接近 Infra 了
你之前聊的：
- GlobalZoneScheduler
- 时区调度 
- Apollo Config
- MQ
- Sharding
- Trace
- 通用序列化
其实已经：
```text
有 Infra 味道了
```
尤其：
```text
GlobalZoneScheduler
```

这个就非常像：
```text
调度 Infra
```

因为它：
- 抽象调度
- 管理时区
- Runtime化
- 多业务复用
已经不是：

```text
“某个订单功能”
```
了。

# 十一、为什么 Infra 工程师通常更偏“架构”
因为 Infra 天然要求：
```text
抽象能力
```
而不是：
```text
完成业务需求
```
所以：
很多高级架构师：
其实本质上都是：
```text
Infra 思维
```

# 十二、AI时代最大的变化
未来很多 Infra：
会从：

```text
传统中间件
```

变成：

```text
AI Runtime Infrastructure
```

例如：
- Agent Runtime
- Memory Runtime
- Tool Runtime
- Workflow Runtime
- MCP Runtime

所以现在：
为什么：
- Dify
- LangGraph
- MCP
- AgentScope
这么火。
因为：
```text
AI Infra 正在形成新一代技术栈
```
