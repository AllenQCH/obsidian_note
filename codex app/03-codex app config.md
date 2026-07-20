


# Q：review.config.toml；这个是什么配置啊？你在举例子的时候说选中的 profile，其实我不理解这种除了本来的 config.toml 之外的review.config.toml 或者还有其他的config.toml 到底是怎么来的，什么时候使用，为什么会有前缀，是做一些特殊处理么

# A：
已确认 Role: solve_personal_problem

先纠正一个容易误解的地方：`review.config.toml` 只是我举的 Profile 示例。你本机当前并不存在这个文件，也没有配置任何 Profile。

Profile 可以理解成：

> 在基础 `config.toml` 上，临时叠加一组有名字的配置。

**文件名怎么来的**

格式固定为：

```
~/.codex/<profile名称>.config.toml
```

例如：

```
~/.codex/review.config.toml
~/.codex/fast.config.toml
~/.codex/prod-debug.config.toml
```

其中：

```
review     = Profile 名称
.config.toml = Codex 约定的固定后缀
```

这些文件不会由 Codex 自动生成，一般是用户根据自己的需要手工创建的。

**什么时候加载**

`review.config.toml` 不会因为放在 `~/.codex` 下就自动加载。必须显式选择：

```
codex --profile review
```

或者：

```
codex exec --profile review "检查当前代码"
```

普通启动：

```
codex
```

只读取基础 [config.toml](/Users/heytea/.codex/config.toml)，不会读取 `review.config.toml`。

**覆盖关系**

假设基础配置是：

```
# ~/.codex/config.toml

model = "gpt-5.6-sol"
model_reasoning_effort = "medium"
approval_policy = "on-request"
personality = "pragmatic"
```

创建一个 Review Profile：

```
# ~/.codex/review.config.toml

model_reasoning_effort = "xhigh"
personality = "none"
```

执行：

```
codex --profile review
```

最终有效配置相当于：

```
model = "gpt-5.6-sol"              # 来自基础配置
model_reasoning_effort = "xhigh"   # Profile 覆盖基础配置
approval_policy = "on-request"     # 来自基础配置
personality = "none"               # Profile 覆盖基础配置
```

Profile 只需要写与基础配置不同的字段，不需要复制整个 `config.toml`。

**为什么需要 Profile**

常见用途是为不同任务准备不同模式：

|Profile|可能的差异|
|---|---|
|`review`|更高推理强度、只读权限、强调代码审查|
|`fast`|较低推理强度、追求响应速度|
|`safe`|严格审批、只读或 workspace 权限|
|`offline`|禁用网页搜索或部分外部工具|

例如：

```
codex --profile review
codex --profile fast
codex --profile safe
```

这比每次修改主 `config.toml` 更方便，也避免忘记把配置改回来。

**完整优先级**

配置冲突时，从高到低为：

```
CLI 参数和 -c 临时覆盖
    >
项目 .codex/config.toml
    >
--profile 选中的 <名称>.config.toml
    >
~/.codex/config.toml
    >
/etc/codex/config.toml
    >
Codex 内置默认值
```

所以 Profile 可以覆盖用户基础配置，但项目配置和当前命令行参数仍然可以覆盖 Profile。

还有两个重要结论：

- `abc.config.toml` 不是自动生效的特殊配置，只有执行 `--profile abc` 才会加载。
- 当前版本不再推荐把 Profile 写成 `[profiles.review]` 放进主 `config.toml`；现在使用独立的 `review.config.toml`。

Profile 主要是 Codex CLI 的切换机制。ChatGPT/Codex 桌面 App 默认继续使用主 [config.toml](/Users/heytea/.codex/config.toml) 和项目配置，不会自动挑选某个 Profile。

