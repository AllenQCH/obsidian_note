```python
from fastapi import FastAPI  
from fastapi.middleware.cors import CORSMiddleware  
  
from svc.core import auth  
from svc.routes import views  
  
def create_app() -> FastAPI:  
    """Create a FastAPI application."""  
    app = FastAPI()  
    # Set all CORS enabled origins  
    app.add_middleware(  
        CORSMiddleware,  
        allow_origins=["*"],  
        allow_credentials=True,  
        allow_methods=["*"],  
        allow_headers=["*"],  
    )  
    app.include_router(auth.router)  
    app.include_router(views.router)  
    return app  
app = create_app()
```

# 整体执行流程
启动：
uvicorn svc.main:app
↓
导入：
svc/main.py
↓
执行：
app = create_app()
↓
创建 FastAPI 对象
↓
注册中间件
↓
注册路由
↓
启动 HTTP 服务
↓
浏览器访问：
http://127.0.0.1:5002/docs
自动生成 Swagger。

# from fastapi.middleware.cors import CORSMiddleware

这是：跨域中间件
浏览器前后端分离时经常需要。
例如：localhost:3000
访问：localhost:5002
浏览器默认会拦截。
CORS 就是解决这个。
# from svc.core import auth
导入：svc/core/auth.py模块。
后面：
```python
app.include_router(auth.router)
```
会把里面的接口注册进来。
```python
from svc.routes import views
```
导入：svc/routes/views.py中的路由。
# def create_app() -> FastAPI:

定义一个函数：create_app；返回类型：FastAPI
这是 Python 类型注解。
类似 Java：
```java
public FastAPI createApp()
```
```python
"""Create a FastAPI application."""
```
函数注释。
```
-> FastAPI这个叫：返回值类型注解
```
Python 官方推荐写法。
IDE：
- hover
- 文档生成
会用到。
```python
app = FastAPI()
```
创建 FastAPI 应用实例。
这是整个项目最核心对象。
后面：
- 路由
- 中间件
- Swagger
- 生命周期
都会挂在：app上。
# app.add_middleware(
给应用添加中间件。
类似 Java：
```text
Filter
Interceptor
```
# CORSMiddleware

指定中间件类型：跨域中间件

# allow_origins=【"*"],

允许哪些域名访问。
表示：
```text
允许所有来源
```
生产环境一般不会这么写。
通常：
```python
["https://xxx.com"]
```
# allow_credentials=True,
允许：
- Cookie
- Authorization Header
这类认证信息。
# allow_methods
```python
allow_methods=["*"],
```
允许所有 HTTP 方法：
- GET
- POST
- PUT
- DELETE
# allow_headers

```python
allow_headers=["*"],
```

允许所有请求头。

例如：

```text
Authorization
Content-Type
```

---

# app.include_router(auth.router)
把：
```python
auth.router
```
注册到应用。
这一步后：
```text
auth.py中的接口
```
才真正生效。
例如：
auth.py：
```python
router = APIRouter()
@router.post("/login")
```
注册后：
```text
/login
```
接口才存在。
# app.include_router(views.router)
同理。把：
```python
views.py
```
中的路由注册进来。
# return app
返回 FastAPI 应用实例。
# app = create_app()
真正创建：app变量。

因为：
```bash
uvicorn svc.main:app
```
中的：
```text
svc.main:app
```
意思是：
```text
导入 svc/main.py
取里面的 app 变量
```

等价于：

```python
from svc.main import app
```

所以：

```python
app = create_app()
```

必须存在。

否则：

```text
uvicorn 找不到 app
```

就会报错。

---

