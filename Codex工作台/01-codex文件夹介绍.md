---
title: "01-codex文件夹介绍"
source: "Codex工作台/01-codex文件夹介绍.md"
author: "heytea"
published:
created: 2026-07-05
description: "介绍本机 ~/.codex 目录中各个文件夹和关键文件的用途，帮助判断哪些是配置、会话、日志、hook、skill、agent、缓存和备份。"
tags: ["codex", "filesystem", "config", "sessions", "hooks", "skills", "agents"]
type: "tech-note"
status: "processed"
---

# 01-codex文件夹介绍

## 摘要

`~/.codex` 是 Codex 在这台电脑上的用户级工作目录。

它不是一个普通项目目录，而是 Codex 的“本机运行家目录”：里面同时放了配置、登录态、会话记录、日志、skills、agents、hooks、插件、缓存和临时文件。

最重要的判断是：

- `config.toml` 决定 Codex 怎么启动、用什么模型、启用哪些 agent / MCP / plugin。
- `sessions/` 和 `history.jsonl` 记录历史会话。
- `skills/` 是可复用能力库。
- `agents/` 是你本机 multi-agent 框架的注册文件和说明文档。
- `hooks/` 是 Codex 在特定生命周期自动执行的小脚本。
- `logs_*.sqlite`、`state_*.sqlite`、`goals_*.sqlite` 是运行数据库，不能随便删。
- `.tmp/`、`tmp/`、`cache/` 更偏缓存和临时产物，但也不建议在 Codex 运行时直接清空。

## 一句话结构图

```text
~/.codex/
  config.toml                 # Codex 主配置
  auth.json                   # 登录/认证状态
  AGENTS.md                   # 用户级行为规则
  sessions/                   # 按日期保存的会话记录
  history.jsonl               # 命令/输入历史流水
  session_index.jsonl         # 会话索引
  skills/                     # 用户级 skills 能力库
  agents/                     # 个人 multi-agent 注册与说明
  hooks/ + hooks.json         # 生命周期钩子脚本和钩子配置
  plugins/                    # Codex 插件
  browser/                    # Codex 浏览器会话状态
  node_repl/                  # Node REPL / MCP 运行状态
  memories/                   # 长期记忆
  commands/                   # 自定义命令
  rules/                      # 规则文件
  logs_*.sqlite               # 日志数据库
  state_*.sqlite              # 状态数据库
  goals_*.sqlite              # goal 目标数据库
  .tmp/ tmp/ cache/           # 临时文件与缓存
  shell_snapshots/            # shell 快照
  backups / archive 类目录     # 历史备份和导入归档
```

## 核心配置文件

| 文件 | 作用 | 能不能动 |
| --- | --- | --- |
| `config.toml` | Codex 主配置。模型、provider、multi-agent、MCP、plugin、项目 trust、agent 注册都在这里。 | 可以改，但要非常谨慎；改错会影响 Codex 启动和工具能力。 |
| `AGENTS.md` | 用户级全局规则。Codex 在相关上下文中会读取这些行为约束。 | 可以维护；适合写长期稳定的个人规则。 |
| `auth.json` | Codex 登录或认证状态。 | 不要手动改，不要外传。 |
| `installation_id` | 本机安装标识。 | 不要改。 |
| `version.json` | 当前 Codex 版本相关状态。 | 不需要手动改。 |
| `model-catalog.gpt-5.5.json` | 模型目录缓存。 | 不需要手动改。 |

## 会话与历史

| 路径 | 作用 |
| --- | --- |
| `sessions/` | Codex 会话正文归档，按年月日分层，例如 `sessions/2026/07/05/`。需要追溯某次对话时会看这里。 |
| `history.jsonl` | 命令、输入或会话历史的追加式流水记录。 |
| `session_index.jsonl` | 会话索引，用来快速定位历史 session。 |
| `shell_snapshots/` | shell 环境或命令执行状态快照，方便恢复或诊断执行上下文。 |

这些文件通常不手动编辑。想查历史可以读，想清理也要先备份。

