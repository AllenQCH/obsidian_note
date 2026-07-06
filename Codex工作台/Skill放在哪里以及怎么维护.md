---
title: "Skill放在哪里以及怎么维护"
source: "Codex工作台/Codex配置和写作规范/Skill放在哪里以及怎么维护.md"
author: "Allen"
published:
created: 2026-05-07
description: "记录本地 Codex skills 的目录、用途、合并归档记录和维护规则。"
tags: ["obsidian-note", "codex", "skill", "workflow"]
type: "workflow"
status: "processed"
---

# Skill放在哪里以及怎么维护

## 摘要

本笔记是本机 Codex skill 的索引和维护记录。以后新建、更新、合并、归档或删除 skill 后，必须同步更新本笔记。

## 核心内容

### Skill 根目录

| 根目录 | 数量 | 说明 |
|---|---:|---|
| `codex_user` | 56 | Codex 用户级 skill，默认主目录 |
| `agents_user` | 19 | Agents/Lark 等外部工具 skill |
| `superpowers` | 14 | Superpowers 流程类 skill |
| `plugin_cache` | 4 | 插件缓存自带 skill，不建议手工修改 |

### 当前状态

- 当前扫描到 skill 总数：`95`。
- 重复 skill 名称数量：`0`。
- `release-workflow` 已新增，用于自动写提测文档和定位/打开流水线。
- `opencli-browser-reuse` 已新增，用于复用稳定 opencli Browser Bridge session，减少 Chrome 中 `OpenCLI Browser` 标签堆积。
- `dws` 重复项已处理：保留 `~/.codex/skills/dws`，归档 `~/.agents/skills/dws`。
- `excel-json-analysis` 已新增，并已扩展到 CSV / 平铺表格场景，可从导出表中提取字段、展开列表、去重、生成新增数据 `INSERT` SQL，并默认附带插入前后查询校验 SQL。
- `dbauto-export-agent` 已新增，用于一键拉起本地 dbauto 导出工作流、准备登录态并打开扩展界面。
- `dbauto-sql-query` 已新增，用于通过 opencli 操作国内 dbauto SQL 查询页，并内置常用 HSP/POF 实例别名；当前以用户级目录为主，支持任意工作目录使用。
- `multi-agent-framework-maintainer` 已新增，用于在新 session 中续接和维护个人 `~/.codex` 多 agent 四层框架，统一从 runtime config、agent docs 和 Obsidian 笔记重建上下文。

### 完整清单

#### codex_user

