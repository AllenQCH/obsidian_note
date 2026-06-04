---
title: "05-OpenCLI"
source: "https://opencli.org/ + https://github.com/spectreconsole/open-cli"
author: "Allen"
published:
created: 2026-05-11
description: "OpenCLI 是一个 CLI 描述规范（OpenCLI Specification, OCS），用于把命令行工具以机器可读方式表达出来。"
tags: ["obsidian-note", "tech-note", "opencli", "cli", "automation", "mcp", "tooling", "spec"]
type: "tech-note"
status: "processed"
---

# 1、OpenCLI是什么？
https://github.com/jackwener/opencli
官方定义大意：
- **“把网站、已登录浏览器、Electron 应用、甚至本地 CLI，统一包装成一个可命令行调用的入口”**
- 让人和机器在**不看源码、不翻文档**的情况下，也能理解一个 CLI 如何调用
- 它不是规范，不是 schema，不是论文式提案。 
- 它是个**真的能运行的工具**。

# 2、它解决什么问题？
传统上：
- 你想读 B 站热榜，要打开网页看
- 你想抓小红书内容，要写浏览器自动化
- 你想让 AI 访问你已登录的账号，要处理 cookie / profile / auth
- 你想控制 Cursor / ChatGPT App / Codex 这类桌面应用，也没统一 CLI
这个 OpenCLI 想做的是：用统一命令把这些都变成“像 API 一样能调”的东西
例如：
```
opencli bilibili hot --limit 5
opencli xiaohongshu search 美食 --limit 10
opencli twitter search "AI news"
opencli claude ask "总结这篇文章"
opencli cursor send "帮我改这段代码"
```

# 3、它到底能干什么？

## 1）网站适配器：直接把很多网站做成 CLI
README 明写了：
- Bilibili
- 小红书 / RedNote
- 知乎
- Twitter / X
- Reddit
- HackerNews
- LinkedIn
- 等等
我还直接解析了它的 `cli-manifest.json`：
### 当前规模
- **总命令数：1030**
- **总站点/目标面：160**
- 其中：
- **Browser 命令：737**
- **Public 命令：313**
- **Cookie/登录态命令：523**
- 还有 UI / local / intercept 等策略
所以这不是“几个 demo 命令”，而是一个挺大的适配器仓库。
## 2）浏览器原语：让 Agent 操作任意页面
它有一整套 `opencli browser` 原语，不只是网站成品命令。
README 里列出的 browser 命令包括：
- `open`
- `state`
- `click`
- `type`
- `fill`
- `select`
- `keys`
- `wait`
- `get`
- `find`
- `extract`
- `frames`
- `close`
这意味着它不仅能调“现成适配器”，还可以：
### **把你的已登录 Chrome 变成 Agent 可控浏览器**
比如：
```
opencli browser work open https://example.com

opencli browser work state

opencli browser work click --role button --name "Submit"

opencli browser work fill --label "Email" "me@example.com"

opencli browser work extract "main"

```

## 3）桌面 / Electron 应用适配
这个点挺特别。
它不只做网站，还支持一些 **Electron/桌面应用**。 文档里列出来的桌面适配器包括：
- Cursor
- Codex
- Antigravity
- ChatGPT App
- Trae SOLO
也就是说它不只是“网站 CLI”，更像：
### **“基于浏览器/CDP/Electron 的统一自动化 CLI”**

## 4）把已有本地 CLI 纳入统一入口
它还支持把你已经有的本地命令统一挂到 `opencli` 下：
README 里举例有：
- `gh`
- `docker`
- `vercel`
- `wrangler`
- `obsidian`
你还可以自己注册：
```
opencli external register my-tool \

  --binary my-tool \

  --install "npm i -g my-tool" \

  --desc "My internal CLI"

```
然后就能：
```
opencli my-tool --help
```

