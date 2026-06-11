---
title: "Agent体系阅读顺序概览"
source: "conversation: Codex chat 2026-06-05"
author: "Codex"
published:
created: 2026-06-05
description: "整理 Obsidian 中 agent 拆分相关笔记的推荐阅读顺序：先看 Xuetao 模板，再看个人 Codex 多 Agent 改造与实操样板。"
tags: ["codex", "agent", "workflow", "reading-list"]
type: "workflow"
status: "processed"
---

# Agent体系阅读顺序概览

## 摘要

这是一篇入口笔记，目标是解决一个具体问题：现在 Obsidian 里 agent 相关笔记已经比较多，应该先看哪一篇、后看哪一篇。

推荐顺序是：

1. 先看 Xuetao 的模板，理解“别人已经跑通的多 agent 系统长什么样”。
2. 再看 Xuetao 的 agent 分层清单，知道每一层有哪些 agent。
3. 再看“四层模型与 Xuetao 扩展层对比”，把两套讲法对齐。
4. 再看你自己的改造计划，理解“哪些思想已经迁移到本机 `~/.codex`”。
5. 再看本地 Multi-Agent Registry，确认当前四层命名和职责边界。
6. 最后看几篇具体样板，理解“真实任务进来后，每个 agent 到底怎么串起来”。
7. 如果你已经理解执行型任务，再补看 investigation 样板，理解“不确定问题先怎么查证据”。
8. 最后再看 skill 与 agent 的包装判断，理解后面该继续扩哪些能力。
9. 如果只是想快速上手当前 active agent，不补理论，直接看 `19-Active Agent实战速查表`。
10. 如果你更关心“用户这句话到底会路由到谁”，再看 `20-Active Agent调用示例词典`。

如果你现在最想解决的是“我还是看不懂这些名字到底怎么工作”，最省脑的读法是：

1. 先看一篇 Xuetao 总结，知道别人完整系统长什么样。
2. 马上看本地 Registry，把你自己的 agent 名字认全。
3. 然后只看 `dbauto` 这个样板，把一条真实链路走通。

也就是最短路径：

```text
01-Xuetao-Agent体系研究总结
-> 08-本地Multi-Agent Registry
-> 19-Active Agent实战速查表
-> 20-Active Agent调用示例词典
-> 05-dbauto导出工作流样板
```

## 核心内容

### 第一阶段：先看 Xuetao 模板

#### 1. [[01-Xuetao-Agent体系研究总结]]

阅读目标：

- 建立整体印象：Xuetao 的体系不是一个大 agent，而是一套分层协作系统。
- 看懂核心结构：`config.toml` 做字典，`router` 做分流，阶段 agent 做流程，operator 做具体工具动作，gate 做放行判断。
- 理解为什么“每个 agent 只做一件事”会更稳定。

建议重点看这些小节：

- `研究对象`
- `这套体系真正的强点`
- `实操案例：按他的真实流程看一遍`
- `再进一步：每一层到底“收什么，吐什么”`
- `把他的体系翻译成你自己的场景`
- `你现在可以怎么判断一个 agent 是不是太重`

读完这篇，你要得到的结论不是“我要照抄 Xuetao 的文件名”，而是：

> 一个可维护的 agent 系统，应该把决策、执行、校验、收口拆开。

### 第二阶段：再看你自己的迁移方案

#### 2. [[01-1-Xuetao-Agent分层清单]]

阅读目标：

- 看 Xuetao 的 `config.toml` 里每个 agent 归到哪一层。
- 理解 `router / planner / selector / operator / implementer / reviewer` 的边界。
- 为你后面给自己的 agent 改命名规则提供参照。

这篇是 `01-Xuetao-Agent体系研究总结` 的清单版补充。

#### 3. [[01-2-四层模型与Xuetao扩展层对比]]

阅读目标：

- 用最直白的方式把“你的四层模型”和“Xuetao 的扩展层”对齐。
- 理解 `selector` 是插在 `stage -> tool` 中间。
- 理解 `implement / integration` 是插在 `tool -> gate` 中间。
- 判断你现在到底需不需要这些扩展层。

#### 4. [[02-个人Codex多Agent改造计划]]

阅读目标：

- 看 Xuetao 的思想迁移到你自己的 `~/.codex` 后，实际分成了哪些层。
- 理解你当前已经落地的目录：`control / stage / gate / operator / docs`。
- 理解为什么 `config.toml` 只做 agent 注册和字典，不应该塞太多流程逻辑。

建议重点看这些小节：

