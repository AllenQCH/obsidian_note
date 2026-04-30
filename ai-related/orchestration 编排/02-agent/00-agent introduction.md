> Agent 之所以能做 dynamic orchestration，  
是因为它把“流程控制权”从代码转移给了 LLM（或策略模型）在运行时做决策

# 先看传统（静态 orchestration 是怎么做的）
> Workflow = 一个“编译时写死流程”的执行器

你现在系统：
A → B → C → D
代码里其实是：
stepA();  
if (condition1) { stepB();  
} else {  stepC();  }  
stepD();
👉 特点：流程写死；分支写死；调哪个接口写死
# dynamic orchestration 到底“动态”在哪
> Agent = 一个“运行时生成流程”的执行器；

Agent 把这三件事变成运行时决定：
1. 下一步做什么  
2. 调哪个 tool  
3. 要不要继续 / 结束
也就是：
控制流（control flow）不再写死在代码里  ；而是由模型每一步生成

A → (LLM决定) → B or C or D
甚至：
A → B → A → C → D
流程在运行时才确定。
## 核心机制（本质就 4 个组件）
Agent 能实现 dynamic orchestration，本质靠这 4 个东西：
### ① State（当前上下文）
当前任务信息 + 历史步骤 + 中间结果
例如你发票场景：
- 当前收货单列表  
- 缺失物料编码  
- 已补齐的税收编码  
- 已执行步骤
### ② Tool（可执行能力）
Agent 能调用的“动作集合”
例如：
query_problem_orders  
extract_material_codes  
generate_sql  
execute_sql  
retry_task
### ③ Policy（决策能力 = LLM）
这是核心。
每一步都会问 LLM：
基于当前 state，  
下一步应该做什么？
### ④ Loop（循环执行）
这是 dynamic orchestration 的“发动机”：
while (not finished) {  
    决策下一步  
    执行  
    更新 state  
}
# 最核心流程
## 标准 Agent Loop（ReAct 简化版）
1. 看（state）  
2. 想（LLM）  
3. 做（tool）  
4. 观察结果（更新 state）  
5. 循环
## 对应代码伪实现（关键）
while (!context.isFinished()) {  
    // 1. 把当前状态喂给 LLM  
    String prompt = buildPrompt(context);  
    // 2. LLM 决定下一步  
    Action action = llm.decide(prompt);  
    // 例如：  
    // { "tool": "generate_sql", "params": {...} }  
    // 3. 执行 tool  
    ToolResult result = toolGateway.call(action);  
    // 4. 更新状态  
    context.update(result);  
    // 5. 判断是否结束  
}
👉 这段代码就是 dynamic orchestration 的核心。

# 用你发票修复流程举例（非常关键）
## 静态版本（你现在）
查单据  
→ 找物料  
→ 找税收编码  
→ 生成SQL  
→ 执行
## Agent 版本（动态）
Step1：查问题单据  
LLM 决定：  
→ 是否需要过滤数据？  
Step2：提取物料编码  
LLM 决定：  
→ 是否缺少映射？  
→ 是否需要人工？  
Step3：  
→ 如果缺 → 生成“待补齐清单”  
→ 如果齐 → 继续  
Step4：生成 SQL  
LLM 决定：  
→ 是否批量？  
→ 是否拆分？  
Step5：  
→ 是否需要审批？  
→ 是否可以执行？  
Step6：  
→ 执行 / 等待
👉 每一步路径都不是写死的。
# 七、关键：Agent 并不是“乱跑”
很多人误解：
> dynamic orchestration = 没规则
其实不是。
## 实际是三层控制
1. Scope（能做什么）  
2. Tool（有哪些能力）  
3. Prompt（如何决策）
## 举例（你场景）
Scope：  
不能直接执行 SQL  
Tool：  
generate_sql / validate_sql / request_approval  
  LLM：  
只能在这些范围内选择
👉 所以：
动态 ≠ 无限制
# 八、为什么 LLM 能做“流程控制”
因为它具备：
## 1）理解能力
当前状态是什么
## 2）推理能力
下一步应该做什么
## 3）规划能力
整体目标如何完成
👉 所以它可以替代：
if / else / switch / 状态机
的一部分逻辑。
# 九、ReAct vs Plan-and-Execute（对应两种 dynamic orchestration）
## ReAct（边走边决定）
想 → 做 → 看 → 再想
适合：
- 你这种问题修复流程
- 不确定情况多
## Plan-and-Execute（先规划）
先生成：  Step1 → Step2 → Step3  ；再执行
适合：长任务；可预先规划

### dynamic orchestration 的本质不是“更复杂的流程”，  
而是“流程不再由程序员写死，而是由系统在运行时生成”
# 最后一句总结

Agent 之所以能实现 dynamic orchestration，  
是因为它把“下一步做什么”这个控制权交给了 LLM，  
并通过循环（loop）不断在运行时生成流程。





Agent（总概念）
├── 执行模式
│   ├── ReAct
│   ├── Plan-and-Execute
│   ├── ReWOO
│   └── LLMCompiler 等
│
├── 实现框架
│   ├── LangChain（偏上层）
│   └── LangGraph（偏底层编排、状态、长任务）
│
└── 企业落地平台
    └── Harness（pipeline、治理、安全、观测、执行环境）