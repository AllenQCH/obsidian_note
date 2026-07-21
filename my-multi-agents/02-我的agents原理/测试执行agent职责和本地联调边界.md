---
title: "测试执行agent职责和本地联调边界"
source: "conversation: Codex chat 2026-07-20"
author: "Codex"
published:
created: 2026-07-20
description: "stage_test_runner_agent 的本地 Docker、跨服务联调、Mock 和正式验证规则。"
tags: ["codex", "agent", "testing", "docker", "integration"]
type: "workflow"
status: "processed"
---

# 测试执行agent职责和本地联调边界

## 摘要

`stage_test_runner_agent` 同时承担本地集成调试和正式测试执行，不再拆独立调试 Agent。成功标准是业务链路结果可验证，而不是容器、进程或端口已经启动。

## 执行步骤

1. 根据 diff、设计和测试用例解析参与服务与依赖。
2. 优先复用项目登记的启动方式；需要时使用 Docker 启动基础依赖。
3. 启动参与服务并验证进程、端口、健康路由和关键配置。
4. 准备隔离测试数据，记录数据来源和清理方式。
5. 通过真实 Controller、Consumer、Job、Runner 或页面入口触发链路。
6. 验证 API、DB、消息、文件、日志或页面结果。
7. 按 `test-cases.md` 执行回归，记录 pass/fail 和剩余风险。
8. 清理临时数据和本地资源，输出 `verification.md`。

## Mock 边界

- 可以在测试层、代理层或独立 Mock 服务中模拟不可控外部依赖。
- 可以构造本地测试数据，但必须隔离且可清理。
- 不允许在生产业务接口中增加临时 Mock 分支。
- 不允许修改正常链路逻辑只为让本地测试通过。
- Mock 必须可显式启停，默认关闭，并且不能进入生产配置。
- 能用真实本地依赖验证时，优先真实闭环；无法真实验证的部分要明确标记。

## 必须留存的证据

- 实际启动的服务和依赖清单。
- 触发入口与输入数据。
- 关键命令、HTTP 状态、日志或查询结果。
- 预期与实际结果对照。
- 未覆盖项、失败项和清理结果。
