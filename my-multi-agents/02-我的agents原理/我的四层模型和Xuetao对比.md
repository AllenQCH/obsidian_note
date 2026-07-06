---
title: "我的四层模型和Xuetao对比"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "把当前最适合个人 Codex 的四层模型，与 Xuetao 在此基础上额外拆出的 selector、implement、integration、review 结构做直白对比。"
tags: ["codex", "agent", "workflow", "xuetao", "architecture"]
type: "workflow"
status: "processed"
---

# 我的四层模型和Xuetao对比

## 摘要

这篇笔记只回答一个问题：

> 你现在应该怎么理解“自己的四层模型”，以及 Xuetao 为什么会在这个基础上继续拆层。

最终结论很简单：

- 你现在先用 4 层就够了。
- Xuetao 不是推翻 4 层，而是在 4 层中间又拆出了更细的职责。
- 多出来的层，不是为了显得复杂，而是为了处理多 repo、多工具、多阶段收口。

## 核心内容

### 1. 你现在最适合的四层模型

你现在最稳定、最容易维护的理解是：

```text
用户请求
-> control 层：判断这是什么任务，选哪条流程
-> stage 层：定义这类任务的步骤和推进顺序
-> tool 层：真正调用工具、脚本、浏览器、文件处理去干活
-> gate 层：检查这一步结果能不能进入下一步
```

这里要注意两件事。

第一，`closeout` 不需要单独算一层。  
它可以属于 `stage` 层里的最后一个阶段，例如：

```text
stage_planning
stage_execution
stage_closeout
```

第二，`workflow` 不是单独一层。  
它更像是 `stage` 层里的流程定义，也就是：

```text
这类任务先做什么，后做什么，什么条件下进入下一步
```

所以对你来说，四层模型最容易记成一句话：

```text
control 负责选路
stage 负责排步骤
tool 负责干活
gate 负责放行
```

### 2. Xuetao 不是另一套体系，而是在四层里继续细拆

Xuetao 的底座其实还是同一条主链：

```text
router / control
-> workflow / stage
-> tool
-> gate / review
```

但他处理中间对象更复杂，所以又把其中两段细拆出来了。

拆完以后，更接近：

```text
router / control
-> stage / workflow
-> selector
-> tool
-> implement / integration
-> gate / review
```

所以不是“Xuetao 有一套完全不同的六层宇宙”，而是：

> 他在四层骨架中，把两段复杂职责单独抽出来了。

### 3. selector 层到底插在哪

`selector` 是从：

```text
stage -> tool
```

这段中间拆出来的。

它解决的问题不是“去干活”，而是：

```text
在真正调用工具之前，先选对对象
```

典型选择有：

- 选哪个 repo
- 选哪个 tool operator
- 选哪个知识来源

所以它更准确的位置是：

```text
stage 决定要做什么
selector 决定具体选谁
tool 才真正去执行
```

这也是为什么 Xuetao 会有：

- `catalog_repo_selector`
- `tool_operator`
- `knowledge_base_operator`

它们都不是直接“干业务动作”，而是在做“选择”。

### 4. implement / integration 层到底插在哪

这一层是从：

```text
tool -> gate
```

中间拆出来的。

原因是 Xuetao 的很多任务，不是调完一个工具就结束，而是后面还有一整段真实落地执行链路：

- 准备 workspace
- 进入单个 repo 实现或分析
- 多 repo 结果整合
- rollout / closeout 收口

所以它变成：

```text
tool 拿证据或做原子动作
-> implement 真正进 repo 干活
-> integration 负责多 repo 收口
-> review / gate 判断是否过关
```

这也是为什么 Xuetao 会有：

- `workspace_preparer`
- `repo_implementer`
- `integration_orchestrator`

### 5. 为什么 Xuetao 需要这些扩展层

因为他的典型任务是：

- 先识别需求处于哪个 OpenSpec 阶段
- 再判断要查哪些外部系统
- 再选正确 repo 和 serviceKey
- 再进入 repo 真改代码
- 再做多 repo 集成和 rollout
- 最后还要有 reviewer 看边界和风险

如果不拆，这些东西都会堆在同一个大 planner 或大 operator 里。

所以他的扩展层是为了处理：

- 多 repo
- 多工具
- 多阶段收口
- 需要证据链的 review

### 6. 你现在需不需要这些扩展层

大概率暂时不需要。

因为你现在的很多任务还是：

- `SSO 登录`
- `dbauto 启动`
- `Excel 提取`
- `Obsidian 写入`
- `GitHub 同步`

这些任务通常是：

```text
workflow
-> tool
-> gate
```

就够了。

它们一般不需要：

- 在很多 repo 中做复杂选择
- 进入 repo 修改业务代码
- 多 repo 集成收口

所以你现在最稳的策略是：

```text
先用四层跑通
出现真实痛点时再加 selector
出现真实多 repo 执行链时再加 implement / integration
```

### 7. 什么时候真的需要把 workflow 再拆出 selector

不是 workflow 一复杂就一定要 selector。

更准确的判断标准是：

如果“选择逻辑”已经变成一个独立复杂度，才值得拆。

不需要 selector 的情况：

- 选择规则很简单
- 只服务一条 workflow
- 分支很少
- 不需要复用

这时直接把选择写在 workflow 里就行。

需要 selector 的情况：

- 多条 workflow 都要复用同一种选择逻辑
- 选择规则很多，而且经常变化
- 需要按环境、serviceKey、权限、模块做判断
- 你已经觉得“这个 workflow 一半都在选东西”

这时再拆 selector 才有意义。

### 8. 你现在应该怎么记住这件事

最适合你的记法是：

```text
我的当前模型 = 四层
Xuetao = 四层 + 两段增强拆分
```

再压缩成一句：

```text
Xuetao 不是另一套逻辑，他只是把四层中间最容易变重的两段单独拆出来了。
```

## 可执行动作

1. 当前个人体系先坚持 `control / stage / tool / gate` 四层，不主动加更多层。
2. 只有当多个 workflow 都在重复“选 repo / 选 tool / 选知识源”时，再拆 `selector`。
3. 只有当任务开始进入单 repo 或多 repo 改代码与收口时，再拆 `implement / integration`。

## 相关链接

- [[阅读顺序-先Xuetao再我的agents]]
- [[Xuetao多agent体系总结]]
- [[Xuetao有哪些agent分层]]
- [[我的Codex多agent改造计划]]
