---
title: "01-06-02-主流Agent的Memory实现对比"
source: "Codex / Claude Code / Gemini / Cursor official docs and product notes"
author: "Allen"
published:
created: 2026-07-21
description: "整理 Codex、Claude Code、Gemini、Cursor 等主流 AI Agent 的 memory 实现方式、载体和工程启发。"
tags: ["obsidian-note", "tech-note", "llm", "memory", "agent", "codex", "claude", "gemini", "cursor"]
type: "tech-note"
status: "processed"
aliases: ["Agent Memory实现对比", "Codex Claude Gemini Cursor memory", "主流AI Agent记忆机制"]
---

# 01-06-02-主流Agent的Memory实现对比

## 摘要

Codex、Claude Code、Gemini、Cursor 这些 Agent 的 memory，本质上都不是模型参数里真正“记住”，而是通过外部持久化信息实现：

```text
用户偏好 / 项目规则 / 历史任务 / 代码索引
  -> 保存到文件、配置、数据库、云端 memory 或索引系统
  -> 新任务开始时检索或加载
  -> 注入 prompt / context
  -> 模型表现得像“记得”
```

真正的差异在于：

- 记忆由谁写入：用户手写、Agent 自动生成、系统自动索引。
- 记忆存在哪里：Markdown 文件、本地 memory store、云端账户、项目目录、IDE 索引。
- 记忆如何生效：启动时全量加载、按路径触发、语义检索、用户主动引用。
- 记忆能否编辑：有些透明可编辑，有些是产品内部机制。

## 总览对比

| 产品 | 主要 memory 形态 | 存储 / 载入方式 | 典型用途 | 特点 |
|---|---|---|---|---|
| Codex | Memories、`AGENTS.md`、skills、thread / project context | Codex memory store、项目级 memory、项目文档和配置注入 | 项目规则、用户偏好、工作流经验 | 偏工程 agent，强调项目隔离和可配置 |
| Claude Code | `CLAUDE.md`、auto memory、subagent `MEMORY.md` | 会话启动时加载 Markdown memory；auto memory 可维护项目经验 | 项目约定、命令、架构、子 agent 专属知识 | Markdown 化明显，用户可读可改 |
| Gemini App | Saved info、past chats、instructions | Google 账户侧保存，按设置用于个性化回答 | 个人偏好、长期个人化信息 | 偏个人助手记忆 |
| Gemini CLI | `GEMINI.md`、`/memory add`、`save_memory`、Auto Memory | 层级扫描 `GEMINI.md` 并拼接进 prompt | CLI 项目规则、个人偏好、可复用经验 | 机制透明，和 Markdown memory 很接近 |
| Cursor | Rules、User Rules、Team Rules、`AGENTS.md`、代码库索引、会话搜索 | rules 注入上下文；代码库索引用于检索相关代码 | IDE 编码规则、代码上下文、团队规范 | 更偏 IDE 上下文工程 |

## Codex 的 memory

Codex 的 memory 可以理解为几层：

- Memory：保存可复用的用户偏好、项目经验或任务背景。
- Project-only memory：项目内隔离的 memory，不跨项目使用。
- `AGENTS.md`：项目级长期规则，不是普通 memory，但承担“稳定项目约定”的作用。
- Skills：可复用工作流和专门能力。
- MCP / connectors：实时外部信息源，不等同于 memory。

### 关键点

- ChatGPT memory 和 Codex memory 是不同体系。
- Codex 可以配置是否使用已有 memory，例如 `memories.use_memories = false` 时跳过 memory 注入。
- OpenAI 文档建议把必须稳定遵守的团队规则写进 `AGENTS.md` 或项目文档，而不是只依赖 memory。
- Memory 更适合“辅助回忆”，`AGENTS.md` 更适合“项目硬约定”。

### 工程理解

```text
历史任务 / 用户偏好 / 项目经验
  -> 生成或更新 Codex memory
  -> 新 session 时按范围检索
  -> 与 AGENTS.md、skills、MCP、当前代码一起进入上下文
```

## Claude Code 的 memory

Claude Code 的 memory 更像“可编辑的 Markdown 上下文系统”。

常见载体：

- `CLAUDE.md`：项目级 memory，常放架构说明、命令、代码规范、常用流程。
- `CLAUDE.local.md`：本地个人配置，适合不提交的个人偏好。
- `/memory` 命令：查看、编辑、管理 memory 文件。
- auto memory：Claude Code 自动维护的跨 session 项目记忆。
- subagent `MEMORY.md`：子 agent 自己的专属 memory。

### 关键点

- Claude Code 会在会话开始时加载相关 memory，把它作为 context。
- Memory 是提示上下文，不是强制规则。
- 如果要强制执行某些行为，应该用 hooks，而不是只写 memory。
- 子 agent 可以有自己的 `MEMORY.md`，用于保存专属领域知识。

### 工程理解

```text
CLAUDE.md / CLAUDE.local.md / auto memory / subagent MEMORY.md
  -> 会话启动时加载
  -> 进入 Claude 的上下文
  -> 工作中继续维护 auto memory 或让用户编辑文件
```

## Gemini 的 memory

Gemini 要分成 Gemini App 和 Gemini CLI。

### Gemini App

Gemini App 侧的 memory 更偏个人化助手：

- Saved info：保存用户明确提供的偏好和长期信息。
- Instructions：保存回答风格、偏好和使用方式。
- past chats memory：使用过去 Gemini 对话改善当前回答。
- 用户可以在设置里查看、关闭或删除相关记忆。

