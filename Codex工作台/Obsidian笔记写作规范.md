---
title: "Obsidian笔记写作规范"
source: "Codex工作台/Obsidian笔记写作规范.md"
author: "Allen"
published:
created: 2026-05-07
description: "用于统一 Obsidian 笔记属性、目录、标签和正文结构的写作规范。"
tags: ["obsidian-note", "codex", "workflow", "agent", "skill", "tooling", "cli"]
type: "workflow"
status: "processed"
---

# Obsidian笔记写作规范

## 摘要

本规范适用于当前 Obsidian 主库 `/Users/heytea/Documents/obsidian_note` 下的所有 Markdown 文档，不只适用于 `Codex工作台/`。

以后写入或整理 Obsidian 的任意笔记，都统一采用“属性完整、摘要先行、结构清晰、来源可追溯”的格式。

## 核心内容

### 当前默认笔记体系

- 当前主库后续默认采用：**PARA-lite 目录分层 + MOC 主题入口 + Evergreen 知识沉淀 + Raw Inbox 缓冲区**。
- 具体落地方案见：[[Obsidian笔记体系方案（Allen版）]]。
- 写笔记前先判断类型：索引 / 知识 / 项目 / 素材，再决定目录、标题和正文结构。

### 特定主题风格优先级

- 通用 Obsidian 规范负责约束属性、目录、标签、摘要和链接。
- 如果某个主题已经有更细的个人写作风格规范，则正文表达优先遵循那个专题规范。
- 当前已明确沉淀的专题风格：[[Python学习笔记写作风格规范]]
- 如果想先看不同笔记风格的适用场景，再回到规范落地，可先看：[[Obsidian优秀笔记风格参考]]

### 必备属性

`source` 表示“这篇笔记的来源”，不是“规范适用范围”。如果笔记是自己创建的规范、方案、工作流，`source` 可以写当前笔记的相对路径；如果来自网页、截图、会议或对话，则写原始 URL、文件、会议或对话来源。

```yaml
---
title:
source:
author:
published:
created:
description:
tags:
type:
status:
---
```

### 默认正文结构

```markdown
# 标题

## 摘要

## 核心内容

## 可执行动作

## 相关链接
- [[Skill目录与维护规范]]
- [[Codex 工作台]]
```

### 目录规则

- `Clippings/`：外部文章、X、网页剪藏。
- `Codex工作台/`：Codex、Agent、Skill、MCP、工具链。
- `技术笔记/`：技术知识、框架、语言、数据库。
- `项目相关/`：需求、方案、项目上下文、复盘。
- `会议纪要/`：会议结论、决策、待办。
- `_inbox/`：暂时无法判断归属的笔记。

### 标签规则

- 标签用于筛选和聚类。
- 使用英文、小写、短词，例如 `codex`、`agent`、`workflow`、`tech-note`、`project`。
- 每篇笔记保留少量稳定标签，避免为了图谱效果堆过多标签。

### 内部链接规则

- Obsidian 图谱主要依赖 `[[笔记标题]]` 建立笔记之间的关系。
- 每篇处理过的笔记应在 `## 相关链接` 下保留 2-5 个明确相关的 `[[笔记标题]]`。
- 优先链接到已有笔记标题，例如 `[[Codex 启动加载顺序]]`。
- 不添加猜测性链接；准确稀疏的图谱比噪声密集的图谱更有用。

### 图形规则

- 简单流程图优先 Mermaid。
- 更重视可读性和视觉表达时使用 Excalidraw。
- `.excalidraw.md` 文件只安全更新 frontmatter，不强行追加普通笔记章节。

## 可执行动作

- [ ] 后续新增 Obsidian 笔记时触发 `obsidian-note-writing` skill。
- [ ] 对空白或 `raw` 状态笔记继续补充摘要和核心内容。

## 相关链接

- Skill 路径：`/Users/heytea/.codex/skills/obsidian-note-writing`
- [[Python学习笔记写作风格规范]]
