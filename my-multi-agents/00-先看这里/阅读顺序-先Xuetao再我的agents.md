---
title: "阅读顺序-先Xuetao再我的agents"
source: "my-multi-agents"
author: "Codex"
published:
created: 2026-07-20
description: "从外部原型到本地五类 Agent 目标架构的推荐阅读路径。"
tags: ["codex", "agent", "workflow", "reading-list"]
type: "workflow"
status: "processed"
---

# 阅读顺序-先Xuetao再我的agents

## 摘要

先读 Xuetao 原型理解“为什么拆层”，再读本地目标设计理解“具体拆成什么”。外部原型中的文件名是来源事实，不等于本地目标 Agent 名。

## 推荐顺序

1. [[Xuetao多agent体系总结]]：理解路由、执行、工具、门禁分离的价值。
2. [[Xuetao有哪些agent分层]]：查看外部原型的原始结构。
3. [[我的五层模型和Xuetao对比]]：只比较职责，不做旧名称映射。
4. [[最新multi-agent流程总览]]：查看本地已确认的目标架构。
5. [[所有agent五层结构和统一流程]]：理解五类 Agent 如何协作。
6. [[目标agent注册表]]：查看目标 Agent ID 和职责。
7. [[用户说法对应哪个agent]]：查看请求如何路由。
8. [[我的agent用例总览]]：通过具体场景理解调用链。

## 阅读时的边界

- “Xuetao 原型”章节可以保留对方真实命名。
- “我的 agents”章节只使用 `<layer>_<responsibility>_agent`。
- “目标”不等于“已启用”；运行态以全局配置与 TOML 为准。
- 文档中不再保留已放弃的本地角色或迁移历史清单。
