---
title: "九个Stage职责"
source: "my-multi-agents/02-当前agent架构/九个Stage职责.md"
author: "Codex"
published:
created: 2026-07-22
description: "九个活跃 Stage Agent 的输入、输出和边界。"
tags: ["codex", "agent", "stage"]
type: "note"
status: "evergreen"
---

# 九个Stage职责

## 摘要

九个 Stage 各自拥有一个阶段目标和稳定输出；它们不替代 Control、Capability 或 Gate。

## 核心内容

| Stage | 主要输入 | 主要输出 | 不负责 |
| --- | --- | --- | --- |
| `stage_product_owner` | 历史文档、新需求、现有行为 | 需求范围、服务清单、验收标准、非目标 | 后端设计、编码、产品验收 |
| `stage_backend_designer` | 产品输出、代码现状 | 设计、接口/数据契约、改动文件、回滚与回归面 | 编码和测试执行 |
| `stage_test_case_designer` | 产品输出 + 后端设计 | 正常、异常、边界和回归用例 | 执行测试或宣布通过 |
| `stage_backend_developer` | 已确认设计和用例 | 最小实现、单元测试、构建证据 | 自我 CR、交付、扩大设计 |
| `stage_code_reviewer` | 规范、需求、设计、diff、测试 | 按严重度排序的 CR 结论 | 直接修代码或放弃阻塞项 |
| `stage_test_runner` | 设计用例、diff、项目启动规则 | 本地测试 verdict 和证据 | commit、push、交付 |
| `stage_version_delivery` | 已通过测试的产物和授权 | Commit、SQL、依赖、材料和流水线证据 | 绕过授权或归档未验证版本 |
| `stage_bug_investigator` | 问题、异常、traceId、代码 | 证据链、首个异常、源码流程和结论 | 修改代码 |
| `stage_test_environment_runner` | 已交付版本、用例、环境 | 数据准备、Pod curl、DB/日志结果、Bug 清单 | 修改生产或把失败归档为完成 |

## 相关链接

- [[当前agent注册表]]
- [[当前运行架构和统一流程]]
- [[测试执行和版本交付]]
