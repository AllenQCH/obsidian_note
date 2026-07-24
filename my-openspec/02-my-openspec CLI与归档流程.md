---
title: "my-openspec CLI与归档流程"
aliases: ["my-openspec CLI与归档流程"]
source: "my-openspec/02-my-openspec CLI与归档流程.md"
author: "Codex"
published:
created: 2026-07-24
description: "当前 bin/openspec 的命令职责和从项目登记到不可变归档的执行顺序。"
tags: ["openspec", "cli", "workflow", "archive"]
type: "workflow"
status: "evergreen"
---

# my-openspec CLI与归档流程

## 摘要

当前 `bin/openspec` 提供 13 个子命令。正式需求主线是：登记项目和 Initiative，绑定服务，收集精确 Commit 结果，完成 readiness 检查，测试环境通过后生成不可变 Revision。

## 命令速查

| 命令 | 职责 |
| --- | --- |
| `init-project` | 初始化项目和项目级 standards |
| `init-initiative` | 创建共享 Initiative 和项目 Binding |
| `bind-service` | 在项目 Binding 中登记参与服务 |
| `collect-project-result` | 回填完整 Commit、测试和交付证据 |
| `set-initiative-status` | 更新 Initiative 状态 |
| `check-project-ready` | 检查一个项目的 Binding 和服务结果 |
| `check-initiative-complete` | 检查所有参与项目是否完成 |
| `check-archive-ready` | 检查不可变归档前置条件 |
| `new-investigation` | 创建独立问题调查 |
| `promote-investigation` | 将调查提升为正式 Initiative |
| `archive-initiative` | 从精确 Commit 生成 Revision |
| `search-history` | 查询历史归档 |
| `validate-workspace` | 校验中央工作区结构 |

## 正式需求流程

```text
init-project
-> init-initiative
-> bind-service
-> 服务仓维护项目内 openspec/
-> collect-project-result
-> check-project-ready
-> check-initiative-complete
-> 测试环境验证
-> check-archive-ready
-> archive-initiative
```

`collect-project-result` 必须使用完整 Commit SHA，并使用仓库相对路径登记测试和交付证据。`archive-initiative` 的 checkout 路径只是本次命令参数，不写入中央元数据。

## 调查流程

```text
new-investigation
-> 收集证据并形成结论
-> resolved / blocked
-> promote-investigation（需要正式开发时）
```

## 验证

```bash
bin/openspec validate-workspace
python3 -m unittest discover -s tests -v
```

命令结果以实际退出码和 JSON 输出为准，不使用旧笔记里的历史测试数量作为当前事实。

## 相关链接

- [[my-openspec总览]]
- [[my-openspec当前架构和对象模型]]
- [[my-openspec与Multi-Agent串联及迁移]]
