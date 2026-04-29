ReAct 是一种经典 agent 模式，来自论文 _ReAct: Synergizing Reasoning and Acting in Language Models_。它的核心是：

**思考一点 → 做一个动作 → 观察结果 → 再思考 → 再做动作**

也就是你常见的：

- Thought
- Action
- Observation

循环往复。原论文就是把 reasoning 和 acting 交织起来。

它和框架的关系是：

- 可以用 **LangChain** 实现
- 可以用 **LangGraph** 实现
- 也可以在 **Harness** 这种平台里作为某个 agent 的内部决策模式来实现

所以 **ReAct 不是 LangChain 专属，也不是 LangGraph 专属**。  
它是“模式”，框架只是“载体”。


像一个边走边看的执行者：

- 看到一步，想一步
- 每一步都可能重新判断
- 适合开放环境、探索式任务
- 缺点是容易绕、容易多调用、长任务容易漂