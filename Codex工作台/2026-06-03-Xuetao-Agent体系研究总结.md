---
title: "Xuetao Agent体系研究总结"
source: "conversation: Codex chat 2026-06-03"
author: "Codex"
published:
created: 2026-06-03
description: "基于 /Users/heytea/Documents/xuetao的agetns 的多 Agent 体系分析，提炼可迁移到个人 Codex 工作台的架构经验。"
tags: ["codex", "agent", "workflow", "openspec", "architecture"]
type: "tech-note"
status: "processed"
---

# Xuetao Agent体系研究总结

## 摘要

这套体系好用，不是因为 agent 多，而是因为它把多 agent 运行系统拆成了完整的 4 个模块：注册表、工作流、门禁、协议。`config.toml` 只做入口索引，真正的稳定性来自 `workflow_router + stage gates + structured contract + tool risk matrix` 的组合。

对我当前个人 Codex 体系最有价值的，不是照抄全部 agent 名称，而是复用它的组织方式：先定义阶段，再定义 gate，再定义 operator 边界，最后才挂载具体能力。

## 核心内容

### 研究对象

- 主入口：[config.toml](/Users/heytea/Documents/xuetao的agetns/.codex/config.toml:1)
- Agent 列表目录：[.codex/agents](/Users/heytea/Documents/xuetao的agetns/.codex/agents)
- 多 Agent 总说明：[openspec-multi-agent.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-multi-agent.md:1)
- 默认执行链路：[agent-workflows.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/agent-workflows.md:1)
- 阶段门禁：[openspec-stage-gates.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-stage-gates.md:1)
- 统一协议：[openspec-agent-contracts.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/openspec-agent-contracts.md:1)
- 工具风险矩阵：[tool-agent-matrix.md](/Users/heytea/Documents/xuetao的agetns/my归档/docs/tool-agent-matrix.md:1)

### 这套体系真正的强点

#### 1. `config.toml` 只做注册表

`config.toml` 只负责声明：

- 有哪些 agent
- 每个 agent 的一句话职责
- 对应的配置文件路径

它不承担复杂流程逻辑，也不承担详细协议。这让配置层保持稳定，后面新增 agent 时只是在索引层扩展，不会把整个系统改得很脆。

#### 2. 路由层很克制

`workflow_router` 的职责被刻意限制为：

- 识别当前 stage
- 找最小缺失输入
- 推荐后续 stage agent / tool agent
- 按 gate 判断是否允许继续

它明确不写文件、不改代码、不接管执行。这个边界非常关键，因为很多系统一开始就让 router 顺手做规划和执行，后面会变成一个失控的“大脑代理”。

#### 3. 阶段 agent 与工具 agent 分层清楚

这套体系不是按“日志 agent / 文档 agent / 搜索 agent”这种表层名称拆，而是先区分：

- 阶段 agent：负责对象、阶段、文档、边界、handoff
- 工具 agent：负责某个 CLI 或系统动作

比如：

- `initiative_planner` / `investigation_planner` / `workspace_preparer` 属于阶段层
- `dbauto_operator` / `trace_log_operator` / `wiki_operator` 属于工具层

这让“做什么”和“怎么做”两类决策不会混在一个 agent 里。

#### 4. Gate 被当成主流程的一部分

这套体系不是“最后 review 一下”，而是在每个关键阶段前都用 gate 统一判断：

- `go`
- `warn`
- `block`

而且 gate 不只看文件是否存在，还看：

- `context_isolation_status`
- `required_inputs`
- `required_artifacts`
- `override_allowed`

这说明它在解决的不只是流程完整性，还包括上下文污染和错误路径复用。

#### 5. Contract 非常统一

所有子 agent 被约束为统一输出形状：

- `agent`
- `input`
- `output.facts`
- `output.decision`
- `output.next_actions`
- `output.artifacts_to_update`

这一步把 agent 从“会说话的提示词角色”变成“可编排的结构化节点”。没有这个协议，上层 orchestrator 最后还是得读自然语言猜意思，系统会越来越脆。

#### 6. 工具层不是能力矩阵，而是风险矩阵

`tool-agent-matrix.md` 不只登记“谁能做什么”，还登记：

- sandbox 模式
- 默认执行模式
- 高风险动作
- 是否要求 dry-run 或人工确认

这说明它很重视外部系统边界，尤其适合会碰到 SSO、dbauto、发布、文档写回、调度触发这类高风险动作的工作台。

### 对我自己的可迁移经验

#### 应该直接学习的 4 个骨架

1. `workflow_router`
2. `stage-gates`
3. `agent-contracts`
4. `tool-agent-matrix`

这 4 个骨架比具体 agent 名称更重要。

#### 最值得复用的组织原则

1. 先定阶段，再挂 agent。
2. 先定 gate，再放执行权限。
3. 先定 contract，再追求智能。
4. operator 只执行，不决定主流程。
5. router 只分流，不顺手干活。

#### 不建议照抄的部分

这套体系围绕 OpenSpec 的对象模型非常强，比如 investigation / initiative / plugin-project。我的个人 Codex 工作台不一定需要复制这些对象名，更合理的做法是保留它的分层方式，替换成自己的阶段对象。

## 可执行动作

1. 以这套体系为蓝本，在 `~/.codex/agents/` 下先建立最小骨架。
2. 第一批先定义：
   - `request_router`
   - `stage_orchestrator`
   - `gate_evaluator`
   - `sso_operator`
   - `dbauto_operator`
   - `excel_operator`
3. 在本地先补齐 4 份文档：
   - `agent-workflows.md`
   - `stage-gates.md`
   - `agent-contracts.md`
   - `tool-agent-matrix.md`
4. 暂不直接切换主 `~/.codex/config.toml`，先把骨架和计划落地，避免影响当前稳定环境。

## 相关链接

- [[agent拆分逻辑]]
- [[agent 拆分新逻辑]]
- [[Codex Agent 能力与读取链路图]]
- [[2026-06-03-个人Codex多Agent改造计划]]
