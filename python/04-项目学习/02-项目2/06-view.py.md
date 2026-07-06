```python
from __future__ import annotations  
  
import logging  
from typing import Annotated  
  
from fastapi import APIRouter, Depends  
  
from svc.apis.api_a.mainmod import main_func as main_func_a  
from svc.apis.api_b.mainmod import main_func as main_func_b  
from svc.core.auth import UserInDB, get_current_user  
  
router = APIRouter()  
logger = logging.getLogger(__name__)  
CurrentUser = Annotated[UserInDB, Depends(get_current_user)]  
  
  
@router.get("/")  
async def index() -> dict[str, str]:  
    return {  
        "info": "This is the index page of fastapi-nano. "  
        "You probably want to go to 'http://<hostname:port>/docs'.",  
    }  
  
  
@router.get("/api_a/{num}", tags=["api_a"])  
async def view_a(  
    num: int,  
    _auth: CurrentUser,  
) -> dict[str, int]:  
    result = main_func_a(num)  
    logger.info(f"API A: {result}")  
    return result  
  
  
@router.get("/api_b/{num}", tags=["api_b"])  
async def view_b(  
    num: int,  
    _auth: CurrentUser,  
) -> dict[str, int]:  
    result = main_func_b(num)  
    logger.info(f"API B: {result}")  
    return result
```


# 整体作用：

```
用户请求
    ↓
FastAPI 路由匹配
    ↓
校验登录用户
    ↓
调用 main_func_a / main_func_b
    ↓
生成随机数据
    ↓
打印日志
    ↓
返回 JSON
```

# from __future__ import annotations
开启延迟类型注解。

# from fastapi import APIRouter, Depends
导入 FastAPI 功能。APIRouter作用：定义路由组；类似：SpringBoot 的 Controller 分组；
Depends作用：依赖注入；FastAPI 核心机制之一。

# router = APIRouter()
创建路由对象。后面所有： @router.get()都会挂到这里。最终：app.include_router(router)注册到 FastAPI。

# logger = logging.getLogger(__ name__)
创建 logger。这里：__ name__表示：当前模块名；例如：svc.routes.views

# CurrentUser = Annotated【UserInDB, Depends(get_current_user)]
这是 FastAPI 很经典的写法。拆开理解：UserInDB表示：最终得到的数据类型。Depends(get_current_user)表示：执行 get_current_user()；获取用户。最终：CurrentUser等价于：“当前登录用户”，后面接口里可以直接用。

# @router.get("/")
定义 GET 接口。路径：/

# async def index() -> dict【str, str]:
定义异步接口。返回：dict【str, str]
#     return {
返回 JSON。

# @router.get("/api_a/{num}", tags=["api_a"】)
定义接口：/api_a/{num}例如：/api_a/10
## tags=["api_a"】Swagger 分组。Swagger 页面会显示：api_a分类。