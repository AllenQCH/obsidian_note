---
title: "Codex规范落点与常用命令学习笔记"
source: "conversation: Hermes chat 2026-07-01; https://developers.openai.com/codex/cli/slash-commands; https://developers.openai.com/codex/hooks; https://developers.openai.com/codex/config-advanced"
author: "笨笨"
published:
created: 2026-07-01
description: "把 Codex 里的规范应该写在哪里、常用 slash commands、以及 /goal 与 hooks 的作用整理成一篇明日可直接复习的学习笔记。"
tags: ["codex", "workflow", "cli", "agent", "hooks", "goal"]
type: "workflow"
status: "processed"
---

# Codex规范落点与常用命令学习笔记

## 摘要

这篇笔记把两个问题合在一起整理：

1. **Codex 里的规范应该写在哪里**，不要再把 `project.md / rule.md / dev.md / sql.md` 混成一团。
2. **Codex CLI 常用命令怎么用**，尤其是 `/goal` 和 `hooks` 的实际作用。

一句话先记住：

- **AGENTS.md / docs 负责写规范**
- **hooks 负责把规范变成自动动作**
- **.rules / permissions 负责边界和审批**
- **agents / subagents 负责角色与流程，不负责吞掉所有规范正文**

## 核心内容

### 一、Codex 里规范到底写在哪

#### 1. 最核心的分层

| 层 | 推荐放什么 | 不要放什么 |
|---|---|---|
| `AGENTS.md` | 项目总纲、开发契约、默认工作方式、关键约束 | 冗长细则、所有示例、所有 SQL 细节 |
| `docs/standards/*.md` | `dev.md`、`sql.md`、`build.md`、`company.md` 这类长规范 | 每次都必须进上下文的硬规则 |
| 目录级 `AGENTS.md` | 某个目录的局部强约束，例如 `backend/AGENTS.md`、`db/AGENTS.md` | 全项目通用规范 |
| `.codex/hooks.json` 或 `.codex/config.toml` 里的 `[hooks]` | 自动检查、格式化、校验、通知、阻断 | 普通文档说明 |
| `.rules` / permissions | 哪些命令可越过 sandbox、哪些需要审批 | 代码风格、命名规范 |
| `agents/*.toml` 或 subagents | 角色、职责、输入输出、协作关系 | 大段编码规范正文 |

#### 2. 从 Cursor 旧习惯映射到 Codex

| 旧习惯 | 在 Codex 里建议放哪 |
|---|---|
| `project.md` | 仓库根 `AGENTS.md` |
| `rule.md` | `AGENTS.md` + `docs/standards/*.md` |
| `dev.md` | `docs/standards/dev.md` |
| `sql.md` | `docs/standards/sql.md` 或 `db/AGENTS.md` |
| 编译/测试规范 | `AGENTS.md` 说明 + hooks 自动执行 |
| 安全边界 | `AGENTS.md` + permissions / `.rules` |
| 人的角色分工 | subagent / agent 配置 |

#### 3. 推荐的目录结构

```text
repo/
├─ AGENTS.md
├─ .codex/
│  ├─ config.toml
│  └─ hooks.json
├─ .rules/
│  └─ shell.rules
├─ docs/
│  └─ standards/
│     ├─ dev.md
│     ├─ sql.md
│     ├─ build.md
│     └─ company.md
├─ backend/
│  └─ AGENTS.md
├─ db/
│  └─ AGENTS.md
└─ scripts/
   └─ AGENTS.md
```

#### 4. 一句话判断法

- **每次都必须遵守、10 秒内要让 agent 理解的** → 放 `AGENTS.md`
- **细则很多、需要示例和 checklist 的** → 放 `docs/standards/*.md`
- **要自动执行的** → 放 hooks
- **和权限、越权、审批有关的** → 放 `.rules` / permissions
- **和角色、流程编排有关的** → 放 agent / subagent

---

### 二、我目前对 Codex 常用命令的学习结论

OpenAI 官方 slash commands 文档里，比较常用、值得优先记住的有下面这些：

