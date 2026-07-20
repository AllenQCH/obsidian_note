---
title: "00-Multi-Agent总览"
source: "Feishu 对话：蜂巢模式是否属于 Multi-Agent"
author: "Allen / 笨笨"
published:
created: 2026-07-15
description: "解释 Multi-Agent 的判定标准、蜂巢模式的典型结构，以及它与普通并行调用、单 Agent 和 Agent Swarm 的区别。"
tags: ["ai-agent", "multi-agent", "agent-swarm", "orchestration", "shared-memory"]
type: "note"
status: "processed"
---

# 00-Multi-Agent总览

## 摘要

**蜂巢模式通常可以视为一种 Multi-Agent 协作模式。**

但“蜂巢模式”不是严格统一的学术术语。工程实践中，它通常是以下模式的组合：

```text
Supervisor-Worker（主管—工作者）
+ Role-based Team（角色分工）
+ Shared Memory / Blackboard（共享记忆 / 黑板）
```

一句话理解：

> 多个专业 Agent 围绕共同目标，由协调者分配任务，并通过共享状态交换结果、处理依赖与完成汇总。

判断一个系统是不是 Multi-Agent，关键不在于“同时启动了几个模型”，而在于：**多个相对独立的 Agent 是否具有明确分工、协作关系和统一目标。**

## 核心内容

### 1. 什么才算 Multi-Agent

真正的 Multi-Agent 系统通常包含以下特征：

| 判定维度 | 说明 |
| --- | --- |
| 多个独立 Agent | 至少有两个相对独立的执行主体，各自拥有上下文或运行状态 |
| 角色或目标不同 | 每个 Agent 承担不同职责，例如规划、开发、测试、审查 |
| 信息能够交换 | Agent 可以通过消息、任务结果、共享状态或 Memory 交换信息 |
| 存在协调机制 | 系统能够分配任务、处理依赖、汇总结果或解决冲突 |
| 服务共同目标 | 所有 Agent 最终共同完成一个上层任务，而不是各自输出无关答案 |

因此，Multi-Agent 不只是：

```text
同时调用多个模型
```

而是：

```text
多个具有角色与状态的 Agent
+ 协作协议
+ 任务协调
+ 共享目标
```

### 2. 并行调用不一定是 Multi-Agent

例如：

```text
Agent A：生成答案
Agent B：生成答案
Agent C：生成答案
```

如果三个结果互不交互，只由外部程序简单选一个结果，它更接近：

```text
Parallel Inference（并行推理）
或 Ensemble（集成）
```

它可以作为 Multi-Agent 系统中的一个步骤，但仅凭“并行运行”还不足以构成完整的 Multi-Agent 协作。

更典型的 Multi-Agent 流程是：

```text
Coordinator
├── Research Agent：收集信息
├── Analyst Agent：建立判断
├── Critic Agent：检查漏洞
└── Writer Agent：汇总成最终输出

Research Result
      ↓
Analyst Result
      ↓
Critic Feedback
      ↓
Writer Output
```

这里的 Agent 之间存在前后依赖、结果传递和共同目标，因此更符合 Multi-Agent。

### 3. 蜂巢模式为什么属于 Multi-Agent

蜂巢模式常见的抽象结构如下：

```text
                   Shared Goal
                        │
                        ▼
              Queen / Supervisor Agent
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
     Worker A       Worker B       Worker C
     调研 Agent      开发 Agent      测试 Agent
          │             │             │
          └─────────────┼─────────────┘
                        ▼
              Shared Memory / State
                        │
                        ▼
                 Final Synthesis
```

它通常同时包含三类设计：

| 组成模式 | 在蜂巢中的作用 |
| --- | --- |
| Supervisor-Worker | 由一个协调 Agent 拆解任务、选择 Worker、跟踪进度并汇总结果 |
| Role-based Team | 不同 Worker 具有专业角色、工具权限和任务边界 |
| Shared Memory / Blackboard | Agent 把中间结果写入共享空间，供其他 Agent 继续处理 |

因此，蜂巢模式可以理解为一种**中心协调式 Multi-Agent 架构**。

### 4. 蜂巢模式不等于所有 Multi-Agent

Multi-Agent 是上位概念，蜂巢模式只是其中一种组织方式。

| 模式 | 协作结构 | 适合场景 | 主要风险 |
| --- | --- | --- | --- |
| Supervisor-Worker | 中心节点分配和验收任务 | 复杂工作流、企业开发、需要控制质量门 | Supervisor 成为瓶颈或单点故障 |
| Peer-to-Peer | Agent 之间直接协商 | 去中心化探索、动态协作 | 沟通成本高，容易循环或失控 |
| Debate / Critic | 多个 Agent 提案、反驳和裁决 | 推理、评审、风险分析 | Token 成本高，可能争论不收敛 |
| Pipeline | 上一个 Agent 的输出进入下一个 Agent | 内容生产、数据处理、固定流程 | 上游错误会逐级传播 |
| Blackboard | Agent 围绕共享状态读写 | 多专业协作、长期任务 | 共享状态容易污染，需要版本与权限控制 |
| Swarm | 大量轻量 Agent 按局部规则协作 | 搜索、探索、仿真、开放式问题 | 难以预测、调试和验收 |

