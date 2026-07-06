---
title: "Hermes agent文件夹介绍"
source: "ai-related/16-agent-assistant/hermes agent/01-Hermes agent文件夹介绍.md"
author: "Codex"
published:
created: 2026-07-06
description: "介绍本机 ~/.hermes 和 ~/.hermes/hermes-agent 中各个文件夹与关键文件的用途，区分运行数据、配置、会话、skills、plugins、gateway、cron、源码和缓存。"
tags: ["hermes", "agent", "filesystem", "runtime", "skills", "plugins"]
type: "tech-note"
status: "processed"
---

# Hermes agent文件夹介绍

## 摘要

本机 Hermes agent 主要分成两层：

- `~/.hermes`：个人运行目录，放配置、登录态、会话、日志、缓存、数据库、skills、plugins、hooks 等运行数据。
- `~/.hermes/hermes-agent`：Hermes agent 程序目录，放 CLI、agent 核心代码、gateway、tools、插件源码、测试、依赖和打包文件。

理解这两个目录的关键是：`~/.hermes` 是“这个电脑上 Hermes 跑出来和积累下来的东西”，`~/.hermes/hermes-agent` 是“让 Hermes 能跑起来的程序本体”。

## 一句话结构图

```text
~/.hermes/
  config.yaml / auth.json / .env     # 本机配置、登录态和环境变量
  sessions/ logs/ cache/ tmp/         # 会话、日志、缓存、临时文件
  memories/ skills/ plugins/ hooks/   # 记忆、技能、插件、钩子
  cron/ bridge/ gateway*.json         # 定时任务、桥接和网关运行状态
  *.db                                # Hermes 运行数据库
  hermes-agent/                       # Hermes agent 程序目录
```

```text
~/.hermes/hermes-agent/
  cli.py / run_agent.py               # 启动入口
  agent/ tools/ providers/            # agent 核心、工具和模型提供方
  gateway/ hermes_cli/                # 网关和 CLI 界面
  plugins/ skills/ optional-*         # 内置插件、内置技能和可选扩展
  tests/ pyproject.toml setup.py      # 测试与 Python 包配置
  .venv/ venv/ node_modules/          # 本地依赖环境
```

## `~/.hermes` 是什么

`~/.hermes` 可以理解为 Hermes 的用户级 home 目录。它不只是配置目录，也包含运行时产生的数据。

### 配置、认证和本机状态

| 路径 | 作用 | 建议 |
|---|---|---|
| `config.yaml` | Hermes 主配置，通常保存模型、插件、运行选项、路径等配置。 | 可以读，修改前先备份。 |
| `config.yaml.bak-*` | 配置备份。 | 排查配置回退时有用。 |
| `.env`、`.env.bak-*` | 环境变量，可能包含 token、key 或内部服务地址。 | 不要贴到文档或 Git。 |
| `auth.json`、`auth.json.bak-*` | 登录态或认证信息。 | 不要手改，不要上传。 |
| `auth.lock` | 认证流程锁文件，防止并发写认证状态。 | Hermes 运行时不要动。 |
| `.hermes_history` | Hermes CLI 历史命令。 | 可读，用于回看自己做过什么。 |
| `SOUL.md` | Hermes 的人格、行为或长期指令类配置。 | 可读，修改会影响交互风格。 |
| `.skills_prompt_snapshot.json` | skills prompt 快照或缓存。 | 一般不手改。 |
| `.update_check` | 更新检查标记。 | 不需要关注。 |

### 会话、日志、缓存和临时文件

| 路径 | 作用 | 建议 |
|---|---|---|
| `sessions/` | Hermes 会话记录，类似历史任务和上下文轨迹。 | 排查“之前让它做了什么”时看这里。 |
| `logs/` | 普通运行日志。 | 排障优先看。 |
| `logs/curator/` | curator 或自动整理相关日志。 | 排查自动学习、整理、升级时看。 |
| `cache/` | 通用缓存。 | 可清理，但先确认 Hermes 没在跑。 |
| `cache/documents/` | 文档读取或解析缓存。 | 文档内容异常时可排查。 |
| `cache/screenshots/` | 截图缓存。 | 浏览器/视觉任务排障时有用。 |
| `audio_cache/` | 音频相关缓存。 | 语音任务或转写任务相关。 |
| `image_cache/` | 图片相关缓存。 | 图片生成、视觉处理、素材读取相关。 |
| `tmp/` | 临时文件。 | 通常可清理，运行中不要删。 |
| `checkpoints/` | 任务中间态或恢复点。 | 长任务恢复、失败回放时有用。 |
| `backups/` | Hermes 生成的备份。 | 配置或功能迁移前后排查用。 |

### 数据库和运行状态

