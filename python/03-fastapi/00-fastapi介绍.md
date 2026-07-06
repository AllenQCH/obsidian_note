官网： https://fastapi.tiangolo.com/zh/tutorial/query-params/

FastAPI 是一个：专门给 Python 做 API 服务的现代 Web 框架；可以理解为java的Spring Boot
Java：SpringBoot= 企业 Web API 框架
🟰Python：FastAPI= AI时代 Web API 框架
很多 AI 应用：
- Agent
- RAG
- MCP Server
- AI Workflow
- 推理服务
- 模型网关
现在几乎都在用 FastAPI。

# 1. FastAPI 本质是什么
它的核心作用：让 Python 快速提供 HTTP 接口
例如：
```
@app.get("/hello")
def hello():    
	return {"msg": "hello"}

然后：
GET /hello

就能返回：
{
  "msg": "hello"
}

```

# 2. 为什么 AI 圈几乎都在用 FastAPI
因为它特别适合：AI 推理服务
例如：
```
用户请求→ FastAPI→ 调用 LLM→ 返回结果
或者：
用户上传 PDF→ FastAPI→ embedding→ 向量库
```

# 3. FastAPI 为什么火
以前 Python Web 框架主要：

|框架|特点|
|---|---|
|Flask|简单但偏老|
|Django|大而全|
|FastAPI|现代 + AI时代|

FastAPI 火的核心原因：
## （1）异步性能非常强
支持：

```
async def
例如：
@app.get("/")
async def chat():    
	result = await llm_call()    return result
```

AI 场景大量：
- 网络 IO
- LLM 调用
- streaming
- websocket
所以 async 非常重要。
## （2）自动生成 Swagger 文档
启动后：
```
http://127.0.0.1:8000/docs
```
直接自动生成 API 文档。
这点和 Spring Boot + Swagger 很像。
## （3）类型提示极强
例如：
```
@app.get("/user/{id}")
def get_user(id: int):
    return {"id": id}
```
FastAPI 会：
- 自动校验参数
- 自动生成文档
- 自动报错
## （4）特别适合 AI
因为 AI 服务本质上：
```
就是 HTTP + Streaming
```
FastAPI 对：
- SSE
- websocket
- async
- streaming response
支持非常好。


# 5. AI 系统里 FastAPI 经常干什么

## LLM Gateway
例如：
```
ChatGPT API代理
前端→ FastAPI→ OpenAI→ 返回
```
## RAG 服务
```
上传文档→ FastAPI→ chunk→ embedding→ vector db
```
## Agent Runtime
```
用户请求→ FastAPI→ Agent Workflow→ Tool Calling→ 返回
```
## MCP Server
现在很多 MCP Server：
- filesystem
- browser
- database
底层都是：
```
FastAPI + async
```

# 6. FastAPI 技术栈是什么
内部核心：

|组件|作用|
|---|---|
|Starlette|Web ASGI 框架|
|Pydantic|数据校验|
|Uvicorn|Web Server|
|AnyIO|async runtime|

# 7. FastAPI 和 Spring Boot 最大区别

## Spring Boot
```
偏：
企业业务系统
适合：
- ERP
- 电商
- 订单
- 支付
```
## FastAPI
```
偏：
AI / 数据 / 推理
适合：
- AI API
- 推理服务
- Agent
- RAG
- streaming
```

# 8. 现在 AI 圈为什么 Python 能压过 Java
不是因为 Python 更强。
而是因为：AI 核心生态都在 Python
例如：
- PyTorch
- Transformers
- LangChain
- LlamaIndex
所以：FastAPI≈ AI 世界的 Spring Boot
自然爆发了。

# 9. 你现在学 FastAPI 的意义非常大

因为你现在：
- Java 后端
- 微服务
- API
- MQ
- ES
- infra
这些能力：
```
迁移到 FastAPI 非常快
```
你真正需要补的是：
- Python
- async
- AI SDK
- streaming
- Agent
而不是：
```
重新学习“后端”
```
因为很多底层思想：
- Controller
- Service
- DTO
- Middleware
- DI
- API Gateway
其实都类似。