| 命令 | 作用 | 什么时候用 |
|---|---|---|
| `/init` | 生成当前目录的 `AGENTS.md` 脚手架 | 新项目刚开始接入 Codex |
| `/status` | 看当前会话配置和 token 使用 | 想确认模型、approval、writable roots、上下文容量 |
| `/diff` | 看当前 Git diff（含未跟踪文件） | 提交前快速复查改动 |
| `/review` | 让 Codex 审查当前 working tree | 改完代码后做第二视角检查 |
| `/model` | 切换当前模型 | 不同任务切轻量/深推理模型 |
| `/permissions` | 调整当前会话的权限模式 | 在 Read Only / Auto 等模式间切换 |
| `/mcp` | 查看已配置的 MCP 工具 | 想确认有哪些外部工具能被调用 |
| `/memories` | 配置 memory 使用与生成 | 想开关记忆注入或生成 |
| `/skills` | 浏览和使用 skills | 当前任务想借用已有工作流 |
| `/compact` | 压缩可见对话释放上下文 | 长会话跑久了以后 |
| `/goal` | 设定 / 暂停 / 恢复 / 查看 / 清除任务目标 | 长任务过程中给 Codex 一个持续追踪的目标 |
| `/hooks` | 查看与管理 lifecycle hooks | 排查 hook、trust hook、关掉某些 hook |
| `/plan` | 先进入 plan mode 再决定是否执行 | 大任务先要方案再动手 |
| `/new` | 在同一 CLI 会话中开一个新对话 | 想清空上下文重新聊 |
| `/resume` | 恢复旧会话 | 继续上次没做完的事 |
| `/fork` | 从当前对话分叉出新线程 | 想保留主线，同时测试新思路 |
| `/side` / `/btw` | 开一个临时 side conversation | 插一个旁支问题，不污染主线 |
| `/ps` | 看实验性的后台 terminal 输出 | 有后台任务在跑时看状态 |
| `/stop` | 停掉后台 terminals | 后台任务不想跑了 |
| `/debug-config` | 打印配置层与 requirements 诊断 | 查 config precedence、策略、实验性限制 |

> 最先该背熟的，不是全部命令，而是：`/init`、`/status`、`/diff`、`/review`、`/model`、`/permissions`、`/mcp`、`/goal`、`/hooks`、`/compact`。

---

### 三、`/goal` 到底是干什么的

OpenAI 官方 slash commands 文档对 `/goal` 的原话是：

- **Set, pause, resume, view, or clear a task goal**
- **Give Codex a persistent target to track while a larger task runs**

翻成更实用的话：

#### `/goal` 的本质

`/goal` 不是让 Codex“立刻执行某个命令”，而是给它一个**持续挂在会话里的任务目标**。

它更适合这种场景：

- 需求很长，怕聊着聊着跑偏
- 任务有多个阶段，希望 Codex 一直记得最终交付目标
- 中间会插入 side conversation、review、diff、debug，但不想丢主线

#### 适合怎么用

例如：

- “本轮目标是把支付回调链路排查清楚并给出最小修复 diff”
- “本轮目标是把 Obsidian GitHub 同步链路梳理成可复用 SOP”
- “本轮目标是完成 read-only SQL 取证，不做写操作”

#### 我对 `/goal` 的实战理解

- 它适合做**长任务护栏**
- 很像“把任务目标显式挂出来”
- 比普通一句 prompt 更适合持续跟踪
- 和 `/plan` 可以配合：先 `/goal` 定目标，再 `/plan` 做方案

#### 什么时候最值得用

- 一次任务要跑 20 分钟以上
- 中间会切模型、切线程、插 side 对话
- 任务边界很重要，不能越界

---

### 四、hooks 到底是干什么的

OpenAI 官方 hooks 文档把 hooks 定义为：

> Hooks are an extensibility framework for Codex.

也就是：

> **hooks 是 Codex 生命周期里的可插拔脚本机制。**

官方给出的典型用途包括：

- 发自定义日志或分析数据
- 扫描 prompt，防止误贴 API key
- 自动总结对话，形成记忆
- 在会话 turn 停止时跑自定义校验
- 在某个目录里自动改变提示或行为

#### 1. hooks 的本质

如果说：

- `AGENTS.md` 是“告诉 Codex 应该怎么做”
- 那 **hooks 是“在某些时机自动替你做动作”**

它最像下面这些能力：

- pre-commit hook 的 Codex 版
- agent 生命周期的自动触发器
- 某些规范的自动执行器

#### 2. hooks 常见落点

官方文档明确提到，最常用的 4 个位置是：

- `~/.codex/hooks.json`
- `~/.codex/config.toml`
- `<repo>/.codex/hooks.json`
- `<repo>/.codex/config.toml`

并且要记住：

- 多个 hook source 会**一起加载**
- 高优先级配置层**不会替换掉**低层 hooks
- 项目级 hooks 只有在 project `.codex/` layer **trusted** 时才会生效

#### 3. hooks 的 trust 机制

官方文档明确说：

- 非 managed 的 command hook 在运行前要先 **review + trust**
- trust 是按 **当前 hook 定义的 hash** 记录的
- hook 改了以后，会重新变成待审核状态
- CLI 里用 `/hooks` 来查看、审查、trust、禁用 hook

这点很重要：

> **hook 不是“写完就会跑”，而是“写完还要 trust”。**

#### 4. hooks 现在适合做什么

从官方文档看，现阶段最适合拿来做这些：

- Bash 命令前做检查（`PreToolUse`）
- 需要审批前做 guardrail（`PermissionRequest`）
- 命令执行后做 review / lint / format / validation（`PostToolUse`）
- turn 结束时跑自动总结或记录（`Stop`）
- 会话启动时加载一些上下文（`SessionStart`）

#### 5. 我最值得先记住的 hook 事件

