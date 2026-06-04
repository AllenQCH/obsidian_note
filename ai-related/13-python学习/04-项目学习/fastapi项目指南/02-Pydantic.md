Pydantic 是 Python 里最流行的数据校验库之一。

核心作用：

```text
把“乱数据”
变成“结构化、安全的数据”
```

FastAPI 基本就是建立在 Pydantic 上的。

---

# 一、Pydantic 到底解决什么问题

Python 本身是动态语言。

例如：

```python
data = {
    "name": "allen",
    "age": "18"
}
```

这里：

```python
age = "18"
```

其实是字符串。

但很多时候你希望：

```python
age: int
```

否则：

- 数据可能错
    
- API 参数可能乱
    
- 数据库字段可能异常
    

Pydantic 就是专门干这个的。

---

# 二、最核心用法

```python
from pydantic import BaseModel


class User(BaseModel):
    name: str
    age: int
```

这里：

```python
BaseModel
```

是 Pydantic 核心。

---

然后：

```python
user = User(
    name="allen",
    age="18"
)
```

注意：

```python
age="18"
```

是字符串。

但 Pydantic 会自动转换：

```python
user.age
# 18
```

变成 int。

---

# 三、它做了什么

---

## 1. 数据校验（最核心）

例如：

```python
User(
    name="allen",
    age="abc"
)
```

会直接报错：

```text
Input should be a valid integer
```

因为：

```python
age
```

必须是 int。([pydantic.dev](https://pydantic.dev/docs/validation/latest/concepts/models/?utm_source=chatgpt.com "Models | Pydantic Docs"))

---

## 2. 自动类型转换

例如：

```python
age="18"
```

自动转：

```python
18
```

---

## 3. 自动生成对象

你得到的不再是 dict：

而是：

```python
User
```

对象。

可以：

```python
user.name
```

而不是：

```python
data["name"]
```

---

## 4. 自动生成 JSON Schema

FastAPI Swagger 文档就是靠它。([pydantic.dev](https://pydantic.dev/docs/validation/latest/get-started/?utm_source=chatgpt.com "Welcome to Pydantic | Pydantic Docs"))

---

# 四、为什么 FastAPI 强依赖 Pydantic

例如：

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class User(BaseModel):
    name: str
    age: int


@app.post("/users")
async def create_user(user: User):
    return user
```

当前端传：

```json
{
  "name": "allen",
  "age": "18"
}
```

FastAPI 会：

```text
自动调用 Pydantic
        ↓
校验字段
        ↓
自动转类型
        ↓
生成 User 对象
```

所以：

```python
user.age
```

已经是 int。

---

# 五、Field 是什么

Pydantic 里经常看到：

```python
from pydantic import Field
```

用于字段增强。

例如：

```python
from pydantic import BaseModel, Field


class User(BaseModel):
    age: int = Field(gt=0)
```

意思：

```text
age 必须 > 0
```

---

例如：

```python
User(age=-1)
```

直接报错。

([pydantic.dev](https://pydantic.dev/docs/validation/latest/concepts/fields/?utm_source=chatgpt.com "Fields | Pydantic Docs"))

---

# 六、常见约束

---

## 长度限制

```python
name: str = Field(max_length=20)
```

---

## 数字范围

```python
age: int = Field(gt=0, lt=100)
```

---

## 默认值

```python
name: str = "anonymous"
```

---

## 别名

```python
name: str = Field(alias="username")
```

前端：

```json
{
  "username": "allen"
}
```

也能映射。

([pydantic.dev](https://pydantic.dev/docs/validation/latest/concepts/fields/?utm_source=chatgpt.com "Fields | Pydantic Docs"))

---

# 七、Settings 是什么

你前面看到：

```python
class Settings(BaseSettings):
```

这个也是 Pydantic。

作用：

```text
读取 .env 配置
```

例如：

```env
DB_HOST=localhost
DB_PORT=3306
```

自动转成：

```python
settings.db_host
settings.db_port
```

---

# 八、model_dump 是什么

Pydantic 对象：

```python
user = User(name="allen", age=18)
```

转 dict：

```python
user.model_dump()
```

结果：

```python
{
    "name": "allen",
    "age": 18
}
```

---

# 九、Pydantic v1 和 v2

现在基本是：

```text
Pydantic v2
```

变化很大。

---

例如：

旧版：

```python
user.dict()
```

新版：

```python
user.model_dump()
```

---

新版底层用了 Rust。

性能提升非常明显。([pydantic.dev](https://pydantic.dev/docs/validation/latest/get-started/?utm_source=chatgpt.com "Welcome to Pydantic | Pydantic Docs"))

---

# 十、Pydantic 本质理解

你可以把它理解成：

```text
Python 世界里的：
“数据结构 + 数据校验器”
```

它介于：

```text
dict
```

和：

```text
数据库 ORM 实体类
```

之间。

---

# 十一、最经典完整例子

```python
from pydantic import BaseModel, Field


class User(BaseModel):
    name: str
    age: int = Field(gt=0)
    email: str | None = None


user = User(
    name="allen",
    age="18"
)

print(user)
print(user.age)
print(type(user.age))
```

输出：

```python
name='allen' age=18 email=None

18

<class 'int'>
```

---

# 十二、整体流程

```text
外部数据(JSON/dict)
        ↓
Pydantic BaseModel
        ↓
类型校验
        ↓
数据转换
        ↓
生成 Python 对象
        ↓
FastAPI / 数据库 / 业务逻辑
```

Pydantic 在现代 Python Web 开发里，地位非常核心。