# OpenClaw 与 Hermes Gateway 对比 - 本次讨论

## 来源

本笔记整理自一次关于 OpenClaw Gateway、多人格、多渠道、session、multi-agent，以及 Hermes 对照关系的讨论。

讨论中的默认前提：

- 暂时不讨论底层 LLM 的差异
- 可以假设底层模型统一是 `gpt5.6sol`
- 重点看 Gateway、agent、session、channel、multi-agent 的系统设计关系

## 一句话总览

OpenClaw 更像“一个 Gateway 路由多个隔离 agent”；Hermes 更像“一个长期 agent 接多个入口并持续进化”。

```text
OpenClaw：多个聊天入口 → Gateway → 不同 agent / 不同人格 / 不同权限
Hermes：  多个聊天入口 → Gateway 或消息入口层 → 同一个长期 agent / 共享记忆
```

## OpenClaw

### Gateway 到底是什么意思

OpenClaw 的 Gateway 可以理解成一个常驻在本机的 AI 助手中控服务。

它不是传统后端里的 API Gateway，也不是单纯的 LLM API 转发器。它更像 OpenClaw 本机系统中的：

- 统一入口
- 消息路由层
- 会话管理层
- agent 分发层
- 工具和本机能力调度层
- 多账号、多渠道、多权限的隔离层

直观结构：

```text
微信 / Telegram / WhatsApp / Discord / Web UI / CLI
        ↓
同一个本机 OpenClaw Gateway
        ↓
某个 agent / 某个 session / 某套工具权限
        ↓
底层 LLM，例如默认统一配置成 gpt5.6sol
```

所以，多个聊天软件可以同时连接同一个本机 Gateway。这些聊天软件通常不是各自直接连底层 LLM，而是先进入 Gateway，再由 Gateway 统一判断如何处理。

### Gateway 是否对接同一个 LLM

可以。

如果配置里默认模型都是 `gpt5.6sol`，那么多个聊天入口、多个 agent，都可以共用同一个底层 LLM。

但更准确的理解是：

```text
多个聊天入口 → 同一个 Gateway → 按规则进入某个 agent → agent 再调用默认或指定 LLM
```

底层模型只是推理能力。OpenClaw 的人格、权限、记忆、工具边界，主要由 agent 配置决定，而不是由模型名决定。

### 人格是怎么实现的

OpenClaw 的“多人格”本质上是多个 agent 配置。

一个 agent 可以有自己的：

- workspace
- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- 本地 notes / persona rules
- 长期记忆
- session store
- 工具权限
- auth profile
- 默认模型配置

所以“人格”的来源不是 LLM 本身，而是 agent 的上下文与配置。

```text
Gateway
  ├─ personal-agent
  │   ├─ 私人 prompt
  │   ├─ 私人记忆
  │   ├─ 私人 workspace
  │   └─ 私人工具权限
  │
  └─ work-agent
      ├─ 工作 prompt
      ├─ 工作记忆
      ├─ 工作 workspace
      └─ 工作工具权限
```

即使两个 agent 底层都调用 `gpt5.6sol`，只要注入的 prompt、记忆、工作目录、权限不同，它们表现出来的人格也会不同。

### Channel、Session、Agent 的关系

这三个概念要分开：

```text
channel = 消息从哪里来，例如 Telegram / Discord / WhatsApp
session = 当前这段对话上下文
agent   = 人格、记忆、权限和工作目录的承载单位
```

所以：

```text
人格 ≠ session
人格 ≠ channel
人格 = 被路由到的 agent
```

如果多个渠道都路由到同一个 agent：

```text
Telegram → personal-agent
Discord  → personal-agent
Web UI   → personal-agent
```

那么它们的人格是一样的，只是 session 不同。

如果不同渠道被绑定到不同 agent：

```text
Telegram → personal-agent
Discord  → community-agent
Slack    → work-agent
```

那么这些渠道就表现为不同人格。

### Discord / Telegram / 多 bot 是否自动对应不同人格

不会自动对应。

Discord 和 Telegram 只是渠道。一个渠道里有多个 bot，也只是多个入口或账号。是否对应不同人格，取决于 Gateway 的路由配置。

例如：

```text
Discord bot A → community-agent
Discord bot B → ops-agent
```

这就是两个 bot 对应两个人格。

但如果配置成：

```text
Discord bot A → personal-agent
Discord bot B → personal-agent
```

那么两个 bot 虽然入口不同，底层人格仍然是同一个。

### Multi-Agent 是什么意思

OpenClaw 里的 multi-agent 可以分两层。

第一层是常驻 agent 的多实例路由：

```text
Telegram 私聊        → personal-agent
WhatsApp 家庭群      → family-agent
Slack 公司 workspace → work-agent
Discord 社群频道     → community-agent
飞书运维群           → ops-agent
```

这种 multi-agent 主要解决：

- 私人和工作记忆不要混
- 不同渠道使用不同语气和身份
- 公开群聊不能访问私人文件
- 运维 agent 可以看日志，但普通社群 agent 不能
- 不同客户、不同项目、不同账号需要独立上下文

触发方式通常不是模型自己决定“变成 multi-agent”，而是 Gateway 收到消息后按规则路由：

