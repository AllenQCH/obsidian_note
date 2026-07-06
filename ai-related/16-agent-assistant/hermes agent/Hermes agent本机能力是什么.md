---
title: "Hermes agent本机能力是什么"
source: "conversation: Hermes chat 2026-07-02; https://hermes-agent.nousresearch.com/docs/zh-Hans/developer-guide/architecture; local commands: hermes --version / hermes status --all / hermes tools list / hermes mcp list / hermes cron list / pip show hermes-agent"
author: "笨笨"
published:
created: 2026-07-02
description: "整理本机 Hermes Agent 的安装位置、当前能力、已进化出的自我增强机制，以及官方架构文档的核心要点。"
tags: ["obsidian-note", "hermes", "agent", "architecture", "skills", "mcp", "workflow"]
type: "learning-note"
status: "processed"
---
# Hermes agent本机能力是什么

## 摘要

这台 Mac 上的 Hermes Agent 已经不只是“能聊天的 CLI 工具”，而是一个比较完整的 **个人 Agent OS**：

- 本机可执行入口在 `~/.hermes/hermes-agent/venv/bin/hermes`
- 当前版本是 **Hermes Agent v0.17.0 (2026.6.19)**
- 主模型默认走 **`gpt-5.4` + `openai-codex` provider**
- 已启用：工具调用、Browser、Terminal、文件、Vision、TTS、Skills、Memory、Session Search、Delegation、Cron、Computer Use
- 已接入 MCP：**`dingtalk`、`yahoo_finance`**
- 已沉淀本地 skills：**149 个**
- 已开启持久记忆、用户画像、会话检索、多 agent 委派、定时任务、Feishu gateway

如果用一句话概括它现在“进化到哪里了”：

> 它已经从“单轮问答 Agent”进化成了“带记忆、会生 skill、能调工具、能跨渠道运行、能自己定时执行、还能调用子 Agent 的个人智能操作系统”。

## 核心内容

### 一、本机 Hermes Agent 在哪里

#### 1）可执行入口

- `~/.hermes/hermes-agent/venv/bin/hermes`
- 实际解析结果：`/Users/heytea/.hermes/hermes-agent/venv/bin/hermes`

#### 2）Python 包安装位置

- `~/.hermes/hermes-agent/venv/lib/python3.11/site-packages`
- `pip show hermes-agent` 也显示安装位置在这里

#### 3）本地源码 / 运行目录

虽然当前不是一个带 `.git` 的源码仓库 checkout，但本机仍然保留了 Hermes 的完整运行目录：

- `~/.hermes/hermes-agent/run_agent.py`
- `~/.hermes/hermes-agent/cli.py`
- `~/.hermes/hermes-agent/model_tools.py`
- `~/.hermes/hermes-agent/toolsets.py`
- `~/.hermes/hermes-agent/hermes_state.py`
- `~/.hermes/hermes-agent/agent/`
- `~/.hermes/hermes-agent/tools/`
- `~/.hermes/hermes-agent/gateway/`
- `~/.hermes/hermes-agent/cron/`
- `~/.hermes/hermes-agent/tests/`

也就是说：

- **运行入口** 在虚拟环境 `venv/bin/hermes`
- **Python package** 在 `site-packages`
- **可读的工程级目录** 在 `~/.hermes/hermes-agent/`

#### 4）关键数据与配置位置

- 主配置：`~/.hermes/config.yaml`
- 环境变量：`~/.hermes/.env`
- 认证信息：`~/.hermes/auth.json`
- 持久记忆：`~/.hermes/memories/MEMORY.md`
- 用户画像：`~/.hermes/memories/USER.md`
- Skills：`~/.hermes/skills/`
- Sessions：`~/.hermes/sessions/`
- Logs：`~/.hermes/logs/`
- 定时任务：`~/.hermes/cron/`

### 二、本机当前 Hermes 已经具备哪些能力

### 1）当前版本与运行状态

| 项目 | 当前状态 |
|---|---|
| 版本 | `Hermes Agent v0.17.0 (2026.6.19)` |
| Python | `3.11.14` |
| 默认模型 | `gpt-5.4` |
| Provider | `openai-codex` |
| API 模式 | `codex_responses` |
| Terminal backend | `local` |
| Gateway | 运行中（`launchd` 托管） |
| 当前已配置消息平台 | `Feishu` |
| 当前 profile | `default` |
| Active sessions | `10` |
| Cron jobs | `11 active / 16 total` |

### 2）当前已启用的核心 toolset

本机 `hermes tools list` 显示，当前已启用的核心能力包括：

