## 1. Transformer 是什么

Transformer 是一种处理序列数据的神经网络架构，由 Google Brain 在 2017 年论文《Attention Is All You Need》中提出。
一句话：
> Transformer 的核心思想是：用 Attention（注意力机制）直接找出文本中各个词之间的关系。

## 2. 没有 Transformer 之前

早期 NLP：nature language processing
```text
文本
 ↓
RNN
 ↓
LSTM
 ↓
结果
```
例如：
```text
我今天去了北京，
北京的烤鸭很好吃。
```
处理到：
```text
烤鸭
```
时，需要一步一步传递前面的信息：
```text
我 → 今天 → 去了 → 北京 → 北京 → 的 → 烤鸭
```
问题：
- 不能并行计算
- 长文本容易遗忘
- 训练速度慢
## 3. Transformer 的改进
Transformer 不再逐个词传递。
直接建立关系：
```text
我今天去了北京，北京的烤鸭很好吃
```
模型直接看到：
```text
烤鸭
 ↑
北京
```
知道：
```text
烤鸭属于北京
```
而不是经过很多层传递。
## 4. 核心：Attention
例如：
```text
小明去超市买苹果，
他觉得很好吃。
```
看到：
```text
他
```
模型要知道：
```text
他 = 小明
```
Attention 会计算：
```text
他 ↔ 小明
他 ↔ 超市
他 ↔ 苹果
```
然后发现：
```text
小明 权重最高
```
所以：
```text
他 = 小明
```
这就是注意力机制。
## 5. Self-Attention
Transformer 最核心的部分。
例如：
```text
猫坐在垫子上
```
对于：
```text
猫
```
会看：
```text
猫 ↔ 坐
猫 ↔ 在
猫 ↔ 垫子
猫 ↔ 上
```
对于：
```text
垫子
```
又会看：
```text
垫子 ↔ 猫
垫子 ↔ 坐
垫子 ↔ 上
```
即：
```text
每个词都看所有词
```
这叫：
```text
Self-Attention
```
## 6. Q、K、V 是什么

这是最容易把人看晕的部分。
可以理解成：
```text
Q = 我想找什么
K = 我有什么
V = 我的内容
```
例如：
```text
小明喜欢苹果
```
处理：
```text
喜欢
```
时：
```text
Q(喜欢)
```
去匹配：
```text
K(小明)
K(苹果)
```
发现：
```text
小明 匹配度高
```
于是读取：
```text
V(小明)
```
最终知道：
```text
喜欢的主体是小明
```

## 7. 数学上怎么做

Attention 实际公式：

Attention(Q,K,V)=softmax\left(\frac{QK^T}{\sqrt{d_k}}\right)V

流程：

```text
Q × Kᵀ
 ↓
相似度
 ↓
softmax
 ↓
权重
 ↓
乘 V
 ↓
结果
```

本质：

```text
计算谁和谁最相关
```


## 8. Multi-Head Attention

单个 Attention：

```text
只看一种关系
```

多个 Head：

```text
Head1 看主谓关系
Head2 看时间关系
Head3 看地点关系
Head4 看上下文关系
```

最后合并：

```text
综合理解一句话
```


## 9. Position Encoding

Attention 有个问题：

```text
我爱你
你爱我
```

词一样。

怎么区分顺序？

加入位置编码：

```text
我(位置1)
爱(位置2)
你(位置3)
```

模型知道：

```text
谁在前
谁在后
```


## 10. Transformer 整体结构

```text
输入
 ↓
Embedding
 ↓
Position Encoding
 ↓
Multi-Head Attention
 ↓
Feed Forward
 ↓
Multi-Head Attention
 ↓
Feed Forward
 ↓
...
 ↓
输出
```

每一层都在不断理解：

```text
词
 ↓
短语
 ↓
句子
 ↓
段落
 ↓
全文
```


## 11. GPT 用了什么

GPT 只保留：

```text
Transformer Decoder
```

结构：

```text
输入
 ↓
Decoder
 ↓
预测下一个词
```
例如：
```text
今天的天气很
```
预测：
```text
好
```
然后：
```text
今天的天气很好
```
继续预测：
```text
啊
```
不断循环。

## 12. 为什么 Transformer 改变了 AI
因为它同时解决了：
```text
✓ 长文本问题
✓ 并行训练问题
✓ 语义理解问题
✓ 大规模扩展问题
```
最终形成：
```text
Transformer
 ↓
BERT
 ↓
GPT
 ↓
ChatGPT
 ↓
Agent
```

今天几乎所有主流大模型（GPT、Gemini、Llama、DeepSeek）底层都仍然是 Transformer 的变种。对于你从 Java 转 AI，理解到 **Embedding → Self-Attention → Transformer → GPT** 这条链路，基本就掌握了大模型原理的核心框架。