---
title: "08-Chrome MCP、opencli、Playwright怎么分工"
source: "ai-related/自动化网页操作相关/08-Chrome MCP、opencli、Playwright怎么分工.md"
author: "笨笨"
published:
created: 2026-07-02
description: "对比 Chrome MCP、opencli、Playwright 三种网页操作方式的定位、优劣、替代关系与最佳协作方式。"
tags: ["obsidian-note", "browser-automation", "chrome-mcp", "opencli", "playwright", "agent"]
type: "workflow"
status: "processed"
---

# Chrome MCP、opencli、Playwright怎么分工

## 摘要

这三种方式 **不是简单互相替代**，更像是三把不同的刀：

- **Chrome MCP**：最适合 **接管真实 Chrome 会话做观察 / 调试 / 半自动操作**
- **opencli**：最适合 **把已登录网页快速变成可复用的 CLI 工作流**
- **Playwright**：最适合 **沉淀成严谨、可回放、可测试、可批量执行的自动化脚本**

如果只记一句：

> **Chrome MCP 负责“看懂”，opencli 负责“先用起来”，Playwright 负责“做成资产”。**

## 核心内容

## 1. 三者本质上不是同一层东西

| 方式 | 本质定位 | 最适合的目标 |
|---|---|---|
| Chrome MCP | 通过 MCP 把浏览器能力暴露给 agent | 调试、观察、逆向、分析真实页面行为 |
| opencli | 把网页 / 登录态 / 浏览器操作封成 CLI 能力 | 已登录后台的日常操作、快速探索、半自动化 |
| Playwright | 工程化浏览器自动化 / E2E 测试框架 | 稳定脚本、回归测试、CI、长期维护 |

### Chrome MCP 是什么
更准确说，Chrome MCP 不是单一产品，而是一类模式：
- 一种是 **Chrome DevTools MCP**，更偏 DevTools / CDP / 调试 / network / performance
- 一种是 **扩展型 Chrome MCP**，更偏复用你真实 Chrome、真实登录态、跨 tab 操作

它最强的地方不是“能点页面”，而是：

> **把 DevTools 的观察力交给 agent。**

### opencli 是什么
opencli 更像一个“浏览器桥 + CLI 化层”。

在本机实际查看到的 `opencli browser` 能力包括：
- `open`
- `state`
- `click`
- `fill`
- `find`
- `frames`
- `eval`
- `network`
- `screenshot`
- `wait`
- `bind / unbind`

所以它特别适合：
- 已登录企业后台
- 复杂 iframe 页面
- 临时探索页面状态
- 在登录态里做半结构化操作

### Playwright 是什么
Playwright 是更典型的工程化自动化底座，强调：
- locator
- auto-wait
- trace / report
- assertions
- 多浏览器
- CI / E2E

它的强项不是“今天先帮我点一下”，而是：

> **把网页操作沉淀成长期可维护资产。**

## 2. 直接对比：优劣分别在哪里

| 维度 | Chrome MCP | opencli | Playwright |
|---|---|---|---|
| 核心定位 | agent 直接操作/调试真实浏览器 | 已登录网页的 CLI 化操作 | 工程化自动化与测试 |
| 复用真实登录态 | 强 | 强 | 中等 |
| 探索复杂后台 | 很强 | 强 | 中等 |
| network / console / debug | 最强 | 中等偏强 | 强 |
| 快速试错 | 很强 | 很强 | 中等 |
| 长期脚本化 | 中等 | 中等 | 最强 |
| CI / 回归测试 | 弱 | 弱 | 最强 |
| 团队标准化 | 中等 | 中等 | 最强 |
| 对页面变化的韧性 | 中等 | 中等 | 取决于脚本质量 |
| 上手速度 | 中 | 快 | 中 |
| 工程维护成本 | 中 | 低到中 | 高 |

## 3. 各自最擅长的场景

### 3.1 Chrome MCP 最擅长：看懂网页为什么这样
如果目标是：
- 看 network 请求
- 看 response body
- 看 console 报错
- 看 performance
- 看按钮背后到底打了什么接口
- 看真实 selector / runtime state

那 **Chrome MCP 是最强的侦察工具**。

它特别适合：
- 新站点探索
- 企业后台逆向
- 查页面动作与后端接口映射
- 定位“为什么自动化总出错”

### 3.2 opencli 最擅长：已登录网页直接干活
如果目标是：
- 复用当前浏览器登录态
- 打开某页、切 tab、切 iframe
- 查表格、点筛选、导出
- 临时做几步可重复操作
- 不想立刻进入“正式写自动化脚本”的重模式

那 **opencli 是最顺手的操作层**。

