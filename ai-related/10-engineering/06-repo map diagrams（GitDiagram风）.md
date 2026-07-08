---
title: "06-repo map diagrams（GitDiagram风）"
source: "ai-related/10-engineering/06-repo map diagrams（GitDiagram风）.md"
author: "Allen"
published:
created: 2026-07-08
description: "选定 GitDiagram 风格作为 AI coding 的 repo-centric 图谱方案：用于仓库结构、模块关系、入口点、热点路径与改动风险可视化。"
tags: ["obsidian-note", "tech-note", "diagram", "gitdiagram", "repo-map", "ai-coding", "architecture"]
type: "tech-note"
status: "processed"
---

# 06-repo map diagrams（GitDiagram风）

## 摘要

这条路线不是把图做成“最好看的流程图”，而是把图做成 **AI coding 真正有用的代码理解地图**。

我最终选的是 **GitDiagram 风格**，原因是它更适合下面这类问题：
- 这个仓库大体怎么分层？
- 入口点在哪？
- 哪些模块彼此耦合？
- 改这一处，影响面大概在哪？
- AI 在正式改代码前，应该先建立什么全局理解？

一句话：

> Mermaid 更适合“把逻辑讲清楚”；GitDiagram 风更适合“把代码库摊开给 AI 看”。

## 这个风格适合什么

### 最适合
- 陌生仓库 onboarding
- 中大型项目模块梳理
- AI coding 前置上下文建立
- 架构速览
- 改动影响面 / blast radius 讨论

### 不最适合
- 业务流程讲解
- 产品交互流程
- 纯展示型方案图
- 极细函数级调用关系（这类更适合 `code2flow`）

## 统一结构

一个标准的 GitDiagram 风成品，建议包含 4 块：

1. **Repository**
   - 主要目录 / package / service / workspace
2. **Module Graph**
   - UI / API / Core / DB / Workflow 等核心关系
3. **AI Understanding Output**
   - Entry Points / Hot Paths / Dependencies / Change Risk
4. **Then AI Turns It Into Action**
   - understand repo → 生成图 → 写代码 → 验证

## 已完成的本地集成

### 1. Hermes skill
已创建本地可复用 skill：

- `gitdiagram-style-diagrams`

路径：
- `~/.hermes/skills/software-development/gitdiagram-style-diagrams/SKILL.md`

用途：
- 以后当我说“用 GitDiagram 风画 repo map / 模块图”时，可以直接复用这套约定。

### 2. 模板文件
模板路径：
- `~/.hermes/skills/software-development/gitdiagram-style-diagrams/templates/gitdiagram-style-repo-map.html`

用途：
- 直接改标题、模块名、分析卡片和连线，就能快速产出新的图。

### 3. HTML 转 PNG 脚本
脚本路径：
- `~/.hermes/skills/software-development/gitdiagram-style-diagrams/scripts/render_html_to_png.py`

用途：
- 把本地 HTML 图直接渲染成 PNG 预览图。

示例：
```bash
python3 ~/.hermes/skills/software-development/gitdiagram-style-diagrams/scripts/render_html_to_png.py \
  /path/to/diagram.html \
  /path/to/diagram.png
```

## 当前已生成的效果图

已生成过的示例图：
- HTML：`/Users/heytea/compare-gitdiagram.html`
- PNG：`/Users/heytea/compare-gitdiagram.png`

用途：
- 作为以后出图时的视觉基准样式。

## 以后怎么用

### 用法 A：先理解仓库，再让 AI 出图
适合：新项目 / 陌生代码库

流程：
1. 先列仓库结构
2. 识别入口点和核心模块
3. 用 GitDiagram 风出 repo map
4. 再进入编码

### 用法 B：AI coding 中途补图
适合：已经开始改代码，但感觉上下文太散

流程：
1. 先把当前改动涉及的目录 / 服务列出来
2. 画出模块图和依赖关系
3. 标出 hot path / change risk
4. 再继续实现和验证

### 用法 C：PR / 设计沉淀
适合：需要把复杂改动说清楚

流程：
1. 先出 GitDiagram 风结构图
2. 再补 Mermaid 风流程图
3. 一个负责“全局结构”，一个负责“逻辑流程”

## 推荐搭配

### 最推荐的组合
- **GitDiagram 风**：看代码库全局
- **Mermaid 风**：讲业务流程 / 状态流转
- **code2flow**：追具体调用链

也就是说：

> GitDiagram 风 = 全局地图
> Mermaid 风 = 逻辑路线
> code2flow = 局部剖面图

## 给笨笨的默认口径

以后如果我说：
- “给这个项目出个 repo map”
- “先把这个仓库摊开看看”
- “按 GitDiagram 风做一个成品图”

默认就是：
1. 先抽目录 / 模块 / 服务
2. 再抽入口点 / 热点路径 / 风险面
3. 生成 GitDiagram 风 HTML
4. 渲染 PNG 预览图
5. 必要时再补 Mermaid 流程图

## 相关链接

- [[03-harness engineering]]
- [[05-loop engineering]]
- [[13-自动化网页总览]]
- [[Hermes agent总览]]
