---
title: "17-Closed model、Open-weight model、Open-source model 的区别"
source: "ai-related/17-top firms/17-Closed model、Open-weight model、Open-source model 的区别.md"
author: "笨笨"
published:
created: 2026-07-07
description: "梳理 Closed model、Open-weight model、Open-source model 三类模型的边界、区别与实际意义。"
tags: ["obsidian-note", "ai", "models", "open-weight", "open-source", "closed-model"]
type: "note"
status: "processed"
---

# 17-Closed model、Open-weight model、Open-source model 的区别

## 摘要

这三个概念在 AI 讨论里最容易混淆，尤其是：
> **Open-weight ≠ Open-source**

一句话概括：
- **Closed model**：权重不公开，只能通过 API / 官方产品使用
- **Open-weight model**：训练好的权重公开，可以下载、本地部署、微调，但不一定完整开源
- **Open-source model**：不仅权重公开，训练代码、配置、数据集、训练流程也尽量公开，别人更有机会复现

## 核心内容

### 1. 先理解什么是 Weights（权重）

一个 LLM 本质上可以理解成：

```text
Architecture（架构） + Weights（权重） = 模型
```

其中：
- **Architecture**：模型长什么样，例如 Transformer、MoE
- **Weights**：模型训练出来的参数，也就是几十亿到几千亿个数字

例如：

```text
Transformer
+
175B Parameters
=
GPT 模型
```

这些 **Parameters（参数）**，本质上就是 **Weights（权重）**。
它们记录了模型在训练过程中“学到的东西”。

### 2. 什么叫 Open-weight model

**Open-weight** 的意思是：
> 官方把训练好的权重文件发布出来。

例如：
- Llama 3
- Qwen
- DeepSeek-R1
- Mistral

这类模型通常会提供：
- `model.safetensors`
- `consolidated.00.pth`
- `gguf`
- 或其他可加载的权重文件

这意味着你可以：
- 下载到自己的服务器
- 本地推理
- 部署 API
- Fine-tune
- 做 LoRA
- 接 RAG
- 接 Agent

而不一定必须依赖官方 API。

#### 一个直观例子

以 **Llama 3 8B** 为例，你可以直接下载权重，然后本地加载：

```python
from transformers import AutoModel
model = AutoModel.from_pretrained("./llama3")
```

模型就能在你自己的机器或服务器上运行。

### 3. 什么叫 Closed model

**Closed model** 指的是：
- 权重不公开
- 架构通常也不完全公开
- 只能通过 API 或官方产品使用

典型例子：
- OpenAI 的 GPT 系列
- Anthropic 的 Claude
- Google 的 Gemini

它们的共同点是：
- 你不能下载完整权重
- 你拿不到类似 `gpt.safetensors` 这样的文件
- 你只能调用接口或使用托管服务

### 4. 什么叫 Open-source model

**Open-source model** 的范围比 Open-weight 更大。

它不只是把权重给你，而是更接近把整套训练与复现所需的关键组件都公开，例如：
- 权重
- 推理代码
- 训练代码
- 配置
- 数据集（或足够完整的数据配方）
- 训练日志 / 训练流程

也就是说：
> **Open-source = 不只是“能跑”，而是尽量让别人也能理解、修改、复现这套模型。**

### 5. Open-weight 和 Open-source 的区别

这是最容易搞混的地方。

| 类型 | 权重 | 推理代码 | 训练代码 | 训练数据 | 本地部署 |
|---|---|---|---|---|---|
| Closed model | ❌ | ❌/部分 | ❌ | ❌ | ❌ |
| Open-weight model | ✅ | 部分或无 | 部分或无 | 部分或无 | ✅ |
| Open-source model | ✅ | ✅ | ✅ | ✅/尽量完整 | ✅ |

换句话说：
- **Open-weight** 主要强调“权重公开”
- **Open-source** 强调“整套系统更完整地公开”

### 6. 一个常见例子：Llama 3

以 **Meta 的 Llama 3** 为例：

官方通常会提供：
- ✅ 权重

但通常不会完整公开：
- ❌ 全量训练数据
- ❌ 完整训练流水线
- ❌ 所有训练细节

所以更准确的说法通常是：
> **Open-weight model**

而不是严格意义上的：
> **Open-source model**

### 7. 一个更接近真正 Open-source 的例子：OLMo

例如 **Allen Institute for AI** 的 **OLMo**：

它公开了更多完整组件：
- ✅ 权重
- ✅ 训练代码
- ✅ 配置
- ✅ 数据集 / 数据说明
- ✅ 训练日志

因此它更接近严格意义上的 **Open-source model**。

### 8. 为什么最近大家越来越爱说 Open-weight

因为现在很多主流模型都处在一个中间态：
- 不是完全闭源
- 也不是完整开源

例如：
- Llama 3
- Qwen
- DeepSeek-R1
- Mistral

它们通常：
- ✅ 可以下载权重
- ✅ 可以本地部署
- ✅ 可以微调
- ❌ 不公开完整训练数据
- ❌ 不公开全部训练流程

所以业内越来越倾向用一个更准确的词：
> **Open-weight models**

### 9. 为什么这件事对我研究 top firms 很重要

如果我在看 top firms，这个分类其实非常关键，因为它直接影响：

#### ① 我能不能自己部署
- Closed model：通常不行，只能走 API
- Open-weight / Open-source：通常可以

#### ② 我能不能自己微调
- Closed model：基本不行
- Open-weight：通常可以做 fine-tune / LoRA
- Open-source：不仅能微调，通常还更方便深改和复现

#### ③ 这家公司更偏哪种生态路线
- **OpenAI / Anthropic / Gemini**：更偏 Closed model 路线
- **Meta / Mistral / Qwen / DeepSeek**：更偏 Open-weight 路线
- **OLMo**：更接近 Open-source 路线

#### ④ 这决定了它对 agent / 企业部署的价值
如果我要做：
- 私有化部署
- 企业内网 agent
- 成本更可控的推理系统
- 自己可调的工作流

那 Open-weight / Open-source 路线通常更重要。

### 10. 一句话总结表

| 类型 | 权重 | 训练代码 | 训练数据 | 本地部署 |
|---|---|---|---|---|
| Closed model | ❌ | ❌ | ❌ | ❌ |
| Open-weight model | ✅ | 部分或无 | 部分或无 | ✅ |
| Open-source model | ✅ | ✅ | ✅/尽量完整 | ✅ |

所以当你在 AI 论文或技术文章里看到 **open-weight model**，通常可以理解为：
> **模型的训练权重已经公开，任何人都可以下载并在自己的机器上运行或微调，但它不一定是完全开源。**

## 可执行动作

- [ ] 后续可单独补一页：为什么 Open-weight 对 agent / 私有化部署特别重要
- [ ] 后续可补一页：Meta、Mistral、Qwen、DeepSeek 的开放策略对比
- [ ] 后续可补一页：Closed model 为什么在产品体验和安全控制上仍然更强

## 相关链接

- [[00-top firms总览]]
- [[11-AI公司对比：模型、Agent、开发者生态、开源、科学AI]]
- [[04-Meta AI]]
- [[07-Mistral]]
- [[08-Cohere]]
- [[14-NVIDIA AI]]
- [[01-01-LLM-总览]]
