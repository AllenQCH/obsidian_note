# Q：我想要知道 chatgpt.app 加载顺序，以及会话管理，memory 等是怎么管理，以及他们是放在放在哪个文件夹中的

# A：Codex App 的加载顺序

## 一、配置优先级从高到低是：

1. 当前启动参数、一次性配置覆盖
2. 受信任项目里的 `.codex/config.toml`，从项目根目录向当前目录加载，越近优先级越高
3. 选中的 Profile，例如 `~/.codex/review.config.toml`
4. 用户配置：[config.toml] (/Users/heytea/.codex/config.toml)
5. 系统配置：`/etc/codex/config.toml`
6. Codex 内置默认值
官方说明：[Configuration precedence](https://learn.chatgpt.com/docs/config-file/config-basic#configuration-precedence)。

## 二、AGENTS.md` 是另一条独立的指令加载链：

1. `$CODEX_HOME/AGENTS.override.md`，存在则使用它
2. 否则读取 `$CODEX_HOME/AGENTS.md`
3. 从 Git/项目根目录一路走到当前工作目录
4. 每层依次检查 `AGENTS.override.md`、`AGENTS.md`、配置的备用文件名
5. 根目录先加载，离当前目录越近的文件越晚加载、优先级越高

官方说明：[Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)。

# 三、another

你当前目录 `/Users/heytea/Documents/chatgpt_study` 不是 Git 仓库，也没有项目级 `AGENTS.md` 或 `.codex/config.toml`。因此磁盘上的主要指令来源是全局 [AGENTS.md](/Users/heytea/.codex/AGENTS.md)，加上你在当前消息里直接提供的指令。

Skills、插件和 MCP 不会把全部内容一次性塞进上下文。Codex 先发现它们的名称和描述，需要使用时再加载详细的 `SKILL.md`、工具定义或资源。


# Q： 从项目根目录向当前目录加载，越近优先级越高；我不理解这是什么意思，优先级高与覆盖关系是什么样的；例如users/heytea/.codex 中有一个 agents.md，然后项目中也有 agents.md，但是他们中写的有冲突，哪个优先级高，最后使用的是哪一个呢？

# A：
已确认 Role: solve_personal_problem

你的理解可以简化为一句话：

> 全局 `AGENTS.md` 是默认规则，项目里的 `AGENTS.md` 是更具体的规则；发生冲突时，项目规则优先。

假设目录如下：

```
/Users/heytea/.codex/AGENTS.md              # 全局规则
/Users/heytea/work/my-project/AGENTS.md     # 项目规则
/Users/heytea/work/my-project/service/AGENTS.md
```

当工作目录是：

```
/Users/heytea/work/my-project/service
```

Codex 按下面顺序组合：

```
1. /Users/heytea/.codex/AGENTS.md
2. /Users/heytea/work/my-project/AGENTS.md
3. /Users/heytea/work/my-project/service/AGENTS.md
```

越晚加载、离当前工作目录越近的文件，优先级越高。

例如：

全局文件：

```
# /Users/heytea/.codex/AGENTS.md

修改代码后运行全部测试。
默认可以直接修改本地文件。
```

项目文件：

```
# /Users/heytea/work/my-project/AGENTS.md

修改代码后只运行相关模块测试。
修改任何文件前必须先确认。
```

最终行为是：

|规则|最终结果|
|---|---|
|运行全部测试 vs 只运行模块测试|使用项目规则：只运行相关模块测试|
|可以直接修改 vs 修改前确认|使用项目规则：修改前确认|
|只有全局文件包含的非冲突规则|继续生效|

也就是说，不是“项目 `AGENTS.md` 完全删除全局规则”，而是：

```
全局规则作为基础
    +
项目规则继续补充
    +
冲突部分由更具体的项目规则覆盖
```

如果还有更深一层：

```
my-project/AGENTS.md
my-project/service/AGENTS.md
my-project/service/payment/AGENTS.md
```

当 Codex 工作在 `payment` 目录时，优先级是：

```
payment/AGENTS.md
    > service/AGENTS.md
    > my-project/AGENTS.md
    > /Users/heytea/.codex/AGENTS.md
```

还有一个特殊规则：同一个目录同时存在下面两个文件时：

```
AGENTS.override.md
AGENTS.md
```

Codex 只读取 `AGENTS.override.md`，该目录下的普通 `AGENTS.md` 不会一起加载。

因此，推荐这样分工：

- `/Users/heytea/.codex/AGENTS.md`：所有项目通用的个人工作习惯
- `项目根目录/AGENTS.md`：该项目独有的技术栈、测试命令和交付规范
- `子目录/AGENTS.md`：特定模块的特殊约束
- `AGENTS.override.md`：需要临时或彻底替换当前目录规则时使用