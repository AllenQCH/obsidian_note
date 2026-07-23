---
title: "01-04-02-主流Agent的Context拼接与裁剪策略"
author: "Allen"
created: 2026-07-23
description: "整理 Codex、Claude Code、Kimi、GLM 等主流 Agent/LLM 系统的 context 组成、拼接方式、缓存与裁剪策略。"
tags: ["obsidian-note", "tech-note", "llm", "context", "context-engineering", "agent"]
type: "tech-note"
status: "draft"
aliases: ["Agent Context 拼接", "Context 裁剪策略", "LLM Context Engineering"]
---

# 01-04-02-主流Agent的Context拼接与裁剪策略

## 摘要

- 目前没有一套所有 Agent 都遵守的统一 context 拼接规范。
- 已经逐渐标准化的是外部上下文接入协议和 Agent 通信协议，例如 MCP、A2A。
- 真正送入模型窗口的 context 结构，仍然是各家 Agent 框架自己设计的工程策略。
- 成熟 Agent 不会简单把所有内容拼成一个长 prompt，而是会对指令、历史、文件、工具结果、记忆和检索材料做优先级管理、缓存、摘要和裁剪。

## 先区分三层

### 1. 外部上下文接入层

这一层解决的是：

```text
Agent 从哪里拿上下文？
如何连接文件、数据库、API、MCP Server、工具和外部系统？
```

代表协议：

- MCP: Model Context Protocol
- 各类 tool calling / function calling
- RAG 检索接口
- 企业内部 connector

MCP 更像是标准化“上下文和工具如何暴露给 Agent”，不是规定最终 prompt 怎么拼。

### 2. Agent 通信层

这一层解决的是：

```text
多个 Agent 之间如何发现、通信、委托、返回结果？
```

代表协议：

- A2A: Agent2Agent Protocol
- 多 Agent 框架里的 handoff / delegation

这也不是单个模型窗口的拼接规范。

### 3. 模型输入拼接层

这一层才是狭义的 context 拼接：

```text
system prompt
+ developer instruction
+ user message
+ conversation history
+ memory
+ RAG results
+ file snippets
+ tool definitions
+ tool results
+ task state
+ output format
```

这一层目前没有统一行业规范，通常是各家 Agent 的核心工程能力。

## 主流系统对比

| 系统 | 是否公开完整拼接规范 | 明确公开的组成 | 裁剪/压缩策略公开程度 |
|---|---:|---|---|
| OpenAI Codex | 否 | system/developer/user 指令、AGENTS.md、环境信息、仓库文件、工具结果、历史摘要 | 部分公开，内部细节未完全公开 |
| Anthropic Claude Code | 否，但文档更系统 | system prompt、messages、tool results、CLAUDE.md、memory、files、MCP/tools | 较多公开，包括 prompt caching、context editing、compaction |
| Kimi / Moonshot | 否 | OpenAI-compatible messages、长文本、工具、context cache | 主要公开长上下文和缓存能力 |
| GLM / Z.ai | 否 | messages、tools、长上下文、prompt cache | 主要公开 cache 和 messages 结构 |

## OpenAI Codex 的 Context 组成

Codex 没有公开完整的内部 prompt 拼接模板，但可以从文档和实际使用方式推断出大致结构。

典型组成：

```text
[1] 系统级规则
    - OpenAI/Codex 平台规则
    - 安全边界
    - 工具调用规则

[2] 开发者/运行环境规则
    - developer instructions
    - sandbox / approval / network / filesystem 权限
    - 当前日期、时区、workspace roots
    - 可用工具列表

[3] 仓库级持久指令
    - AGENTS.md
    - 子目录中的 AGENTS.md 可以对局部目录生效

[4] 用户当前请求
    - 本轮目标
    - 明确约束
    - 验收标准

[5] 对话历史
    - 最近原文对话
    - 更早历史摘要
    - 当前任务状态

[6] 工作区上下文
    - 当前目录
    - git 状态
    - 已读取文件片段
    - 搜索结果
    - 测试和命令输出

[7] 工具调用轨迹
    - shell 输出
    - patch 结果
    - web/browser 结果
    - 截图、图片、测试结果
```

