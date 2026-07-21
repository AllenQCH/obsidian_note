---
title: "什么时候把skill做成agent"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "区分公共能力与 Agent 治理岗位，并给出 Tool Agent 晋升标准。"
tags: ["codex", "agent", "skill", "workflow", "architecture"]
type: "workflow"
status: "processed"
---

# 什么时候把skill做成agent

## 摘要

Skill 不需要为了统一命名而全部包装成 Agent。只有当一种能力需要独立的输入校验、安全边界、证据合同、重试策略或路由身份时，才值得增加 `tool_<capability>_agent`；底层 Skill 仍是公共能力入口。

## 判断标准

| 问题 | 是时意味着什么 |
| --- | --- |
| 是否被多个 Workflow/Stage 重复调用？ | 需要稳定公共合同 |
| 是否涉及外部系统、写操作、生产或权限？ | 需要统一安全边界和确认规则 |
| 是否需要固定输入校验和结构化证据？ | 适合 Tool Agent 治理 |
| 是否需要独立重试、恢复或状态监控？ | 适合独立执行主体 |
| 只是几段操作说明或本地纯函数吗？ | 通常保留 Skill/Script 即可 |

## 关系

```text
Stage Agent
-> Tool Agent（治理合同，可选）
-> Skill / MCP / Script（实际能力）
```

直接使用 Skill 不是绕过治理，但必须保持与 Tool Agent 相同的输入检查、读写限制、秘密处理和证据要求。

## 已确认新增能力

- `tool_dependency_package_publisher_agent`：依赖包远程发布涉及顺序、授权和可验证结果，需要独立治理。
- `tool_test_delivery_document_agent`：提测材料有稳定输入输出合同，且会被版本交付阶段复用。

其余 Tool Agent 等运行态盘点后逐项决定，不按名称批量生成。