### Gemini CLI

Gemini CLI 的 memory 更像 Claude Code：

- 全局 `~/.gemini/GEMINI.md`
- 项目根目录 `GEMINI.md`
- 子目录 `GEMINI.md`
- `/memory show`
- `/memory add <text>`
- `save_memory` tool
- 实验性 Auto Memory

### 关键点

- Gemini CLI 会层级扫描 `GEMINI.md`，并把内容拼接进 prompt。
- `/memory add` 和 `save_memory` 会把 fact 写入全局 memory 文件。
- Auto Memory 会从历史 session transcript 里提出 memory update 或 reusable skill，但需要用户 review。

### 工程理解

```text
GEMINI.md 文件层级
  -> CLI 扫描并拼接
  -> 注入 prompt
  -> /memory add 或 save_memory 写回全局 GEMINI.md
```

## Cursor 的 memory

Cursor 官方文档里更常用的词是 Rules、Indexing、Context，而不是把所有东西都叫 memory。

但从机制上看，Cursor 的长期上下文主要来自：

- User Rules：个人全局偏好。
- Project Rules：项目级规则，通常放在 `.cursor/rules`。
- Team Rules：团队级规则，由团队管理。
- `AGENTS.md`：项目或子目录级 agent instructions。
- Codebase indexing：代码库索引，用于检索相关代码。
- Conversation search / side chats：历史对话可以搜索和引用。

### 关键点

- Cursor 明确把 Rules 当作持久、可复用的 prompt-level context。
- Rules 会在适用时放进模型上下文开头。
- Project Rules 可以随仓库版本控制。
- Codebase index 不是用户偏好 memory，但它是“项目知识召回”的核心。

### 工程理解

```text
Rules / AGENTS.md / User Rules / Team Rules
  -> 作为长期指令注入 context

Codebase index
  -> 检索相关代码
  -> 注入当前任务上下文

Past conversations / side chats
  -> 可搜索、可引用
```

## 本质区别

| 维度 | Codex | Claude Code | Gemini CLI | Cursor |
|---|---|---|---|---|
| 最核心载体 | memory store + `AGENTS.md` | `CLAUDE.md` | `GEMINI.md` | Rules + code index |
| 用户可编辑性 | 中等，`AGENTS.md` 强 | 强，Markdown 文件明显 | 强，`GEMINI.md` 透明 | 强，rules 文件可编辑 |
| 项目隔离 | 强 | 强 | 取决于 `GEMINI.md` 层级 | 强 |
| 自动生成 memory | 有 | 有 auto memory | 有实验性 Auto Memory | 更偏规则和索引 |
| 更适合 | 软件工程 agent | 项目助手 / 子 agent | CLI 项目助手 | IDE 编码助手 |

## 工程启发

### 1. Memory 不等于强制规则

Memory 是上下文，可能被模型忽略或误用。

强规则应该放在：

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- Cursor Rules
- hooks / lint / tests

### 2. Markdown 是个人 Agent memory 的好载体

Claude Code、Gemini CLI、Cursor、Codex 都不同程度支持 Markdown 形式的长期上下文。

对个人知识管理来说，Obsidian 很适合做 memory backend：

- 人能直接看。
- 人能手动改。
- GitHub 能同步。
- AI 能检索和整理。

### 3. Memory 要分层

建议个人 Agent memory 分成：

- user memory：长期偏好和个人习惯。
- project memory：项目目标、技术栈、目录结构、约束。
- task memory：某次任务的过程和结果。
- procedure memory：可复用流程。
- source memory：外部资料索引。

### 4. Memory 要有生命周期

好的 memory 不是无限堆积，而是要有：

- 来源
- 时间
- 适用范围
- 置信度
- 是否过期
- 是否可删除
- 与旧 memory 冲突时的更新策略

## 对自己的 Obsidian 工作流启发

可以把当前 vault 设计成个人 AI memory：

- `ai-related/02-LLM`：AI 概念和理论。
- `ai-related/09-agent`：Agent 框架和运行模式。
- `my-multi-agents`：自己的 agent 设计和案例。
- `Codex工作台`：Codex 使用、流程、复盘。
- `z_pictures`：图片和附件。

后续可以新增几个长期 memory 笔记：

- `用户偏好-memory.md`
- `项目背景-memory.md`
- `AI资料索引-memory.md`
- `Agent工作流-memory.md`
- `任务复盘-memory.md`

## 来源

- OpenAI Codex customization / memories: https://learn.chatgpt.com/docs/customization/memories
- OpenAI Codex config reference: https://developers.openai.com/codex/config
- Anthropic Claude Code memory: https://docs.anthropic.com/en/docs/claude-code/memory
- Anthropic Claude Code memory tool: https://docs.anthropic.com/en/docs/claude-code/memory-tool
- Google Gemini Apps saved info: https://support.google.com/gemini/answer/16868299
- Gemini CLI memory documentation: https://google-gemini.github.io/gemini-cli/docs/cli/memory
- Cursor Rules documentation: https://cursor.com/docs/rules
- Cursor codebase indexing documentation: https://cursor.com/docs/context/codebase-indexing

## 相关链接

- [[01-06-00-LLM-Memory]]
- [[01-06-01-AI-Memory-GitHub资料整理]]
- [[01-04-00-LLM-Context]]
- [[02-02-RAG-Retrieval召回与混合检索]]
- [[04-RAG-高级模式]]
