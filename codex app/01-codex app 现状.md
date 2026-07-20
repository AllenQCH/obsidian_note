# Q：因为我以前使用的是 codex cli，我知道codex 加载顺序，很方便我使用，但是 codex.app对我来说有点陌生，所以我想要多了解，你帮忙梳理一下给我吧
# A：
先给结论：你安装的 `/Applications/ChatGPT.app` 是新版统一桌面客户端，虽然显示名叫 ChatGPT，但 Bundle ID 是 `com.openai.codex`，内部会启动 `codex app-server`。
因此，Codex App、Codex CLI、IDE 扩展共用同一个 `CODEX_HOME`；你以前对 Codex CLI 的大部分认知仍然有效。
你这台 Mac 没有设置 `CODEX_HOME`，所以默认根目录是：
```
/Users/heytea/.codex
```

**一、需要区分的三套状态**

|类型|用途|主要存放位置|
|---|---|---|
|Codex 会话历史|当前任务的消息、工具调用、上下文、运行结果|`~/.codex/sessions`、`state_5.sqlite`|
|Codex 本地 Memory|从多个历史会话提炼、供未来会话复用|`~/.codex/memories`、`memories_1.sqlite`|
|普通 ChatGPT Chat/Memory|Quick chat、网页端 ChatGPT、账号个性化|主要是账号云端数据，本地只有客户端缓存|

普通 ChatGPT Quick chat 不出现在 Codex 项目侧边栏；它和本地 Codex 会话不是同一个存储体系。


# Q ：/Users/heytea/.codex 这个是不是就是与我之前用的 Codex cli 的目录一致？？你帮忙核实一下，我记得之前我是用 codex cli 的时候目录就是这个

# A ：
是的，已经核实：`/Users/heytea/.codex` 就是你以前使用 Codex CLI 时的同一个用户数据目录，现在 ChatGPT/Codex App 也继续共用它。

证据：

- 当前没有设置 `CODEX_HOME`，因此 CLI 默认使用 `/Users/heytea/.codex`
- 当前 CLI：`/Users/heytea/.hermes/node/bin/codex`，版本 `codex-cli 0.144.4`
- [state_5.sqlite](/Users/heytea/.codex/state_5.sqlite) 中明确有 `103` 条来源为 `cli` 的历史会话
- ChatGPT App 当前也在运行内置的 `codex app-server`
- 两者共同读取 [config.toml](/Users/heytea/.codex/config.toml)、[AGENTS.md](/Users/heytea/.codex/AGENTS.md)、[sessions](/Users/heytea/.codex/sessions) 等内容

需要注意的区别是：

```
CLI 可执行程序：
/Users/heytea/.hermes/node/bin/codex

ChatGPT App 内置 Codex：
/Applications/ChatGPT.app/Contents/Resources/codex

共同的数据与配置目录：
/Users/heytea/.codex
```

所以可以理解为：入口程序不同，但“家目录”相同。你以前为 Codex CLI 配置的 `config.toml`、`AGENTS.md`、Skills、MCP、Agents 和历史会话，现在 App 基本都能继续使用。
 
 