```text
收到消息 → 识别 channel/accountId/peer/guildId/teamId → 匹配 binding → 进入某个 agent
```

第二层是任务执行时的 sub-agent：

```text
主 agent：帮我调研 5 个竞品并总结技术路线
  ├─ sub-agent 1：查竞品 A/B
  ├─ sub-agent 2：查竞品 C/D/E
  └─ sub-agent 3：整理结论和表格
```

这类 sub-agent 是复杂任务中的临时分工，不一定是长期存在的人格。

### OpenClaw 的核心价值

OpenClaw Gateway 的优势不是“它支持很多聊天软件”，而是：

> 它把多渠道消息路由到不同 agent，并管理记忆、权限、账号、会话之间的边界。

适合 OpenClaw 的场景：

- 要跑多个长期 agent
- 私人、工作、运维、客服、社群需要分开
- 不希望不同渠道共享同一份记忆
- 不同渠道需要不同权限
- 有多个账号、多个 bot、多个 workspace
- 希望路由规则作为基础设施管理，而不是写进 prompt
- 希望一个 Gateway 管理一组 agent

## Hermes

### Hermes 的核心理解

Hermes 更适合先理解成一个长期 agent runtime。

它的多渠道更像：

```text
Telegram / Discord / Slack / Web UI / Email
        ↓
同一个 Hermes agent
        ↓
共享记忆 / 共享 skills / 共享人格 / 共享长期状态
```

也就是说，如果没有额外配置成多个 profile 或多个 agent，那么多个聊天入口背后通常还是同一个 Hermes agent。

### Hermes 的多渠道意义

Hermes 的多渠道重点不是“把不同来源隔离到不同人格”，而是“让多个入口共同塑造同一个长期助手”。

例如：

```text
你在 Telegram 告诉 Hermes：
以后给我写代码解释时，先讲结论，再讲实现。

之后你在 Discord 或 Web UI 问代码问题，
它也可能沿用这个偏好。
```

这不是因为 Telegram 和 Discord 直接通信，而是因为它们背后连接的是同一个 Hermes agent。

### Hermes 的跨会话进化

Hermes 的跨会话进化依赖一个前提：

> 不同会话产生的经验、记忆、偏好、skill 使用反馈，会回流到同一个 agent 的长期状态里。

所以 Hermes 的优势是：

- 一个助手长期跟随用户
- 多个入口共享长期记忆
- skills 和 tools 在多个入口之间复用
- 用户偏好可以跨聊天软件生效
- 越用越像同一个熟悉你的助手

### Hermes 也可以有 Gateway / Profile

Hermes 并不是完全没有 Gateway。

更准确地说：

- Hermes 也可以有消息入口层
- Hermes 也可以支持多个 profile
- profile 可以有自己的 bot token、session、memory、skills、provider keys
- 可以每个 profile 一个 Gateway 进程
- 也可以通过 multiplex 让一个 Gateway 管多个 profile

所以 OpenClaw 的优势不能简单理解成“Hermes 没有 Gateway”。

更准确的区别是：

```text
Hermes 早期核心：一个强 agent，多入口接入，强调跨会话进化
OpenClaw 核心：一个 Gateway，路由多个 agent，强调边界和隔离
```

### 适合 Hermes 的场景

Hermes 更适合这些情况：

- 个人使用一个长期助手
- 希望 Telegram、Discord、网页等入口都共享同一个记忆
- 希望 agent 通过不同会话逐渐了解自己的偏好
- 希望 skills 和 tools 在多个入口之间复用
- 不太需要复杂的多账号、多权限、多 agent 路由

## 对照表

| 维度 | OpenClaw | Hermes |
| --- | --- | --- |
| 核心形态 | 一个 Gateway 路由多个 agent | 一个长期 agent 接多个入口 |
| Gateway 价值 | 路由、隔离、权限边界、账号绑定 | 消息入口、profile multiplex、长期助手接入 |
| 多渠道含义 | 多个来源可以分发到不同 agent | 多个入口共同塑造同一个 agent |
| 人格来源 | agent 配置、prompt、记忆、权限 | agent/profile 的长期状态和配置 |
| session 作用 | 当前对话上下文，通常与 agent 分离 | 当前对话上下文，经验可回流长期 agent |
| multi-agent 重点 | 多个隔离 agent 的路由和管理 | 不是早期核心，后来可通过 profile/gateway 增强 |
| 最适合 | 多身份、多账号、多权限、多团队 | 个人长期助手、跨会话记忆、持续进化 |

## 最终结论

如果目标是“一个熟悉我的长期助手，在不同入口都能延续记忆和偏好”，Hermes 的思路更自然。

如果目标是“同一台机器上管理多个不同身份、不同权限、不同记忆边界的 agent”，OpenClaw 的 Gateway 思路更清晰。

最终可以用这句话记：

> Hermes 是一个长期助手伸出很多入口；OpenClaw 是一个本机总台管理很多助手。

## 相关笔记

- [[OpenClaw Gateway 多渠道与多 Agent 路由]]
- [[Hermes Agent 多渠道与跨会话进化]]