### Codex 的关键特点

Codex 更像是一个动态 context manager：

- 不会一次性把整个仓库塞进模型。
- 会根据任务主动搜索、读取文件、运行命令。
- 已读取内容和工具结果会进入当前上下文。
- 长对话或长任务会依赖摘要和状态压缩继续推进。
- `AGENTS.md` 是项目级长期指令入口，适合写代码风格、测试命令、工程约定。

### Codex 的裁剪策略

可以按优先级理解：

```text
高优先级保留：
- system / developer 指令
- 用户当前任务
- 最近关键消息
- AGENTS.md / repo conventions
- 当前正在编辑的文件
- 失败测试、错误栈、关键命令输出

中优先级摘要：
- 较早对话
- 已完成步骤
- 长日志
- 多个工具调用结果

低优先级丢弃或按需重读：
- 无关文件内容
- 旧搜索结果
- 重复命令输出
- 大段依赖安装日志
```

## Anthropic Claude / Claude Code 的 Context 组成

Anthropic 在 context 管理上公开得更系统一些，尤其是 prompt caching、context editing 和 compaction。

典型结构：

```text
system:
  高优先级行为指令

messages:
  user / assistant 多轮消息

tools:
  工具定义

tool_result:
  工具返回结果

extra context:
  文件、检索片段、缓存内容、memory、MCP 资源
```

Claude Code 还有项目记忆机制，例如 `CLAUDE.md`，用来记录项目约定、常用命令、代码风格等。

### Prompt Caching

Prompt caching 适合缓存稳定、重复、大块的上下文：

```text
- system prompt
- tool definitions
- 长文档
- 代码库说明
- 多轮对话中的稳定前缀
```

作用：

- 降低重复输入成本
- 降低延迟
- 让长任务可以复用稳定上下文

### Context Editing

Context editing 的核心是自动清理上下文里的旧工具结果，尤其适合长任务、多工具调用场景。

它不是简单截断，而是针对上下文里的特定类型内容做清理，例如：

```text
- 旧 tool result
- 大量中间工具输出
- 不再需要的检索结果
```

这解决的是 Agent 常见问题：

```text
用户对话本身不长，
但工具结果、文件内容、日志和网页内容迅速撑爆 context。
```

### Compaction

Claude Code 有 `/compact` 一类能力，用来把长对话压缩成摘要，保留关键状态后继续工作。

适合场景：

```text
- 长时间 coding session
- 多文件修改
- 多轮调试
- 上下文接近窗口上限
```

### Anthropic 的裁剪策略

可以抽象为：

```text
1. 稳定前缀缓存
   system prompt、tool definitions、大文档、项目说明

2. 活跃上下文保留
   当前用户目标、最近消息、当前文件、最近工具结果

3. 工具结果清理
   过旧或过长的 tool results 被清除或压缩

4. 历史压缩
   长对话 compact 成摘要

5. 必要时重新拉取
   文件、工具结果、外部资源按需重新读取
```

## Kimi / Moonshot 的 Context 组成

Kimi API 公开资料主要围绕长上下文、OpenAI-compatible messages 和 context caching。

基础输入结构通常类似：

```json
[
  {"role": "system", "content": "..."},
  {"role": "user", "content": "..."},
  {"role": "assistant", "content": "..."},
  {"role": "user", "content": "..."}
]
```

工程上，一个 Kimi Agent 的 context 可能是：

```text
system prompt
+ 用户任务
+ 历史 messages
+ 长文档/检索内容
+ 工具定义
+ 工具结果
+ cache 引用或缓存前缀
```

Kimi 的优势通常在长上下文承载能力上，但长上下文不等于可以随便塞。

仍然要注意：

```text
- 中间位置注意力衰减
- 关键信息被噪声稀释
- 成本上升
- 延迟上升
- 工具结果污染判断
```

### Kimi 的推荐裁剪思路

```text
稳定大块内容 -> cache
当前任务关键材料 -> 原文保留
历史对话 -> 摘要
无关长文档 -> 检索后插入片段
旧工具输出 -> 裁剪或摘要
```

## GLM / Z.ai 的 Context 组成