- `目标架构`
- `严格实施规则`
- `当前执行状态`
- `相关链接`

读完这篇，你要能回答三个问题：

- 哪些 agent 属于控制层？
- 哪些 agent 属于阶段层？
- 哪些 agent 属于操作层？

#### 5. [[03-个人.codex目录整理说明与清单]]

阅读目标：

- 看你本机 `.codex` 里现在有哪些目录、备份、模板和配置。
- 理解哪些文件是运行配置，哪些只是归档或历史痕迹。
- 避免后面维护 agent 时不知道文件该放哪里。

这篇可以快速扫，不需要逐字读。

#### 6. [[08-本地Multi-Agent Registry]]

阅读目标：

- 看当前本地 `~/.codex` 的四层 agent 注册表。
- 快速确认每个 agent 属于哪一层、负责什么、不会做什么。
- 把 `config.toml`、agent 文件名和你的理解对齐。

建议重点看这些小节：

- `当前命名规则`
- `每一层的真实例子`
- `最常见的 4 条真实链路`

#### 7. [[19-Active Agent实战速查表]]

阅读目标：

- 不再从理论出发，而是直接按“遇到什么任务，先想到哪个 active agent”来理解。
- 把 dbauto export、dbauto 只读 SQL、Excel 提取、Obsidian 写入、investigation 五类高频入口压成速查表。
- 快速记住哪些 tool agent 只是干活，不代表业务已经完成。

#### 8. [[20-Active Agent调用示例词典]]

阅读目标：

- 直接把“用户怎么说”翻译成 active agent 链。
- 降低后面靠经验猜路由的成本。
- 特别适合复盘时检查自己有没有把 export / SQL / investigation 混掉。

### 第三阶段：看规则拆分案例

#### 9. [[04-Obsidian同步规则拆分说明]]

阅读目标：

- 理解一个原本写在 `AGENTS.md` 里的大规则，怎么拆成 operator + gate。
- 看懂为什么“写 Obsidian”和“同步 GitHub”是两个动作，不应该混在一起。

这篇是从“规则文本”切到“agent 编排”的桥梁。

读完以后，你应该记住：

> operator 只干活，gate 判断能不能继续，closeout 讲清楚到底完成到哪。

### 第四阶段：看你自己的三个实操样板

#### 10. [[05-dbauto导出工作流样板]]

阅读目标：

- 看 `tool_sso_operator` 和 `tool_dbauto_operator` 如何串起来。
- 重点区分 `环境 ready` 和 `导出完成`。

这是最适合作为第一个实操样板的笔记，因为它覆盖了登录前置条件、本地脚本启动、Browser Bridge / opencli 依赖、gate 判断和 closeout 收口。

如果你只选一个实操案例先看，就先看这篇。因为它最完整，也最能看出：

- `tool_*` 不等于任务完成
- `gate_*` 不是工具，而是放行判断
- `stage_integration_orchestrator` 和 `stage_closeout_reporter` 为什么要分开

#### 11. [[06-Obsidian写入与GitHub同步工作流样板]]

阅读目标：

- 看本地文件写入和外部 GitHub 同步如何拆开。
- 重点理解为什么同步前要过 `gate_stage_evaluator(gate_obsidian_sync_ready)`。

这篇适合用来理解本地状态变更、外部状态变更，以及为什么自动 commit/push 需要更谨慎。

#### 12. [[07-Excel提取去重工作流样板]]

阅读目标：

- 看一个纯本地数据处理任务如何拆成 planning、operator、gate、closeout。
- 重点理解为什么不能直接相信用户说的字段名，必须先读表头和样例 JSON。

这篇适合用来理解参数确认、数据提取、去重验证和输出文件验收。

#### 13. [[09-Investigation排查工作流样板]]

阅读目标：

- 看 investigation 任务为什么不能直接当 execution 做。
- 重点理解 `stage_investigation_planner`、`gate_stage_evaluator(gate_investigation_ready)` 和“证据链”到底在做什么。

这篇适合用来理解另外一种很常见的真实任务：

- 现象不对
- 根因还不清楚
- 这时候先查什么、怎么查、什么时候才算证据够了

#### 14. [[10-Skill与Agent包装判断]]

阅读目标：

- 看哪些 skill 现在已经适合包装成 agent。
- 看哪些 skill 现在还不适合直接 agent 化。
- 建立一套以后自己判断“该不该包”的标准。

#### 15. [[11-tool_trace_log_operator候选拆分草案]]

阅读目标：

