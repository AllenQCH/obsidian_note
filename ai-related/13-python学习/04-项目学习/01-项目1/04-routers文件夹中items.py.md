
```python
docs_src/bigger_applications/app_an_py310/routers/items.py

from fastapi import APIRouter, Depends, HTTPException

from ..dependencies import get_token_header

router = APIRouter(
    prefix="/items",
    tags=["items"],
    dependencies=[Depends(get_token_header)],
    responses={404: {"description": "Not found"}},
)

fake_items_db = {"plumbus": {"name": "Plumbus"}, "gun": {"name": "Portal Gun"}}

@router.get("/")
async def read_items():
    return fake_items_db

@router.get("/{item_id}")
async def read_item(item_id: str):
    if item_id not in fake_items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"name": fake_items_db[item_id]["name"], "item_id": item_id}

@router.put(
    "/{item_id}",
    tags=["custom"],
    responses={403: {"description": "Operation forbidden"}},
)
async def update_item(item_id: str):
    if item_id != "plumbus":
        raise HTTPException(
            status_code=403, detail="You can only update the item: plumbus"
        )
    return {"item_id": item_id, "name": "The great Plumbus"}
```


# 1. 这整个文件的作用
这个文件本质是：items 模块的路由文件
负责处理：/items相关接口。
它主要做了三件事：
- 创建 items 路由
- 定义 items 接口
- 配置 token 校验

## 整体流程
例如：
```http
GET /items/gun
```
FastAPI 内部流程：
```text
请求进入
   ↓
router 匹配 /items/{item_id}
   ↓
执行 Depends(get_token_header)
   ↓
执行 read_item()
   ↓
查询 fake_items_db
   ↓
返回 JSON
```

# 2. 导入部分
## A、导入 FastAPI 组件
from fastapi import APIRouter, Depends, HTTPException
这里导入了三个东西。
### 1)APIRouter
作用：创建子路由
类似：SpringBoot 的 Controller 分组
### 2)Depends
作用：依赖注入
通常用于：
- token 校验
- 数据库 session
- 用户登录校验
### 3)HTTPException
作用：主动返回 HTTP 错误
例如：
- 404
- 403
- 401
## B、导入 dependencies
from ..dependencies import get_token_header
这里：..表示：上一层目录

因为当前文件在：routers/items.py
所以：..会回到：app_an_py310/
然后找到：dependencies.py
这一行整体意思：
从上一级目录的 dependencies.py
导入 get_token_header
# 3. 创建 router

## A、创建 APIRouter
router = APIRouter(
这里开始创建：items 模块自己的 router
## B、prefix
prefix="/items",
作用：给当前 router 所有接口统一加前缀
## C、tags
tags=["items"],
作用：Swagger 文档分组
在：/docs页面中：
会出现：items这个分类。
## D、dependencies
dependencies=[Depends(get_token_header)],
作用：当前 router 的所有接口，都必须执行 token 校验
即：所有：/items/*请求，都会优先执行：get_token_header()
## E、responses
responses={404: {"description": "Not found"}},
作用：给 Swagger 文档补充响应说明
表示：当前模块可能返回 404
# 4. 模拟数据库

```python
fake_items_db = {
    "plumbus": {"name": "Plumbus"},
    "gun": {"name": "Portal Gun"}
}
```
这里是：模拟数据库
真实项目通常会：
- 查 MySQL
- 查 Redis
- 调 service
这里只是教学示例。
# 5. 查询所有 items 接口

## A、注册 GET 接口
@router.get("/")这里表示：注册 GET /items/
## B、定义接口函数
async def read_items():
函数名：read_items
意思：读取所有 items
## C、返回数据
return fake_items_db
FastAPI 会自动转成 JSON：
```json
{
  "plumbus": {
    "name": "Plumbus"
  },
  "gun": {
    "name": "Portal Gun"
  }
}
```
# 6. 查询单个 item 接口
## A、注册动态路由
```python
@router.get("/{item_id}")
```
这里：{item_id}
表示：路径参数
例如：
```text
/items/gun
/items/plumbus
```
## B、定义函数
async def read_item(item_id: str):
FastAPI 会自动：从 URL 中提取 item_id
例如：/items/gun；item_id = "gun"

## C、判断 item 是否存在
if item_id not in fake_items_db:
作用：检查数据库里有没有这个 item
## D、返回 404
```python
raise HTTPException(
    status_code=404,
    detail="Item not found"
)
```
客户端收到：404 Not Found
以及：
```json
{
  "detail": "Item not found"
}
```
## E、返回 item 数据
```python
return {
    "name": fake_items_db[item_id]["name"],
    "item_id": item_id
}
```
返回对应 item 信息。
# 7. 更新 item 接口

## 注册 PUT 接口
@router.put(这里：注册 PUT 接口
PUT 通常表示：
更新资源
## 动态路径
"/{item_id}",即：PUT /items/plumbus这种请求。
## 覆盖 tags
tags=["custom"],这里会覆盖：router 默认 tags=["items"]
所以 Swagger 中：这个接口属于 custom 分组
## 额外 responses
responses={403: {"description": "Operation forbidden"}},
表示：当前接口可能返回 403
## 定义更新函数
async def update_item(item_id: str):
定义更新接口。
## 判断是否允许更新
if item_id != "plumbus":
意思：只有 plumbus 能更新
## 返回 403

```python
raise HTTPException(
    status_code=403,
    detail="You can only update the item: plumbus"
)
```
客户端收到：403 Forbidden
## 更新成功
```python
return {
    "item_id": item_id,
    "name": "The great Plumbus"
}
```
返回更新后的数据。