| Skill | 文件数 | 路径 | 用途摘要 |
|---|---:|---|---|
| `ai-regression-testing` | 1 | `/Users/heytea/.codex/skills/ai-regression-testing` | Regression testing strategies for AI-assisted development. Sandbox-mode API testing withou |
| `alidocs-browser-reader` | 3 | `/Users/heytea/.codex/skills/alidocs-browser-reader` | 通过本机 Chrome 已登录会话读取 `alidocs.dingtalk.com` / `docs.dingtalk.com` 文档，绕过 `dws` CLI 授权限制。 |
| `alidocs-test-delivery-doc` | 5 | `/Users/heytea/.codex/skills/alidocs-test-delivery-doc` | 基于旧提测模板与 BK 需求流水线结果创建钉钉 AliDocs 在线提测表格，写入服务清单、TEST/PROD 配置、数据库脚本、XXL-JOB、发布流程。 |
| `api-design` | 2 | `/Users/heytea/.codex/skills/api-design` | REST API design patterns including resource naming, status codes, pagination, filtering, e |
| `backend-patterns` | 2 | `/Users/heytea/.codex/skills/backend-patterns` | Backend architecture patterns, API design, database optimization, and server-side best pra |
| `bug-killer` | 4 | `/Users/heytea/.codex/skills/bug-killer` | Bug analysis and repair workflow for the HeyTea internal stack. Use when Codex needs to in |
| `claude-api` | 2 | `/Users/heytea/.codex/skills/claude-api` | Anthropic Claude API patterns for Python and TypeScript. Covers Messages API, streaming, t |
| `clickhouse-io` | 1 | `/Users/heytea/.codex/skills/clickhouse-io` | ClickHouse database patterns, query optimization, analytics, and data engineering best pra |
| `coding-standards` | 2 | `/Users/heytea/.codex/skills/coding-standards` | Baseline cross-project coding conventions for naming, readability, immutability, and code- |
| `configure-ecc` | 1 | `/Users/heytea/.codex/skills/configure-ecc` | Interactive installer for Everything Claude Code — guides users through selecting and inst |
| `content-hash-cache-pattern` | 1 | `/Users/heytea/.codex/skills/content-hash-cache-pattern` | Cache expensive file processing results using SHA-256 content hashes — path-independent, a |
| `continuous-learning` | 3 | `/Users/heytea/.codex/skills/continuous-learning` | Automatically extract reusable patterns from Claude Code sessions and save them as learned |
| `continuous-learning-v2` | 10 | `/Users/heytea/.codex/skills/continuous-learning-v2` | Instinct-based learning system that observes sessions via hooks, creates atomic instincts  |
| `database-migrations` | 1 | `/Users/heytea/.codex/skills/database-migrations` | Database migration best practices for schema changes, data migrations, rollbacks, and zero |
| `dbauto-sql-query` | 3 | `/Users/heytea/.codex/skills/dbauto-sql-query` | 通过 opencli Browser Bridge 操作国内 dbauto SQL 查询页，内置 HSP IDS / POF / POF-SCM 三个 MySQL 常用实例别名并限制只读 SQL。 |
| `deep-research` | 2 | `/Users/heytea/.codex/skills/deep-research` | Multi-source deep research using firecrawl and exa MCPs. Searches the web, synthesizes fin |
| `deployment-patterns` | 1 | `/Users/heytea/.codex/skills/deployment-patterns` | Deployment workflows, CI/CD pipeline patterns, Docker containerization, health checks, rol |
| `django-patterns` | 1 | `/Users/heytea/.codex/skills/django-patterns` | Django architecture patterns, REST API design with DRF, ORM best practices, caching, signa |
| `django-security` | 1 | `/Users/heytea/.codex/skills/django-security` | Django security best practices, authentication, authorization, CSRF protection, SQL inject |
| `django-tdd` | 1 | `/Users/heytea/.codex/skills/django-tdd` | Django testing strategies with pytest-django, TDD methodology, factory_boy, mocking, cover |
| `django-verification` | 1 | `/Users/heytea/.codex/skills/django-verification` | Verification loop for Django projects: migrations, linting, tests with coverage, security  |
| `dws-auth-helper` | 2 | `/Users/heytea/.codex/skills/dws-auth-helper` | DingTalk `dws` CLI 认证包装 skill。负责检查 `dws auth status`、引导设备流登录、登录后重试原始 `dws` 命令。 |
| `dbauto-export-agent` | 3 | `/Users/heytea/.codex/skills/dbauto-export-agent` | 启动本地 dbauto 导出工具，串起后端拉起、dbauto 登录准备和扩展界面打开。 |
| `docker-patterns` | 1 | `/Users/heytea/.codex/skills/docker-patterns` | Docker and Docker Compose patterns for local development, container security, networking,  |
| `dws` | 31 | `/Users/heytea/.codex/skills/dws` | 管理钉钉产品能力(AI表格/日历/通讯录/群聊与机器人/待办/审批/考勤/日志/DING消息/工作台/开放平台文档等)。当用户需要操作表格数据、管理日程会议、查询通讯录、管理群聊、 |
| `excel-json-analysis` | 3 | `/Users/heytea/.codex/skills/excel-json-analysis` | 从 Excel / CSV 导出中提取字段、展开列表、去重，或按表格字段生成新增数据 `INSERT` SQL 与插入前后查询校验 SQL。 |
| `e2e-testing` | 2 | `/Users/heytea/.codex/skills/e2e-testing` | Playwright E2E testing patterns, Page Object Model, configuration, CI/CD integration, arti |
| `eval-harness` | 2 | `/Users/heytea/.codex/skills/eval-harness` | Formal evaluation framework for Claude Code sessions implementing eval-driven development  |
| `exa-search` | 2 | `/Users/heytea/.codex/skills/exa-search` | Neural search via Exa MCP for web, code, and company research. Use when the user needs web |
| `frontend-patterns` | 2 | `/Users/heytea/.codex/skills/frontend-patterns` | Frontend development patterns for React, Next.js, state management, performance optimizati |
| `imagegen` | 12 | `/Users/heytea/.codex/skills/.system/imagegen` | Generate or edit raster images when the task benefits from AI-created bitmap visuals such  |
| `internal-gitlab-downloader` | 2 | `/Users/heytea/.codex/skills/internal-gitlab-downloader` | Use when a user needs to discover, clone, mirror, or organize many private internal GitLab |
| `iterative-retrieval` | 1 | `/Users/heytea/.codex/skills/iterative-retrieval` | Pattern for progressively refining context retrieval to solve the subagent context problem |
| `java-coding-standards` | 1 | `/Users/heytea/.codex/skills/java-coding-standards` | Java coding standards for Spring Boot services: naming, immutability, Optional usage, stre |
| `jpa-patterns` | 1 | `/Users/heytea/.codex/skills/jpa-patterns` | JPA/Hibernate patterns for entity design, relationships, query optimization, transactions, |
| `mcp-server-patterns` | 1 | `/Users/heytea/.codex/skills/mcp-server-patterns` | Build MCP servers with Node/TypeScript SDK — tools, resources, prompts, Zod validation, st |
| `multi-agent-framework-maintainer` | 2 | `/Users/heytea/.codex/skills/multi-agent-framework-maintainer` | 在新 session 中续接、维护和收敛个人 `~/.codex` 多 agent 四层框架，优先读取 runtime config、agent docs 与 Obsidian 现有沉淀。 |
| `obsidian-note-writing` | 8 | `/Users/heytea/.codex/skills/obsidian-note-writing` | Create, normalize, or improve Obsidian notes with consistent YAML properties, folder routi |
| `openai-docs` | 9 | `/Users/heytea/.codex/skills/.system/openai-docs` | Use when the user asks how to build with OpenAI products or APIs and needs up-to-date offi |
| `openspec-demand-workflow` | 1 | `/Users/heytea/.codex/skills/openspec-demand-workflow` | Use when the user mentions openspec、需求改造、多服务改动、先确认方案、先看 diff、确认分支、需求号/需求名、提交前人工复核，或希望按规范沉淀 |
| `plankton-code-quality` | 1 | `/Users/heytea/.codex/skills/plankton-code-quality` | Write-time code quality enforcement using Plankton — auto-formatting, linting, and Claude- |
| `plugin-creator` | 6 | `/Users/heytea/.codex/skills/.system/plugin-creator` | Create and scaffold plugin directories for Codex with a required `.codex-plugin/plugin.jso |
| `postgres-patterns` | 1 | `/Users/heytea/.codex/skills/postgres-patterns` | PostgreSQL database patterns for query optimization, schema design, indexing, and security |
| `python-patterns` | 1 | `/Users/heytea/.codex/skills/python-patterns` | Pythonic idioms, PEP 8 standards, type hints, and best practices for building robust, effi |
| `python-testing` | 1 | `/Users/heytea/.codex/skills/python-testing` | Python testing strategies using pytest, TDD methodology, fixtures, mocking, parametrizatio |
| `release-workflow` | 6 | `/Users/heytea/.codex/skills/release-workflow` | Generate test-release documents and locate or open CI/CD pipelines for development handoff |
| `search-first` | 1 | `/Users/heytea/.codex/skills/search-first` | Research-before-coding workflow. Search for existing tools, libraries, and patterns before |
| `security-review` | 3 | `/Users/heytea/.codex/skills/security-review` | Use this skill when adding authentication, handling user input, working with secrets, crea |
| `security-scan` | 1 | `/Users/heytea/.codex/skills/security-scan` | Scan your Claude Code configuration (.claude/ directory) for security vulnerabilities, mis |
| `skill-creator` | 10 | `/Users/heytea/.codex/skills/.system/skill-creator` | Guide for creating effective skills. This skill should be used when users want to create a |
| `skill-installer` | 8 | `/Users/heytea/.codex/skills/.system/skill-installer` | Install Codex skills into $CODEX_HOME/skills from a curated list or a GitHub repo path. Us |
| `opencli-browser-reuse` | 3 | `/Users/heytea/.codex/skills/opencli-browser-reuse` | 复用 opencli 浏览器探索 session 的 skill。按常见内部域名路由固定 session，并支持一次性读取任务自动收口。 |
| `springboot-patterns` | 1 | `/Users/heytea/.codex/skills/springboot-patterns` | Spring Boot architecture patterns, REST API design, layered services, data access, caching |
| `springboot-security` | 1 | `/Users/heytea/.codex/skills/springboot-security` | Spring Security best practices for authn/authz, validation, CSRF, secrets, headers, rate l |
| `springboot-tdd` | 1 | `/Users/heytea/.codex/skills/springboot-tdd` | Test-driven development for Spring Boot using JUnit 5, Mockito, MockMvc, Testcontainers, a |
| `springboot-verification` | 1 | `/Users/heytea/.codex/skills/springboot-verification` | Verification loop for Spring Boot projects: build, static analysis, tests with coverage, s |
| `strategic-compact` | 3 | `/Users/heytea/.codex/skills/strategic-compact` | Suggests manual context compaction at logical intervals to preserve context through task p |
| `sso-login` | 3 | `/Users/heytea/.codex/skills/sso-login` | HeyTea 统一 SSO 登录 skill。基于 opencli Browser Bridge 检查和刷新 account.heytea.com 会话，并为 dbauto/bk 等内部系统提供浏览器驱动的登录入口。 |
| `tdd-workflow` | 2 | `/Users/heytea/.codex/skills/tdd-workflow` | Use this skill when writing new features, fixing bugs, or refactoring code. Enforces test- |
| `trace-log-analysis` | 2 | `/Users/heytea/.codex/skills/trace-log-analysis` | Use when investigating an internal log platform or exported logs by traceId and the goal i |
| `verification-loop` | 2 | `/Users/heytea/.codex/skills/verification-loop` | A comprehensive verification system for Claude Code sessions. |

#### agents_user

| Skill | 文件数 | 路径 | 用途摘要 |
|---|---:|---|---|
| `lark-base` | 88 | `/Users/heytea/.agents/skills/lark-base` | 当需要用 lark-cli 操作飞书多维表格（Base）时调用：适用于建表、字段管理、记录读写、视图配置、历史查询，以及角色/表单/仪表盘管理；也适用于把旧的 +table / + |
| `lark-calendar` | 5 | `/Users/heytea/.agents/skills/lark-calendar` | 飞书日历（calendar）：提供日历与日程（会议）的全面管理能力。核心场景包括：查看/搜索日程、创建/更新日程、管理参会人、查询忙闲状态及推荐空闲时段。高频操作请优先使用 Sho |
| `lark-contact` | 3 | `/Users/heytea/.agents/skills/lark-contact` | 飞书通讯录：查询组织架构、人员信息和搜索员工。获取当前用户或指定用户的详细信息、通过关键词搜索员工（姓名/邮箱/手机号）。当用户需要查看个人信息、查找同事 open_id 或联系方 |
| `lark-doc` | 8 | `/Users/heytea/.agents/skills/lark-doc` | 飞书云文档：创建和编辑飞书文档。从 Markdown 创建文档、获取文档内容、更新文档（追加/覆盖/替换/插入/删除）、上传和下载文档中的图片和文件、搜索云空间文档。当用户需要创建 |
| `lark-drive` | 4 | `/Users/heytea/.agents/skills/lark-drive` | 飞书云空间：管理云空间中的文件和文件夹。上传和下载文件、创建文件夹、复制/移动/删除文件、查看文件元数据、管理文档评论、管理文档权限、订阅用户评论变更事件。当用户需要上传或下载文件 |
| `lark-event` | 2 | `/Users/heytea/.agents/skills/lark-event` | 飞书事件订阅：通过 WebSocket 长连接实时监听飞书事件（消息、通讯录变更、日历变更等），输出 NDJSON 到 stdout，支持 compact Agent 友好格式、正 |
| `lark-im` | 13 | `/Users/heytea/.agents/skills/lark-im` | 飞书即时通讯：收发消息和管理群聊。发送和回复消息、搜索聊天记录、管理群聊成员、上传下载图片和文件、管理表情回复。当用户需要发消息、查看或搜索聊天记录、下载聊天中的文件、查看群成员时 |
| `lark-mail` | 12 | `/Users/heytea/.agents/skills/lark-mail` | 飞书邮箱 — draft, compose, send, reply, forward, read, and search emails; manage drafts, folde |
| `lark-minutes` | 1 | `/Users/heytea/.agents/skills/lark-minutes` | 飞书妙记：获取妙记基础信息（标题、封面、时长）和相关的 AI 产物（总结、待办、章节）。飞书妙记的 URL 格式为: http(s)://<host>/minutes/<minut |
| `lark-openapi-explorer` | 1 | `/Users/heytea/.agents/skills/lark-openapi-explorer` | 飞书/Lark 原生 OpenAPI 探索：从官方文档库中挖掘未经 CLI 封装的原生 OpenAPI 接口。当用户的需求无法被现有 lark-* skill 或 lark-cli |
| `lark-shared` | 1 | `/Users/heytea/.agents/skills/lark-shared` | 飞书/Lark CLI 共享基础：应用配置初始化、认证登录（auth login）、身份切换（--as user/bot）、权限与 scope 管理、Permission deni |
| `lark-sheets` | 8 | `/Users/heytea/.agents/skills/lark-sheets` | 飞书电子表格：创建和操作电子表格。创建表格并写入表头和数据、读取和写入单元格、追加行数据、在已知电子表格中查找单元格内容、导出表格文件。当用户需要创建电子表格、批量读写数据、在已知 |
| `lark-skill-maker` | 1 | `/Users/heytea/.agents/skills/lark-skill-maker` | 创建 lark-cli 的自定义 Skill。当用户需要把飞书 API 操作封装成可复用的 Skill（包装原子 API 或编排多步流程）时使用。 |
| `lark-task` | 13 | `/Users/heytea/.agents/skills/lark-task` | 飞书任务：管理任务和清单。创建待办任务、查看和更新任务状态、拆分子任务、组织任务清单、分配协作成员。当用户需要创建待办事项、查看任务列表、跟踪任务进度、管理项目清单或给他人分配任务 |
| `lark-vc` | 3 | `/Users/heytea/.agents/skills/lark-vc` | 飞书视频会议：查询会议记录、获取会议纪要产物（总结、待办、章节、逐字稿）。1. 查询已经结束的会议数量或详情时使用本技能(如昨天 / 上周 / 今天已经开过的会议等场景)，查询未开 |
| `lark-whiteboard` | 19 | `/Users/heytea/.agents/skills/lark-whiteboard` | > |
| `lark-wiki` | 1 | `/Users/heytea/.agents/skills/lark-wiki` | 飞书知识库：管理知识空间和文档节点。创建和查询知识空间、管理节点层级结构、在知识库中组织文档和快捷方式。当用户需要在知识库中查找或创建文档、浏览知识空间结构、移动或复制节点时使用。 |
| `lark-workflow-meeting-summary` | 1 | `/Users/heytea/.agents/skills/lark-workflow-meeting-summary` | 会议纪要整理工作流：汇总指定时间范围内的会议纪要并生成结构化报告。当用户需要整理会议纪要、生成会议周报、回顾一段时间内的会议内容时使用。 |
| `lark-workflow-standup-report` | 1 | `/Users/heytea/.agents/skills/lark-workflow-standup-report` | 日程待办摘要：编排 calendar +agenda 和 task +get-my-tasks，生成指定日期的日程与未完成任务摘要。适用于了解今天/明天/本周的安排。 |

#### superpowers

| Skill | 文件数 | 路径 | 用途摘要 |
|---|---:|---|---|
| `brainstorming` | 1 | `/Users/heytea/.codex/superpowers/skills/brainstorming` | You MUST use this before any creative work - creating features, building components, addin |
| `dispatching-parallel-agents` | 1 | `/Users/heytea/.codex/superpowers/skills/dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequent |
| `executing-plans` | 1 | `/Users/heytea/.codex/superpowers/skills/executing-plans` | Use when you have a written implementation plan to execute in a separate session with revi |
| `finishing-a-development-branch` | 1 | `/Users/heytea/.codex/superpowers/skills/finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to integra |
| `receiving-code-review` | 1 | `/Users/heytea/.codex/superpowers/skills/receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if fe |
| `requesting-code-review` | 2 | `/Users/heytea/.codex/superpowers/skills/requesting-code-review` | Use when completing tasks, implementing major features, or before merging to verify work m |
| `subagent-driven-development` | 4 | `/Users/heytea/.codex/superpowers/skills/subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session |
| `systematic-debugging` | 11 | `/Users/heytea/.codex/superpowers/skills/systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixe |
| `test-driven-development` | 2 | `/Users/heytea/.codex/superpowers/skills/test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `using-git-worktrees` | 1 | `/Users/heytea/.codex/superpowers/skills/using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before execu |
| `using-superpowers` | 1 | `/Users/heytea/.codex/superpowers/skills/using-superpowers` | Use when starting any conversation - establishes how to find and use skills, requiring Ski |
| `verification-before-completion` | 1 | `/Users/heytea/.codex/superpowers/skills/verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating |
| `writing-plans` | 1 | `/Users/heytea/.codex/superpowers/skills/writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code |
| `writing-skills` | 7 | `/Users/heytea/.codex/superpowers/skills/writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before dep |

#### plugin_cache

| Skill | 文件数 | 路径 | 用途摘要 |
|---|---:|---|---|
| `browser` | 2 | `/Users/heytea/.codex/plugins/cache/openai-bundled/browser-use/0.1.0-alpha1/skills/browser` | Browser automation for the Codex in-app browser. Use for developer browser tasks on local  |
| `documents` | 73 | `/Users/heytea/.codex/plugins/cache/openai-primary-runtime/documents/26.430.10722/skills/documents` | Create, edit, redline, and comment on `.docx` files inside the container, with a strict re |
| `Presentations` | 26 | `/Users/heytea/.codex/plugins/cache/openai-primary-runtime/presentations/26.430.10722/skills/presentations` | Build premium editorial analytics PPTX decks with artifact-tool presentation JSX, using ru |
| `Spreadsheets` | 9 | `/Users/heytea/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.430.10722/skills/spreadsheets` | Use this skill when a user requests to create, modify, analyze, visualize, or work with sp |

## 可执行动作

- [ ] 新建或更新任何 skill 后，同步更新本笔记。
- [ ] 如果发现重复 skill，先比较文件树 hash；只有完全相同或明确可合并时才归档。
- [ ] 插件缓存目录下的 skill 默认不手工合并或删除。
- [ ] 补充 `release-workflow/references/pipeline-map.json` 中真实流水线 URL 后，才能一键打开具体项目流水线。

## 变更记录

- 2026-06-23：更新用户级 skill `/Users/heytea/.codex/skills/sso-login`。将浏览器打开动作接入 `/Users/heytea/.codex/skills/opencli-browser-reuse/scripts/opencli_reuse.sh`，继续沿用稳定 session `heytea-sso-cn`，避免 SSO 检查和登录刷新为每次请求创建新的 opencli Browser Bridge session；已通过真实 `--platform cn --status` 校验；最近更新时间：2026-06-23。
- 2026-06-23：更新用户级 skill `/Users/heytea/.codex/skills/dbauto-sql-query`。默认 session 由 `dbauto-sql` 收敛为稳定名 `dbauto-query`，并将页面打开动作接入 `opencli-browser-reuse` wrapper；已通过脚本 `--list-common-instances` 链路和固定 session URL/标题校验；最近更新时间：2026-06-23。
- 2026-06-23：新增用户级 skill `/Users/heytea/.codex/skills/opencli-browser-reuse`。用途：当 Codex/Hermes 被要求“用 opencli 探索网页/内部站点”时，默认复用稳定 Browser Bridge session，而不是为每次探索创建新的 session 名；内置脚本 `scripts/opencli_reuse.sh` 会按域名自动映射 `heytea-sso-cn`、`dbweb-explore`、`dbauto-query`、`bk-console` 等固定 session，并支持 `--close-after` 对一次性读取任务自动收口。来源目录：Codex 用户级 skills；启用状态：已启用；已通过 `superpowers-codex use-skill opencli-browser-reuse`、脚本 `--help`、真实 `dbweb.test.heytea.com` 打开验证，以及 Chrome `OpenCLI Browser` 标签计数回归校验；最近更新时间：2026-06-23。
- 2026-06-11：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。新增按需求区域自动选择在线提测文档目标目录：`region=cn` 默认创建到《国内迭代》（`workspaceId=26116527504`，`folderId=P7QG4Yx2Jp7N1PAgi41lknj2V9dEq3XD`）；`region=intl` 必须创建到《海外迭代》，本地未配置海外 folderId 时会阻断并要求显式传入目录，避免落到空间根目录或错误文件夹。同步更新 skill 文档、脚本 dry-run 输出 `targetSource/targetFolderName`，并验证国内 dry-run 自动解析到《国内迭代》；最近更新时间：2026-06-11。
- 2026-06-08：新增用户级 skill `/Users/heytea/.codex/skills/multi-agent-framework-maintainer`。用途：在新 session 中继续维护个人 `~/.codex` 多 agent 四层框架，不要求用户每次重复提供完整历史背景；默认优先读取 `/Users/heytea/Documents/HeyTea/codex-workspace/AGENTS.md`、`~/.codex/config.toml`、`~/.codex/agents/README.md`、`~/.codex/agents/docs/README.md` 以及 Obsidian 中的 `02-个人Codex多Agent改造计划`、`17-当前成果总清单` 重建上下文；来源目录：Codex 用户级 skills；启用状态：已启用；最近更新时间：2026-06-08。
- 2026-05-15：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create`。补充 HSP/BFC 环境约定：国内需求默认 `dev-hsp-1`，国际需求默认 `dev-intl-hsp-1`；同时为当前 `dhtInvoice` 发票仓库补充 `service/scm/bfc -> yc9e25 / dev-hsp-1 / hsp` 路由，用于需求 `p35_15805` 生成 BK 需求流水线配置；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-06-04：新增项目级 skill `/Users/heytea/Documents/HeyTea/code/dhtInvoice/.codex/skills/dbauto-sql-query`。用途：通过 opencli Browser Bridge 打开国内 dbauto SQL 查询页并执行只读查询，默认常用实例仅保留 3 个 MySQL：`hsp-ids`、`hsp-pof`、`hsp-pof-scm`；支持 `--list-dbs` 按实例展示数据库，`--list-tables` 按实例和库展示表，形成“选实例 -> 选库 -> 查表/SQL”的默认交互流程；已通过实例列表、库列表、表列表和生产 `center_hsp_invoice.hsp_goods_rate` 只读查询验证；最近更新时间：2026-06-04。
- 2026-06-04：删除用户级副本 `/Users/heytea/.codex/skills/dbauto-sql-query`，避免与项目级版本产生漂移；当前仅保留项目级版本；最近更新时间：2026-06-04。
- 2026-06-04：按用户确认恢复用户级 skill `/Users/heytea/.codex/skills/dbauto-sql-query`，使国内 dbauto 查询能力可在任意工作目录触发；用户级版本作为主版本，项目级 `/Users/heytea/Documents/HeyTea/code/dhtInvoice/.codex/skills/dbauto-sql-query` 可作为当前仓库副本保留；最近更新时间：2026-06-04。
- 2026-06-04：更新 `dbauto-sql-query` 用户级与项目级副本，移除国内 dbauto `SQL上线` 页面说明，保留该 skill 仅用于在线只读 SQL 查询、实例/库/表列表能力；最近更新时间：2026-06-04。
- 2026-06-07：更新用户级 skill `/Users/heytea/.codex/skills/dbauto-sql-query`。修复 `scripts/dbauto_sql_query.py` 的只读 SQL 判定：此前 `SHOW CREATE TABLE ...` 会被 `CREATE` 关键字误判为写 SQL 并拒绝执行；本次收紧实现为“先判定语句前缀是否为只读，再拦截真正危险写关键字”，保留对 `UPDATE/INSERT/DELETE/ALTER/TRUNCATE/...` 的阻断，同时允许 `SHOW CREATE TABLE` 这类只读元数据查询；已通过 `opencli doctor -v`、`--list-common-instances`、以及生产 `hsp-ids / center_hsp_invoice / SHOW CREATE TABLE hsp_goods_rate` 真实查询验证；最近更新时间：2026-06-07。
- 2026-05-14：更新用户级 skill `/Users/heytea/.codex/skills/obsidian-note-writing`。新增 Obsidian 编号主题组织规则：整理主题目录时优先使用 `NN-Topic/NN-00-Topic-索引.md`、`NN-01-Topic-总览.md`、`NN-02-Topic-子主题.md`、`NN-99-Topic-原始长文归档.md` 命名，并要求同步更新内部链接、用 aliases 兼容旧标题；本次用于整理 `ai-related/02-LLM` 与 `ai-related/03-RAG`；启用状态：已启用；最近更新时间：2026-05-14。
- 2026-05-14：再次优化用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc` 的可核对性。dry-run 结果新增 `headerStylePlan`，在线创建结果中的每个 sheet 新增 `styleRanges`，用于明确展示哪些表头区域被加粗；同步收敛 `build_header_style_plan` 实现，去除无效参数；已通过本地回归、`quick_validate.py` 和真实海外提测文档 `https://alidocs.dingtalk.com/i/nodes/Qnp9zOoBVBZzojBKsLzKgK5EV1DK0g6l` 验证；最近更新时间：2026-05-14。
- 2026-05-15：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。当提测证据未显式提供负责人和 `developer.name/id` 时，新增从当前工作目录下匹配服务仓库的 `git config user.name` 自动回填负责人逻辑，优先读取仓库本地配置；同步补充脚本回归测试与 skill 文档，并用需求 `p35_15805` 的真实提测数据验证 `服务清单` 负责人列可自动带出 `qichenghui`；最近更新时间：2026-05-15。
- 2026-05-14：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。新增在线表格表头加粗能力：写入各 sheet 数据后，通过 `dws mcp sheet update_range` 对模板表头区域写入 `fontWeights=bold`，其中普通 sheet 加粗首行，`定时任务 XXL-JOB` 额外加粗 `A11:P11`；已补充回归测试、更新 skill 文档，并用真实海外提测文档 `https://alidocs.dingtalk.com/i/nodes/14lgGw3P8vvl1yqpipo3vrw085daZ90D` 验证样式写入成功；最近更新时间：2026-05-14。
- 2026-05-14：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。新增通过隐藏 MCP 调用 `dws mcp sheet update_sheet` 重命名默认首个 sheet 的能力，线上创建后首个 tab 由 `Sheet1` 修正为 `服务清单`，并与其余 5 个 sheet 一起保证最终顺序与旧模板一致；已补充脚本回归测试、更新 skill 文档，并用真实海外提测文档 `https://alidocs.dingtalk.com/i/nodes/Y1OQX0akWm3gY0qvFvow7qRZJGlDd3mE` 验证通过；最近更新时间：2026-05-14。
- 2026-05-14：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc` 的提测文档命名规则：默认名称改为 `YYYYMMDD-需求号-需求标题`，当需求号或需求标题缺失时回退为纯 `YYYYMMDD`；已同步回归测试、skill 文档与 dry-run 校验；最近更新时间：2026-05-14。
- 2026-05-24：更新用户级 skill `/Users/heytea/.codex/skills/obsidian-note-writing`。新增 Python / FastAPI / 代码学习类笔记的默认风格覆盖规则：当 Obsidian 写作任务命中这类主题时，skill 会默认读取并遵循 `/Users/heytea/Documents/obsidian_note/Codex工作台/Codex配置和写作规范/Python学习笔记怎么写.md`，而不是仅按通用知识库风格输出；同步更新 `SKILL.md`、`references/style-guide.md` 与 `agents/openai.yaml`；最近更新时间：2026-05-24。
- 2026-05-25：新增用户级 skill `/Users/heytea/.codex/skills/excel-json-analysis`。用途：从 Excel 导出的 JSON 列中提取嵌套字段、展开列表、去重并生成新工作簿；已通过 `quick_validate.py`、`--help` 校验和真实样本 `export_20260525_151155.xlsx` 验证；最近更新时间：2026-05-25。
- 2026-05-26：更新用户级 skill `/Users/heytea/.codex/skills/excel-json-analysis`。扩展平铺 CSV / Excel 台账场景：当用户要求基于表格生成新增数据 `INSERT` SQL 时，skill 现在要求同回合同步生成插入前 `COUNT` / 明细查询和插入后回查 SQL；已用真实样本 `0526发票助手灰度计划 (1).csv` 验证字段映射、空行过滤、`13% -> 0.13` 归一化以及查询 SQL 产物；最近更新时间：2026-05-26。
- 2026-05-27：新增用户级 skill `/Users/heytea/.codex/skills/dbauto-export-agent`。用途：作为 dbauto 导出工具的本地 agent 入口，转调 `/Users/heytea/Documents/new_tools/dbauto_export_tool/start-agent.sh`，统一完成后端拉起、dbauto 登录准备和扩展界面打开；已通过 `quick_validate.py`、`use-skill` 加载、wrapper `--help` 与真实 `--env bj --status-only` 校验；最近更新时间：2026-05-27。
- 2026-06-24：更新用户级 skill `/Users/heytea/.codex/skills/dbauto-export-agent`。新增硬规则：当用户要求“导出 dbauto 数据”时，Codex 必须严格停留在成熟的 dbauto export agent 工作流内，禁止私自退化到 `dbauto-sql-query`、`opencli browser eval`、自定义 Python 分页、手工 CSV 拼接或擅自改写 SQL 语义；导出失败时必须先调试现有 agent / 本地导出工具链，而不是切换实现路径；最近更新时间：2026-06-24。
- 2026-05-14：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。根据参考提测文档 `https://alidocs.dingtalk.com/i/nodes/93NwLYZXWygl1LqZCZzbGwavJkyEqBQm` 优化模板生成：锁定 6 个 sheet 顺序（服务清单、提测配置清单-TEST、提测配置清单-PROD、数据库脚本、定时任务 XXL-JOB、发布流程），文档顶层标题按 `需求号 需求标题（国内/海外）` 区分，缺失数据来源时单元格保持为空，不再写 `待确认`；脚本新增默认首 sheet 复用计划与 `dws sheet.update_sheet` CLI 未暴露限制说明；已通过模板测试、示例 dry-run 与 `quick_validate.py` 校验；最近更新时间：2026-05-14。
- 2026-05-15：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create`：将“测试发版 / 开发发版”纳入 step1/step2 配置流，新增 `pipelines[].deployRole` 确认项并在 step2 初始化基础信息时按配置传给 BK；同时新增 `pipelines[].skipGrayEnv` 作为“是否跳过灰度环境”确认项，当前仅记录在需求 JSON 和控制台提示中，未自动下发到 BK（本地尚未确认稳定入参字段）；已补充 `tests/test_run_pipeline.py` 并通过 `py_compile`、`unittest discover` 和离线 mock 的 step1 配置生成校验；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-13：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create` 的 `config/release-excludes.json`，将 `hsp-ims-lowcost-domain` 加入 deploy-only 服务排除名单；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-13：更新用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。根据旧提测模板 `https://alidocs.dingtalk.com/i/nodes/amweZ92PV6vZanB5igKPPaLLVxEKBD6p` 修正输出结构：由自定义 5-sheet 改为 6-sheet 模板（服务清单、提测配置清单-TEST、提测配置清单-PROD、数据库脚本、定时任务 XXL-JOB、发布流程），并新增 `tests/test_template_workbook.py` 锁定模板表头；已通过模板测试、`quick_validate.py`、脚本 dry-run 校验；最近更新时间：2026-05-13。
- 2026-05-13：新增用户级 skill `/Users/heytea/.codex/skills/alidocs-test-delivery-doc`。用途：在 0-1 / 1-100 开发收口或 BK 需求流水线创建后，基于开发证据、服务分支、提交、验证输出与 `docs/bk/{需求编号}.json` 创建钉钉 AliDocs 在线提测表格；来源目录：Codex 用户级 skills；启用状态：已启用；包含脚本 `scripts/create_test_delivery_sheet.py` 与示例 `references/evidence-example.json`；已通过 `quick_validate.py`、`use-skill` 加载、脚本 `--help`、示例 dry-run 与 BK-only dry-run 校验；最近更新时间：2026-05-13。
- 2026-05-13：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create`：新增 `config/release-excludes.json` deploy-only 排除名单，Step1 扫描时按服务名或 GitLab group_path 跳过永不进入需求流水线的服务，并补充 `tests/test_scan_services.py` 回归测试；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-12：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create` 的国际供应链路由配置：新增 `智慧供应链（国际业务） -> u04c7f`、模板 `f42a4e0ff4d444cc97b5be5aebc77a64`、`u04c7f` 流水线映射，并将 `service-hsp-pom-web` 路由修正为 `u04c7f / dev-intl-hsp-1 / intl-hsp`；同时支持基础信息 `prodVerifier` 传多名生产验证人员；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-12：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create` 的 step2 重试逻辑：已存在 `pipelineId` 时跳过创建并触发新构建；修正蓝鲸基础信息插件 `deployRole` 字段为枚举 `DEVELOPER`，避免误传人员工号列表导致 `DeployRoleEnum` 解析失败；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-12：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create` 的 step2 脚本，支持 `DEVELOPER` 测试角色、传递用户确认的 `deployRole`，并在基础信息初始化子进程失败时停止主流程；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-12：更新外部 skill 仓库 `shop-ofc-skill/bk-pipeline/2.0.3/skills/bk-pipeline-create` 的服务路由配置，新增 `service-hsp-pom-web -> yc9e25 / dev-intl-hsp-1 / hsp`，用于需求 `p45_6578` 生成蓝鲸流水线配置；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描。
- 2026-05-12：新增用户级 skill `/Users/heytea/.codex/skills/alidocs-browser-reader`。用途：在 `dws` CLI 认证不可用或组织未开放 CLI data access 时，通过本机 Chrome 已登录会话读取钉钉文档正文；包含 Playwright + Chrome cookie 渲染脚本 `scripts/read_alidocs.py`；启用状态：已启用，已通过 `quick_validate.py` 校验并完成真实 AliDocs URL 读取验证。
- 2026-05-12：新增用户级 skill `/Users/heytea/.codex/skills/dws-auth-helper`。用途：处理 DingTalk `dws` CLI 认证状态检查、设备流登录引导和登录后重试；启用状态：已启用，已通过 `quick_validate.py` 校验并可被 `superpowers-codex use-skill dws-auth-helper` 发现。
- 2026-05-12：新增用户级 skill `/Users/heytea/.codex/skills/sso-login`。用途：让 Codex 直接发现并调用 HeyTea 统一 SSO 登录能力；来源目录为 `/Users/heytea/Documents/HeyTea/code/tool_file/agent/bug-killer/skills/sso-login` 的 wrapper，不复制 `.chromium-profile`、cookie 或 token 文件；启用状态：已启用，已通过 `quick_validate.py` 校验并可被 `superpowers-codex use-skill sso-login` 发现。
- 2026-05-25：更新用户级 skill `/Users/heytea/.codex/skills/sso-login`。移除对外部 canonical Python wrapper 的依赖，改为基于 `opencli` Browser Bridge 的本地实现；新增脚本 `scripts/sso_opencli.py`，支持 `--status` 检查、浏览器驱动的 SSO 页面打开、手动登录轮询与 Browser Bridge 诊断；已通过 `quick_validate.py`、脚本 `--help` 和真实 `--platform cn --status` 校验，当前可正确识别 `LOGIN_REQUIRED`；最近更新时间：2026-05-25。
- 2026-05-12：更新外部 skill 仓库 `shop-ofc-skill`（路径：`/Users/heytea/Documents/skills/shop-ofc-skill`；来源：内部 GitLab `service/shop/ai/shop-ofc-skill`；用途：PDF 转 Markdown、BK 流水线创建、SSO 登录辅助；启用状态：本地外部技能仓库，未纳入当前 Codex 用户级 skills 自动扫描）。本次为 `pdf-to-md-j` 安装 OCR/PDF 依赖并修正 MCP 配置路径；无合并/归档。
- 2026-05-12：修复 `shop-ofc-skill/pdf-to-md-j/scripts/convert.py` 的 CLI 帮助参数处理，支持 `-h/--help` 正常输出，避免将帮助参数误作为 PDF 路径。
- 2026-05-08：新增 `/Users/heytea/.codex/skills/release-workflow`，支持自动生成提测文档和按映射定位/打开流水线；已通过 skill 校验。
- 2026-05-07：创建本笔记；记录 88 个本地 skill；归档重复的 `~/.agents/skills/dws` 到 `/Users/heytea/.codex/skill-duplicates-archive/20260507-dws-agents-duplicate`；保留 `/Users/heytea/.codex/skills/dws`。
- 2026-05-07：在 `~/.codex/AGENTS.md` 增加 Skill Documentation Sync 规则，要求后续 skill 变更自动同步本笔记。