蜂巢模式常被口语化地称为 Agent Swarm，但严格来说：

- 有中心 Supervisor 的蜂巢，更接近 **Hierarchical Multi-Agent**；
- 完全去中心化、依靠局部规则涌现行为的系统，才更接近严格意义上的 **Swarm Intelligence**。

### 5. 单 Agent、多实例与 Multi-Agent 的区别

| 形态 | 核心特征 | 是否属于 Multi-Agent |
| --- | --- | --- |
| 单 Agent + 多工具 | 一个 Agent 统一决策，只是调用多个 Tool | 否 |
| 同一 Agent 的多个并行副本 | 相同角色、相同任务，各自生成候选答案 | 通常不算完整 Multi-Agent |
| 多角色 Agent 团队 | 不同 Agent 有明确职责，并交换任务结果 | 是 |
| Supervisor + Workers | 由主管拆解、调度、验收多个 Worker | 是 |
| 多 Agent 共享 Memory | Agent 围绕共享状态持续协作 | 是，但必须控制状态和权限 |

核心区别是：

> Tool 是 Agent 使用的能力；Agent 是能够基于目标和上下文自主决策的执行主体。

### 6. Multi-Agent 的核心组件

一个可落地的 Multi-Agent 系统一般需要：

```text
Multi-Agent System
├── Agent Registry        # 有哪些 Agent，各自能做什么
├── Role Definition       # 角色、目标、权限和边界
├── Coordinator / Router  # 任务路由与阶段编排
├── Communication         # 消息与结果传递协议
├── Shared State          # 共享任务状态
├── Memory                # 短期与长期记忆
├── Dependency Graph      # 任务依赖关系
├── Gate / Evaluator      # 质量门与验收规则
├── Conflict Resolution   # 冲突处理与裁决
├── Observability         # 日志、Trace、成本和耗时
└── Stop Conditions       # 完成、失败、超时和人工接管条件
```

如果缺少协调、状态与停止条件，多个 Agent 很容易退化成：

```text
更多调用
+ 更多 Token
+ 更多重复劳动
+ 更难定位问题
```

### 7. Multi-Agent 什么时候真正有价值

适合使用 Multi-Agent 的任务通常具备以下特征：

- 任务可以拆成相对独立的专业子任务；
- 不同子任务需要不同上下文、工具或权限；
- 可以并行处理，且并行收益大于协调成本；
- 需要独立审查、交叉验证或质量门；
- 单个 Agent 的上下文过长，容易混淆角色和目标；
- 任务持续时间较长，需要明确的阶段状态与恢复能力。

不适合强行使用 Multi-Agent 的情况：

- 任务简单，一个 Agent 一次即可完成；
- 子任务高度耦合，频繁沟通比执行本身更贵；
- 没有清晰的验收标准；
- 只是为了展示“Agent 数量”，没有实际分工；
- 缺少日志、追踪、超时和人工接管机制。

### 8. 一个实用判断公式

可以用下面的方式判断是否值得采用 Multi-Agent：

```text
Multi-Agent 收益
= 并行收益
+ 专业分工收益
+ 独立验证收益
- 协调成本
- 上下文传递损耗
- Token / 时间成本
- 调试复杂度
```

只有当收益明显大于成本时，Multi-Agent 才是架构升级；否则只是系统复杂化。

### 9. 与 Allen 当前工作流的对应关系

Allen 当前的本地开发协作方式，本质上就是一种带质量门的层级式 Multi-Agent：

```text
飞书需求群：控制面 / 人工确认
        ↓
Control Agent：接收和路由需求
        ↓
Stage Agent：规划当前阶段
        ↓
Operator Agent：执行开发、测试、查询和文档操作
        ↓
Gate Agent：检查证据与放行条件
        ↓
Coordinator：汇总结果并回传飞书
```

它不是单纯“同时启动多个 Codex”，而是：

- Agent 有明确角色；
- 阶段之间存在依赖；
- 结果需要交接；
- Gate 负责独立验收；
- 飞书群承担人工控制面；
- 所有 Agent 服务于同一个需求交付目标。

因此，它属于典型的 **Hierarchical Multi-Agent + Stage Workflow + Quality Gates**。

## 可执行动作

- [ ] 为本专题继续补充 `Supervisor-Worker`、`Agent Swarm`、`Blackboard` 三篇独立知识页。
- [ ] 为实际 Multi-Agent 系统建立统一的 Agent Registry，明确角色、输入、输出、工具和权限。
- [ ] 每个阶段定义可验证的完成条件，避免只凭 Agent 自述判定成功。
- [ ] 增加 Trace、Token、耗时、失败原因和人工接管记录。
- [ ] 对简单任务优先使用单 Agent，只有在分工或验证收益明确时才升级为 Multi-Agent。

## 相关链接

- [[04-0-运行模式]]
- [[00-Agent Runtime总览]]
- [[orchestration concept]]
- [[飞书需求群与本地Multi-Agent联动]]
- [[my-multi-agents总览]]
