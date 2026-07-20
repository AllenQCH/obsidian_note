---
title: 飞书需求群与本地 Multi-Agent 联动
source: Codex工作台/飞书需求群与本地Multi-Agent联动.md
author: 笨笨
published:
created: 2026-07-13
description: 记录需求链接进入后，如何建立飞书控制面并绑定本地 Codex 四层 Multi-Agent 执行面的实际实现。
tags: [codex, multi-agent, feishu, workflow]
type: workflow
status: processed
---

# 飞书需求群与本地 Multi-Agent 联动

## 摘要

需求链接进入后，每个规范化 URL 创建或复用一个飞书需求群。飞书群负责沟通、澄清和人工确认；本地 Codex 四层 Multi-Agent 负责路由、开发、测试和交付执行。

## 核心内容

### 职责分工

| 层面 | 负责内容 | 不负责内容 |
| --- | --- | --- |
| 飞书需求群 | 需求讨论、补充材料、需求/方案确认、进度与证据链接 | 不直接代表代码和测试状态 |
| Hermes / 笨笨 | 读取需求、建群、整理上下文、连接本地执行面 | 不绕过本地质量门禁 |
| Codex Multi-Agent | `control -> stage -> tool -> gate`，分析、实现、测试、集成、收口 | 不把聊天结论直接当验证事实 |
| OpenSpec / 仓库 / 测试证据 | 长期事实源、实现记录、可复现验证 | 不承担实时沟通 |

### 已注册的 Agent

- Agent：`tool_lark_requirement_group_operator`
- 配置：`~/.codex/agents/operator/tool_lark_requirement_group_operator.toml`
- 实现：`~/.codex/agents/operator/scripts/tool_lark_requirement_group_operator.py`
- 运行时注册：`~/.codex/config.toml`
- 绑定状态：`~/.codex/state/lark-requirement-groups.json`

### 实际链路

```text
需求 URL
-> Hermes 读取并提取需求编号/标题/地区/模块
-> 创建或复用飞书需求群
-> 绑定 chat_id / role / primary_workspace / prompt_file
-> 群内完成需求与设计确认
-> gate_design_confirmed
-> 本地 Codex Multi-Agent 实现
-> stage_test_runner
-> gate_test_passed
-> commit / push / pipeline / delivery
-> 结项沉淀
```

### 安全边界

- 建群默认 dry-run；只有用户明确要求时才执行。
- 建群不会自动启动 Codex、创建分支或修改代码。
- 同一规范化需求 URL 复用原群，避免重复群。
- 飞书群消息是上下文和审计轨迹，不替代 OpenSpec、代码 diff 和测试证据。
- 代码前必须通过需求/设计确认门；commit、push、流水线前必须通过测试门。

## 可执行动作

Dry-run：

```bash
python3 ~/.codex/agents/operator/scripts/tool_lark_requirement_group_operator.py \
  --demand-url '<需求链接>' \
  --title '<需求标题>'
```

真实创建：

```bash
python3 ~/.codex/agents/operator/scripts/tool_lark_requirement_group_operator.py \
  --demand-url '<需求链接>' \
  --title '<需求标题>' \
  --region '<cn|intl>' \
  --module '<模块>' \
  --role '<开发角色>' \
  --primary-workspace '<绝对路径>' \
  --execute
```

本地 Codex launcher 已改为优先使用：

```text
/Applications/Codex.app/Contents/Resources/codex
```

避免依赖失效的旧 NVM Codex 路径。

## 相关链接

- [[我的.codex目录里有什么]]
- [[Codex agent会读取哪些上下文]]
- [[Codex启动时会读取什么]]
