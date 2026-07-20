## ~/Library 里的目录是什么

`/Users/heytea/Library/Application Support/Codex` 是 Chromium/App 外壳的数据目录，包含 Cookies、Local Storage、Session Storage、浏览器配置和渲染缓存。它不是 Codex 配置根目录，也不适合手工维护。

`/Users/heytea/Library/Caches/Codex` 和 `/Users/heytea/Library/Caches/com.openai.codex` 是可再生缓存。

日常真正应该关注和备份的是 `~/.codex`；尤其不要随意分享 `auth.json`、浏览器 Cookies、完整 sessions 和 Memory，因为它们可能包含敏感上下文。

快速打开两个主要目录：

```
open /Users/heytea/.codex
open "/Users/heytea/Library/Application Support/Codex"
```



# Q：/Users/heytea/Library/Application Support/Codex这个是干嘛的啊， 我看了半天没明白里面是做什么的啊？而且我打开看了下里面内容特别多
# A：

已确认 Role: solve_personal_problem

这个目录可以理解成：

> ChatGPT/Codex Desktop 自带浏览器内核的“用户数据目录”，类似 Chrome 的用户 Profile。

ChatGPT App 当前进程明确使用了：

```
--user-data-dir=/Users/heytea/Library/Application Support/Codex
```

所以里面文件多是正常的。它们由 Chromium 内核和 ChatGPT App 自动创建，不是需要你手工维护的 Codex 配置。

**和 `~/.codex` 的区别**

|目录|主要职责|
|---|---|
|`/Users/heytea/.codex`|Codex 配置、AGENTS、Skills、Agents、MCP、会话、Memory|
|`/Users/heytea/Library/Application Support/Codex`|Desktop App 界面、浏览器、登录会话、网页存储、渲染缓存|

真正需要你关心和维护的是：

```
/Users/heytea/.codex
```

`Application Support/Codex` 主要由 App 自己管理。

**里面的文件分别做什么**

|文件或目录|作用|
|---|---|
|`Cookies`|App 和网页的登录 Cookie、会话状态|
|`Local Storage`|网页和 App 前端保存的持久状态|
|`Session Storage`|当前窗口、页面的临时状态|
|`Local State`|Chromium 全局状态|
|`Preferences`|App 浏览器内核的偏好设置|
|`Default`|默认 Chromium Profile|
|`Partitions`|不同页面或功能的隔离存储空间|
|`codex-browser-app`|Codex 内置浏览器使用的独立 Profile|
|`Cache`、`Code Cache`|页面资源和 JavaScript 缓存|
|`GPUCache`、`GraphiteDawnCache`|GPU、WebGPU 和页面渲染缓存|
|`Crashpad`、`sentry`|崩溃报告和错误诊断|
|`Safe Browsing`、`CertificateRevocation`|浏览器安全检查和证书数据|
|`WidevineCdm`|受保护媒体内容支持组件|
|`WasmTtsEngine`|语音相关的 WebAssembly 组件|
|`component_crx_cache`|Chromium 组件下载缓存|
|`SingletonLock`、`SingletonSocket`|防止重复启动和进程间通信|
|`*-journal`、`*-wal`、`*-shm`|SQLite 数据库的事务和并发辅助文件|

**你本机当前占用**

整个目录约：

```
156 MB
```

主要空间来自：

```
48 MB  component_crx_cache
22 MB  WasmTtsEngine
19 MB  WidevineCdm
18 MB  Cache
15 MB  Default
13 MB  Partitions
```

因此它看起来文件很多，但大部分是 Chromium 自动下载的组件、缓存和数据库辅助文件。

**哪些重要、哪些可再生**

大体可以这样理解：

```
登录和界面状态：
Cookies、Local Storage、Preferences、Default、Partitions

可重新生成或下载：
Cache、GPUCache、Code Cache、component_crx_cache、
WidevineCdm、WasmTtsEngine

诊断信息：
Crashpad、sentry
```

不要在 App 运行时手工删除其中单个数据库、`-wal`、`-shm` 或 `-journal` 文件，否则可能导致数据库状态不一致。

删除整个目录通常不会删除 [sessions](/Users/heytea/.codex/sessions) 中的 Codex 会话，但可能造成：

- ChatGPT/Codex App 退出登录
- 内置浏览器网站登录状态丢失
- 界面偏好和页面状态被重置
- 浏览器组件和缓存重新下载
- 部分本地 App 状态丢失

所以这个目录不适合作为日常配置入口，也不建议手动整理。它还可能包含 Cookie 和网站登录信息，不要分享或提交到 Git。