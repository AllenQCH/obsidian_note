---
title: "OneNote恢复-AI_related-第一轮整理清单"
source: "01 Projects/Obsidian整理/OneNote恢复-AI_related-第一轮整理清单.md"
author: "笨笨"
published:
created: 2026-05-30
description: "对 ai-related/OneNote恢复/AI_related 目录做第一轮盘点，按可迁移、待核验、可归档三类给出整理顺序。"
tags: ["obsidian-note", "onenote-recovery", "cleanup", "ai-related", "project"]
type: "project"
status: "processed"
---

# OneNote恢复-AI_related-第一轮整理清单

## 摘要

- 当前 `ai-related/OneNote恢复/AI_related/` 共 **26** 篇笔记。
- 其中 **18** 篇可读性较好，已经具备二次迁移价值；**5** 篇只恢复到标题；**2** 篇内容过薄；**1** 篇虽然可读，但应继续作为归档页保留。
- 第一轮整理不建议大搬家，而是按 **直接迁移 / 待补全 / 保留归档** 三类处理。

## 核心内容

### 目录现状

- 总数：26
- `processed`：18
- `raw`：7
- `archived`：1
- `usable`：17
- `empty`：5
- `thin`：2
- `needs-verification`：1

### 第一类：可以直接吸收进正式主题体系

这批内容已经不是“纯素材”，而是有明确结构、可继续拆分或并入正式目录的半成品。

#### LLM 基础

- [[05-temperature 学习]] → 对应正式主题 [[01-05-LLM-Temperature]]
- [[06-token 学习]] → 对应正式主题 [[01-02-LLM-Token]]
- [[07-Prompt 学习]] → 对应正式主题 [[01-03-LLM-Prompt]]
- [[08-LLM 学习]] → 对应正式主题 [[01-01-LLM-总览]]
- [[09-memory 学习]] → 建议并入 Agent / Memory 主题，或单独升级为 evergreen
- [[12-上下文context]] → 对应正式主题 [[01-04-LLM-Context]]

#### Agent / 工具链

- [[10-AI agent 是什么]] → 可并入 [[05-agent.md]] 或拆为 `Agent是什么` 正式知识页
- [[15-Agent skill 学习]] → 可并入 skill / workflow 主题
- [[23-tool 学习]] → 可并入 [[00-Tool 索引]] / [[Tool]]
- [[24-Function-Tool Calling 学习]] → 可并入 [[Function Tool Calling]]
- [[25-mcp 学习]] → 已基本可直接并入 [[mcp]]

#### 工程学习路径

- [[01-python 学习]] → 已有更正式承接页 [[12-02-AI工程所需Python能力]]
- [[04-openspec学习（1-n 项目）]] → 可并入 `07-develop-function/` 或 `09-engineering/`
- [[19-基本名词和概念]] → 适合作为 AI 基础概念总览页的原料

### 第二类：保留为资源/草稿，等回看原文再决定

这些笔记并不是完全没价值，但当前内容不足以直接升级成正式知识页。

#### 只恢复到标题的 5 篇

- [[11-多智能体协作学习]]
- [[13-rules]]
- [[14-subAgent]]
- [[20-Playwright]]
- [[21-应用机器人]]

处理建议：
- 先保留在 `OneNote恢复`，继续标记 `raw`
- 如果 OneNote 原文能找回正文，再补录
- 如果原文本来就是空占位，可后续归档或删除

#### 内容过薄的 2 篇

- [[16-安装 openclaw 步骤]]
- [[18-codex 与 openclaw]]

处理建议：
- 两篇本质上是同一主题，后续适合合并成一篇“Codex / OpenClaw 安装与集成记录”
- 由于 OpenClaw 已经退居历史资料，建议最后并入 `99 Archive/`，避免继续作为主线知识维护

#### 需核验的 1 篇

- [[17-全世界的ai模型]]

处理建议：
- 主题具有时效性，不适合直接当 evergreen
- 更适合保留为 `03 Resources/` 或转成“模型分类方法”而不是“模型清单”

### 第三类：明确保留为归档页

- [[22-RAG 学习]]

这页已经做得对：
- 保留 OneNote 恢复原貌的价值
- 同时把正式知识沉淀拆进 `02-RAG/` 目录
- 这是后续处理 OneNote 恢复内容的最佳模板

### 推荐整理顺序

1. 先清“已有正式承接页”的内容：
   - `temperature / token / prompt / context / mcp / tool-calling / python`
2. 再清“可升级成新 evergreen”的内容：
   - `AI agent 是什么 / Agent skill / 基本名词和概念 / openspec`
3. 最后处理“空页和薄页”：
   - `多智能体 / rules / subAgent / Playwright / 应用机器人 / openclaw`

## 可执行动作

- [ ] 把 `25-mcp 学习` 与正式页 [[mcp]] 做差异比对，确认是否可以归档恢复版。
- [ ] 把 `07-Prompt 学习`、`06-token 学习`、`12-上下文context` 的内容并入现有 LLM 正式页。
- [ ] 为 `AI agent 是什么` 建一个更稳定的正式知识页，再把恢复版转为 archive。
- [ ] 回看 OneNote 原文，优先确认 5 个空页是否真的有图片/附件内容。
- [ ] 将 OpenClaw 相关两页归入历史资料，而不是继续主线维护。

## 相关链接

- [[Obsidian笔记体系方案（Allen版）]]
- [[00-AI_related 索引]]
- [[01-01-LLM-总览]]
- [[00-Tool 索引]]
- [[mcp]]
- [[02-01-RAG-总览]]