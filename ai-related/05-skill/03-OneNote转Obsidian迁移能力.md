---
title: "03-OneNote转Obsidian迁移能力"
source: "Obsidian OneNote Import Help + Jimmy + onenote-to-obsidian + onenote-md-exporter"
author: "Allen"
published:
created: 2026-05-11
description: "把 OneNote 笔记迁移到 Obsidian 的实用方案整理，包含官方导入、Windows 高保真导出、跨平台 Markdown 转换三条路线。"
tags: ["obsidian-note", "tech-note", "onenote", "obsidian", "migration", "markdown", "skill"]
type: "tech-note"
status: "processed"
---

# 03-OneNote转Obsidian迁移能力

## 摘要

这篇笔记整理 **OneNote → Obsidian** 的迁移能力。结论先说：

- **第一优先**：先试 **Obsidian 官方 OneNote Importer**
- **第二优先**：如果追求保真度高，优先走 **Windows 下的 OneNote Md Exporter**
- **第三优先**：如果手头是 `.one` 文件、zip 导出包，或者想走更可编排的 Markdown 流程，可以考虑 **onenote-to-obsidian / Jimmy** 这类工具链

这套能力后面很可能会高频用到，适合沉淀成固定迁移工作流。

## 1. 为什么 OneNote -> Obsidian 不是一条路

OneNote 的难点在于：
- 它不是天然 markdown 系统
- 页面结构、层级、附件、图片、内部链接比较复杂
- 不同平台（Windows / Mac / Web）导出能力差异明显
- 很多第三方工具对 OneNote 的支持依赖 `.one` 文件、Windows 客户端或中间格式

所以迁移时通常不是“一个按钮搞定”，而是要按你的实际情况选路线。

## 2. 推荐路线总览

### 路线 A：Obsidian 官方 Importer（第一优先）
适合：
- 先快速迁移
- 想优先验证能不能导
- 想少折腾工具链

来源：
- Obsidian 官方帮助里明确有 **Import from Microsoft OneNote**

判断：
- 这是最应该先试的路线
- 官方支持，后续维护最稳
- 如果它已经满足你的结构和内容保留要求，就没必要一开始就走更复杂方案

### 路线 B：OneNote Md Exporter（Windows 高保真路线）
适合：
- 笔记很多
- 对结构、层级、附件、图片保真度要求高
- 接受借助 Windows 机器/虚拟机完成导出

来源：
- `alxnbl/onenote-md-exporter`

已确认特性：
- 是 **Windows 控制台程序**
- 目标就是把 OneNote 导出为 Markdown
- 适合迁移到 Obsidian / Joplin 等 markdown 笔记系统
- 支持：
  - section / section group 层级导出为文件夹层级
  - frontmatter
  - OneNote links 转 markdown / wikilink
  - 图片 / 附件
  - 简单表格
  - 一部分富文本样式

已确认限制：
- **要求 Windows**
- 依赖 OneNote for Windows（并非所有 OneNote 版本都支持）
- README 中提到需要 OneNote >= 2013，且 Windows Store 版不支持
- 还要求 Word >= 2013

结论：
- 如果你后面真的要大规模迁移，而且很在意导出质量，**这条路线很值得**。

### 路线 C：`.one` / zip 导出包 -> Markdown（跨平台/可编排路线）
适合：
- 手里拿得到 `.one` 文件或导出 zip
- 想走脚本化、可重复执行流程
- 希望后面可以批量处理、接进 agent workflow

代表工具：
1. `jonathangeller/onenote-to-obsidian`
2. `Jimmy`

#### C1. onenote-to-obsidian
已确认特性：
- 输入支持：
  - `.zip` 导出包
  - `.one` 文件目录
  - 单个 `.one` 文件
- 输出：Obsidian 兼容 markdown vault
- 支持：
  - frontmatter
  - checkboxes
  - links
  - created date
  - 失败时 fallback recovery
  - 可跳过 recycle bin
  - 可 flat 输出

要求：
- Python 3.10+
- `one2html`（Rust 工具，需要 Cargo / Rust）
- Unix `strings` 作为 fallback

结论：
- 这条路线更适合“脚本化迁移”
- 如果你后面想让我长期接管迁移流程，这种路线很有潜力

