---
title: "05-loop engineering"
source: "ai-related/10-engineering/05-loop engineering.md"
author: "Allen"
published:
created: 2026-07-02
description: "loop engineering 的结构化笔记：从第一性原理、工程分层与可执行实践理解如何把 AI 从单轮问答推进到可持续闭环。"
tags: ["obsidian-note", "tech-note", "loop", "loop-engineering", "agent", "harness", "automation"]
type: "tech-note"
status: "processed"
---

# 05-loop engineering

## 摘要

loop engineering 不是“把 prompt 写得更长”，而是：**把“你亲自一轮一轮盯着 AI 干活”这件事，改造成一个可自动运行、可校验、可恢复、可持续优化的闭环系统。**

如果说：
- [[01-prompt engineering]] 关注“单次输入怎么写”
- [[02-context engineering]] 关注“上下文怎么组织”
- [[03-harness engineering]] 关注“单个 agent 运行在什么支架里”

那么 **loop engineering** 关注的就是：**如何让多个回合、多个触发器、多个校验环节、多个状态文件，组成一个你可以暂时离开、但它还能继续推进的执行闭环。**

它之所以突然火，不是因为大家发明了全新东西，而是因为 coding agent 已经从“聊天助手”进入“可长期执行的工程对象”阶段。此时，真正稀缺的东西不再只是生成，而是：
- 任务怎么持续推进
- 失败怎么被发现
- 结果怎么被验证
- 状态怎么被继承
- 系统怎么自己越跑越稳

## 一句话定义

> loop engineering = 设计一个让 AI 在“目标—执行—校验—反馈—续跑”中持续工作的系统，而不是你亲自每一轮都去 prompt 它。

## 为什么它会出现：从第一性原理看

### 1. LLM 的本质强项不是“完成任务”，而是“生成下一步”
LLM 本质上擅长的是：
- 根据当前上下文生成下一段最可能的动作/文本
- 在局部推理里给出一个看起来合理的候选方案

但真实工程任务需要的是：
- 跨多轮推进
- 跨多个文件/工具/环境执行
- 出错后恢复
- 对结果做可信校验
- 在长时间尺度上不丢目标

所以，**单次回答能力 ≠ 长程交付能力**。

### 2. 真正的工程问题不在“回答”，而在“闭环”
一个任务能否完成，取决于 5 个问题：
1. **目标是否被明确表示**
2. **行动是否能实际发生**（工具、代码、环境、权限）
3. **结果是否能被验证**
4. **失败是否能被重试或回滚**
5. **状态是否能跨轮次保留下来**

这 5 个问题没有一个是单靠 prompt 就能彻底解决的。

### 3. 所以 loop engineering 的核心不是“更会说”，而是“更会组织反馈回路”
本质上，loop engineering 处理的是：
- **目标回路**：当前要完成什么
- **执行回路**：谁去做、怎么做
- **校验回路**：怎么知道做对了
- **记忆回路**：下次怎么接着做
- **优化回路**：如何根据历史结果持续改进

## 它和 prompt / context / harness 的关系

### 1. prompt engineering
关注点：单轮指令质量。

适用场景：
- 一次性问答
- 文案生成
- 简单代码片段

局限：
- 它默认“人一直在线”
- 它不天然处理状态、恢复、验证

### 2. context engineering
关注点：给模型喂什么上下文、按什么顺序喂。

适用场景：
- 大上下文组织
- 检索增强
- 多文档任务

局限：
- 仍然主要解决“这一轮怎么想”
- 不天然解决“下一轮怎么继续”

### 3. harness engineering
关注点：给单个 agent 一个稳定的执行支架。

包括：
- 工具调用
- 状态持久化
- 恢复机制
- 任务推进框架

### 4. loop engineering
关注点：**把一个或多个 harness 串成闭环，让任务能自动被触发、推进、校验、复盘和再优化。**

一句话区分：
- prompt：写一句话
- context：喂一堆材料
- harness：搭一个工作台
- loop：让工作台自己按节奏反复运转

