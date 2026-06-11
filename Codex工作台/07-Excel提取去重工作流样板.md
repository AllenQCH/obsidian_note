---
title: "Excel提取去重工作流样板"
source: "conversation: Codex chat 2026-06-05"
author: "Codex"
published:
created: 2026-06-05
description: "用 Excel 中 JSON 字段提取 goodsCode 和 goodsName 的例子，说明 tool_excel_operator 如何配合 stage、gate 和 closeout。"
tags: ["codex", "agent", "workflow", "excel", "json"]
type: "workflow"
status: "processed"
---

# Excel提取去重工作流样板

## 摘要

这篇笔记用最开始那个 Excel 任务做样板：

```text
从 Excel 的 shot_json 中提取 goodsCode 和 goodsName，去重后生成新文档。
```

这类任务特别适合拆成 agent 流程，因为它不是简单“跑一个脚本”：

- 先要确认文件能不能读
- 再确认真实表头
- 再确认 JSON 字段和嵌套路径
- 再提取字段
- 再去重
- 最后验证输出文件和行数

如果这些都塞进一个大 agent，最容易出现的问题是：它直接相信用户说的字段名，然后没有验证就输出文件。

## 核心内容

### 用户入口

用户说：

```text
我的文档 /Users/heytea/Downloads/export_20260525_151155.xlsx 里面的 shot_json 中的 goodsCode 和 goodsName 帮忙拿出来，去重，并生成新文档
```

### 推荐链路

```text
control_request_router
-> stage_task_planner
-> control_stage_orchestrator(stage=execution)
-> stage_execution_runner
-> tool_excel_operator
-> gate_stage_evaluator(gate_execution_ready)
-> gate_stage_evaluator(gate_closeout_ready)
-> stage_closeout_reporter
```

### 这条链每一步到底干什么

#### 1. `control_request_router`

它先判断任务类型。

它看到的是：

- 输入是一个 `.xlsx`
- 用户提到了 JSON 字段 `shot_json`
- 用户要提取 `goodsCode`、`goodsName`
- 用户要去重并生成新文档

它输出的应该是：

- `task_type = excel_json_extraction`
- `primary_operator = tool_excel_operator`
- `requested_fields = [goodsCode, goodsName]`
- `dedupe_required = true`

它不应该直接假设表头一定叫 `shot_json`。

#### 2. `stage_task_planner`

它负责把任务变成可执行参数。

它要先做这些确认：

1. 文件路径是否存在
2. 当前终端是否能读取 `Downloads` 文件
3. 工作表有哪些表头
4. 用户说的 `shot_json` 是否真的是实际表头
5. JSON 里面的记录是在根对象里，还是嵌套列表里
6. 去重字段是不是 `goodsCode + goodsName`
7. 输出文件路径是什么

这里最关键的是：

> `records-path` 不能猜，必须看样例 JSON 后再定。

#### 3. `control_stage_orchestrator`

它把阶段推进到 `execution`，并指定这一步只需要 `tool_excel_operator`。

它不应该读取 Excel，也不应该拼脚本命令。

#### 4. `stage_execution_runner`

它负责执行顺序和结果收集。

它要确保：

- 先有可执行参数
- 再运行 `tool_excel_operator`
- 再把提取行数、去重行数、无效 JSON 行数交给 gate 和 closeout

它自己不解析 Excel。

#### 5. `tool_excel_operator`

它是真正干活的 operator。

当前真实入口是：

```bash
python3 ~/.codex/skills/excel-json-analysis/scripts/extract_json_fields_from_excel.py \
  --input /Users/heytea/Downloads/export_20260525_151155.xlsx \
  --json-column shot_json \
  --records-path '<确认后的JSON列表路径>' \
  --fields goodsCode goodsName \
  --dedupe-fields goodsCode goodsName \
  --output /Users/heytea/Downloads/export_20260525_151155_goods_dedup.xlsx
```

它输出的结果不应该只有“文件生成了”，还应该包含：

- 使用的是哪个 sheet
- 实际 JSON 列名是什么
- 使用的 `records-path` 是什么
- 原始提取多少行
- 去重后多少行
- 无效 JSON 多少行
- 输出文件路径

如果 `Downloads` 权限读不了，它应该换一个可读副本继续，而不是停在“没权限”。

#### 6. `gate_stage_evaluator`

这里会用两个 gate。

执行前用：

```text
gate_stage_evaluator(gate_execution_ready)
```

它判断：

- 文件可读吗
- JSON 列确认了吗
- 字段确认了吗
- 输出路径明确吗

执行后用：

```text
gate_stage_evaluator(gate_closeout_ready)
```

它判断：

- 输出文件存在吗
- 去重结果能复核吗
- 是否有无效 JSON 或缺字段风险

典型结果有三种。

`go`：

- 文件可读
- 字段和路径确认
- 输出文件存在
- 去重检查通过

`warn`：

- 输出文件存在
- 但有少量无效 JSON 或缺字段，需要告知用户

`block`：

- 文件读不了
- JSON 列不存在
- `records-path` 错了
- 输出文件没有生成

#### 7. `stage_closeout_reporter`

最后要用用户能看懂的方式收口。

好的收口应该像这样：

```text
已生成去重后的商品清单：
/Users/heytea/Downloads/export_20260525_151155_goods_dedup.xlsx

提取行数：128
去重后：43
无效 JSON：0
去重字段：goodsCode + goodsName
```

它不能只说：

```text
已完成。
```

因为用户真正需要知道的是输出在哪里，以及提取过程有没有损耗。

### 为什么要这么拆

这条流程最容易犯的错有三个。

第一，直接相信用户说的列名。

用户说 `shot_json` 只是线索，真正准的是 Excel 表头。

第二，直接猜 JSON 嵌套路径。

如果字段在列表里，必须指定列表路径；如果路径错了，输出可能为空。

第三，只验证文件存在，不验证去重结果。

文件存在只能说明写入动作发生过，不代表提取逻辑正确。

拆成 agent 后：

- `stage_task_planner` 负责防止参数猜测
- `tool_excel_operator` 负责确定性提取
- `gate_stage_evaluator` 负责阻塞错误输出
- `stage_closeout_reporter` 负责把行数和风险讲清楚

## 可执行动作

1. 后续所有 Excel JSON 提取任务，都先读表头和样例 JSON，再运行脚本。
2. 输出文件必须使用明确路径，避免覆盖原始文件。
3. closeout 必须带行数、去重数、无效 JSON 数和输出路径。

## 相关链接

- [[02-个人Codex多Agent改造计划]]
- [[05-dbauto导出工作流样板]]
- [[06-Obsidian写入与GitHub同步工作流样板]]
- [[Skill目录与维护规范]]
