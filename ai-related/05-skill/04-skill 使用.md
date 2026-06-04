
# 是这样的，我设定项目 A文件夹、项目 文件夹B、codex 或者 claude 的根目录中都有大量 skill；如果在根目录启动 codex 或者 Claude；能看到哪些skill；如果在项目 A 启动，能看到哪些；如果在项目 B 启动，能看到哪些；帮忙解释并给出原因
先说结论：

|启动位置|能看到的 Skill|
|---|---|
|根目录启动|全局 Skill|
|项目A启动|全局 Skill + 项目A Skill|
|项目B启动|全局 Skill + 项目B Skill|

---

假设目录结构：

```text
~/
├── .codex/
│   └── skills/
│       ├── java-review
│       ├── sql-optimize
│       └── git-commit
│
├── project-a/
│   └── .codex/
│       └── skills/
│           ├── deploy-a
│           └── invoice-flow
│
└── project-b/
    └── .codex/
        └── skills/
            ├── deploy-b
            └── lowcost-flow
```

---

# 场景1：在根目录启动

```bash
cd ~
codex
```

当前目录：

```text
~
```

Agent向上查找：

```text
~
↑
/
```

没发现：

```text
./.codex/skills
```

所以只能加载：

```text
~/.codex/skills
```

结果：

```text
√ java-review
√ sql-optimize
√ git-commit

× deploy-a
× deploy-b
× invoice-flow
× lowcost-flow
```

---

# 场景2：在项目A启动

```bash
cd ~/project-a
codex
```

当前目录：

```text
~/project-a
```

发现：

```text
~/project-a/.codex/skills
```

同时还有：

```text
~/.codex/skills
```

结果：

```text
√ java-review
√ sql-optimize
√ git-commit

√ deploy-a
√ invoice-flow

× deploy-b
× lowcost-flow
```

---

# 场景3：在项目B启动

```bash
cd ~/project-b
codex
```

结果：

```text
√ java-review
√ sql-optimize
√ git-commit

√ deploy-b
√ lowcost-flow

× deploy-a
× invoice-flow
```

---

# 为什么这么设计

假设没有项目级 Skill。

你做发票系统：

```text
发布蓝票
```

Agent可能会匹配到：

```text
deploy-b
```

因为全局就这一份。

明显错误。

---

有项目 Skill 后：

项目A：

```text
发票系统
```

自动加载：

```text
invoice-flow
```

项目B：

```text
低值易耗
```

自动加载：

```text
lowcost-flow
```

不会串。

---

# Agent 内部一般怎么找

很多 Agent 都类似：

```text
当前目录
↓
找 .codex
↓
找 skills
↓
加载索引
↓
再加载全局 skills
↓
合并
```

类似 Python：

```python
import
```

会查：

```text
当前目录
↓
site-packages
```

Skill 也是类似的搜索路径思想。

---

对于你公司场景，我会这样分：

全局：

```text
~/.codex/skills

java-review
sql-review
git-commit
architecture-review
java-coding-standard
```

项目A：

```text
project-a/.codex/skills

invoice-flow
invoice-release
invoice-troubleshoot
```

项目B：

```text
project-b/.codex/skills

lowcost-flow
monthly-job
store-cache
```

这样无论你打开哪个项目，Agent 都能拿到：

```text
通用能力
+
项目专属能力
```

而不会把所有业务 Skill 混在一起。





# 其实是这样的，因为有很多 skill 其实平时根本用不上，而且我现在本地有非常多的 skill；然后我该如何让这些闲置的 skill 平时省点 token 呢；这有什么方案么


你的担心是对的。

如果你本地有：

```text
100 个 Skill
每个 Skill 500 行
```

全部塞进 Context：

```text
100 × 500 行
```

几万甚至几十万 Token，根本不现实。

所以现代 Agent 基本都采用：

```text
Skill 索引
↓
检索
↓
命中
↓
加载
```

而不是：

```text
全部加载
```

---

# 方案1：按需加载（推荐）

目录：

```text
skills/
├── deploy
│   └── SKILL.md
├── invoice
│   └── SKILL.md
├── sql
│   └── SKILL.md
```

每个 Skill 顶部写：

```markdown
---
name: invoice
description: 发票相关业务处理
keywords:
  - 发票
  - 蓝票
  - 红票
  - 税率
---
```

用户说：

```text
处理蓝票异常
```

Agent：

```text
检索 description
↓
命中 invoice
↓
只加载 invoice
```

最终：

```text
token ≈ 1 个 skill
```

而不是：

```text
token ≈ 100 个 skill
```

---

# 方案2：Skill 分级

不要把所有东西都放 Skill。

例如：

```text
skills/
```

只放：

```text
发版
数据库变更
故障处理
代码评审
```

这些高价值流程。

---

不要放：

```text
git pull
git status
查看日志
```

这种一句话能说清的东西。

---

# 方案3：大 Skill 拆小 Skill

不要：

```text
company-workflow
```

5000 行。

拆：

```text
invoice-release
invoice-debug
invoice-sql
invoice-api
```

这样：

```text
处理发票SQL
```

只加载：

```text
invoice-sql
```

---

# 方案4：归档冷 Skill

例如：

```text
skills/
archive/
```

```text
skills/
├── active/
└── archive/
```

平时：

```text
active
```

参与检索。

归档：

```text
archive
```

不参与检索。

---

# 方案5：建立 Skill Registry（推荐你这样做）

例如：

```text
skills/
├── registry.md
├── deploy/
├── invoice/
├── lowcost/
├── scheduler/
```

registry 只写：

```markdown
invoice
- 发票相关

lowcost
- 低值易耗

scheduler
- 多时区任务
```

Agent 先读：

```text
registry
```

几十 Token。

确定需要：

```text
scheduler
```

再读：

```text
scheduler/SKILL.md
```

这样最省。

---

对于你目前的情况（Java后端 + Agent学习）：

建议控制在：

```text
全局 Skill
10~20 个

项目 Skill
5~10 个
```

超过：

```text
50+
```

就应该开始做：

```text
索引
+
按需加载
+
归档
```

否则后面你会发现 Agent 经常匹配错 Skill，而且检索速度也会下降。