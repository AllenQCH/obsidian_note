---
title: "Codex Agent 能力与读取链路图"
source: "Codex工作台/Codex Agent 能力与读取链路图.md"
author: "Allen"
published: 
created: 2026-05-07
description: "这份文档用 Mermaid 汇总当前 `codex-workspace` 已经具备的 agent 能力，以及后续可以扩展进来的能力。"
tags: ["obsidian-note", "codex", "workflow", "agent", "skill", "prompt", "openspec"]
type: "workflow"
status: "processed"
---
# Codex Agent 能力与读取链路图

这份文档用 Mermaid 汇总当前 `codex-workspace` 已经具备的 agent 能力，以及后续可以扩展进来的能力。

## 1. 规则读取与上下文生效顺序

```mermaid
flowchart TD
    A[平台系统规则<br/>System / Developer Instructions] --> B[Codex 本机配置<br/>~/.codex/config.toml]
    B --> C[全局记忆 / 全局规则<br/>~/.codex/AGENTS.md]
    C --> D[当前工作区规则<br/>codex-workspace/AGENTS.md]
    D --> E[目标项目根规则<br/>目标项目/AGENTS.md]
    E --> F[子目录规则<br/>更靠近当前目录的 AGENTS.md]
    F --> G[当前用户需求<br/>用户消息 / prompt 文件]
    G --> H[按需读取内容<br/>routing.md / skills / 代码 / openspec / README]

    A -.最高优先级.-> H
    D -.当前工作区只负责路由.-> G
```

## 2. 当前开发需求分流链路

```mermaid
flowchart TD
    U[用户提出开发需求] --> W[codex-workspace]
    W --> R[读取 routing.md<br/>只判断 region + module]
    R -->|cn + lowcost| IMS[IMS 主任务<br/>codex-downloads/service/scm/ims]
    R -->|cn + pof| CNP[国内订货通主任务<br/>codex-downloads/service/scm/dinghuotong]
    R -->|intl + pof| INTP[海外订货通主任务<br/>codex-downloads/intl/supplychain/dinghuotong]

    IMS --> IMSA[由 IMS 自己读取 AGENTS.md<br/>分析 / openspec / 子任务 / 验收]
    CNP --> CNPA[由国内订货通自己读取 AGENTS.md<br/>分析 / openspec / 子任务 / 验收]
    INTP --> INTPA[由海外订货通自己读取 AGENTS.md<br/>进入 order/service-hsp-pom-web 等仓库]

    W -.禁止.-> X[直接读取业务代码 / 直接实现 / 直接测试 / 直接提交]
```

## 3. Ghostty 启动器结构

```mermaid
flowchart LR
    A[需求文本] --> B[prompt 文件<br/>.codex-launchers/*.prompt]
    B --> C[launch-codex-in-ghostty-split.sh<br/>外层封装]
    C --> D[复制短命令到剪贴板]
    D --> E[Ghostty Cmd+D<br/>打开右侧分屏]
    E --> F[粘贴并回车]
    F --> G[launch-primary-codex.sh<br/>内层启动器]
    G --> H[cd primary workspace]
    H --> I[codex --cd primary workspace prompt]
    I --> J[目标项目 Codex 会话]
```

## 4. Agent / Memory / 本地配置的 Git 规则

```mermaid
flowchart TD
    A[本地 agent 上下文] --> B{是否需要进入 Git?}

    A --> A1[AGENTS.md]
    A --> A2[memory 文件]
    A --> A3[.codex/ 目录]
    A --> A4[skills / launcher / 本地配置]

    B -->|默认不需要| C[不要主动 git add / commit]
    B -->|用户明确要求版本化| D[再按用户要求提交]

    A1 --> B
    A2 --> B
    A3 --> B
    A4 --> B
```

## 5. 当前已具备能力总览

```mermaid
mindmap
  root((Codex 工作台))
    规则系统
      平台系统规则
      全局 AGENTS / memory
      workspace AGENTS
      项目 AGENTS
      子目录 AGENTS
    需求分流
      URL 需求接收
      region 判断
        cn
        intl
      module 判断
        lowcost
        pof
        invoice
      routing.md
    启动执行
      prompt 文件
      Ghostty 右侧分屏
      launch-codex-in-ghostty-split.sh
      launch-primary-codex.sh
    项目主任务
      IMS
      国内订货通
      海外订货通
      未来更多主任务
    Skills
      bug-killer
      lark 系列
      springboot 系列
      frontend/backend patterns
      verification
      security
    文档与图
      Mermaid
      ASCII
      Markdown 表格
      PlantUML / Graphviz
      HTML / SVG
      图片生成
```

## 6. 未来可扩展点

```mermaid
flowchart TD
    A[未来扩展] --> B[更多路由]
    A --> C[更多启动目标]
    A --> D[更多输入来源]
    A --> E[更多验证能力]
    A --> F[更多图形输出]

    B --> B1[intl + lowcost]
    B --> B2[intl + invoice]
    B --> B3[cn + invoice]
    B --> B4[新业务模块]

    C --> C1[按模块启动 primary Codex]
    C --> C2[按服务仓库启动 child Codex]
    C --> C3[按修复 / 验证 / review 分角色启动]

    D --> D1[飞书文档 URL]
    D --> D2[HHT bug URL]
    D --> D3[GitLab Issue / MR]
    D --> D4[纯文本需求]

    E --> E1[Java 单测]
    E --> E2[接口回归]
    E --> E3[前端截图验证]
    E --> E4[代码审查]

    F --> F1[Mermaid 文档]
    F --> F2[SVG / HTML 可视图]
    F --> F3[PPT / 文档图]
```

## 7. 推荐使用原则

```mermaid
flowchart TD
    A[收到任务] --> B{是否是开发需求?}
    B -->|否| C[在 codex-workspace 处理普通任务]
    B -->|是| D[只做需求接收与路由]
    D --> E[读取 routing.md]
    E --> F{能否判断 region + module?}
    F -->|不能| G[问一个简短澄清问题]
    F -->|能| H[生成 prompt 文件]
    H --> I[启动 Ghostty 主任务]
    I --> J[当前工作区停止业务实现]
```

## 摘要

- 待整理。

## 核心内容

- 待补充。

## 可执行动作

- [ ] 待确认。

## 相关链接

- [[Codex 启动加载顺序]]
- [[0、Codex CLI 本质架构]]
- [[1、skill是什么]]
