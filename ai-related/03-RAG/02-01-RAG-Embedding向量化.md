---
title: "02-03-RAG-Embedding向量化"
source: "整理自 ai-related/02-LLM/RAG 原始长文归档.md"
author: "Allen"
published:
created: 2026-05-14
description: "Embedding 的含义、RAG 中的用法和主要限制。"
tags: ["obsidian-note", "tech-note", "rag", "embedding", "retrieval"]
type: "tech-note"
status: "processed"
aliases: ["Embedding 向量化"]
---

# 02-03-RAG-Embedding向量化

## 摘要

- Embedding 是把文本、代码或图片等内容转成向量，让机器可以比较“语义距离”。
- 在 RAG 中，文档 chunk 会先被 embedding；用户问题也会被 embedding；系统再按向量相似度找候选资料。
- Embedding 擅长语义相似，不擅长精确匹配、权限判断和复杂逻辑推理。
- 向量是有损压缩，不能把原文所有细节都保留下来。

## 核心内容

### Embedding 在做什么

Embedding 的目标是：

```text
语义相近的内容 -> 向量空间里距离也近
语义不同的内容 -> 向量空间里距离更远
```

例如：

```text
"订单退款流程" 和 "用户申请退单怎么处理"
```

字面不完全相同，但语义接近，理想情况下向量距离应较近。

### RAG 中怎么用

| 阶段 | 输入 | 输出 |
|---|---|---|
| 索引阶段 | 文档 chunk | chunk 向量 |
| 提问阶段 | 用户 query | query 向量 |
| 召回阶段 | query 向量 + chunk 向量集合 | 相似度最高的一批候选 chunk |

常见相似度计算是 cosine similarity。实际系统通常会用向量数据库或搜索引擎的 ANN 索引加速。

### 为什么不是精确搜索

Embedding 更像“语义搜索”，不是字符串搜索。

适合：

- 同义表达
- 概念接近
- 意图相似
- 不知道关键词时的模糊查找

不适合单独处理：

- 订单号、手机号、编码、主键等精确值
- 版本号、错误码、字段名等必须完全匹配的内容
- 权限、时间、业务域等结构化过滤条件

因此现代 RAG 通常会结合 [[02-02-RAG-Retrieval召回与混合检索|混合检索]]：Embedding 负责语义，关键词检索负责精确匹配，metadata filter 负责结构化约束。

### 常见问题

| 问题 | 影响 |
|---|---|
| chunk 太短 | 缺少上下文，向量语义不稳定 |
| chunk 太长 | 多个主题混在一起，向量语义被稀释 |
| 专有名词多 | 通用 embedding 可能理解不准 |
| 原文质量差 | 噪声会进入向量表示 |
| 只用向量检索 | 精确查询和权限过滤容易失控 |


Embedding（向量化）本质上是在做：

> “把人类语言，映射到数学空间中的坐标。”

即：

```text
一句话
↓
一串浮点数数组
↓
vector（向量）
```

例如：

```text
"订单取消流程"
```

可能变成：

```text
[0.182, -0.773, 0.918, ...]
```

长度可能：

- 384维
    
- 768维
    
- 1024维
    
- 1536维
    
- 3072维
    

---

# 一、Embedding 到底在干什么

你可以理解为：

LLM 不真正“懂中文”。

它只懂：

```text
数字之间的关系
```

所以：

Embedding 的目标是：

## 让“语义相近”的内容

在数学空间里：

## 距离也相近。

---

例如：

```text
"退货"
"逆向履约"
```

虽然字不同。

但是：

向量距离会很近。

---

而：

```text
"数据库连接池"
"猫咪"
```

距离会很远。

---

# 二、Embedding 的真正输入是什么

很多人误以为：

```text
Embedding("你好")
```

直接输出向量。

实际上中间步骤很多。

---

# 三、完整流程（重点）

完整过程：

```text
文本
↓
Tokenizer 分词
↓
Token IDs
↓
Embedding Model
↓
Transformer 编码
↓
Pooling
↓
最终向量
```

---

# 四、Step1：Tokenizer（分词）

例如：

```text
"订单取消流程"
```

先被 tokenizer 切分。

可能：

```text
["订单", "取消", "流程"]
```

或者：

```text
["订", "单", "取消", "流程"]
```

然后：

转成 token id：

```text
[1832, 9921, 551]
```

---

# 五、Step2：Token Embedding

每个 token：

先变成：

```text
初始词向量
```

例如：

```text
token 1832
↓
[0.12, 0.88, -0.55 ...]
```

这一步：

和 Word2Vec 很像。

---

# 六、Step3：Transformer 编码（真正核心）

这里：

Embedding Model 会：

## 理解上下文语义。

例如：

```text
苹果很好吃
```

和：

```text
苹果发布了新手机
```

“苹果”向量不同。

因为：

