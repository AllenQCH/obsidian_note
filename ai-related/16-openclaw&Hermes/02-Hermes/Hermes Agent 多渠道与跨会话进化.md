# Hermes Agent 多渠道与跨会话进化

## 核心理解

按 Hermes Agent 早期和核心设计来看，它本质上是一个 agent runtime。

Telegram、Discord、Slack、网页、短信、Email 等聊天工具，只是不同的输入输出入口。

所以可以这样理解：

> Hermes 是一个 agent，外面接了很多聊天窗口。

如果没有额外配置成多个 profile 或多个 agent，那么无论连接多少聊天工具、打开多少会话窗口，它们背后通常还是同一个 Hermes agent。

## 一个 agent，共享记忆和 skills

在这种设计下，不同渠道通常会共享：

- 同一套长期记忆
- 同一套 skills 和 tools
- 同一套系统人格或 SOUL 配置
- 同一套模型/provider 配置
- 同一个 agent 的行为习惯和自我调整结果

不同聊天窗口或不同平台上的会话，更多只是不同 session 或 conversation context。

短期上下文可能分开，但底层 agent 身份是同一个。

## 跨会话进化为什么成立

Hermes 的跨会话进化，逻辑上依赖一个前提：

> 不同会话产生的经验、记忆、偏好、skill 使用反馈，都会回流到同一个 agent 的长期状态里。

例如：

你在 Telegram 里告诉它：

> 以后给我写代码解释时，先讲结论，再讲实现。

之后你在 Discord 或 Web UI 里问代码问题，它也可能沿用这个偏好。

这不是因为 Telegram 和 Discord 之间直接通信，而是因为它们背后连接的是同一个 Hermes agent。

所以 Hermes 的一个核心优势是：

> 所有入口都在训练和塑造同一个长期助手。

## Hermes 与 OpenClaw 的思路差异

Hermes 早期核心思路：

> 多个入口进入同一个持续成长的 agent。

OpenClaw Gateway 思路：

> 多个入口通过 gateway 被路由到不同 agent，从而避免记忆、权限和人格混乱。

因此两者的目标并不完全一样。

Hermes 更适合把多个聊天渠道聚合到同一个长期助手上，让它跨会话积累偏好和经验。

OpenClaw 更适合做多 agent、多账号、多权限、多渠道的路由隔离。

## Hermes 后来的 Gateway 能力

Hermes 后来文档中也出现了 Messaging Gateway、multi-profile gateway、multiplex profiles 等能力。

这说明 Hermes 并不是完全没有 gateway。

更准确地说：

- Hermes 也有消息入口层
- Hermes 也可以支持多个 profile
- Hermes 的 profile 可以有各自的 bot token、session、memory、skills、provider keys
- Hermes 可以选择每个 profile 一个 gateway 进程，也可以通过 multiplex 让一个 gateway 管多个 profile

所以 OpenClaw 的优势不能简单理解成“Hermes 没有 gateway”。

更准确的区别是：

| 维度 | Hermes | OpenClaw |
| --- | --- | --- |
| 早期核心形态 | 一个强 agent，多入口接入 | gateway 路由多个 agent |
| 主要价值 | 跨会话记忆、skills 共享、长期进化 | 多 agent、多账号、多渠道隔离 |
| 多渠道含义 | 多个入口塑造同一个助手 | 多个入口被分发到不同 agent |
| 隔离能力 | 后来通过 profile/gateway 增强 | 从概念上更靠前 |

## 适合 Hermes 的场景

Hermes 更适合这些情况：

- 个人使用一个长期助手
- 希望 Telegram、Discord、网页等入口都共享同一个记忆
- 希望 agent 通过不同会话逐渐了解自己的偏好
- 希望 skills 和 tools 在多个入口之间复用
- 不太需要复杂的多账号、多权限、多 agent 路由

## 一句话总结

Hermes 的多渠道更像“一个 agent 伸出很多入口”，所以它天然适合跨会话记忆共享和长期进化；OpenClaw 的 gateway 更像“一个路由总台”，更强调把不同来源分发给不同 agent 并保持边界。
