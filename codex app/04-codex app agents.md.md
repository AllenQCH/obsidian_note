# Q：每层依次检查 AGENTS.override.md、AGENTS.md、配置的备用文件名;当这三个同时存在的时候，会怎么读取呢，备用文件名长什么样，是什么时候产生和使用的
# A：
已确认 Role: solve_personal_problem

核心规则是：

> 在每一个目录里按顺序查找，找到第一个非空文件后停止；同一目录不会把它们全部读取。

**同一目录的选择顺序**

假设某个项目目录同时存在：

```
AGENTS.override.md
AGENTS.md
TEAM_GUIDE.md
.agents.md
```

并且配置了：

```
project_doc_fallback_filenames = ["TEAM_GUIDE.md", ".agents.md"]
```

Codex 在这个目录中的查找过程是：

```
1. AGENTS.override.md   找到，读取并停止
2. AGENTS.md            不读取
3. TEAM_GUIDE.md        不读取
4. .agents.md           不读取
```

完整规则：

|存在情况|最终读取|
|---|---|
|`AGENTS.override.md` 存在且非空|只读取 `AGENTS.override.md`|
|override 不存在，`AGENTS.md` 存在|只读取 `AGENTS.md`|
|前两个都不存在|按备用文件名列表顺序查找|
|第一个备用文件存在|读取该备用文件，然后停止|
|文件存在但内容为空|跳过，继续查找下一个|

**Override 只替换同一目录的文件**

假设目录结构是：

```
my-project/
├── AGENTS.md
└── service/
    ├── AGENTS.md
    └── AGENTS.override.md
```

Codex 在 `service` 中工作时，读取：

```
my-project/AGENTS.md
service/AGENTS.override.md
```

不会读取：

```
service/AGENTS.md
```

也就是说，`service/AGENTS.override.md` 只替换同目录的 `service/AGENTS.md`，不会让项目根目录的 `my-project/AGENTS.md` 消失。

最终依然是：

```
项目根目录规则作为基础
    +
service/AGENTS.override.md 作为更具体的规则
```

冲突时，后加载的 `service/AGENTS.override.md` 优先。

**备用文件名是什么**

备用文件名不是 Codex 自动生成的，也没有默认固定名称。它是用户在 [config.toml](/Users/heytea/.codex/config.toml) 中自行配置的兼容文件名。

例如：

```
project_doc_fallback_filenames = [
  "TEAM_GUIDE.md",
  ".agents.md",
  "CODEX_INSTRUCTIONS.md"
]
```

配置后，每个项目目录的查找顺序变成：

```
AGENTS.override.md
    ↓
AGENTS.md
    ↓
TEAM_GUIDE.md
    ↓
.agents.md
    ↓
CODEX_INSTRUCTIONS.md
```

列表顺序也代表优先级。

**什么时候需要备用文件名**

主要用于已有项目已经有自己的规范文件，不方便改名的场景：

```
TEAM_GUIDE.md
CONTRIBUTING_AI.md
CODEX_INSTRUCTIONS.md
```

例如一个公司所有项目原来都使用 `TEAM_GUIDE.md`，就可以配置：

```
project_doc_fallback_filenames = ["TEAM_GUIDE.md"]
```

这样不需要给每个项目重新创建 `AGENTS.md`。

不建议随便把 `README.md` 或 `CONTRIBUTING.md` 加进去，因为这些文件通常内容很大，也不一定都是给 Codex 的指令。

**你当前机器的实际状态**

你的 [config.toml](/Users/heytea/.codex/config.toml) 没有配置 `project_doc_fallback_filenames`，所以目前不存在备用文件名机制。

全局目录当前是：

```
不存在：/Users/heytea/.codex/AGENTS.override.md
存在：  /Users/heytea/.codex/AGENTS.md
```

因此现在全局实际读取的是：

[AGENTS.md](/Users/heytea/.codex/AGENTS.md)

另外，备用文件名主要用于项目目录发现；全局 $CODEX_HOME 层仍然使用 `AGENTS.override.md` 或 `AGENTS.md`。