- 看一个“下一步最值得 agent 化的 skill 候选”应该怎么提前做拆分草案。
- 理解为什么 `trace-log-analysis` 值得做，但现在还不应该草率直接注册进 `config.toml`。

#### 16. [[12-tool_trace_log_operator-Contract草案]]

阅读目标：

- 看 `tool_trace_log_operator` 如果未来真要实现，字段级 contract 应该怎么设计。
- 理解为什么先补 contract 草案，会比直接写 TOML 更稳。

#### 17. [[13-Active与Draft状态矩阵]]

阅读目标：

- 一眼看清当前哪些 agent 已经 active，哪些还只是 draft。
- 建立“是否真正落地，只看 `config.toml`”这个判断习惯。

#### 18. [[14-tool_trace_log_operator-激活门槛清单]]

阅读目标：

- 看一个 draft candidate 到底要满足什么条件，才适合真正写进运行态。
- 理解“有草案”和“可以激活”之间还差哪一层判断。

#### 19. [[21-tool_trace_log_operator-最小执行入口草案]]

阅读目标：

- 看 trace-log draft 在没有稳定脚本入口时，什么样的真实输入才算一次标准化 case。
- 理解为什么“能不能开始记 case”本身也要有门槛，而不是任何排查请求都算。

#### 20. [[15-tool_trace_log_operator-真实案例记录模板]]

阅读目标：

- 看真实 trace 排查案例应该按什么格式沉淀。
- 理解“激活门槛”之后，证据到底该怎么积累。

#### 21. [[22-tool_trace_log_operator-填写样例]]

阅读目标：

- 看一份完整 trace case 实际填出来应该长什么样。
- 下次拿到真实 `traceId` 时，不用从空白开始组织格式。

#### 22. [[23-tool_trace_log_operator-晋升评审表]]

阅读目标：

- 看真实 case 足够后，最后怎么正式评审能不能升 active。
- 理解“激活门槛”和“正式评审”不是同一层动作。

#### 23. [[16-tool_trace_log_operator-专题总览]]

阅读目标：

- 把 `11/12/21/14/15/22/23` 这组 trace 文档串成一条专题阅读线。
- 以后回看时，先用一篇总览定位自己现在该看哪一篇。

#### 24. [[17-当前成果总清单]]

阅读目标：

- 用一篇笔记快速回忆“这轮改造到底已经落地了什么”。
- 不想翻十几篇时，先用这篇快速定位当前状态和下一步动作。

#### 25. [[24-阶段性收口与后续动作]]

阅读目标：

- 用一篇笔记快速判断这轮整理现在是否已经接近自然收口点。
- 理解什么地方已经够了，后面真正该继续推进的是哪一步。

#### 26. [[18-dbauto只读SQL工作流样板]]

阅读目标：

- 看新落地的 `tool_dbauto_sql_operator` 在四层体系里怎么串联。
- 区分 dbauto export runtime 和 dbauto 只读 SQL 两类能力。

### 推荐阅读路径

#### 路径 A：第一次看，先建立直觉

1. [[01-Xuetao-Agent体系研究总结]]
2. [[08-本地Multi-Agent Registry]]
3. [[05-dbauto导出工作流样板]]
4. [[09-Investigation排查工作流样板]]
5. [[10-Skill与Agent包装判断]]
6. [[11-tool_trace_log_operator候选拆分草案]]
7. [[12-tool_trace_log_operator-Contract草案]]
8. [[21-tool_trace_log_operator-最小执行入口草案]]
9. [[13-Active与Draft状态矩阵]]
10. [[26-trace-log真实任务执行卡片]]
10. [[14-tool_trace_log_operator-激活门槛清单]]
11. [[15-tool_trace_log_operator-真实案例记录模板]]
12. [[22-tool_trace_log_operator-填写样例]]
13. [[23-tool_trace_log_operator-晋升评审表]]
14. [[16-tool_trace_log_operator-专题总览]]
15. [[17-当前成果总清单]]
16. [[24-阶段性收口与后续动作]]
17. [[18-dbauto只读SQL工作流样板]]

这条路径最适合你现在这种状态：

- 先知道别人为什么这么拆
- 再知道你自己本地到底有哪些 agent
- 最后用一个真实流程把名字全部串起来

#### 路径 B：想系统理解全部设计