## 主流观点汇总

### Addy Osmani：loop 是“用系统替代你自己做 prompting”
Addy 把 loop engineering 定义得很直接：
- 不再是你亲自一轮轮给 agent 下指令
- 而是你设计一个系统，由系统替你持续 prompt / 调度 / 交接 agent

他提出了 5 个核心部件 + 1 个记忆层：
1. **Automations**：定时发现工作、自动 triage
2. **Worktrees**：并行隔离，避免多个 agent 互相踩文件
3. **Skills**：把项目知识写下来，避免 agent 每次重猜
4. **Plugins / connectors**：打通 issue tracker、数据库、Slack、MCP 等
5. **Sub-agents**：执行与评审分离，不让同一个 agent 既当运动员又当裁判
6. **State / memory**：把进度和上下文写到对话外（文件、看板、Linear、markdown）

这个定义非常适合工程实践，因为它直接回答了“loop 需要哪些最小构件”。

### LangChain：loop 不是一个环，而是“多层 loop stack”
LangChain 把 loop 拆成 4 层：
1. **Agent loop**：模型调用工具直到任务完成
2. **Verification loop**：加 grader / rubric，不合格就反馈重试
3. **Event-driven loop**：由 cron / webhook / 事件触发 agent 自动运行
4. **Hill-climbing loop**：分析历史 trace，反过来优化 prompt / tool / harness 配置

这个视角很有价值，因为它说明：
- loop engineering 不是只有“执行”
- 更关键的是“验证”和“持续优化”

### CodeRabbit：好 loop 的标准是“你能走开，它还靠谱”
CodeRabbit 的表述非常工程化：
- loop 的目标不是“自动化一次”
- 而是设计一个 **you can actually walk away from** 的系统

它强调了几个关键条件：
- 有稳定目标，而不是每次标准都在变
- 有可信质量门禁，而不是 agent 自己说“我做完了”
- 有状态文件，保证每次 run 不是重新冷启动
- 适合“小而可验证”的任务，而不是开放式大创造

它的判断很实用：
- **稳定目标 → 值得建 loop**
- **移动目标 → 继续手动 prompt 更划算**

### iii.dev：loop engineering 本质上就是软件工程 / 分布式系统
iii.dev 的反驳很重要：
- 这不是神秘新学科
- 很多所谓 loop primitives，本质上就是老的软件工程/分布式系统原语

比如：
- schedule = cron
- external memory = key-value store / durable state
- verifier = retry + rubric + consumer
- triage inbox = dead-letter queue
- traces = observability pipeline
- sub-agents = 隔离 worker

这个观点的重要性在于：
**它帮你去魅。**

loop engineering 不神秘，核心仍然是：
- 状态
- 调度
- 隔离
- 校验
- 观测
- 恢复

### Jeena：loop 很容易“转起来”，但不一定“转得更好”
Jeena 的翻译实验是一个很好的反例：
- 建了 plan → execute → critique → repair 回路
- 加了 reference translation 作为 witness
- 加了 memory 避免术语漂移
- 结果 critic 一直不满意，loop 不断回转，但质量并没有明显提升

这个案例说明：
- loop ≠ 必然更好
- 如果 verifier 太严、executor 太弱，loop 只会空转
- 没有退出条件、回退策略、成本上限时，loop 会变成磨损机器

## 钱学森工程架构视角：把 loop engineering 看成“复杂系统工程”

如果按钱学森式系统工程思路看，loop engineering 不是一个技巧，而是一个 **由目标、结构、控制、信息、反馈、演化组成的复杂系统**。

### 1. 目标层：任务闭环要服务什么结果
首先定义系统目标，不是“让 AI 多跑几轮”，而是：
- 更快完成任务
- 更少人工介入
- 更稳定的质量
- 更低的返工率
- 更强的跨轮连续性