- `web`：网页搜索/提取
- `browser`：浏览器自动化
- `terminal`：终端执行与进程管理
- `file`：读写/搜索/patch 文件
- `code_execution`：Python 代码执行
- `vision`：图像分析
- `image_gen`：图片生成
- `tts`：文本转语音
- `skills`：skills 读取与维护
- `todo`：任务列表
- `memory`：长期记忆
- `session_search`：跨会话检索
- `clarify`：带 UI 的追问
- `delegation`：子 agent 委派
- `cronjob`：定时任务
- `computer_use`：macOS 桌面操作

当前未启用但框架已具备的还有：

- `video`
- `video_gen`
- `x_search`
- `moa`
- `context_engine`
- `homeassistant`
- `spotify`
- `yuanbao`

### 3）当前工具层已经很厚了

本机 `~/.hermes/hermes-agent/tools/` 顶层已有 **86 个 Python 工具模块**；官方架构文档里写的是：

> 中央工具注册表包含约 **28 个 toolset、70+ 个已注册工具**。

这意味着 Hermes 现在不是“只有 terminal + file 的轻 agent”，而是一个相当完整的工具运行时。当前本机还能看到的能力模块包括：

- terminal / process registry
- file read/write/search/patch
- browser / browser cdp / dialog / supervisor
- code execution
- delegate / async delegation
- MCP client / MCP OAuth
- memory
- todo
- session search
- cronjob
- vision / TTS / transcription
- Discord / HomeAssistant / Feishu / Graph 等工具模块
- image / video generation
- tool search / tool output limits / approval / security guard

### 4）当前 MCP 能力

本机已经启用的 MCP server：

| MCP server | 状态 | 用途 |
|---|---|---|
| `dingtalk` | enabled | 钉钉消息、日历、文档、AI 表格、待办、审批、通讯录等 |
| `yahoo_finance` | enabled | 股票、新闻、财务、期权、行业、行情等 |

这说明 Hermes 当前已经不只是“调本地工具”，而是已经开始把外部系统能力接成原生工具源了。

### 5）当前 skills 体系已经很成熟

本机 `~/.hermes/skills/` 下共统计到 **149 个 skills**，覆盖：

| 分类 | 数量 |
|---|---:|
| apple | 5 |
| autonomous-ai-agents | 10 |
| creative | 16 |
| github | 7 |
| mcp | 4 |
| mlops | 22 |
| note-taking | 4 |
| openclaw-imports | 21 |
| productivity | 14 |
| research | 10 |
| software-development | 17 |
| 其他分类合计 | 19+ |

这很关键，因为 Hermes 的“自我进化”不只是升级版本，更重要的是：

- 把成功工作流沉淀为 skill
- 下次自动加载 skill
- skill 不断被 patch、修正、升级

也就是说，它在积累的不是“聊天记录”，而是 **可复用的方法资产**。

### 6）记忆、用户画像、会话检索已经打开

本机配置里已经开启：

- `memory.memory_enabled: true`
- `memory.user_profile_enabled: true`
- 持久化文件：
  - `~/.hermes/memories/MEMORY.md`
  - `~/.hermes/memories/USER.md`

同时还有：

- 会话目录：`~/.hermes/sessions/`
- 当前本机 session 文件数量：**134**
- 支持 `session_search` 全文检索
- 官方架构文档说明会话存储基于 **SQLite + FTS5 + 会话血缘追踪**

所以 Hermes 的长期演化逻辑其实是：

1. **会话里学到上下文**
2. **重要稳定事实进 Memory / User Profile**
3. **成功流程抽成 Skill**
4. **后续对话再检索旧 session + 复用 skill**

这已经非常接近“经验累积型 agent”了。

### 7）多 Agent 委派能力已经就位

本机配置显示 delegation 已开启，且参数比较完整：

- `provider: custom:cloudapi`
- `api_mode: codex_responses`
- `max_iterations: 50`
- `child_timeout_seconds: 600`
- `max_concurrent_children: 3`
- `max_spawn_depth: 1`
- `orchestrator_enabled: true`
- 默认子 agent 工具集：`terminal`、`file`、`web`

这意味着 Hermes 现在不是“一个 agent 干到底”，而是已经支持：

- 主 agent 拆任务
- 子 agent 并行执行
- 按工具集限制能力范围
- 做相对可控的多 agent 编排

### 8）定时任务与自治运行能力已经具备

Hermes 现在已经不是“你问一句，它答一句”。

本机 `hermes cron list` 显示已经有 **11 个 active jobs / 16 个 total jobs**，例如：

- `morning-ai-markets-brief`
- `github-daily-report`
- `github-weekly-report`
- `us-stocks-investment-ideas-night`
- `ai-english-daily-feishu-group`
- `daily-personal-agent-os-sync`
- `hermes-context-hygiene-daily`
- `hermes-weekly-upgrade`

其中还有两种模式：

