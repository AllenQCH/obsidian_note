这些向量会存到：
常见方案：
- Pinecone
- Milvus
- Weaviate
- Elasticsearch
- pgvector（PostgreSQL 插件）


## Vector DB 干什么
它做：
```text
相似度搜索
```
例如：
用户问：
```text
DH 单据如何履约？
```
系统会：
```text
把问题也 embedding
```
然后：
```text
去向量库里找：
“最相似的 chunks”
```


