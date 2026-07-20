**会话是怎么管理的**

一次 Codex Chat 在底层叫 `thread`，一次问答及执行过程叫 `turn`。

- 新建 Chat：创建 thread，并写入元数据和 JSONL 日志
- 继续 Chat：resume 原 thread，后续 turn 追加到原历史
- Fork：复制指定位置之前的历史，产生新 thread ID
- Archive：把完整日志移入归档目录，不等于删除
- Delete：永久删除持久化 thread
- Compact：压缩模型当前可见的旧上下文，避免超出上下文窗口；不应理解成简单删除整个会话文件
- 关闭窗口：thread 可以从进程内存卸载，但持久化历史仍在磁盘

官方接口说明：[Codex App Server](https://learn.chatgpt.com/docs/app-server#api-overview)。

本机关键文件如下：

| 路径                                                                         | 职责                                               |
| -------------------------------------------------------------------------- | ------------------------------------------------ |
| [state_5.sqlite] (/Users/heytea/.codex/state_5.sqlite)                     | 会话目录和元数据：标题、cwd、来源、归档状态、模型、Memory 模式、父子 agent 关系 |
| [sessions] (/Users/heytea/.codex/sessions)                                 | 活跃会话完整 JSONL，按年月日组织                              |
| [archived_sessions] (/Users/heytea/.codex/archived_sessions)               | 已归档会话的 JSONL                                     |
| [session_index.jsonl] (/Users/heytea/.codex/session_index.jsonl)           | 较轻量的会话名称索引                                       |
| [history.jsonl] (/Users/heytea/.codex/history.jsonl)                       | 输入历史，类似 CLI 的历史记录                                |
| [.codex-global-state.json] (/Users/heytea/.codex/.codex-global-state.json) | App UI 状态：项目、侧边栏顺序、thread-project 归属、工作区、待发送消息   |
| [worktrees] (/Users/heytea/.codex/worktrees)                               | Codex 托管的 Git worktree                           |

本次检查时，`state_5.sqlite` 中有 192 个 thread，其中 26 个已归档。


# Q：我看了一下，你列出来的 session 相关数据，是我之前在 codex cli 中的文件夹地址，那么codex.app 也是这个地址吗？？
# A：
已确认 Role: solve_personal_problem

是的，已经通过当前正在运行的 ChatGPT/Codex App 进程核实：

> Codex CLI 和 Codex Desktop App 的本地会话，确实共用 `/Users/heytea/.codex` 下的 session、状态数据库和 Memory。

当前 App 进程正在直接打开：

```
/Users/heytea/.codex/state_5.sqlite
/Users/heytea/.codex/memories_1.sqlite
/Users/heytea/.codex/sessions/2026/07/19/*.jsonl
```

当前这个 Desktop 会话对应的文件就是：

```
/Users/heytea/.codex/sessions/2026/07/19/
rollout-2026-07-19T14-47-11-019f7920-f8c2-7c12-8bc0-cb22eb5b1023.jsonl
```

文件内部明确记录：

```
originator = "Codex Desktop"
cwd = "/Users/heytea/Documents/chatgpt_study"
```

所以不是 App 仅仅“读取了 CLI 旧数据”，而是 App 自己的新会话也正在写入同一个 [sessions](/Users/heytea/.codex/sessions) 目录。

**CLI 和 App 如何区分**

它们共用目录，但每个 JSONL 的元数据会标记来源：

```
Codex CLI：
source = "cli"

Codex Desktop：
originator = "Codex Desktop"
source = "vscode"
```

这里 Desktop 的 `source="vscode"` 是当前内部实现沿用的来源标签，不代表你真的从 VS Code 启动；判断 Desktop 来源应结合 `originator="Codex Desktop"`。

整体关系是：

```
Codex CLI
    ┐
    ├──> /Users/heytea/.codex/state_5.sqlite
    ├──> /Users/heytea/.codex/sessions
    ├──> /Users/heytea/.codex/archived_sessions
    └──> /Users/heytea/.codex/memories

Codex Desktop App
    ┘
```

因此你在 App 里能看见或恢复一部分以前 CLI 创建的会话，底层原因就是它们使用同一个会话目录和索引数据库。

需要区别的是：

|目录|用途|
|---|---|
|`/Users/heytea/.codex/sessions`|CLI 与 Desktop 共用的完整会话 JSONL|
|`/Users/heytea/.codex/state_5.sqlite`|CLI 与 Desktop 共用的会话目录和元数据|
|`/Users/heytea/.codex/memories`|CLI 与 Desktop 共用的本地 Memory|
|`/Users/heytea/Library/Application Support/Codex`|Desktop 界面、浏览器、Cookie、Local Storage 等客户端数据|

只有两种情况可能不共用：

- 启动 CLI 时手工设置了其他 `CODEX_HOME`
- 使用的是纯云端 ChatGPT/Codex Chat，而不是本地 Codex 会话

你当前没有设置自定义 `CODEX_HOME`，所以现在 CLI 与 Desktop App 使用的都是：

```
/Users/heytea/.codex
```