GLM / Z.ai 公开侧主要是 API messages、tools、长上下文和 prompt cache。

基础结构类似：

```text
system / user / assistant messages
+ tools
+ tool calls / tool results
+ cache-able prefix
+ long-context input
```

工程上，一个 GLM Agent 大概会这样组织：

```text
1. system prompt
2. agent 行为约束
3. 工具 schema
4. 用户目标
5. conversation history
6. RAG / 文件片段
7. tool call results
8. memory / profile / project rules
```

### GLM 的推荐裁剪思路

```text
保留：
- 当前任务
- 系统规则
- 最近几轮
- 当前工具调用链
- 最相关检索片段

压缩：
- 较早历史
- 多轮推理过程
- 重复文件内容
- 长日志

丢弃：
- 低相关检索结果
- 过期 tool result
- 已经反映进摘要的中间步骤
```

## 通用 Agent Context Contract

如果自己设计 Agent，可以把 context 分成固定槽位。

```text
[0] System Policy
    不可变规则、安全边界、模型行为约束

[1] Developer / Agent Policy
    agent 身份、工具使用规则、输出格式、任务流程

[2] Durable Project Context
    AGENTS.md / CLAUDE.md / project rules / repo conventions

[3] User Goal
    当前用户请求、验收标准、明确禁止事项

[4] Active State
    当前计划、已完成步骤、未解决问题、关键假设

[5] Conversation Window
    最近 N 轮原文 + 更早历史摘要

[6] Working Set
    当前相关文件、代码片段、RAG 片段、网页片段

[7] Tool Context
    工具 schema、最近 tool calls、必要 tool results

[8] Memory
    用户偏好、项目长期事实、已确认约定

[9] Output Contract
    本轮回答格式、语言、详细程度
```

## 通用裁剪优先级

### 永不裁

```text
- system prompt
- developer instruction
- 当前用户目标
- 安全规则
- 明确输出格式要求
```

### 尽量保留原文

```text
- 当前编辑文件
- 错误栈
- 失败测试
- 用户最近指令
- 关键工具返回
```

### 可以摘要

```text
- 旧对话
- 长日志
- 历史工具结果
- 已完成步骤
- 多轮调试过程
```

### 可以丢弃

```text
- 重复输出
- 低相关检索片段
- 过期网页
- 无关文件
- 已经写入摘要的中间过程
```

## 一个推荐的拼接顺序

```text
system policy
developer / agent policy
durable project rules
tool definitions
stable cached context
conversation summary
recent conversation messages
active task state
retrieved working set
recent tool results
current user message
output contract
```

注意：这个顺序不是行业标准，只是一个工程上比较稳的设计。

核心原则：

```text
越稳定、越高优先级的内容越靠前；
越贴近当前任务的问题越靠近末尾；
工具结果必须可控，不能无限增长；
历史要从原文逐步退化为摘要；
可重新获取的信息不要长期占用窗口。
```

## 结论

未来更可能标准化的是：

```text
- 上下文来源协议，例如 MCP
- Agent 通信协议，例如 A2A
- 工具 schema 格式
- memory / cache 的外部接口
```

短期内不太可能统一的是：

```text
- 最终 prompt/context 的具体拼接模板
- 每类上下文的 token budget
- 裁剪、摘要、重排和冲突处理策略
```

因为这部分直接影响 Agent 的质量、成本、速度和可靠性，仍然是各家产品和框架的核心差异化能力。

## 参考资料

- OpenAI Codex Prompting Guide: https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide
- OpenAI Responses API - Conversation State: https://developers.openai.com/api/docs/guides/conversation-state
- Anthropic Prompt Caching: https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching
- Anthropic Context Editing: https://docs.anthropic.com/en/docs/build-with-claude/context-editing
- Anthropic Claude Code Memory: https://docs.anthropic.com/en/docs/claude-code/memory
- Anthropic Claude Code Slash Commands: https://docs.anthropic.com/en/docs/claude-code/slash-commands
- Moonshot Kimi Context Caching: https://platform.moonshot.cn/docs/guide/use-context-caching-feature-of-kimi-api
- Z.ai Cache Capability: https://docs.z.ai/guides/capabilities/cache