| 路径 | 作用 | 建议 |
|---|---|---|
| `state.db` | 主要运行状态数据库。 | 不要手工编辑。 |
| `state.db-wal`、`state.db-shm` | SQLite 写前日志和共享内存文件。 | 和 `state.db` 是一组，不能随便单独删。 |
| `hermes.db` | Hermes 相关数据数据库。 | 不要手工编辑。 |
| `kanban.db` | kanban 功能数据库。 | 看板功能异常时相关。 |
| `processes.json` | Hermes 进程状态记录。 | 排查残留进程时有用。 |
| `gateway.pid`、`gateway.lock` | gateway 运行进程号和锁。 | Hermes/gateway 运行中不要删。 |
| `gateway_state.json` | gateway 当前状态。 | 排查 gateway、网页端、桥接时有用。 |
| `channel_directory.json` | 渠道目录或通道映射。 | 排查消息通道时有用。 |
| `feishu_seen_message_ids.json` | 飞书已处理消息 ID 记录。 | 防止重复处理消息。 |

### 能力扩展：skills、plugins、hooks、scripts

| 路径 | 作用 | 建议 |
|---|---|---|
| `skills/` | 用户安装或同步下来的 Hermes skills。 | 这是最值得阅读的能力目录。 |
| `skills/.hub/` | skill hub 元数据或同步缓存。 | 一般不手改。 |
| `skills/.curator_backups/` | curator 修改 skills 前后的备份。 | 回滚 skill 时有用。 |
| `plugins/` | 用户级插件目录。 | 插件排查时看。 |
| `hooks/` | 钩子脚本或事件处理逻辑。 | 会影响 Hermes 执行流程，修改需谨慎。 |
| `scripts/` | 本机辅助脚本。 | 可读，通常是操作 Hermes 的小工具。 |
| `bin/` | 本机可执行文件或包装脚本。 | PATH、启动命令排查时看。 |

### 任务、桥接和外部平台

| 路径 | 作用 | 建议 |
|---|---|---|
| `cron/` | 定时任务配置和运行目录。 | 自动任务从这里排查。 |
| `cron/output/` | 定时任务输出。 | 看 cron 有没有成功执行。 |
| `bridge/` | 本机桥接能力相关目录。 | 浏览器、外部工具通信异常时看。 |
| `pairing/` | 配对信息，通常和外部客户端或设备连接有关。 | 不要随便清。 |
| `whatsapp/`、`whatsapp/session/` | WhatsApp 集成和会话状态。 | 不使用 WhatsApp 时可以忽略。 |
| `kanban/` | kanban 功能的文件层数据。 | 和 `kanban.db` 一起看。 |
| `sandboxes/` | 沙箱运行环境。 | 工具隔离执行相关。 |
| `sandboxes/singularity/` | singularity 沙箱相关。 | 高隔离任务相关。 |
| `node/` | Hermes 自带或管理的 Node 环境。 | 不要手动搬动。 |
| `skins/` | 界面皮肤或展示样式。 | UI 外观相关。 |
| `memories/` | Hermes 的长期记忆或个人知识。 | 可读，但修改会影响后续行为。 |

### 迁移和导入目录

| 路径 | 作用 | 建议 |
|---|---|---|
| `migration/` | 迁移脚本或迁移过程数据。 | 升级、迁移排查时看。 |
| `migration/openclaw/` | OpenClaw 迁移相关。 | 只在迁移场景关注。 |
| `openclaw-import/` | OpenClaw 导入工作区。 | 导入旧数据时相关。 |
| `openclaw-import/raw/` | 原始导入数据。 | 保留用于回溯。 |
| `openclaw-import/exported-memory/` | 导出的 memory 数据。 | 迁移记忆时有用。 |
| `openclaw-import/identity/` | 身份信息导入数据。 | 不要外传。 |
| `openclaw-import/reports/` | 导入报告。 | 看迁移是否成功。 |
| `openclaw-import/workspace/` | 导入过程工作区。 | 迁移临时工作目录。 |

## `~/.hermes/hermes-agent` 是什么

`~/.hermes/hermes-agent` 是 Hermes agent 的程序目录。这里更像一个 Python 项目，也包含前端构建产物、Node 依赖和插件包。

### 启动入口和包配置

| 路径 | 作用 | 建议 |
|---|---|---|
| `cli.py` | Hermes 命令行入口之一。 | 想理解命令怎么进入系统，从这里看。 |
| `run_agent.py` | agent 运行入口。 | 想理解一次任务怎么启动，从这里看。 |
| `hermes_bootstrap.py` | 启动初始化逻辑。 | 排查启动环境时看。 |
| `mcp_serve.py` | MCP 服务入口。 | MCP 集成排查时看。 |
| `pyproject.toml`、`setup.py`、`setup.cfg` | Python 包配置。 | 依赖、打包、安装方式相关。 |
| `VERSION`、`README.md`、`LICENSE` | 版本、说明和许可证。 | 了解版本和项目背景。 |
| `AGENTS.md` | 本目录内 agent 执行规范。 | 让 Codex/Hermes 处理这个目录前应先读。 |
| `MANIFEST.in`、`PKG-INFO`、`hermes_agent.egg-info/` | Python 打包元数据。 | 一般不手改。 |