官方文档出现的核心事件有：

| 事件 | 适合做什么 |
|---|---|
| `SessionStart` | 会话启动时加载说明、上下文、状态 |
| `SubagentStart` | 子 agent 启动时做初始化 |
| `PreToolUse` | 命令执行前检查风险或改写策略 |
| `PermissionRequest` | 发生审批请求前做 guardrail |
| `PostToolUse` | 命令执行后跑 review / validation / formatting |
| `PreCompact` | 压缩前做预处理 |
| `PostCompact` | 压缩后补充摘要或状态 |
| `UserPromptSubmit` | 用户 prompt 提交时记录或检查 |
| `SubagentStop` | 子 agent 停止时做收尾 |
| `Stop` | 当前 turn 结束时做收尾、总结、通知 |

#### 6. matcher 的实用理解

官方文档说明：`matcher` 是一个 regex，用来控制 hook 在什么情况下触发。

常见过滤对象包括：

- `Bash`
- `apply_patch`
- MCP tool name
- `manual` / `auto`（用于 compact）
- `startup` / `resume` / `clear` / `compact`（用于 session start）

也就是：

> 不是所有 hook 都是“逢事件必跑”，可以按工具名、压缩来源、启动来源等做过滤。

#### 7. hook 配置的最小理解模型

官方文档里的结构可以压成一句话：

> **一个事件 + 一个 matcher group + 一个或多个 hook handler**

最常见的是 command hook。今天值得先记住的不是完整 JSON 语法，而是这个结构：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ...",
            "statusMessage": "Checking Bash command"
          }
        ]
      }
    ]
  }
}
```

#### 8. 什么时候优先用 hooks，而不是只写文档

如果一条规则满足下面任意一项，就更适合进 hooks：

- 每次都应该自动检查
- 人工容易忘
- 出错代价高
- 结果能被脚本明确判断

典型例子：

- 改代码后自动跑 lint
- 执行危险 Bash 前做 deny / warn
- 输出前自动格式化
- 停止时自动沉淀简报

---

### 五、我对 `/goal` 与 hooks 的配合理解

这两个东西不是一类能力：

| 能力 | 更像什么 | 解决什么问题 |
|---|---|---|
| `/goal` | 会话级目标护栏 | 防止长任务跑偏 |
| `hooks` | 生命周期自动化脚本 | 把规则变成自动动作 |

最简单的理解方式：

- `/goal` 管 **“我要朝哪走”**
- `hooks` 管 **“走到某个时机时自动做什么”**

比如：

- `/goal`: “本轮只做 read-only 排查，不做写操作”
- `PermissionRequest hook`: 一旦出现写操作审批，就弹规则或直接阻断

这是很适合配起来的。

---

### 六、明天如果要继续学，建议按这个顺序

#### 第一层：先学会每天都用到的

1. `/status`
2. `/diff`
3. `/review`
4. `/model`
5. `/permissions`
6. `/compact`

#### 第二层：再学提高效率的

1. `/goal`
2. `/plan`
3. `/new`
4. `/resume`
5. `/fork`
6. `/side`

#### 第三层：再学体系化配置

1. `AGENTS.md`
2. `hooks`
3. `MCP`
4. `skills`
5. `subagents`
6. `permissions / .rules`

#### 第四层：最后再做工程化落地

1. 在一个真实 repo 里拆 `AGENTS.md`
2. 把 `dev/sql/build` 规范移到 `docs/standards`
3. 做 1-2 个真正有用的 hook
4. 再考虑 subagent / multi-agent 编排

---

### 七、本机现状补充

我这次在当前机器里实际执行 `codex --help` 时，命令没有正常工作，而是报错：

- 缺少可选依赖：`@openai/codex-darwin-x64`
- 报错信息建议：`npm install -g @openai/codex@latest`

这说明：

- **当前终端里的 npm 版 codex CLI 不是健康状态**
- 你明天如果要在终端里直接练习命令，最好先确认是：
  - 重装 npm 版 `@openai/codex`
  - 或改用已正常的桌面 / 正式安装版本

这个不影响今天整理文档，但会影响你明天实际敲命令。

## 可执行动作

- [ ] 明天先检查 `codex --help` 是否恢复正常；如果没恢复，优先重装 CLI。
- [ ] 选一个真实 repo，先补根目录 `AGENTS.md`。
- [ ] 把旧的 `project/dev/sql` 习惯迁到 `docs/standards/`。
- [ ] 先做一个最小 `PreToolUse` 或 `PostToolUse` hook，别一开始就搞复杂。
- [ ] 实战试一次 `/goal` + `/plan` + `/review` 的组合。

## 相关链接

- [[Codex启动加载顺序]]
- [[Codex Agent 能力与读取链路图]]
- [[Skill目录与维护规范]]
- [[Obsidian笔记写作规范]]
- [[02-个人Codex多Agent改造计划]]
- [[17-当前成果总清单]]