官方说明：[Profiles](https://learn.chatgpt.com/docs/config-file/config-advanced#profiles) 和 [Configuration precedence](https://learn.chatgpt.com/docs/config-file/config-basic#configuration-precedence)。

# Q：/etc/codex/config.toml 这个又是哪里来的啊？？？为什么会有这么多的 config.toml 啊，而且是各种目录的 config.toml，我甚至不知道这些是哪里来的，或者什么时候加载
# A：
已确认 Role: solve_personal_problem

先说你这台 Mac 的实际情况：你现在只有一个真正生效的配置文件：

```
/Users/heytea/.codex/config.toml
```

以下文件都不存在：

```
/etc/codex/config.toml
/Users/heytea/Documents/chatgpt_study/.codex/config.toml
/Users/heytea/.codex/*.config.toml
```

所以你目前不需要处理一堆 `config.toml`。其他路径只是 Codex 支持的“可选配置层”。

**这些配置分别是谁创建的**

|配置层|路径|谁创建|什么时候加载|
|---|---|---|---|
|内置默认值|没有文件|Codex 自带|永远存在|
|系统配置|`/etc/codex/config.toml`|公司管理员或用户手工创建|文件存在时自动加载|
|用户配置|`~/.codex/config.toml`|用户或 Codex 设置界面|每次使用 Codex 都加载|
|Profile|`~/.codex/review.config.toml`|用户手工创建|只有指定 `--profile review` 才加载|
|项目配置|`项目/.codex/config.toml`|项目维护者手工创建|打开受信任项目时自动加载|
|命令临时配置|没有固定文件|当前命令指定|只对当前启动有效|

**`/etc/codex/config.toml` 是什么**

`/etc` 是 Unix/macOS 的系统配置目录。在 macOS 上，`/etc` 实际对应 `/private/etc`。

```
/etc/codex/config.toml
```

主要用于一台电脑上所有用户共享的 Codex 默认配置，例如公司统一要求：

```
approval_policy = "on-request"
sandbox_mode = "workspace-write"
```

它通常由：

- 公司 IT 管理员
- 设备管理系统
- 自己维护多用户电脑的人

创建。个人电脑一般不需要它，Codex 也不会必然生成它。你这台 Mac 当前没有这个文件。

**为什么设计这么多层**

这是为了让不同范围的配置各归其位：

```
系统层：这台电脑上的所有用户
用户层：你自己的所有项目
Profile：某一种临时工作模式
项目层：某个项目独有的配置
命令层：仅当前这一次运行
```

例如：

```
系统要求：必须使用安全沙箱
个人偏好：默认使用 pragmatic 风格
项目要求：这个项目使用特定 MCP
本次运行：临时提高 reasoning effort
```

这些需求不适合全部塞进同一个文件，所以 Codex 才提供分层机制。

**你当前实际的加载过程**

由于其他配置文件都不存在，你现在可以理解成：

```
Codex 内置默认值
    ↓
/Users/heytea/.codex/config.toml
    ↓
当前 App 或 CLI 选择的模型、权限等会话设置
```

目前没有：

- `/etc/codex/config.toml` 系统覆盖
- 项目 `.codex/config.toml` 覆盖
- `review.config.toml` 等 Profile 覆盖

因此你日常只需要关注：

[config.toml](/Users/heytea/.codex/config.toml)

其他配置只有明确需要时再创建。不要为了“配置完整”主动创建 `/etc/codex/config.toml`、Profile 或项目配置。

另外，这些类似文件不会被加载：

```
config.toml.bak
config.toml.backup
随便一个目录/config.toml
review.config.toml    # 没有 --profile review 时
```

Codex 只识别约定位置和明确选中的配置层。官方完整优先级是：

```
当前命令参数
    >
受信任项目的 .codex/config.toml
    >
显式选择的 Profile
    >
/Users/heytea/.codex/config.toml
    >
/etc/codex/config.toml
    >
Codex 内置默认值
```




# Q：内置默认值这是在哪里啊？我都不知道也没见过
# A：
已确认 Role: solve_personal_problem

你没见过“内置默认值”是正常的，因为它通常不是一个可以打开的 `config.toml` 文件。

它是 Codex 程序自身预设的行为，主要存在于：

```
Codex CLI 程序代码/可执行文件
ChatGPT App 内置的 Codex runtime
部分由服务端根据模型和账号能力返回
```

你本机对应的程序入口包括：

```
Codex CLI：
/Users/heytea/.hermes/node/bin/codex

ChatGPT App 内置 Codex：
/Applications/ChatGPT.app/Contents/Resources/codex
```

可以把配置解析过程理解成：

```
程序先准备内置默认值
    ↓
如果存在 /etc/codex/config.toml，则覆盖对应字段
    ↓
如果 ~/.codex/config.toml 配置了字段，再覆盖
    ↓
Profile、项目配置和命令参数继续覆盖
```

例如，假设程序内部默认是：

```
personality = pragmatic
```

而你的 [config.toml](/Users/heytea/.codex/config.toml) 没有配置 `personality`，Codex 就使用程序默认值。

如果你配置：

```
personality = "friendly"
```

则用户配置覆盖内置默认值。

这里的示例是为了说明覆盖逻辑，不代表每个版本的实际默认值固定不变。

**为什么不提供一个默认配置文件**

因为很多默认值不是简单的静态文本：

- 有些取决于操作系统
- 有些取决于当前模型是否支持
- 有些取决于 ChatGPT 账号和工作区权限
- 有些实验功能会随 Codex 版本变化
- 有些由 App 当前模式或服务端能力决定

所以不会存在一个完整且永久准确的：

```
~/.codex/default-config.toml
```

你的 [config.toml](/Users/heytea/.codex/config.toml) 也不需要写全所有配置，只写你希望改变的字段即可。

**怎么知道实际默认值**

主要看两个地方：

1. 官方 [Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference)，这里会标注已公开配置项的类型、含义和默认值。
2. Codex App/CLI 当前解析出的有效配置和实际行为，因为部分设置可能受模型、账号或版本影响。

因此，“内置默认值”不是隐藏在某个你漏看的目录里，而是 Codex 程序在没有其他配置时采用的基础行为。对于日常使用，你只需要维护 [config.toml](/Users/heytea/.codex/config.toml) 中自己明确想覆盖的部分。


# Q：--profile review 时这个一般写在哪里啊
# A：
已确认 Role: solve_personal_problem

`--profile review` 是命令行启动参数，一般直接写在终端命令里，不是写进 `config.toml`。

例如在 Terminal 中运行：

```
codex --profile review
```

它表示：

```
启动 Codex
    +
先读取 ~/.codex/config.toml
    +
再叠加 ~/.codex/review.config.toml
```

执行单次任务时可以写：

```
codex exec --profile review "检查当前代码"
```

对应关系是：

```
--profile review
          │
          └── 加载 /Users/heytea/.codex/review.config.toml
```

前提是这个文件已经存在：

```
/Users/heytea/.codex/review.config.toml
```

例如文件内容：

```
model_reasoning_effort = "xhigh"
approval_policy = "on-request"
```

如果直接运行：

```
codex
```

就不会加载 `review.config.toml`。

当前版本不要这样写进主配置：

```
# 当前版本不再支持这种选择方式
profile = "review"

[profiles.review]
model_reasoning_effort = "xhigh"
```

如果经常使用，可以在 `~/.zshrc` 中定义一个快捷命令：

```
alias codex-review='codex --profile review'
```

以后执行：

```
codex-review
```

效果就等同于：

```
codex --profile review
```

不过这属于可选便利设置，并不是必须的。

ChatGPT/Codex 桌面 App 通常不会自动使用 CLI 的 `--profile review`。Profile 主要用于你从终端启动 Codex CLI；桌面 App 更常通过主 `config.toml`、项目 `.codex/config.toml` 和每个会话的界面选项控制配置。