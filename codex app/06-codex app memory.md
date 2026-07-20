**本地 Memory 怎么运行**

你当前已经启用：

```
[features]
memories = true

[memories]
generate_memories = true
use_memories = true
```

大致流程是：

```
历史会话空闲
  -> 筛选符合条件的会话
  -> 提取摘要和可复用事实
  -> 后台归并 Memory
  -> 新会话检索相关 Memory
  -> 选择性注入当前上下文
```

短会话、仍在活跃的会话可能被跳过，生成也不是关闭会话后立即发生。Memory 是“辅助回忆层”，不能替代必须稳定生效的 `AGENTS.md`。

主要文件：

- [memory_summary.md](/Users/heytea/.codex/memories/memory_summary.md)：高度浓缩的用户偏好和近期主题
- [MEMORY.md](/Users/heytea/.codex/memories/MEMORY.md)：可搜索的 Memory 注册表
- [rollout_summaries](/Users/heytea/.codex/memories/rollout_summaries)：每次历史任务的提炼摘要和证据指针
- [raw_memories.md](/Users/heytea/.codex/memories/raw_memories.md)：较原始的提取结果
- [memories_1.sqlite](/Users/heytea/.codex/memories_1.sqlite)：后台提取、整理任务和阶段结果

可以在 ChatGPT App 中用 `/memories` 控制当前 Chat 是否读取 Memory、是否用于生成未来 Memory；全局开关位于 `Settings > Personalization`。官方说明：[Codex Memories](https://learn.chatgpt.com/docs/customization/memories)。