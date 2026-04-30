# 1、什么是openspec
**OpenSpec** 是一套用于“规范驱动开发”的工具与方法论，目标是把**需求 → 设计 → 实现 → Agent执行**串成一条可自动化的链路。
核心思想：
- 用**结构化 spec（规范文件）**替代零散文档
- 让 **LLM / Agent 按 spec 执行，而不是自由发挥**
- 支持多人协作 + 可追溯 + 可复用

# 2、OpenSpec 的核心结构
初始化项目后通常会生成：
```text
.openspec/  
  ├── config.yaml        # 全局配置  
  ├── project.md         # 项目级说明  
  ├── AGENTS.md          # Agent能力声明  
  ├── specs/             # 所有规范文件  
  │    ├── xxx.md  
  │    ├── yyy.md
```
### 1️⃣ `config.yaml`
控制行为策略，例如：
- 默认 Agent
- 使用哪些模型
- 执行策略（严格/宽松）
### 2️⃣ `project.md`
描述：
- 项目背景
- 技术栈
- 约束（比如你常见的 Java + 微服务）
### 3️⃣ `AGENTS.md`
定义：
- 有哪些 Agent
- 每个 Agent 的职责
- 能使用哪些 tools / skills
示例：
## main-agent  
负责整体流程编排    
## sql-agent  
负责生成 SQL 和数据库操作
### 4️⃣ `specs/*.md`
这是 **核心**
一个 spec 通常包含：
# 功能名称  

## 背景  
为什么做    
## 输入  
输入数据结构  
## 输出  
输出结果  
## 约束  
必须遵守的规则  
## 执行步骤  
1. 查询数据库  
2. 处理数据  
3. 生成SQL  
## 验证  
如何判断正确
👉 本质：**把 prompt 固化成结构化 DSL**

## 、OpenSpec 的使用流程（重点）

### Step 1：初始化

openspec init

生成 `.openspec` 目录

---

### Step 2：创建 spec

/opsx:new

或手动写：

.openspec/specs/fix_invoice_issue.md

---

### Step 3：执行 spec

/opsx:apply fix_invoice_issue

执行过程：

用户命令  
   ↓  
读取 spec  
   ↓  
加载 AGENTS.md  
   ↓  
选择 agent  
   ↓  
执行 spec 步骤  
   ↓  
调用 skill / tool  
   ↓  
输出结果

## 四、Agent + OpenSpec 的执行机制（核心理解）

你之前问的关键点，这里给你讲清楚：

### 1️⃣ spec ≠ prompt

- prompt：一次性文本
- spec：**结构化执行计划**

👉 spec 更像：

Plan + Constraint + Contract

---

### 2️⃣ Agent 如何执行 spec

流程本质是：

spec → 转换为上下文 → LLM推理 → 决策下一步

关键点：

- Agent **不会逐行死执行**
- 而是：
    - 读取 spec
    - 结合上下文
    - 动态决策

👉 这就是你之前困惑的：

> “为什么会跳步骤？”

因为：  
👉 **执行者是 LLM，不是状态机**

---

### 3️⃣ 如果你想“强约束执行”

需要：

- 明确步骤依赖
- 写“必须执行”
- 或结合 **skill state**

例如：

## 执行步骤（必须按顺序执行）