---
title: "trace日志最小执行入口"
source: "conversation: Codex chat 2026-06-07"
author: "Codex"
published:
created: 2026-06-07
description: "把 trace-log draft 从纯概念草案推进到可验证草案：先定义什么样的输入才算一次标准化的真实调查入口。"
tags: ["codex", "agent", "trace", "investigation", "draft"]
type: "workflow"
status: "processed"
---

# trace日志最小执行入口

## 摘要

这篇笔记解决的是 trace-log 这条线里一个很关键、但之前还没有单独讲清楚的问题：

> 既然 `tool_trace_log_operator` 现在还没有稳定脚本入口，那什么样的真实任务，才算一次“可以拿来积累晋升证据”的标准化调查入口？

这篇的作用不是把它提前说成 active。

恰恰相反，它是为了把边界收紧：

- 现在还不能激活
- 但已经可以开始按统一格式积累真实案例

## 核心内容

### 当前最重要的事实

`trace-log-analysis` 现在和这些已经 active 的 `tool_*` 不一样：

- 它没有像 `sso-login` 那样的稳定脚本入口
- 也没有像 `excel-json-analysis` 那样的固定执行器
- 它现在更像“分析方法 skill”

所以当前最合理的推进方式不是：

```text
先注册进 config.toml 再说
```

而是：

```text
先定义一次标准化调查入口长什么样
-> 再按这个格式记录真实 case
-> 再判断能不能激活
```

### 什么样的输入才算一次有效入口

一条真实 trace 调查想算“有效 draft 执行尝试”，至少要明确这些字段：

#### 必选

- `trace_id`
- `source_type`
  - `raw_text`
  - `export_file`
  - `platform_copy`
- 至少一类真正证据体：
  - `raw_logs`
  - `platform_results`
  - `export_file_path`

#### 强烈建议补齐

- `env`
- `time_range`
- `service_hint`
- `action_hint`

### 哪些输入不能算

下面这些情况，不应该算作可积累晋升证据的标准 case：

- 只有截图，没有机器可读文本
- 只有一句“帮我看看为什么报错”，没有 `traceId` 也没有原始日志
- 多个无关请求混在一起，没有唯一锚点
- 只有拍脑袋猜测哪个服务有问题，没有日志证据

也就是说：

> 不是所有“排查请求”都能直接算 trace-log operator 的有效验证样本。

### 推荐归一化输入形状

后面如果真有 trace 调查任务，建议先统一整理成这样：

```json
{
  "trace_id": "abc123",
  "env": "intl",
  "time_range": "2026-06-07 10:00-10:10",
  "service_hint": "order-service",
  "action_hint": "submit-order",
  "source_type": "platform_copy",
  "raw_logs": "",
  "platform_results": "...",
  "export_file_path": ""
}
```

这个动作很重要，因为它会把“临场自由发挥”收敛成“后面能复盘、能比较”的标准入口。

### 三种 source_type 怎么理解

#### `raw_text`

适合：

- 用户直接贴原始日志文本

这是最好的情况，因为：

- 时间顺序最容易保住
- 关键证据最容易引用

#### `export_file`

适合：

- 用户给了本地导出的日志文件

这里至少要满足：

- 文件路径明确
- 文件对应的是一个 trace 或一个很小的请求窗口

#### `platform_copy`

适合：

- 用户从浏览器日志平台复制结果

最低要求是：

- 复制结果里还能保住时间戳和服务边界

### 什么才能算一次真正的 draft 执行尝试

一条 case 只有同时满足下面 4 条，才算一次有效尝试：

1. 输入已经归一化
2. 时间线已经成功重建，或者明确说明为什么无法重建
3. 第一异常点已经找到，或者明确说明为什么找不到
4. 最后能判断这次结果对 gate 来说是 `go / warn / block`

少任何一条，都只能算“有价值上下文”，不能算正式晋升证据。

### 这篇和另外两篇怎么配合

最实用的配合方式是：

- [[trace日志agent什么时候能启用]]
  - 定义什么时候可以升 active
- [[trace日志真实案例模板]]
  - 定义一次真实 case 怎么记录
- 本篇
  - 定义什么样的输入才配叫“一次标准化 case”

也就是：

> 本篇负责“能不能开始”，模板负责“怎么记录”，门槛清单负责“能不能晋升”。

## 可执行动作

1. 下一次真实 traceId 排查任务出现时，先按这篇补齐输入入口，不要直接临场分析。
2. 只有满足本篇的最小入口条件，再去填 [[trace日志真实案例模板]]。
3. 后面积累到 3 个以上标准化 case 后，再回看 [[trace日志agent什么时候能启用]] 判断是否能升 active。

## 相关链接

- [[trace日志agent怎么拆]]
- [[trace日志agent输入输出约定]]
- [[trace日志agent什么时候能启用]]
- [[trace日志真实案例模板]]
- [[trace日志agent是做什么的]]
