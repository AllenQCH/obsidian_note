# OpenClaw Gateway 多渠道与多 Agent 路由

## 核心理解

OpenClaw 的 Gateway 可以理解成一个“消息总交换台”。

它本身不负责真正思考，而是负责判断：

- 这条消息从哪个聊天渠道来
- 属于哪个账号
- 应该交给哪个 agent
- 应该放进哪个会话上下文
- 回复应该从哪个渠道、哪个账号发回去

所以 OpenClaw 的“多渠道”优势，不只是“支持 Telegram、Slack、Discord、飞书、WhatsApp 等很多聊天工具”，而是把渠道、账号、会话、agent、记忆、权限之间的映射关系做成一层基础设施。

## 多渠道不是重点，路由和隔离才是重点

如果只是“很多聊天软件都能接入 AI”，那 Hermes Agent 也能做到很多。

OpenClaw 更强调的是：

> 不同来源的消息，可以被稳定地路由到不同 agent、不同账号、不同记忆、不同权限、不同人格。

例如：

| 来源 | 路由到 | 记忆和权限 |
| --- | --- | --- |
| Telegram 个人号 | personal-agent | 个人日程、私人文件 |
| Slack 公司频道 | work-agent | 公司项目、工作工具 |
| Discord 社群 | community-agent | 社群规则、公开知识 |
| 飞书运维群 | ops-agent | 部署工具、日志权限 |
| WhatsApp 家人群 | family-agent | 家庭提醒、低权限 |

这里的价值不是“能接 Slack”，而是 Slack 里的工作消息不会混进 Telegram 的私人记忆里，Discord 社群消息也不会误用私人 agent 的权限。

## OpenClaw Gateway 解决的问题

### 1. 上下文污染

如果所有渠道都接到同一个 agent，私人信息、工作信息、社群语气、运维任务可能会混在一起。

例如：

- Telegram 里说：“帮我记一下我妈的生日”
- Slack 里说：“帮我整理客户需求”
- Discord 里说：“用轻松语气回复这个用户”

如果这些都进入同一个长期记忆和同一个人格，agent 时间久了会变得混乱。

Gateway 的价值是：

> 不同渠道可以进入不同的“脑子”。

### 2. 权限边界

不同 agent 可以有不同权限。

例如：

- personal-agent 可以读个人笔记、日历、邮件
- work-agent 可以访问 GitHub、Jira、公司 Slack
- community-agent 只能回复公开问题，不能读私有文件
- ops-agent 可以看日志，但执行危险命令前需要更严格限制

如果所有渠道都接到同一个高权限 agent，外部群聊里的一条恶意指令就可能触碰不该触碰的工具。

OpenClaw 的路由隔离可以降低这种风险。

### 3. 多账号绑定

“多渠道”不只是 Telegram、Slack、Discord 这种大类，也包括同一渠道下的多个账号。

例如：

- Telegram bot A 给 personal-agent
- Telegram bot B 给 customer-agent
- Slack workspace A 给公司 A
- Slack workspace B 给公司 B
- Discord server A 给游戏社群 agent
- Discord server B 给开源项目 agent

OpenClaw 的 agentId、accountId、channel binding 这类设计，主要就是为了处理这种映射关系。

## 和 Hermes 的直观区别

Hermes 早期更像：

> 一个很强的 agent，开了很多聊天软件窗口。

OpenClaw Gateway 更像：

> 一个前台系统，后面坐着多个不同岗位的 agent，前台根据来源、账号、群、规则，把消息分给正确的人。

## 什么时候 OpenClaw Gateway 的优势明显

OpenClaw 更适合这些情况：

- 要跑多个长期 agent
- 私人、工作、运维、客服、社群需要分开
- 不希望不同渠道共享同一份记忆
- 不同渠道需要不同权限
- 有多个账号、多个 bot、多个 workspace
- 希望路由规则作为基础设施管理，而不是写进 prompt
- 希望一个 gateway 管理一组 agent

如果只是个人使用一个万能助手，OpenClaw Gateway 的优势不一定明显。

## 一句话总结

OpenClaw Gateway 的优势不是“它支持很多渠道”，而是“它把多渠道消息路由到不同 agent，并管理记忆、权限、账号、会话之间的边界”。

