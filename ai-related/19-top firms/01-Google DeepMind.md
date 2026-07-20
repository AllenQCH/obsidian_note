---
title: "01-Google DeepMind"
source: "ai-related/19-top firms/01-Google DeepMind.md"
author: "笨笨"
published:
created: 2026-07-07
description: "Google DeepMind 的发展脉络、代表成果、研究方向与对 AI Agent 的影响。"
tags: ["obsidian-note", "ai", "deepmind", "gemini", "agent", "research"]
type: "note"
status: "processed"
---

# 01-Google DeepMind

## 摘要

Google DeepMind（原 DeepMind）是全球最顶尖的 AI 研究机构之一，现在隶属于 Google，也是 **AGI、强化学习、科学 AI、Gemini、AI Agent** 等方向的重要推动者。

一句话概括：
> 如果 OpenAI 的目标是打造通用人工智能（AGI），那么 Google DeepMind 可以理解为 Google 实现 AGI 的核心研究团队。

## 核心内容

### 1. 发展历程

#### 2010：成立
DeepMind 成立于英国伦敦。
创始人：
- Demis Hassabis
- Shane Legg
- Mustafa Suleyman

其中最知名的是 **Demis Hassabis**。
他的背景很特别：
- 国际象棋神童
- 电子游戏设计师
- 神经科学博士
- AI 科学家

所以 DeepMind 从一开始就很强调：
> 用神经科学启发人工智能。

#### 2014：被 Google 收购
Google 以约 5 亿美元收购 DeepMind。
这是当时 AI 领域最受关注的收购之一。

之后 DeepMind 一直保持相对独立的研究文化。

#### 2023：Google DeepMind 成立
Google 将：
- DeepMind
- Google Brain
正式合并，形成 **Google DeepMind**。
负责人仍然是 **Demis Hassabis**。

### 2. 为什么 DeepMind 这么有名

它出名并不是因为 chatbot 起家，而是因为它几乎改变了现代 AI 的几个关键方向。

#### AlphaGo
2016 年，**AlphaGo** 击败李世石。
之后又击败柯洁。

AlphaGo 的核心是：
- 深度学习
- 强化学习（Reinforcement Learning）
- 蒙特卡洛树搜索（MCTS）

这件事的重要性在于：
- 围棋长期被视为比国际象棋复杂得多
- 它证明了“学习 + 搜索”的结合可以跨越非常复杂的决策空间
- 后来的很多 agent 搜索、planning 思想都能看到类似影子

#### AlphaZero
比 AlphaGo 更进一步。
它不依赖人类棋谱，而是：
- 自己和自己下棋
- 不断提升
- 最后打败传统程序

而且：
- 国际象棋
- 将棋
- 围棋
都可以由同一套核心思路处理。

这说明 DeepMind 很强的一点是：
> 它不仅在做 task-specific system，也在寻找更通用的 learning / planning 原理。

#### AlphaFold
很多科学家认为，**AlphaFold** 才是 DeepMind 最大的科学贡献之一。

它解决了蛋白质结构预测这个长期科学难题，对：
- 生物学
- 制药
- 医学
都有巨大影响。

这也是 DeepMind 和很多只做产品型 AI 公司的根本差别：
> 它不只是做“更聪明的聊天模型”，还在做会改变科学研究范式的 AI。

#### Gemini
现在 Google 的核心大模型体系 **Gemini**，本质上就是由 **Google DeepMind** 主导研发。

包括：
- Gemini 2.x
- 多模态模型
- 长上下文
- agent 能力

### 3. DeepMind 的几个重点研究方向

#### ① 强化学习（Reinforcement Learning）
这是 DeepMind 最标志性的方向之一。
代表：
- AlphaGo
- AlphaZero
- Atari 游戏研究

我的理解：
- 如果你研究 agent，DeepMind 的 RL 背景非常值得看
- 因为 agent 的 planning、search、long horizon execution，很多底层直觉都和 RL 世界有关

#### ② 大语言模型（LLM）
代表是 **Gemini**。
重点能力包括：
- 长上下文
- 推理
- 多模态
- tool use

#### ③ Agent
这两年 Google DeepMind 在 agent 上投入很重。
常见主题包括：
- 多 Agent
- Planning
- Memory
- Tool Use
- Eval
- Reliability

这也是我现在最值得跟踪它的地方，因为它不只在发模型，也在补整套 agent system 的方法论。

#### ④ 科学 AI
这是 DeepMind 很独特的强项。
例如：
- AlphaFold
- 天气预测
- 材料科学
- 数学
- 机器人

### 4. DeepMind 和 OpenAI 的差异

| 对比项 | Google DeepMind | OpenAI |
|---|---|---|
| 隶属 | Google | 独立公司（与 Microsoft 深度合作） |
| 起点 | 强化学习、科学研究 | 通用 AI、语言模型 |
| 代表成果 | AlphaGo、AlphaFold、Gemini | GPT 系列、ChatGPT |
| 优势 | 强化学习、科学 AI、多模态、研究深度 | LLM、产品速度、开发者生态 |

### 5. 对 AI Agent 的影响

如果我最近重点在研究 Agent，那么 DeepMind 最值得看的几个方向是：

1. **Planning**
   - agent 在执行前如何做规划
   - 而不是直接生成答案

2. **Tool Use**
   - 模型如何合理调用搜索、浏览器、计算器、代码执行等外部工具

3. **Long Horizon Tasks**
   - agent 如何完成几十步甚至上百步的复杂任务

4. **Eval & Reliability**
   - agent 如何被稳定评测
   - 如何区分“偶尔成功”和“可靠成功”

### 6. 为什么程序员值得持续关注 DeepMind

如果我的目标是继续往 AI Agent 工程师方向走，DeepMind 值得持续追踪，因为它经常提供：
- 高质量研究
- 方法论级别的系统思考
- 会被业界反复复用的工程主题

很多后来被行业广泛采用的思想，都能在它的研究中找到源头或重要推动力。

### 7. 本页整理时参考的稳定来源

- 用户给出的这版 DeepMind 介绍
- Google DeepMind 官方 About 页：`https://deepmind.google/about/`

## 可执行动作

- [ ] 后续补一页：DeepMind 最值得追的 Agent / Gemini / Research 博客索引
- [ ] 后续补一页：DeepMind vs Anthropic vs OpenAI 在 agent engineering 上的差异

## 相关链接

- [[00-top firms总览]]
- [[02-OpenAI]]
- [[03-Anthropic]]
- [[04-Meta AI]]
- [[05-xAI]]
- [[01-01-LLM-总览]]
- [[05-agent.md.md]]