### Agent 核心、工具和模型

| 路径 | 作用 | 建议 |
|---|---|---|
| `agent/` | agent 核心实现，通常包含规划、执行、上下文、消息处理等主逻辑。 | 这是理解 Hermes agent 的核心目录。 |
| `agent/lsp/` | LSP 相关能力。 | 代码理解、语言服务相关。 |
| `agent/secret_sources/` | secret 来源读取逻辑。 | 涉及凭据，阅读时注意不要泄露。 |
| `agent/transports/` | 传输层，负责不同通信方式。 | 排查连接和消息通道时看。 |
| `tools/` | Hermes 可调用工具集合。 | 想知道 Hermes 能做什么，看这里。 |
| `tools/computer_use/` | 电脑操作类工具。 | GUI 自动化、屏幕操作相关。 |
| `tools/environments/` | 工具运行环境封装。 | 沙箱、环境隔离相关。 |
| `providers/` | 模型或服务提供方适配。 | 模型切换、API 兼容排查时看。 |
| `toolsets.py`、`toolset_distributions.py` | 工具集组织和分发逻辑。 | 理解 tools 怎么被注册。 |
| `model_tools.py` | 模型相关工具逻辑。 | 模型调用辅助能力。 |
| `trajectory_compressor.py` | 轨迹压缩。 | 长上下文、历史压缩相关。 |

### CLI、Gateway 和界面

| 路径 | 作用 | 建议 |
|---|---|---|
| `hermes_cli/` | Hermes CLI 的主要实现。 | 命令行行为从这里看。 |
| `hermes_cli/subcommands/` | CLI 子命令。 | 查某个命令具体做什么时看。 |
| `hermes_cli/dashboard_auth/` | dashboard 登录认证。 | Web dashboard 登录相关。 |
| `hermes_cli/proxy/` | CLI 代理相关。 | 代理、转发问题相关。 |
| `hermes_cli/scripts/` | CLI 辅助脚本。 | 运维或本地辅助功能。 |
| `hermes_cli/tui_dist/` | TUI 构建产物。 | 一般不手改。 |
| `hermes_cli/web_dist/` | Web 前端构建产物。 | 一般不手改。 |
| `gateway/` | gateway 服务端逻辑，负责连接 Web、CLI、外部平台或本地能力。 | 通信问题优先看。 |
| `gateway/assets/` | gateway 静态资源。 | UI 或资源相关。 |
| `gateway/builtin_hooks/` | gateway 内置 hooks。 | 网关事件处理相关。 |
| `gateway/platforms/` | 平台适配层。 | 飞书、浏览器、外部平台集成相关。 |
| `gateway/relay/` | relay 转发逻辑。 | 中继、转发排查时看。 |
| `tui_gateway/` | TUI gateway。 | 终端界面通信相关。 |
| `web_dist/`、`tui_dist/` | 如果出现在 CLI 子目录下，是前端/TUI 打包后资源。 | 不直接改构建产物。 |

### 插件、技能和可选扩展

| 路径 | 作用 | 建议 |
|---|---|---|
| `plugins/` | Hermes 内置插件源码。 | 理解 browser、memory、kanban、image_gen 等能力从这里看。 |
| `plugins/browser/` | 浏览器插件。 | 网页浏览、自动化相关。 |
| `plugins/context_engine/` | 上下文引擎插件。 | 上下文检索、组织相关。 |
| `plugins/cron/` | 定时任务插件。 | 自动任务相关。 |
| `plugins/dashboard_auth/` | dashboard 认证插件。 | Web 登录相关。 |
| `plugins/disk-cleanup/` | 磁盘清理插件。 | 自动清理相关。 |
| `plugins/google_meet/` | Google Meet 集成。 | 会议相关。 |
| `plugins/hermes-achievements/` | 成就或激励类插件。 | 可以忽略。 |
| `plugins/image_gen/` | 图片生成插件。 | 图像生成相关。 |
| `plugins/kanban/` | 看板插件。 | kanban 功能相关。 |
| `plugins/memory/` | 记忆插件。 | 长期记忆相关。 |
| `plugins/model-providers/` | 模型提供方插件。 | 模型适配相关。 |
| `plugins/observability/` | 可观测性插件。 | 日志、指标、监控相关。 |
| `plugins/platforms/` | 平台类插件集合。 | 外部平台集成。 |
| `plugins/security-guidance/` | 安全指导插件。 | 安全提示、风险控制相关。 |
| `plugins/spotify/` | Spotify 集成。 | 不使用可忽略。 |
| `plugins/teams_pipeline/` | Teams 或 pipeline 集成。 | 协作/流水线相关。 |
| `plugins/video_gen/` | 视频生成插件。 | 视频生成相关。 |
| `plugins/web/` | Web 插件。 | Web 能力相关。 |
| `skills/` | Hermes 内置 skills。 | 和用户级 `~/.hermes/skills/` 区分开。 |
| `optional-skills/` | 可选 skills。 | 需要时再启用或安装。 |
| `optional-mcps/` | 可选 MCP 服务。 | MCP 扩展能力来源。 |