# 4、它的核心原理是什么？
这个项目的关键不在“爬虫”，而在：
### **复用你本机已登录 Chrome 的会话**
它不是让你把 cookie 手动导出来乱传。 它的架构是：
```
opencli CLI
   ↕
本地 micro-daemon
   ↕
Chrome 扩展（Browser Bridge）
   ↕
你正在登录的网站页面
```
也就是：
1. 你先在 Chrome 里正常登录某网站
2. OpenCLI 通过浏览器扩展 + daemon 连到这个 Chrome
3. 然后命令直接复用这个登录态
这就是为什么它能处理：
- 小红书通知
- B站收藏
- Twitter 书签
- Claude 网页端
- Gemini 网页端
- 需要账号态的页面操作
而且不需要你自己折腾 OAuth/API key。
# 5、它有什么作用？
我给你按场景讲，比概念更直观。
## 作用 1：把网站能力变成稳定命令
比如你平时想看：
- B站热榜
- 小红书搜索结果
- 知乎热榜
- Twitter 趋势
- Reddit 热帖
你可以直接命令化：
```
opencli bilibili hot
opencli zhihu hot
opencli xiaohongshu search 露营
opencli twitter trending
opencli reddit hot
```
### 好处
- 输出稳定
- 可脚本化
- 可 cron 跑
- 可给 Agent 用
- 支持 `json/yaml/md/csv`
## 作用 2：让 AI Agent 用你的登录态浏览器
这是它很强的一点。
例如你不只是想“读公开网页”，而是想让 Agent：
- 看小红书通知
- 发小红书笔记
- 看 B站历史/收藏
- 操作 Claude 网页端
- 操作 ChatGPT 网页端
- 填表单
- 提取某个网页里的数据
OpenCLI 提供 skill 给 Agent 用。 README 里推荐安装：
```
npx skills add jackwener/opencli
```
或者单独装：
```
npx skills add jackwener/opencli --skill opencli-browser
npx skills add jackwener/opencli --skill opencli-usage
npx skills add jackwener/opencli --skill opencli-adapter-author
npx skills add jackwener/opencli --skill opencli-autofix
```
### 作用本质
把：
- 浏览器导航
- 点击
- 表单输入
- 数据抓取
- network 拦截
变成 Agent 能稳定调用的一套原语。
## 作用 3：下载平台内容
它还有下载能力。
文档里明确支持下载：
- 小红书：图片 / 视频
- B站：视频（需 `yt-dlp`）
- Twitter/X：图片 / 视频
- Pixiv：图片
- 1688：商品图片 / 视频
- 小宇宙：音频 / 转录
- 微信公众号：文章 Markdown
- 豆瓣：图片
例如：
```
opencli xiaohongshu download "<url>" --output ./xhs
opencli bilibili download BV1xxx --output ./bilibili
opencli zhihu download "<url>" --output ./zhihu
opencli weixin download --url "<url>" --output ./weixin
```
## 作用 4：控制桌面 AI / Electron 应用
比如：
- Cursor
- Codex
- ChatGPT App
- Discord
- Qoder

这部分是别的 browser automation 工具不太常见的能力。 项目自己的 comparison 文档里也强调了：
> 它在“Desktop App Control”这块是很独特的。

# 6、它支持哪些应用？
我直接解析了仓库里的 live manifest，大致结论：
## 总规模
- **160 个 site/app surface**
- **1030 个命令**
## 你关心的中文平台，确实支持不少
### 小红书 / RedNote
- `search`
- `note`
### Bilibili
- `hot`
- `download`
### 还有
- 知乎
- 12306
- 闲鱼
- WeRead 等等。
## 国外平台也很多
- Twitter / X
- Reddit
- YouTube
- LinkedIn
- Spotify 等等。