1. [[01-Xuetao-Agent体系研究总结]]
2. [[01-1-Xuetao-Agent分层清单]]
3. [[01-2-四层模型与Xuetao扩展层对比]]
4. [[02-个人Codex多Agent改造计划]]
5. [[08-本地Multi-Agent Registry]]
6. [[05-dbauto导出工作流样板]]
7. [[06-Obsidian写入与GitHub同步工作流样板]]
8. [[07-Excel提取去重工作流样板]]
9. [[09-Investigation排查工作流样板]]
10. [[10-Skill与Agent包装判断]]
11. [[11-tool_trace_log_operator候选拆分草案]]
12. [[12-tool_trace_log_operator-Contract草案]]
13. [[21-tool_trace_log_operator-最小执行入口草案]]
14. [[13-Active与Draft状态矩阵]]
15. [[14-tool_trace_log_operator-激活门槛清单]]
16. [[15-tool_trace_log_operator-真实案例记录模板]]
17. [[22-tool_trace_log_operator-填写样例]]
18. [[23-tool_trace_log_operator-晋升评审表]]
19. [[16-tool_trace_log_operator-专题总览]]
20. [[17-当前成果总清单]]
21. [[24-阶段性收口与后续动作]]
22. [[18-dbauto只读SQL工作流样板]]

如果你今天只想快速看懂整体思想，按这个顺序读：

1. [[01-Xuetao-Agent体系研究总结]]
2. [[01-1-Xuetao-Agent分层清单]]
3. [[01-2-四层模型与Xuetao扩展层对比]]
4. [[02-个人Codex多Agent改造计划]]
5. [[08-本地Multi-Agent Registry]]
6. [[05-dbauto导出工作流样板]]
7. [[09-Investigation排查工作流样板]]

如果你想看“怎么落到自己机器上”，按这个顺序读：

1. [[02-个人Codex多Agent改造计划]]
2. [[03-个人.codex目录整理说明与清单]]
3. [[08-本地Multi-Agent Registry]]
4. [[04-Obsidian同步规则拆分说明]]
5. [[10-Skill与Agent包装判断]]
6. [[11-tool_trace_log_operator候选拆分草案]]
7. [[12-tool_trace_log_operator-Contract草案]]
8. [[21-tool_trace_log_operator-最小执行入口草案]]
9. [[13-Active与Draft状态矩阵]]

如果你想以后自己拆 agent，按这个顺序读：

1. [[01-Xuetao-Agent体系研究总结]]
2. [[01-1-Xuetao-Agent分层清单]]
3. [[01-2-四层模型与Xuetao扩展层对比]]
4. [[08-本地Multi-Agent Registry]]
5. [[05-dbauto导出工作流样板]]
6. [[06-Obsidian写入与GitHub同步工作流样板]]
7. [[07-Excel提取去重工作流样板]]
8. [[09-Investigation排查工作流样板]]
9. [[10-Skill与Agent包装判断]]
10. [[11-tool_trace_log_operator候选拆分草案]]
11. [[12-tool_trace_log_operator-Contract草案]]
12. [[21-tool_trace_log_operator-最小执行入口草案]]
13. [[13-Active与Draft状态矩阵]]
14. [[26-trace-log真实任务执行卡片]]

## 可执行动作

1. 后续新增 agent 相关笔记时，优先把入口链接补到这篇概览。
2. 如果某篇笔记变成核心必读，把它放到“推荐阅读路径”里，而不是只放在相关链接。
3. 如果后面整理为编号目录，可以把这篇作为 `00-索引` 或 `00-阅读路线`。

## 相关链接

- [[01-Xuetao-Agent体系研究总结]]
- [[01-1-Xuetao-Agent分层清单]]
- [[01-2-四层模型与Xuetao扩展层对比]]
- [[02-个人Codex多Agent改造计划]]
- [[08-本地Multi-Agent Registry]]
- [[05-dbauto导出工作流样板]]
- [[06-Obsidian写入与GitHub同步工作流样板]]
- [[07-Excel提取去重工作流样板]]
- [[09-Investigation排查工作流样板]]
- [[10-Skill与Agent包装判断]]
- [[11-tool_trace_log_operator候选拆分草案]]
- [[12-tool_trace_log_operator-Contract草案]]
- [[21-tool_trace_log_operator-最小执行入口草案]]
- [[13-Active与Draft状态矩阵]]
- [[14-tool_trace_log_operator-激活门槛清单]]
- [[15-tool_trace_log_operator-真实案例记录模板]]
- [[22-tool_trace_log_operator-填写样例]]
- [[23-tool_trace_log_operator-晋升评审表]]
- [[26-trace-log真实任务执行卡片]]
- [[16-tool_trace_log_operator-专题总览]]
- [[17-当前成果总清单]]
- [[24-阶段性收口与后续动作]]
- [[18-dbauto只读SQL工作流样板]]
