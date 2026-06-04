
```python
docs_src/bigger_applications/app_an_py310/routers/items.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/users/", tags=["users"])
async def read_users():
    return [{"username": "Rick"}, {"username": "Morty"}]
@router.get("/users/me", tags=["users"])
async def read_user_me():
    return {"username": "fakecurrentuser"}
@router.get("/users/{username}", tags=["users"])
async def read_user(username: str):
    return {"username": username}
```

# 1. 这整个文件的作用

这个文件是：users 模块的路由文件
负责：/users相关接口
它定义了三个接口：

|方法|路径|作用|
|---|---|---|
|GET|/users/|查询所有用户|
|GET|/users/me|查询当前用户|
|GET|/users/{username}|查询指定用户|

这里重点是：FastAPI 路由匹配顺序

# 2. 导入与 router 创建
## A、导入 APIRouter
from fastapi import APIRouter
作用：导入 FastAPI 的子路由类
## B、创建 router
router = APIRouter()
作用：创建 users 模块自己的 router
后面所有： @router.get(...)
都会挂到这个 router 上。
# 3. 查询所有用户接口
## A、注册 GET 接口
@router.get("/users/", tags=["users"])
这里：

|部分|含义|
|---|---|
|router.get|注册 GET 接口|
|"/users/"|接口路径|
|tags|Swagger 分组|

这个接口最终路径：/users/

## B、定义函数
async def read_users():
函数名：read_users
意思：读取所有用户
## C、返回数据

```python
return [{"username": "Rick"}, {"username": "Morty"}]
```

返回：

```json
[
  {
    "username": "Rick"
  },
  {
    "username": "Morty"
  }
]
```

这里返回的是：list[dict]
FastAPI 自动转 JSON。
# 4. 查询当前用户接口

## A、注册接口

```python
@router.get("/users/me", tags=["users"])
```

路径：/users/me
## B、定义函数
```python
async def read_user_me():
```
函数名：read_user_me
意思：查询当前登录用户
## C、返回数据

```python
return {"username": "fakecurrentuser"}
```
返回：
```json
{
  "username": "fakecurrentuser"
}
```

# 5. 查询指定用户接口

这是整个文件最重要部分。

## A、注册动态路由

```python
@router.get("/users/{username}", tags=["users"])
```
这里：{username}
表示：路径参数
例如：
```text
/users/rick
/users/jack
/users/allen
```
## B、定义函数

```python
async def read_user(username: str):
```
FastAPI 自动：从 URL 提取 username
例如：/users/allen
则：username = "allen"
## 返回数据

```python
return {"username": username}
```
返回：
```json
{
  "username": "allen"
}
```

# 6. 这个文件最核心的知识点
重点是：/users/me和：/users/{username}同时存在。
你可能会想：访问 /users/me 时，会不会 username="me"？

答案：不会
因为：FastAPI 按顺序匹配路由
当前顺序： @router.get("/users/me")在前
所以：/users/me会优先匹配read_user_me()
只有：/users/其他内容
才会进入：read_user(username)
# 7. 如果顺序反了会怎样
如果： @router.get("/users/{username}")写前面。

则：/users/me会被解析成：username = "me"
导致：read_user_me()永远不会执行。

**重点**
**所以：固定路径；要写在动态路径前面
这是 FastAPI 很重要的规则。**