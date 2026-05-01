# Codex 权限体系：沙箱、审批、网络

## 一句话结论

Codex 不是“天然拥有你电脑的所有权限”。它能做什么，主要由三层决定：

1. **本机权限**：你的系统账号、VPN、GitLab/SSH/浏览器登录态是否可用。
2. **Codex 沙箱**：允许读写哪些目录、命令能否联网。
3. **审批策略**：越界动作是否要先问你。

所以 GitLab、SSO、Obsidian 写入失败时，不一定是 Codex 不会做，通常是这三层里某一层没放开。

## Codex 的核心权限开关

### 1. `sandbox_mode`

控制 Codex 运行命令时的技术边界。

| 模式 | 含义 | 适合场景 |
| --- | --- | --- |
| `read-only` | 主要用于读取和分析；写文件、跑命令会受限或需要审批 | 读代码、问问题、做 review |
| `workspace-write` | 可读文件，可写当前工作区；可配置额外可写目录 | 日常开发、写文档、改代码 |
| `danger-full-access` | 关闭沙箱边界，接近普通终端权限 | 内网、SSO、跨目录、复杂本机自动化 |

重点：`workspace-write` 不是“全盘可写”。如果 Obsidian vault 不在当前 workspace 或 `writable_roots` 里，Codex 可能写不了。

### 2. `sandbox_workspace_write.network_access`

控制 `workspace-write` 沙箱里的命令能不能访问网络。

```toml
[sandbox_workspace_write]
network_access = true
```

不开网络时，`curl`、`git fetch`、`git push`、访问公司 GitLab/SSO 都可能失败。

### 3. `sandbox_workspace_write.writable_roots`

给 `workspace-write` 额外放开可写目录。

```toml
[sandbox_workspace_write]
writable_roots = [
  "/Users/heytea/Documents/Obsidian Vault",
  "/Users/heytea/Documents/HeyTea/code"
]
```

这比直接开 `danger-full-access` 更稳：只扩大必要目录，不放开整台机器。

### 4. `approval_policy`

控制 Codex 什么时候停下来问你。

| 策略 | 含义 |
| --- | --- |
| `untrusted` | 对不在可信集合里的命令更保守 |
| `on-request` | 默认在沙箱内执行，需要越界时请求你批准 |
| `never` | 不弹审批；能做就做，不能做就失败 |

注意：`on-failure` 已经过时，交互式使用优先用 `on-request`，自动化脚本场景再考虑 `never`。

## 最常用配置

### 日常开发

```toml
sandbox_mode = "workspace-write"
approval_policy = "on-request"

[sandbox_workspace_write]
network_access = true
writable_roots = [
  "/Users/heytea/Documents/Obsidian Vault"
]
```

适合：改代码、写 Obsidian、访问 GitHub/GitLab、跑测试。  
优点：大部分事能做，越界时还会问你。

### 内网/SSO/浏览器自动化

```toml
sandbox_mode = "danger-full-access"
approval_policy = "on-request"
```

适合：Playwright 登录、读取独立 Chromium profile、访问公司 GitLab、操作多个本地目录。  
风险：Codex 拥有更接近普通终端的权限，应该只在可信任务里用。

### 全自动高权限

```toml
sandbox_mode = "danger-full-access"
approval_policy = "never"
```

这是“让我自己跑完”的模式。效率最高，风险也最高。不要在不可信仓库、带生产密钥的目录、或你没看过的脚本里用。

## GitLab/SSO 为什么经常卡

访问公司 GitLab 不是一个权限，而是一串权限：

| 环节 | 需要什么 |
| --- | --- |
| 打开 `git.heytea.com` | 网络、DNS、VPN/内网 |
| 登录 GitLab | GitLab 账号或浏览器 session |
| 走 SSO | `account.heytea.com` 登录态、钉钉确认 |
| Playwright 打开浏览器 | 本机可执行浏览器、可写 profile 目录 |
| 复用 cookie | 读写指定 Chromium profile |
| clone/push | GitLab 权限、SSH key 或 HTTPS 凭据 |

所以要分层排查：

1. 普通终端/浏览器能不能访问？
2. Codex 当前会话有没有网络？
3. 目标目录是不是可写？
4. GitLab/SSO 登录态是否在 Codex 使用的浏览器 profile 里？
5. Git 本身有没有 SSH/HTTPS 凭据？

## 其他 Agent 也是这样吗？

是，原则类似，但实现不同。

| 工具 | 权限模型特点 |
| --- | --- |
| Codex | 用 `sandbox_mode` 定义边界，用 `approval_policy` 定义何时询问；可配置网络和额外可写目录 |
| Claude Code | 用 allow/ask/deny 规则控制工具、文件、域名；也有 sandbox，权限规则和 OS 级沙箱是两层 |
| Gemini CLI | 支持 sandbox，可用 Docker/Podman/macOS Seatbelt 等隔离危险命令和文件修改 |
| Cursor CLI | 用 permission tokens 控制 shell 命令和文件读取 |

共同点：只要 Agent 能执行命令、改文件、联网，就必须有权限边界。  
差异点：Codex 更直接暴露“沙箱 + 审批”两个旋钮；Claude/Cursor 更偏细粒度规则；Gemini 更强调容器或系统沙箱。

## 我的使用建议

默认用：

```toml
sandbox_mode = "workspace-write"
approval_policy = "on-request"

[sandbox_workspace_write]
network_access = true
writable_roots = [
  "/Users/heytea/Documents/Obsidian Vault"
]
```

只有遇到这些任务，再临时开高权限：

- SSO/钉钉/浏览器自动化
- 跨多个目录搬文件
- 需要读写 Playwright/Chromium profile
- 公司内网工具链需要完整本机环境

不要把 token、cookie、SSH 私钥写进笔记、代码或 remote URL。Codex 可以使用本机已有凭据，但不应该把凭据持久化到项目文件里。

## 参考

- OpenAI Codex：Sandboxing
  https://developers.openai.com/codex/concepts/sandboxing
- OpenAI Codex：Configuration Reference
  https://developers.openai.com/codex/config-reference
- Claude Code：Permissions
  https://code.claude.com/docs/en/permissions
- Gemini CLI：Sandboxing
  https://geminicli.com/docs/cli/sandbox/
