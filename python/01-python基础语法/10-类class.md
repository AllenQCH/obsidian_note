# Python 定义类的基本规则
## 基本结构

```python
class 类名(父类):
    类内容
```
例如：
```python
class User:
    pass
```
# 2. 类名

```python
User
类名规范：
- 大驼峰
- PascalCase
例如：
UserService
OrderManager
```
# 3. 类体
Python 用：
```python
缩进
```
表示代码块。
例如：
```python
class User:
    name = "Allen"
    def hello(self):
        print("hello")
```
# 5. 方法定义
类中的函数：
```python
def hello(self):
```
叫：
> 方法（method）
# 6. self
```python
self
```
表示：
> 当前对象自己
类似 Java：
```java
this
```
例如：
```python
class User:
    def hello(self):
        print(self.name)
```
# 7. 创建对象
```python
u = User()
类似：java中的new User()

```
# 8. 构造函数
Python：
```python
__init__
```
例如：
```python
class User:
    def __init__(self, name):
        self.name = name
```
创建：
```python
u = User("Allen")
```
# 9. 完整例子
```python
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    def say_hello(self):
        print("hello", self.name)
```
使用：
```python
u = User("Allen", 18)
u.say_hello()
```
# 和 Java 对比

|Python|Java|
|---|---|
|class User:|class User {}|
|def|方法|
|self|this|
|**init**|构造函数|
|缩进|{}|

# BaseModel 是什么
```python
class User(BaseModel):
```
本质仍是普通 Python 类。
只是：
```python
BaseModel
```
给它增加了：
- 类型校验
- JSON转换
- 自动解析
- 自动序列化
能力。