### 2. 结构层：系统由哪些部件组成
最常见部件：
- 任务入口（issue / 待办 / 用户请求）
- 调度器（cron / webhook / 手动触发器）
- 执行器（主 agent）
- 评审器（grader / verifier / test runner / reviewer agent）
- 记忆层（markdown / db / board / progress file）
- 工具层（MCP / shell / browser / git / CI）
- 观察层（logs / trace / metrics / alerts）
- 人类干预口（审批、回退、升级）

### 3. 控制层：什么时候前进，什么时候重试，什么时候停
一个成熟 loop 必须定义：
- 成功条件
- 失败条件
- 最大重试次数
- 超时条件
- 人工接管条件
- 成本阈值（token / 时间 / CI 次数）

没有控制层的 loop，只是“自动空转”。

### 4. 信息层：信息如何流动
信息要在这些对象之间流动：
- 用户意图
- 项目约束
- 中间结果
- 校验反馈
- 历史状态
- 下一步计划

这里最重要的一条是：
**不要把连续性寄托在模型脑子里，而要寄托在外部可读写状态里。**

### 5. 反馈层：系统靠什么自我修正
反馈可以分 3 种：
- **即时反馈**：测试通过/失败、lint 结果、API 响应
- **阶段反馈**：PR review、验收结果、部署结果
- **长期反馈**：哪些 loop 常失败、哪些 verifier 太贵、哪些任务最适合自动化

### 6. 演化层：系统如何越跑越强
好的 loop 不只是跑任务，还会逐步改进：
- 调整 prompt / skill
- 调整 verifier
- 调整触发条件
- 优化状态文件结构
- 用 trace 反推瓶颈

这就是 LangChain 所说的 hill-climbing loop，也是复杂系统真正形成“学习能力”的位置。

## loop engineering 的最小可用模型（MVP）

如果只保留最小集合，一个可用 loop 至少需要：

1. **一个清晰目标**
2. **一个执行 agent**
3. **一个外部状态文件**
4. **一个 verifier**（测试 / checklist / review agent）
5. **一个重试规则**
6. **一个停止规则**

没有 verifier，就不是 loop，只是连续生成。
没有 state，就不是 loop，只是长对话。
没有 stop rule，就不是 loop，只是失控自动机。

## 什么时候值得建 loop

### 适合
- 目标稳定、验收标准明确
- 任务高频重复
- 可程序化校验
- 人类价值主要在决策，不在每次重复执行
- 可以把知识写成 skill / checklist / SOP

典型场景：
- 定时抓取→总结→发日报
- issue triage→方案草拟→测试→PR review
- 文档同步、批量重构、小型修复
- 回归检查、质量守门、周期性巡检

### 不适合
- 需求还在快速变化
- 验收标准高度主观
- 任务一次性且不复用
- 代价很高但失败信号很弱
- 安全/资金/数据风险过大又没有审批闸门

## 你现在最该怎么用：针对“总要不断补充回答”的痛点

你提到一个真实痛点：**在用我时，经常需要不断补充说明。**
这恰好说明，你现在缺的不是更长 prompt，而是更好的 loop 设计。

### 痛点的根因
通常反复补充，根因有 5 类：
1. **目标没有结构化写出来**
2. **验收标准不外显**
3. **历史状态没有持久化**
4. **领域约束没有沉淀成 skill / checklist**
5. **每次都是从聊天重新开局，而不是从系统状态接着跑**

### 对你最有用的不是“大自动化 loop”，而是“轻量个人工作 loop”
你不一定一上来就要做全自动 agent factory。
更适合你的，是下面这类个人 loop：

#### Loop A：需求交付 loop
适用于开发/研究/整理类任务。

结构：
1. 先写目标卡片（要什么、不做什么、验收标准）
2. 生成执行计划
3. 子 agent / 工具执行
4. 自动或半自动验证
5. 结果写回状态文件
6. 下一轮从状态文件继续

你真正要做的不是反复解释，而是**第一次就把目标卡片写完整**。

#### Loop B：知识整理 loop
适用于你这种“先去学，再整理到 Obsidian”的任务。

