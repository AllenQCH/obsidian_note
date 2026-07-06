
```python
docs_src/bigger_applications/app_an_py310/dependencies.py 代码：

from typing import Annotated
from fastapi import Header, HTTPException

async def get_token_header(x_token: Annotated[str, Header()]):
    if x_token != "fake-super-secret-token":
        raise HTTPException(status_code=400, detail="X-Token header invalid")

async def get_query_token(token: str):
    if token != "jessica":
        raise HTTPException(status_code=400, detail="No Jessica token provided")
```

1、导入 Annotated
`Annotated` 是 Python 类型增强工具。
作用：给类型额外附加“元信息”
2、Annotated[str, Header()]
意思：这是一个 str，并且它来自 HTTP Header
3、from fastapi import Header, HTTPException
导入 FastAPI 工具；Header--读取请求头
HTTPException--抛 HTTP 错误
4、第一段函数
```python
async def get_token_header(x_token: Annotated[str, Header()]):
```
async def：定义异步函数。FastAPI 中非常常见。
5、 get_token_header
函数名，获取并校验请求头 token
6、x_token 参数
这是函数参数。
7、Annotated[str, Header()]
等价理解：x_token 是字符串，  值来自 HTTP Header
8、Header() 是什么
告诉 FastAPI：去请求头里取值
9、校验 token
如果请求头 token 不正确
正确请求：X-Token: fake-super-secret-token
10、raise 是什么
Python 抛异常。
11、HTTPException
FastAPI 的 HTTP 错误类。
12、status_code=400
返回 HTTP 状态码：400 Bad Request
detail：返回错误信息。
## 二：第二个函数：不做分析了
1、async def get_query_token(token: str):
query 参数：token: str