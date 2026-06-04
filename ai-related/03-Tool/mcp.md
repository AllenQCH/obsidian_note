---
title: "MCP 学习"
source: "OneNote: 呈辉 的笔记本/AI_related.one (于 2026-4-19)/mcp 学习"
author: "Allen"
published:
created: 2026-05-11
description: "MCP 的定义、架构、工作流程和与 Tool/Agent 的边界。"
tags: ["obsidian-note", "tech-note", "mcp", "tool", "agent"]
type: "tech-note"
status: "processed"
---

# MCP 学习

## 摘要

- MCP 是 Model Context Protocol，用于标准化 AI 应用与外部工具、数据源和上下文的连接。
- MCP 不是模型本身，LLM 通常属于 Host；MCP 负责 Host/Client/Server 之间的工具和资源通信。
- 它的价值是用统一、可控、安全的协议连接文件、数据库、API 和本地/远程能力。

## 核心内容

### MCP 是什么

MCP = Model Context Protocol，模型上下文协议。

它是一套开放协议，让大模型应用可以用统一、可控、安全的方式访问外部能力和上下文，例如文件系统、数据库、API、本地工具和远程服务。

### 直观比喻

| 比喻 | 含义 |
|---|---|
| AI 的 USB 接口 | 让 AI 接入不同外部设备和能力 |
| 驱动程序 | 让 AI 能连接数据库、API、文件系统 |
| 安全管道 | 通过受控通道访问敏感数据 |
| API 翻译器 | 把各种系统能力翻译成 AI 可用的协议形式 |

### 核心架构

MCP 遵循 Host / Client / Server 架构。

| 角色 | 职责 |
|---|---|
| Host | 发起请求的 LLM 应用，例如 Claude Desktop、IDE、AI 工具 |
| Client | Host 内部的协议客户端，与 MCP Server 保持 1:1 连接 |
| Server | 暴露资源、工具和提示词，连接本地或远程系统 |
| Local Resources | 本机文件、数据库等本地资源 |
| Remote Resources | 远程 API、服务、云资源 |

### LLM 在哪里

LLM 不在 MCP Server 里。通常：

```text
用户 -> Host（UI + LLM） -> MCP Client -> MCP Server -> 工具/数据源
```

MCP 只负责 LLM 如何用工具和上下文，不负责 LLM 怎么想。这样设计的好处是：以后换 GPT、Claude 或本地模型，Server 可以尽量不变。

### 基本工作流程

1. Host 创建 MCP Client。
2. Client 与 MCP Server 建立连接。
3. Server 声明自己提供哪些 tools、resources、prompts。
4. LLM 根据任务决定是否使用某个工具。
5. Client 把调用请求发送给 Server。
6. Server 执行实际操作并返回结果。
7. Host 把结果交给 LLM 继续推理。

### 实践线索

原 OneNote 笔记提到的 MCP 市场：

- https://mcp.so/
- https://mcpmarket.com/zh
- https://smithery.ai/

常见 Server 实现语言：Python 和 Node.js。常见启动方式涉及 `uvx` 或 `npx`。

## 可执行动作

- [ ] 按官方文档重新整理 MCP Server 最小实现。
- [ ] 补 Host / Client / Server 的真实调用时序图。
- [ ] 整理 MCP 与 Tool Calling、Skill 的边界。

## 相关链接

- [[01-01-LLM-总览]]
- [[Tool]]
- [[Function Tool Calling]]
- [[00-agent introduction]]