结构：
1. 收集资料
2. 去重和分层
3. 用统一框架整理
4. 写入 Obsidian
5. 生成后续 TODO / 相关文章链接

这会把“临时研究”变成“长期资产”。

#### Loop C：日报/监控 loop
适用于晨报、投资观察、行业追踪。

结构：
1. 定时抓取
2. 过滤
3. 按你的偏好摘要
4. 只在有价值变动时推送
5. 状态持久化，避免重复

### 你和我配合时，最有效的 4 个改法

#### 1. 从“聊天提问”升级为“任务卡片”
每次尽量给我 4 件事：
- **目标**：这次要完成什么
- **边界**：不要做什么
- **标准**：什么算完成
- **上下文资产**：链接、文件、历史状态在哪

#### 2. 把常重复的说明写成 skill / 模板
例如：
- 你喜欢的输出格式
- 你的日报结构
- 某项目的验收标准
- 某类开发需求的默认工作流

这样下次不是“再解释一遍”，而是“调用已有 skill”。

#### 3. 把任务连续性放到 Obsidian / 状态文件，而不是靠聊天记忆
例如一项长期任务至少保留：
- 当前目标
- 已完成项
- 未完成项
- 风险/阻塞
- 下一步

#### 4. 给 loop 配 verifier，不要让 agent 自证完成
可用 verifier 包括：
- 测试是否通过
- 文档链接是否有效
- checklist 是否全部勾完
- 第二个 agent 是否 review 通过
- 是否生成了明确交付物

## 一个适合你的个人版 loop 框架

### 输入
- 任务卡片
- 相关文件/链接
- 现有 skill / 模板

### 运行
1. 我先把任务拆成 plan
2. 执行工具/子 agent
3. 中途把状态写回外部文件
4. 用 verifier 校验
5. 校验失败就按反馈再跑一轮
6. 达标才交付

### 输出
- 最终结果
- 更新后的状态文件
- 可复用 skill / 模板
- 下一轮建议

### 这套框架的价值
它会把你现在的使用方式，从：
- “想到什么补什么”
变成：
- “一次设定目标，系统按闭环推进”

## 风险与反模式

### 1. loop 太早、太重
还没搞清目标，就上自动化，结果只是把混乱自动化。

### 2. 没有 verifier
没有验证就敢自动 merge / 自动发布，风险很高。

### 3. 把状态留在上下文，不落盘
上下文一断，连续性就断。

### 4. 同一个 agent 既执行又评审
容易自我放过。

### 5. 没有停止条件
会进入昂贵空转。

### 6. 对开放性创造任务强行上 loop
很多高不确定任务仍然适合人主导、agent 辅助。

## 我的结论

loop engineering 真正重要的地方不在 buzzword，而在它把一个越来越明显的事实说清楚了：

> 当 AI 从“回答问题”进入“持续做事”阶段，工程重点就会从 prompt 转向 loop。

但它不是魔法。

它本质上仍然是系统工程：
- 用目标约束系统
- 用状态维持连续性
- 用 verifier 建立可信度
- 用反馈回路持续改进

所以我更愿意把它理解为：

> **loop engineering = 面向 agent 的闭环软件工程。**

## 你下一步最值得做的事

### 低成本起步版
先不要追求全自动，只做这三件事：
1. 以后复杂任务先写“任务卡片”
2. 给任务配一个外部状态文件/Obsidian 页面
3. 给任务配一个 verifier/checklist

### 进阶版
把高频任务做成半自动 loop：
- 研究整理
- 晨报/监控
- 开发需求交付
- 文档更新

### 高阶版
再考虑：
- cron / heartbeat
- 多 agent 协作
- trace 驱动优化
- 自动 triage / review / merge

## 相关链接

- [[04-00-loop engineering 文章时间线]]
- [[03-harness engineering]]
- [[03-00-harness engineering 文章时间线]]
- [[02-context engineering]]
- [[01-prompt engineering]]