# 7、它怎么使用？
我给你整理成最实用的上手路径。
## 第 1 步：安装
项目要求大概是：
- Node.js >= 20（有文档写 20，有文档写 21，保守按 20+/21+ 看）
- Chrome/Chromium
安装命令：
```
npm install -g @jackwener/opencli
```
## 第 2 步：安装浏览器扩展
装 **OpenCLI Browser Bridge** 扩展。
两种方式：
### 方式 A：Chrome Web Store
README 里给了商店链接，推荐这个。
### 方式 B：GitHub Releases 手动装
下载扩展 zip，解压后到：
```
chrome://extensions
```
打开开发者模式，加载已解压扩展。
## 第 3 步：登录你要操作的网站
比如：
- [bilibili.com](http://bilibili.com)
- [xiaohongshu.com](http://xiaohongshu.com)
- [zhihu.com](http://zhihu.com)
因为很多命令要复用你的登录态。
## 第 4 步：跑诊断
```
opencli doctor
```
它会检查：
- CLI 是否正常
- daemon 是否能起
- 浏览器扩展是否连通
- Chrome 会话是否可访问
## 第 5 步：看支持什么
```
opencli list
```
这个是最重要的入口。 你能看到当前注册的所有 site/command。
也可以看某个站点文档，或直接试：
```
opencli bilibili hot --limit 5
opencli xiaohongshu search 美食 --limit 10
opencli zhihu hot
```


# 8、具体示例

## 例子 1：B站
```
opencli bilibili hot --limit 5
opencli bilibili search 黑神话 --limit 10
opencli bilibili favorite --limit 10
opencli bilibili comments BV1xx411c7mD --limit 10
opencli bilibili summary BV1xx411c7mD

```

如果要下载：

```
opencli bilibili download BV1xxx --output ./bilibili

```

> 这个需要 `yt-dlp`


## 例子 2：小红书

```
opencli xiaohongshu search 旅行 --limit 10

opencli xiaohongshu feed

opencli xiaohongshu notifications

opencli xiaohongshu note "https://www.xiaohongshu.com/search_result/<id>?xsec_token=..."

opencli xiaohongshu comments "<signed-url>" --with-replies --limit 20

opencli xiaohongshu download "<signed-url>" --output ./xhs

```

如果是创作者操作，还支持：

```
opencli xiaohongshu publish ...

opencli xiaohongshu creator-notes

opencli xiaohongshu creator-stats

```


## 例子 3：任意网页浏览器原语

```
opencli browser work open https://example.com

opencli browser work state

opencli browser work tab list

opencli browser work get title

opencli browser work click --role button --name "Submit"

opencli browser work fill --label "Email" "me@example.com"

opencli browser work extract "main"

opencli browser work close

```

注意它的 browser 命令必须带 `<session>`，比如这里的 `work`。



## 例子 4：安装插件

如果官方没有你想要的站点，可以装第三方插件：

```
opencli plugin install github:ByteYue/opencli-plugin-github-trending

opencli plugin list

opencli github-trending repos --limit 10

```



## 例子 5：自己扩展

### 快速生成私人 adapter

```
opencli browser init cnn/top

# 编辑 ~/.opencli/clis/cnn/top.js

opencli browser verify cnn/top

opencli cnn top

```

### 创建插件

```
opencli plugin create my-cnn

cd my-cnn

git init

opencli plugin install file://$(pwd)

opencli my-cnn hello
```



## 5、它为什么实用
### 对人来说
- 文档更清晰
- CLI 学习成本更低
- 可以快速看懂命令结构
### 对 agent / 自动化系统来说
- 不用瞎猜命令行参数
- 可以更稳定地生成调用
- 可以更容易把 CLI 包成 agent 能调用的能力
### 对团队来说
- CLI 变化可被追踪
- 工具接口更规范
- 适合作为“命令行能力层”的标准描述

## 6、它最适合什么场景

### 场景 1：你有很多 CLI 工具要接给 agent
比如：
- 本地脚本
- 开发工具
- MCP server 启动命令
- 自动化操作脚本

这时 OpenCLI 很适合做一层“描述规范”，让这些工具更容易被自动化系统消费。

### 场景 2：你要把 CLI 工具产品化/平台化
如果一个 CLI 已经不只是给自己用，而是要：
- 给团队用
- 给平台用
- 给 AI agent 用

那 OpenCLI 很有价值，因为它把 CLI 从“经验型命令”变成“结构化接口”。

### 场景 3：你想做命令级别的治理与演化
比如：
- 命令升级了哪些参数
- 哪些自动化脚本会受影响
- CLI 对外接口是否稳定

OpenCLI 可以成为比纯 README 更稳定的接口描述层。



# 8、和你当前工作流的关系

结合你现在的需求，OpenCLI 的价值不是“替你直接做网页自动化”，而是：

### 1. 给常用工具做统一调用描述
如果你后面有很多：
- 网页操作脚本
- 数据处理脚本
- MCP 启动命令
- 内部小工具

OpenCLI 可以让它们更容易被 agent 调用和维护。

### 2. 把“工具能力”变成可组合能力
你后面想提高效率，本质上就是：
- 不重复解释工具怎么用
- 不重复解释命令参数怎么传
- 不重复摸索哪个命令该怎么调用

OpenCLI 适合帮助建立这个“标准命令描述层”。

### 3. 和知识库联动
OpenCLI 这类规范类工具，适合在知识库里记录：
- 它的作用
- 它适用在哪些 workflow
- 它和 MCP / agent / CLI 的关系

这样以后查的时候，不用再重新研究一遍。

# 9、对你来说最值得记住的点

- **OpenCLI 本体是规范，不是浏览器自动化产品。**
- **它最像 CLI 世界里的 OpenAPI。**
- **最实用的能力是：文档生成、client 生成、自动化外部工具、变更检测、自动补全。**
- **它适合做 agent 调 CLI 的标准化中间层。**



# 11、OpenCLI 的思路

OpenCLI 更像：
```
先接管一个已经登录的浏览器
```
例如：
```
Chrome    
↓
已经完成SSO
```
然后：
```
publish_skillquery_log_skillquery_order_skill
```
全部运行在：
```
同一个Chrome上。
```


变成：
```
Chrome    
↓
已登录publish_skill
query_log_skill
query_order_skill
```

这时候：
```
登录不再是Skill
```
而变成：
```
运行环境
```
的一部分。

# 有无opencli的区别

实际上你现在的架构可能是：

```
publish_skill   
↓
sso_login_skill   
↓
playwrightquery_log_skill   
↓
sso_login_skill   
↓
playwright
```

而 OpenCLI 的思路是：

```
OpenCLI   
↓
Chrome(已登录)   
↓
publish_skill
query_log_skill
query_order_skill
```

所以：

```
登录能力浏览器能力
```
被抽到了 Runtime 层。
Skill 只关心业务。

## 为什么很多人觉得 OpenCLI 很神奇？

因为他们看到的是：

```
"帮我发版"
```

然后就自动发版了。

实际上内部是：

```
OpenCLI Runtime    ↓找到 publish skill    ↓把浏览器对象传进去    ↓执行
```

---

对于你来说。

最准确的理解应该是：

```
OpenCLI ≈ Spring Boot

Skill ≈ Service

Chrome(已登录) ≈ DataSource

Playwright ≈ JDBC Driver
```

所以 OpenCLI 本身不是 Skill。

它更像：

```
承载 Skill 的平台
```

或者说：

```
让 Agent、Skill、浏览器、登录态能够协同工作的运行时。
```

如果用一句最简单的话解释：

```
以前：每个 Skill 自己带着浏览器和登录能力。OpenCLI：浏览器和登录能力由平台统一提供，Skill 只负责业务动作。
```

这也是为什么你会看到很多 OpenCLI 的 Skill 里面根本没有 `sso-login`，因为登录已经不属于 Skill 的职责了。



## 相关链接

- [[01-网页插件方案探讨]]
- [[04-Playwright]]
- [[03-harness engineering]]
- [[02-文章知识库相关能力]]