尤其适合：
- 企业后台
- 控制台
- 页面结构复杂但人已经能正常操作的系统
- 需要 agent 先干活、再决定是否沉淀成脚本的流程

### 3.3 Playwright 最擅长：变成长期自动化资产
如果目标是：
- 写稳定脚本
- 做回归测试
- 跑 CI
- 批量执行
- 结构化断言
- 长期维护

那就该上 **Playwright**。

它最适合：
- E2E 测试
- 固定导出流程
- 固定巡检流程
- 需要长期复用的 Web 自动化

## 4. 三者是不是互相替代

### 能替代的部分
在这些基础能力上，三者有明显重叠：
- 打开页面
- 点击
- 输入
- 截图
- 读取页面内容

### 不能替代的部分
但真正拉开差距的是：

#### Chrome MCP 不能完全替代 Playwright
因为它强在：
- 调试
- 观察
- DevTools 级洞察

但它不天然等于：
- 成熟测试框架
- 长期维护脚本体系
- 团队级 CI 资产

#### Playwright 也不能完全替代 Chrome MCP / opencli
因为它虽然也能操作页面，但对这些场景不够顺手：
- 直接接管已登录真实浏览器
- 临时探索企业后台
- 现场查 network / console / runtime state

#### opencli 也不是 Playwright 的替代品
opencli 更像：
- 操作桥
- 登录态浏览器 CLI
- 探索与半自动化层

它不是完整测试框架。

## 5. 最佳配合方式：三层分工

我更推荐按三层来用：

### 第一层：侦察层 —— Chrome MCP
用途：
- 查页面到底发生了什么
- 看请求、响应、报错、状态
- 识别真实 API、真实页面状态和失败原因

### 第二层：操作层 —— opencli
用途：
- 基于已登录浏览器先把事情做起来
- 进行轻量、灵活、可重复但还没必要正式工程化的操作
- 补 DOM / iframe / JS / 页面状态验证

### 第三层：沉淀层 —— Playwright
用途：
- 把已经摸清楚、值得长期复用的流程固化成脚本
- 加断言、trace、回归、CI

### 一句话工作流
```text
先用 Chrome MCP 看懂页面
        ↓
再用 opencli 验证和跑通真实操作
        ↓
最后把稳定流程沉淀成 Playwright
```

## 6. 如果只选一个，怎么选

| 目标 | 优先选择 |
|---|---|
| 已登录网页里直接干活 | opencli |
| 最强网页调试与逆向观察 | Chrome MCP |
| 长期可维护自动化 / 测试 | Playwright |

## 7. 对 Allen 当前环境最实用的建议

### 本机验证结果（2026-07-02）
实际检查到：
- `opencli` 已安装：`1.8.0`
- Python `playwright` 已安装：`1.60.0`
- Google Chrome 已安装
- Hermes 当前 MCP server 配置里 **还没有接入 Chrome MCP**
- 当前 Hermes 已接入的 MCP 主要是：`dingtalk`、`yahoo_finance`

### 因此更实用的顺序是
1. **先把 opencli 当主力操作层**
   - 因为你已经可用
   - 而且非常适合已登录后台、企业系统、iframe 页面
2. **再把 Chrome MCP 当高级侦察层补上**
   - 尤其适合调试、抓 network、分析按钮背后的真实接口
3. **把稳定高频流程再升级成 Playwright**
   - 让它从“临时能跑”升级成“长期资产”

### 这套分工对你的意义
它避免两种常见错误：
- 一上来就用 Playwright 硬啃复杂已登录后台，成本过高
- 永远停留在临时操作，不把稳定流程沉淀成正式资产

## 8. 当前外部信号：为什么 Chrome MCP 值得重点关注

这次顺手查到的一个明显信号是：**Chrome MCP 现在非常热。**

- `ChromeDevTools/chrome-devtools-mcp` GitHub stars 很高
- HN 上 Chrome DevTools MCP 相关文章热度也很高

这说明它已经不是“小玩具”，而是正在进入 agent/browser tooling 的主流组合里。

但它更像“浏览器调试与观察接口”，不是自动取代 opencli 或 Playwright 的单一答案。

## 可执行动作

- [ ] 如果后面要做“网页登录自动化能力栈”，优先补一篇《Chrome MCP 接入与最小实战》
- [ ] 如果当前要直接服务日常后台操作，先继续沉淀 opencli 工作流与 adapter 思路
- [ ] 对于高频、稳定、值得复用的网页流程，再单独挑出来升级成 Playwright 脚本

## 相关链接

- [[00-自动化网页总览]]
- [[网页自动化方案]]
- [[拆开讲三种“模拟点击”的层次]]
- [[05-OpenCLI]]
- [[07-adopter和chrome daemon]]