### 定时任务、适配层、测试和依赖

| 路径 | 作用 | 建议 |
|---|---|---|
| `cron/` | 程序层 cron 实现。 | 和用户级 `~/.hermes/cron/` 区分：这里是代码，那边是运行数据。 |
| `cron/scripts/` | cron 相关脚本。 | 定时任务实现细节。 |
| `acp_adapter/` | ACP 适配层。 | 和 agent communication protocol 相关。 |
| `locales/` | 多语言文案。 | UI/提示文案翻译相关。 |
| `tests/` | 测试。 | 改程序代码后应跑相关测试。 |
| `.pytest_cache/` | pytest 缓存。 | 可清理。 |
| `__pycache__/` | Python 字节码缓存。 | 可清理。 |
| `.venv/`、`venv/` | Python 虚拟环境。 | 不手动改里面文件；重装依赖时可重建。 |
| `node_modules/` | Node 依赖。 | 不手动改里面文件；用包管理器重装。 |
| `build/` | 构建产物。 | 可重建，通常不手改。 |

## 哪些能动，哪些别动

| 类型 | 代表路径 | 建议 |
|---|---|---|
| 高风险认证和密钥 | `.env`、`auth.json`、`agent/secret_sources/` | 只读，不贴到笔记、聊天或 Git。 |
| 主配置 | `config.yaml`、`SOUL.md` | 能改，但先备份；改完要知道影响的是全局 Hermes 行为。 |
| 运行数据库 | `state.db`、`hermes.db`、`kanban.db`、`state.db-wal`、`state.db-shm` | 不手工编辑，不单独删除 wal/shm。 |
| 运行锁和进程文件 | `gateway.pid`、`gateway.lock`、`auth.lock`、`.weekly-upgrade.lock` | Hermes 正在运行时不要动。 |
| 会话和日志 | `sessions/`、`logs/` | 适合排查；归档前不要随便删。 |
| 缓存和临时文件 | `cache/`、`audio_cache/`、`image_cache/`、`tmp/`、`.pytest_cache/`、`__pycache__/` | 一般可清，但先停止 Hermes 并确认不是当前任务需要。 |
| 用户能力 | `skills/`、`plugins/`、`hooks/`、`memories/` | 可读；修改会影响 Hermes 的能力和行为。 |
| 程序本体 | `hermes-agent/` | 不要整体移动；升级或调试时再改。 |
| 依赖目录 | `.venv/`、`venv/`、`node_modules/` | 不手改文件，出问题优先重装依赖。 |

## 和 Codex 目录的类比

`~/.hermes` 和 `~/.codex` 很像，都是某个 agent 系统的用户级工作目录。

区别是：

- `~/.codex` 更偏 Codex CLI 的配置、skills、sessions、plugins。
- `~/.hermes` 里除了配置和 skills，还能看到更多 Hermes 自己的 gateway、kanban、cron、WhatsApp、OpenClaw 导入、Node 环境和本地数据库。
- `~/.hermes/hermes-agent` 是程序包目录，这一点和普通配置目录不同；它更接近一个实际源码项目。

## 可执行动作

- 想知道 Hermes 最近做过什么：先看 `~/.hermes/sessions/` 和 `~/.hermes/logs/`。
- 想知道 Hermes 有哪些能力：先看 `~/.hermes/skills/`、`~/.hermes/plugins/` 和 `~/.hermes/hermes-agent/plugins/`。
- 想排查启动或连接问题：先看 `gateway_state.json`、`gateway.pid`、`gateway.lock`、`~/.hermes/hermes-agent/gateway/`。
- 想排查自动任务：看 `~/.hermes/cron/`、`~/.hermes/cron/output/` 和 `~/.hermes/hermes-agent/cron/`。
- 想清理空间：优先评估 `cache/`、`audio_cache/`、`image_cache/`、`tmp/`、`.pytest_cache/`、`__pycache__/`，不要动认证、数据库和配置。

## 相关链接

- [[Hermes agent总览]]
- [[Hermes agent本机能力是什么]]
- [[01-codex文件夹介绍]]