## 日志、状态和数据库

| 文件 | 作用 | 注意 |
| --- | --- | --- |
| `logs_2.sqlite` | Codex 日志数据库。 | 不要手工删。 |
| `state_5.sqlite` | Codex 本机状态数据库。 | 不要手工删。 |
| `goals_1.sqlite` | goal / 任务目标相关数据库。 | 不要手工删。 |
| `*.sqlite-wal` | SQLite 预写日志文件。 | 和主库是一套，不能单独删。 |
| `*.sqlite-shm` | SQLite 共享内存辅助文件。 | 和主库是一套，不能单独删。 |
| `log/`、`logs/` | 旧式或特定功能日志目录。 | 可读；清理前先确认没有正在使用。 |

重点：`-wal` 和 `-shm` 看起来像临时文件，但它们是 SQLite 正常运行的一部分，不能凭感觉删除。

## skills：可复用能力库

| 路径 | 作用 |
| --- | --- |
| `skills/` | 你自己安装和维护的 Codex skills。每个 skill 通常有一个 `SKILL.md`，说明什么时候触发、怎么执行。 |
| `skills/.system/` | Codex 系统级 skills，例如 imagegen、openai-docs、skill-creator 等。 |
| `skill-catalog/` | skill 索引目录，帮助按名称或运行时查找 skill。 |
| `skills_backup/` | skills 的历史备份。 |
| `skill-duplicates-archive/` | 重复 skill 的归档区。 |
| `vendor_imports/` | 从外部导入的能力资源。 |

可以把 `skills/` 理解成 Codex 的“工具说明书仓库”。当你要求 Codex 做 Obsidian 整理、trace 排查、dbauto 查询、SSO 登录、提测文档等任务时，很多行为就是从这里的 skill 触发的。

## agents：你的 multi-agent 框架

| 路径 | 作用 |
| --- | --- |
| `agents/` | 你的个人 multi-agent 运行配置目录。 |
| `agents/control/` | 控制层 agent，例如请求路由、阶段编排。 |
| `agents/stage/` | 阶段层 agent，例如任务规划、调查规划、执行协调、收口报告。 |
| `agents/operator/` | 工具执行层 agent，例如 dbauto、trace log、Obsidian、GitHub、BK pipeline、Excel。 |
| `agents/gate/` | gate 层 agent，用来判断阶段是否可以继续、是否需要阻塞或补证据。 |
| `agents/docs/` | multi-agent 框架说明文档、注册表、流程图、用例文档。 |

这里和 `config.toml` 是配套关系：只有 `.toml` agent 文件放在 `agents/` 下还不够，还需要在 `config.toml` 里有 `[agents.xxx]` 注册项，Codex 才能把它当成可用 agent。

## hooks：自动钩子

| 路径 | 作用 |
| --- | --- |
| `hooks.json` | hook 配置入口，定义哪些生命周期事件触发哪些脚本。 |
| `hooks/` | hook 脚本目录。 |
| `hooks/sync-codex-session-id.py` | 同步 Codex session id 的脚本。 |
| `hooks/turn-usage-summary.py` | 回合用量摘要脚本。 |
| `hooks/__pycache__/` | Python 编译缓存。 |

hook 可以理解成“Codex 执行到某个节点时自动跑的小程序”。它适合做记录、同步、统计、检查，不适合塞复杂业务流程。

如果 hook 写错，可能会影响 Codex 某些生命周期动作，所以不要随便改 `hooks.json` 和脚本。

## plugins、browser 和 MCP 运行时

| 路径 | 作用 |
| --- | --- |
| `plugins/` | Codex 插件目录。当前本机启用了 `browser@openai-bundled`。 |
| `plugins/cache/` | 插件缓存。 |
| `.tmp/bundled-marketplaces/` | openai-bundled marketplace 的本地来源缓存。 |
| `browser/` | Codex 浏览器能力的会话状态。 |
| `browser/sessions/` | 浏览器 session 配置，例如 in-app browser 或 Browser Bridge 会话记录。 |
| `node_repl/` | Node REPL MCP 的运行状态。 |
| `node_repl/active_execs/` | 正在运行或最近运行的 Node REPL 执行记录。 |
| `computer-use/` | Codex Computer Use 相关本地应用和运行资源。 |