Transformer 会：

## 根据上下文动态调整语义。

---

这就是：

## Contextual Embedding（上下文向量）

也是现代 embedding 强大的原因。

---

# 七、Step4：Pooling（池化）

Transformer 输出：

其实是：

```text
每个 token 一个向量
```

例如：

```text
token1 -> vector1
token2 -> vector2
token3 -> vector3
```

但：

RAG 要的是：

## “整句话一个向量”

所以：

需要 Pooling。

---

# 八、Pooling 是什么

本质：

> “把多个 token 向量压缩成一个句子向量”

常见方式：

---

## 1. Mean Pooling（最常见）

直接平均：

```text
(v1 + v2 + v3)/3
```

---

## 2. CLS Token

取：

```text
[CLS]
```

那个 token。

BERT 常见。

---

## 3. Max Pooling

每一维取最大值。

---

最后：

得到：

```text
Sentence Embedding
```

---

# 九、为什么向量能表达语义

这是最核心的问题。

---

因为：

模型训练时：

会不断学习：

## 哪些词经常一起出现。

例如：

```text
订单
履约
发货
收货
库存
```

经常共现。

所以：

数学空间中：

它们会靠近。

---

而：

```text
猫
狗
宠物
```

会形成另一团。

---

# 十、向量空间长什么样

可以理解成：

```text
一个超高维坐标空间
```

例如：

1536维：

```text
[x1,x2,x3....x1536]
```

每一维：

不是：

```text
“是否是订单”
```

这种人类可理解语义。

而是：

模型自己学出来的抽象特征。

---

# 十一、Embedding 模型怎么训练

核心思想：

---

# “让相似内容靠近”

例如训练：

```text
Query:
"如何取消订单"

Positive:
"订单取消流程"

Negative:
"数据库连接池配置"
```

训练目标：

```text
query 与 positive 更近
query 与 negative 更远
```

---

这叫：

## Contrastive Learning（对比学习）

---

# 十二、RAG 中真正怎么用 Embedding

例如：

数据库里：

有：

```text
chunk1:
DH单据履约流程...

chunk2:
库存扣减失败处理...

chunk3:
发票税码同步...
```

---

## 第一步：

全部 embedding。

变成：

```text
vector1
vector2
vector3
```

存 VectorDB。

---

## 第二步：

用户问：

```text
DH 如何履约？
```

也 embedding：

```text
query_vector
```

---

## 第三步：

计算距离。

例如：

---

# Cosine Similarity（最常见）

公式：

\cos(\theta)=\frac{A\cdot B}{|A||B|}

---

含义：

```text
方向越接近
语义越接近
```

结果：

```text
chunk1 -> 0.95
chunk2 -> 0.62
chunk3 -> 0.31
```

然后：

取 TopK。

---

# 十三、为什么 embedding 不适合精确搜索

这是 RAG 大坑。

例如：

```text
SC00081720251222000001
```

这种：

订单号。

Embedding 不擅长。

因为：

它关注：

## 语义

不是：

## 精确字符串。

---

所以：

现代 RAG：

通常：

# Hybrid Search

一起用：

- BM25（关键词）
    
- Embedding（语义）
    

---

# 十四、代码 Embedding 又是什么

代码 embedding：

本质一样。

例如：

```java
public void cancelOrder()
```

会变成向量。

---

因为：

模型学习了：

```text
cancel
rollback
refund
reverse
```

语义相关。

---

所以：

即使：

你搜：

```text
订单撤销
```

也可能召回：

```java
cancelOrder()
```

---

# 十五、Embedding 和 LLM 的关系

很多人误解：

> embedding = LLM

其实：

不是。

---

## Embedding 模型：

重点：

```text
语义压缩
```

输出：

```text
vector
```

---

## LLM：

重点：

```text
token预测
```

输出：

```text
文本
```

---

所以：

很多公司：

会：

```text
LLM 用 GPT-5
Embedding 用 bge / e5
```

分开。

---

# 十六、现在主流 Embedding 模型

开源：

- BGE
    
- E5
    
- Sentence Transformers
    
- GTE
    
- Jina Embedding
    

OpenAI：

- text-embedding-3-small
    
- text-embedding-3-large
    

---

# 十七、Embedding 最大的问题

其实：

## 向量会丢信息。

因为：

```text
长文本
↓
压缩成一个固定长度向量
```

这本质是：

## 有损压缩

---

所以：

会出现：

## 语义漂移

例如：

一个 chunk：

同时包含：

- 发票
    
- 库存
    
- 履约
    

embedding 后：

可能：

谁都不像。

---

# 十八、为什么 chunking 极其重要

因为：

embedding 不是无限理解。

chunk 太大：

语义会混。

chunk 太小：

上下文断裂。

---

所以：

真正高级 RAG：

chunking 才是核心。

甚至比模型更重要。




