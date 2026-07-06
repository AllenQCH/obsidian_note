
```python
docs_src/bigger_applications/app_an_py310/internal/admin.py

from fastapi import APIRouter

router = APIRouter()

@router.post("/")
async def update_admin():
    return {"message": "Admin getting schwifty"}
```
**整体运行流程：**
```text
客户端发送 POST 请求
        ↓
router.post("/") 匹配成功
        ↓
执行 update_admin()
        ↓
return dict
        ↓
FastAPI 自动转 JSON
        ↓
返回 HTTP 响应
```

# 第一部分
from fastapi import APIRouter
作用：从 fastapi 模块中，导入 APIRouter 类
## APIRouter 是什么？
可以理解成：“子路由管理器”
类似 SpringBoot：Controller 分组
例如：
users 相关接口，放一个 router。
items 相关接口，再放一个 router。
最后统一挂到：app上

# 第二部分：
router = APIRouter()
作用：创建一个路由对象，创建子路由。
router
可以管理：
- GET接口
- POST接口
- DELETE接口
# 第三部分
@router.post("/")
作用：注册 POST 接口
这里：当收到 POST / 请求时，执行下面函数

async def update_admin():
定义接口函数

FastAPI 收到请求后：会执行这个函数
执行后：{"message": "Admin getting schwifty"}