1. **Agent 驱动的 cron**：定时拉起一个全新的 AIAgent 跑 prompt
2. **no-agent 脚本 cron**：只执行脚本，把 stdout 直接投递

这就是“自治运行层”的基础。

### 三、为什么说 Hermes 是会“自我进化”的 Agent

先看本机 `pip show hermes-agent` 的官方描述：

> The self-improving AI agent — creates skills from experience, improves them during use, and runs anywhere

结合你这台机器的实际状态，可以把“自我进化”拆成 6 层来看：

### 1）从对话经验里长出 Skill

Hermes 不是把一次成功操作仅仅留在聊天记录里，而是允许把复杂流程沉淀成 skill，并且后续继续 patch。这个机制比“记住答案”更强，因为它记住的是：

- 何时使用
- 具体步骤
- 常见坑点
- 验证方法

### 2）用 Memory / User Profile 记稳定事实

它能把稳定偏好、环境事实、工作习惯写进记忆文件，而不是每次重新问一遍。这样它逐渐形成对“这个用户/这台机器/这套工作流”的长期认知。

### 3）通过 Session Search 具备可回溯学习能力

Hermes 不是只有“当前窗口上下文”，而是可以回查旧 session，把过去讨论过的问题、结论、上下文重新找回来。这让它能跨多次对话延续工作，而不是每次从零开始。

### 4）通过 Curator 做 skill/知识卫生维护

本机配置里已经有：

- `curator.enabled: true`
- `interval_hours: 168`
- `prune_builtins: true`
- `backup.enabled: true`

这说明 Hermes 不只是不断加东西，也有“定期整理、清理、备份”的演化机制。它不是纯堆积，而是带一点“系统维护”的味道。

### 5）通过 MCP / Plugins 不断长外部能力

Hermes 的成长不只来自 prompt 和记忆，也来自“接更多系统”。现在你这台机器已经接了：

- Feishu gateway
- DingTalk MCP
- Yahoo Finance MCP
- Browser / Computer Use / Terminal / File / Vision / Cron / Delegation

未来它还可以继续长出：

- Chrome MCP
- Discord / Telegram / Email / Mattermost / Teams
- Home Assistant
- 更多图像/视频/语音能力
- 更多企业系统 / Web API / 自定义 MCP

### 6）通过 Cron + Gateway 从被动回答变成主动运行

真正的进化点在这里：

- 不只是“用户来问才工作”
- 而是“到了时间自己跑、跑完自己发、跨平台自己送达”

这让 Hermes 开始具备 **持续运行的 agent loop**，而不是一次性推理器。

### 四、Hermes 官方架构文档学到的关键知识

官方文档：
`https://hermes-agent.nousresearch.com/docs/zh-Hans/developer-guide/architecture`

### 1）它的系统入口不是单一 CLI，而是多入口共用一个核心 Agent

官方架构图的关键点是：

- CLI（`cli.py`）
- Gateway（`gateway/run.py`）
- ACP（编辑器集成）
- Batch Runner
- API Server
- Python Library

这些入口最终都汇入同一个核心：

- `AIAgent`（`run_agent.py`）

也就是说，Hermes 的核心设计不是“每个平台一套 Agent”，而是：

> **一个统一的 Agent 核心 + 多种入口外壳**

这也是它能同时跑 CLI、Feishu、cron、ACP 的基础。

### 2）Agent Loop 本质上是同步编排循环

官方文档给出的核心链路大意是：

用户输入
→ `HermesCLI.process_input()`
→ `AIAgent.run_conversation()`
→ `prompt_builder.build_system_prompt()`
→ `runtime_provider.resolve_runtime_provider()`
→ 模型 API 调用
→ 如果需要工具，则 `model_tools.handle_function_call()`
→ 继续循环
→ 最终响应
→ 保存到 SessionDB

本质上它还是经典的 **LLM + tool call + loop**，但它已经把很多运行时细节工程化了。

### 3）Prompt 系统不是一段固定 system prompt，而是动态组装

官方文档说 prompt builder 会从这些来源组装系统 prompt：

- 个性（SOUL.md）
- 记忆（`MEMORY.md`、`USER.md`）
- skill
- 上下文文件（如 `AGENTS.md`、`.hermes.md` 等）
- 工具使用指引
- 模型专项指令

这意味着 Hermes 的 prompt 已经不是“写死一大段规则”，而是一个 **上下文拼装系统**。

### 4）工具系统是注册表驱动的

官方文档的依赖链非常关键：

`tools/registry.py`
↑
`tools/*.py` 在导入时自动 `register()`
↑
`model_tools.py` 触发工具发现
↑
`run_agent.py / cli.py / batch_runner.py`

这意味着：

- 新工具以模块方式加入
- 导入时自动注册
- 不需要手工维护一大串工具清单
- agent 创建之前，工具注册已经完成