#### C2. Jimmy
定位：
- 一个通用的 note conversion tool
- 官方文档明确支持 **OneNote -> Markdown**，并提到可以导入 Obsidian

结论：
- Jimmy 更像一个“通用转换框架”
- 如果你后面不只是迁 OneNote，还想迁别的来源，Jimmy 这条线值得留意

## 3. 结合你这台机器的现实情况

我已经查过当前机器：

### 已有环境
- 有 OneNote for Mac：`/Applications/Microsoft OneNote.app`
- 有 OneNote 容器/数据目录
- 有 `python3`
- 有 `node`
- 有 `npm`
- 有 `brew`

### 目前缺的
- 没有 `pandoc`
- 没有 `dotnet`

### 对应判断
- **如果先试官方 Importer**：最省事，优先级最高
- **如果要跑 Windows 导出器**：这台机器本地不能直接跑，需要 Windows 环境
- **如果走脚本路线**：这台机器可以继续安装 Python / Rust 相关依赖来做

## 4. 我建议你的实际迁移策略

### 第一阶段：先验证
目标：确认迁移质量，不追求一步到位。

做法：
1. 选一个小 Notebook / 一个 Section
2. 先用 **Obsidian 官方 Importer** 试导
3. 检查：
   - 层级是否保留
   - 图片是否保留
   - 附件是否保留
   - 内部链接是否还能用
   - 标题 / 日期 / 清单项是否正常

如果官方导入已经够好：
- 直接走官方路线，不折腾

### 第二阶段：如果官方不够，再走高保真路线
如果出现下面情况：
- 层级丢失很多
- 图片 / 附件保留不好
- 内部链接不理想
- 批量迁移稳定性不够

那就升级成：
- **Windows + onenote-md-exporter**

### 第三阶段：如果要做可复用、可自动化流程
如果你后面想要：
- 批量迁移
- 多批次清洗
- 自动补 frontmatter
- 自动整理到固定目录
- agent 辅助迁移和验收

那我建议后面走：
- **`.one` / zip -> onenote-to-obsidian / Jimmy -> Obsidian`**

## 5. 迁移时最需要关注的验收点

不管走哪条路线，建议都按这 8 项验收：

1. **目录层级**
- Notebook / Section / Page 是否保留

2. **标题**
- 页面标题是否正确

3. **时间信息**
- created / updated 是否保留

4. **图片**
- 图片是否丢失，路径是否正常

5. **附件**
- 附件是否导出成功

6. **内部链接**
- OneNote 页面间链接是否还能转成 markdown link / wikilink

7. **待办 / 复选框**
- checklist 是否转成 `- [ ]`

8. **表格 / 富文本**
- 复杂表格、颜色、高亮、折叠内容是否出现明显损坏

## 6. 适合沉淀成的长期 workflow

### 最小工作流
OneNote 笔记 -> 官方 Importer -> Obsidian -> 人工抽查

### 稍强工作流
OneNote 笔记 -> 导出 markdown -> 我帮你批量清洗 frontmatter / 链接 / 路径 -> 写入 Obsidian

### 长期工作流
OneNote 笔记 -> 分批迁移 -> 我帮你：
- 统一命名
- 补标签
- 补 frontmatter
- 建导航页
- 建索引页
- 建主题页
- 整理成可查的 Obsidian 知识库

## 7. 对你最实用的结论

### 现在先记住三句话
1. **先试 Obsidian 官方 Importer**
2. **大规模高保真迁移优先考虑 Windows 的 onenote-md-exporter**
3. **想做脚本化 / 自动化迁移，可走 onenote-to-obsidian / Jimmy 路线**

### 你的最佳下一步
不是立刻迁全部，而是：
- 先拿一个最典型的小 notebook 做样本迁移
- 我帮你一起验收
- 再定最终路线

## 8. 后续我可以直接帮你做什么

- [ ] 陪你跑一次 OneNote -> Obsidian 的样本迁移
- [ ] 帮你设计迁移后的目录规范
- [ ] 帮你写迁移后统一 frontmatter 模板
- [ ] 帮你做迁移验收 checklist
- [ ] 如果你后面确定路线，我可以把这套流程再沉淀成可复用 skill

## 相关链接

- [[02-文章知识库相关能力]]
- [[Obsidian笔记写作规范]]
- [[Codex 工作台]]