这些目录支撑“浏览器操作、Node REPL、插件、Computer Use”等能力。它们不是普通文档，不建议手动移动。

## memories、commands 和 rules

| 路径 | 作用 |
| --- | --- |
| `memories/` | 长期记忆目录，记录一些跨会话复用的经验、项目规则或专项 playbook。 |
| `commands/` | 自定义命令说明或快捷命令，例如 `sessionids.md`。 |
| `rules/` | 规则文件目录，例如 `default.rules`。 |

这些更像“用户级知识和行为补充”。它们通常比会话记录更稳定，比 `AGENTS.md` 更适合放专项记忆。

## 缓存、临时目录和归档

| 路径 | 作用 | 建议 |
| --- | --- | --- |
| `.tmp/` | Codex 临时资源，包含 marketplace / plugin 相关缓存。 | 不在运行时清理。 |
| `tmp/` | 临时文件。 | 可清查，但先看内容。 |
| `cache/` | Codex app、工具或目录缓存。 | 可清查，但不盲删。 |
| `agent-catalog-runtime/` | agent catalog 运行时产物。 | 通常不手动改。 |
| `superpowers/` | Superpowers / Everything Claude Code 相关增强系统。 | 不是缓存，默认保留。 |
| `worktrees/` | Codex 或相关工具创建的工作树目录。 | 删除前确认没有任务依赖。 |

## 根目录备份文件

| 文件 | 作用 |
| --- | --- |
| `config.toml.bak.*` | 不同时间点的 Codex 配置备份。 |
| `.codex-global-state.json.bak` | 全局状态备份。 |
| `.personality_migration` | 个性化迁移标记。 |
| `.DS_Store` | macOS Finder 元数据。 |

备份文件可以整理到 archive，但不建议直接删。尤其是 `config.toml.bak.*`，在配置改坏时很有价值。

## 新下载的 Codex 通常会有什么

一个比较干净的新 Codex 用户目录通常会先有这些：

- `config.toml`
- `auth.json`
- `sessions/`
- `history.jsonl`
- `session_index.jsonl`
- `state_*.sqlite`
- `logs_*.sqlite`
- `version.json`
- `AGENTS.md` 或项目/用户规则文件

随着使用增加，会逐渐出现：

- `skills/`
- `hooks/`
- `plugins/`
- `browser/`
- `node_repl/`
- `memories/`
- `cache/`
- `tmp/`

你这台电脑已经不是“刚下载的 Codex”，而是一个高度扩展过的 Codex 工作环境：已经有 multi-agent、skills、hooks、browser plugin、Node REPL、Superpowers、Computer Use 和不少内部工作流能力。

## 能不能删的粗略判断

| 类型 | 示例 | 建议 |
| --- | --- | --- |
| 主配置 | `config.toml`、`AGENTS.md` | 不随便删。 |
| 登录和状态 | `auth.json`、`installation_id`、`state_*.sqlite` | 不删。 |
| 会话历史 | `sessions/`、`history.jsonl` | 可备份，不直接删。 |
| 能力目录 | `skills/`、`agents/`、`hooks/`、`plugins/` | 不删，除非明确知道影响。 |
| 数据库伴生文件 | `*.sqlite-wal`、`*.sqlite-shm` | 不单独删。 |
| 缓存临时 | `.tmp/`、`tmp/`、`cache/` | 可清查，但不要在 Codex 运行中清。 |
| 备份归档 | `config.toml.bak.*`、`skills_backup/` | 可迁移归档，不建议直接删。 |

## 相关链接

- [[我的.codex目录里有什么]]
- [[Codex启动时会读取什么]]
- [[Codex agent会读取哪些上下文]]
- [[Codex规则放哪里以及常用命令]]
- [[Skill放在哪里以及怎么维护]]
- [[my-multi-agents总览]]