这是 Hermes 能不断扩展工具能力的重要基础。

### 5）会话层不是临时上下文，而是带检索和血缘的持久层

官方文档强调：

- 会话基于 SQLite
- 支持 FTS5 全文检索
- 支持 session lineage（父/子会话血缘）
- 支持跨压缩追踪
- 支持平台隔离

这让 Hermes 的会话不只是“历史消息保存”，而是一个可查询、可继承、可压缩的长期状态层。

### 6）Gateway 是长驻消息中台

官方文档把 Gateway 描述成：

- 长驻进程
- 多平台 adapter
- 统一会话路由
- 白名单 / DM 配对授权
- slash command 分发
- hooks
- cron 触发
- 后台维护

你本机当前就已经在实际使用其中一部分：

- Feishu gateway 已配置并运行中
- cron 会往 Feishu 投递结果

### 7）Plugin 与 MCP 是两条不同的扩展路线

可以这样理解：

- **Plugin**：扩展 Hermes 自己的内部能力与平台能力
- **MCP**：把外部系统的能力接成工具

官方文档还提到 plugin 发现来源有三种：

- `~/.hermes/plugins/`（用户级）
- `.hermes/plugins/`（项目级）
- pip entry point

而 MCP 则是另一种对外部能力的统一接入层。

### 8）Cron 是一等公民，不是外挂脚本

官方文档明确指出 Cron 的逻辑是：

调度器触发
→ 从 jobs 加载到期任务
→ 创建一个**全新 AIAgent（无历史）**
→ 注入 skill
→ 运行 prompt
→ 投递到目标平台
→ 更新 next_run

这个点很重要：

> Hermes 的 cron 不是简单 shell 定时器，而是 **定时拉起一个新的 agent 会话**。

### 9）设计原则非常清晰

官方文档里我觉得最重要的原则有 6 个：

| 原则 | 含义 |
|---|---|
| Prompt 稳定性 | 中途不随便改 system prompt，减少缓存破坏 |
| 可观测执行 | 每次工具调用都能对用户可见 |
| 可中断 | API 调用和工具执行能被中断 |
| 平台无关核心 | 一个 `AIAgent` 服务 CLI / gateway / ACP / batch |
| 松耦合 | 插件、MCP、记忆、上下文引擎都是可插拔的 |
| Profile 隔离 | 不同 profile 拥有独立配置、记忆、会话和 gateway PID |

### 五、对这台机器上的 Hermes 的实际判断

### 1）它已经是“能长期工作的 Agent OS 雏形”

不是简单的聊天机器人，已经有：

- 记忆
- 技能库
- 工具运行时
- 消息 gateway
- cron
- 多 agent delegation
- MCP 外部系统接入
- 会话检索与压缩

### 2）它最强的地方已经不是“回答”，而是“持续操作”

尤其适合：

- 长期工作流沉淀
- 多平台消息交付
- 日报/晨报/监控/提醒
- 研究结果落知识库
- 带记忆的个人工作台

### 3）你这台机器上的 Hermes 目前还没完全长满

当前明显还能继续进化的方向：

- 接入 **Chrome MCP**，补强浏览器结构化操作
- 打开更多消息平台（如 Discord / Telegram）增强远程入口
- 补更多 Web / image / video provider
- 按个人需求继续沉淀 skill，而不是只靠单次对话
- 继续把 Obsidian / GitHub / Feishu / Finance / Browser 串成稳定流水线

### 4）如果只看“个人 AI 操作系统”这条路，它已经比很多 agent demo 更像生产系统

因为它已经同时具备：

- 状态持久化
- 工具层
- 调度层
- 消息层
- 记忆层
- 扩展层
- 多 agent 层

很多所谓 agent 产品只做到了其中 1-2 层，而 Hermes 现在基本已经是全链路雏形了。

## 可执行动作

### 如果后面要继续强化这台 Hermes，优先顺序建议是：

1. **补一篇《Hermes 的 toolset / plugin / MCP 三层扩展关系》**
2. **接入 Chrome MCP**，把浏览器能力补成更完整的“结构化网页操作层”
3. **把 Hermes 常驻能力做成一张架构图**，方便以后复习和迁移
4. **单独盘点 `~/.hermes/skills/` 里哪些是最值得保留的个人能力资产**
5. **梳理 Feishu / GitHub / Obsidian / Finance 这几条已成型流水线**

## 相关链接

- [[Obsidian笔记怎么写]]
- [[Codex agent会读取哪些上下文]]
- [[08-Chrome MCP、opencli、Playwright怎么分工]]
- 官方架构文档：<https://hermes-agent.nousresearch.com/docs/zh-Hans/developer-guide/architecture>
