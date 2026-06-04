---
title: "个人Codex多Agent改造计划"
source: "conversation: Codex chat 2026-06-03"
author: "Codex"
published:
created: 2026-06-03
description: "基于 Obsidian 的 agent 拆分思想与 Xuetao 样例体系，为个人 ~/.codex 工作台制定的多 Agent 改造计划与第一阶段实施顺序。"
tags: ["codex", "agent", "workflow", "plan", "architecture"]
type: "workflow"
status: "processed"
---

# 个人Codex多Agent改造计划

## 摘要

这次改造目标不是一次性启用完整多 agent 系统，而是先按 Obsidian 的拆分方式，把个人 `~/.codex` 工作台补出稳定骨架。整体分三步：

1. 先沉淀研究结论和计划；
2. 先落地骨架文件，不立即切换主配置；
3. 先把 `sso-login`、`dbauto-export-agent`、`excel-json-analysis` 这三类高价值能力收敛到 `operator` 层。

第一阶段的成功标准是：本地已经存在可继续演进的 `router / stage / operator / gate / contract / matrix` 骨架，而不是已经全量替换当前工作流。

## 核心内容

### 目标架构

#### 1. 控制层

- `request_router`
- `stage_orchestrator`
- `gate_evaluator`

控制层只负责阶段识别、状态推进和放行判断，不做具体外部系统动作。

#### 2. 阶段层

- `investigation_agent`
- `planning_agent`
- `execution_agent`
- `integration_agent`
- `closeout_agent`

阶段层负责阶段目标、边界和产物，不直接承载所有工具动作。

#### 3. 操作层

第一批先落地：

- `sso_operator`
- `dbauto_operator`
- `excel_operator`

后续再补：

- `lark_doc_operator`
- `lark_sheet_operator`
- `trace_log_operator`
- `release_doc_operator`

#### 4. 协议层

- 统一 `contract`
- 统一 `gate output`
- 统一 `tool-agent-matrix`
- 统一 `state transition`

### 第一阶段计划

#### 阶段 A：文档先行

产出：

- Obsidian 研究总结笔记
- Obsidian 改造计划笔记

目标：

- 把架构决策和实施顺序沉淀到知识库
- 避免后续边改边漂移

#### 阶段 B：建立本地骨架

产出路径：

- `~/.codex/agents/README.md`
- `~/.codex/agents/config.template.toml`
- `~/.codex/agents/agent-workflows.md`
- `~/.codex/agents/stage-gates.md`
- `~/.codex/agents/agent-contracts.md`
- `~/.codex/agents/tool-agent-matrix.md`

目标：

- 先建立一个不影响当前运行环境的骨架
- 让后续 agent 扩展有稳定落点

#### 阶段 C：第一批 agent 落地

第一批文件：

- `request-router.toml`
- `stage-orchestrator.toml`
- `gate-evaluator.toml`
- `sso-operator.toml`
- `dbauto-operator.toml`
- `excel-operator.toml`

目标：

- 先把“控制层 + 高复用 operator”落地
- 不急着落地完整阶段 agent

### 严格实施规则

1. 不直接改当前 `~/.codex/config.toml` 的有效运行逻辑。
2. 先写模板和骨架，再决定是否切换到主配置。
3. operator 只调用现有已验证 skill / script，不重新发明执行器。
4. 所有新 agent 必须遵守统一 contract。
5. 高风险动作必须进 `tool-agent-matrix`。

### 第一阶段完成后的下一步

1. 为 `dbauto-export-agent` 增加薄编排层，改成：
   - `sso_operator`
   - `dbauto_operator`
   - 上层 workflow 串联
2. 把 `sso-login` 从共享 skill 语义进一步固化成 shared operator。
3. 视稳定性再决定是否把 `config.template.toml` 合并进主 `~/.codex/config.toml`。

## 可执行动作

1. 本轮先完成阶段 A 与阶段 B，以及阶段 C 的最小骨架。
2. 完成本轮后，优先验证文件存在性和关键字段正确性。
3. 下一轮再决定是否启用主配置和扩展阶段 agent。

### 当前执行状态（2026-06-03）

- 已完成：阶段 A
  - 已新增研究总结笔记
  - 已新增改造计划笔记
- 已完成：阶段 B
  - 已在 `~/.codex/agents/` 下新增骨架文档与 registry 模板
- 已完成：阶段 C 的第一批最小骨架
  - 已新增 `request-router.toml`
  - 已新增 `stage-orchestrator.toml`
  - 已新增 `gate-evaluator.toml`
  - 已新增 `sso-operator.toml`
  - 已新增 `dbauto-operator.toml`
  - 已新增 `excel-operator.toml`
- 已完成：主配置合并
  - 已将 `~/.codex/agents/config.template.toml` 中的 multi-agent 配置合并进主 `~/.codex/config.toml`
  - 已通过 TOML 解析验证
- 待继续：是否补阶段 agent，以及是否继续整理 `~/.codex` 根目录中的备份/缓存结构

## 相关链接

- [[2026-06-03-Xuetao Agent体系研究总结]]
- [[agent拆分逻辑]]
- [[agent 拆分新逻辑]]
- [[Skill目录与维护规范]]