## 本轮讨论整理：Gateway、人格、Session、Multi-Agent

### 1. Gateway 是不是本机通道

可以先把 OpenClaw Gateway 理解成一个常驻在本机的 AI 助手中控服务。

它不是传统后端里的 API Gateway，也不是单纯的 LLM API 转发器。它更像本机 OpenClaw 系统的“统一入口 + 消息路由 + 工具调度 + 会话管理”。

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

所以，如果先不讨论底层模型差异，可以理解为：

- 多个聊天软件可以同时接入同一个 Gateway
- 这些入口不是各自直接连接 LLM，而是先进入 Gateway
- Gateway 可以默认调用同一个底层 LLM
- 但 Gateway 本身还负责判断消息来源、会话归属、agent 路由、工具调用和回复通道

更准确的公式是：

```text
多个聊天入口 → 同一个 Gateway → 按规则进入某个 agent → agent 再调用默认或指定 LLM
```

### 2. 人格是怎么实现的

OpenClaw 里的“人格”本质上不是模型名决定的，而是 agent 配置决定的。

一个 agent 可以有自己的：

- workspace
- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- 本地 notes / persona rules
- 记忆和 session store
- 工具权限
- auth profile
- 默认模型配置

所以“多人格”更准确地说是：

> 一个 Gateway 下运行多个彼此隔离的 agent，每个 agent 有自己的 prompt、记忆、工作目录、权限和会话库。

例如：

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

在这个设计里：

```text
人格 = agent 的配置、记忆、规则、权限
不是 = LLM 模型本身
```

即使底层都用同一个 `gpt5.6sol`，只要不同 agent 注入的上下文、记忆、权限不同，表现出来的人格就可以不同。

### 3. 不同渠道的人格是否一样

不一定。关键看渠道被 Gateway 路由到哪个 agent。

如果多个渠道都路由到同一个 agent：

```text
Telegram → personal-agent
Discord  → personal-agent
Web UI   → personal-agent
```

那它们的人格就是一样的，只是 session 不同。

这里要区分三个概念：

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

如果配置成不同渠道路由到不同 agent：

```text
Telegram → personal-agent
Discord  → community-agent
Slack    → work-agent
```

那这些渠道就表现为不同人格。

同一个 Discord 里有两个 bot 也一样。两个 bot 不会天然变成两个人格，只有在 Gateway 配置中把它们绑定到不同 agent 时，才会是两个人格：

```text
Discord bot A → community-agent
Discord bot B → ops-agent
```

如果两个 bot 都绑定到同一个 agent：

```text
Discord bot A → personal-agent
Discord bot B → personal-agent
```

那底层人格仍然是同一个。

### 4. Multi-Agent 是什么意思

OpenClaw 里的 multi-agent 可以分两层理解。

第一层是常驻 agent 的多实例路由：

> 一个 Gateway 中运行多个隔离 agent，Gateway 根据渠道、账号、群、私聊、server、workspace 等信息，把消息分发给对应 agent。

典型场景：

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

它的触发方式通常不是“模型自己决定变成 multi-agent”，而是 Gateway 的路由规则触发：

```text
收到消息 → 识别 channel/accountId/peer/guildId/teamId → 匹配 binding → 进入某个 agent
```

第二层是任务执行时的 sub-agent：

> 主 agent 遇到复杂任务时，临时派出子 agent 并行处理部分工作。

例如：

```text
主 agent：帮我调研 5 个竞品并总结技术路线
  ├─ sub-agent 1：查竞品 A/B
  ├─ sub-agent 2：查竞品 C/D/E
  └─ sub-agent 3：整理结论和表格
```

这类 sub-agent 更像任务分工，不一定是长期存在的人格。

### 5. 最终关系图

```text
Gateway 是总入口和调度层
Agent 是人格单位
Session 是对话单位
Channel 是消息来源
Binding 决定 channel/session 进入哪个 agent
LLM 是底层推理模型，可以多个 agent 共用同一个模型
Multi-agent 是一个 Gateway 管多个隔离 agent
Sub-agent 是复杂任务里的临时分工
```

一句话：

> OpenClaw 的 Gateway 不是“一个聊天软件接一个模型”，而是“多个入口进入一个本机中控，中控再按规则分配到不同人格、会话、权限和工具系统”。
