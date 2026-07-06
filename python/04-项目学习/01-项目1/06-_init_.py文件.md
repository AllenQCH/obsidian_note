# 作用
`__init__.py` 本质上是：告诉 Python：“这个目录是一个 package（包）”
可以把 `__init__.py` 理解成：“这个目录的入口文件”
类似：
- Java 的 package 定义
但 Python 的 package 更依赖它。

# 一、先理解 Python 的模块系统

Python 中：
```txt
一个 .py 文件 = 一个 module（模块）
一个目录 = 一个 package（包）
```
例如：
```txt
project/
├── main.py
├── utils.py
```
你可以：
```python
import utils
```
因为：
```txt
utils.py
```
本身就是 module。
但如果：
```txt
project/
├── app/
│   ├── router.py
│   └── service.py
```
你想：
```python
from app import router
```
Python 必须先知道：
```txt
app 是不是 package
```
这时：
```txt
__init__.py
```
就是“身份证”。

# 二、没有 `__init__.py` 会发生什么

## 老版本 Python（3.3前）
直接报错：
```txt
ImportError
```
因为：
Python 根本不认为：
```txt
app/
```
是 package。
## 新版本 Python（3.3+）
支持：
```txt
Namespace Package
```
即：
没 `__init__.py` 也能导入。
所以：
```txt
app/
 └── router.py
```
可能仍能：
```python
from app import router
```
但问题来了。
# 三、有它和没它的真正区别
这是核心。
# 情况1：有 `__init__.py`
```txt
app/
├── __init__.py
├── router.py
└── service.py
```
Python认为：
```txt
这是一个正式 package
```
特点：
- 导入稳定
- 支持相对导入
- IDE识别更好
- pytest更稳定
- 打包更稳定
- 可执行初始化代码
# 情况2：没有 `__init__.py`
```txt
app/
├── router.py
└── service.py
```
这是：
```txt
namespace package
```
特点：
- 更“轻”
- 不需要文件
- 适合大型分布式包

但：
- import 有时不稳定
- IDE 有时识别异常
- pytest 容易路径错乱
- 相对导入容易炸
- 打包容易有坑
# 四、真正本质：导入路径树
这是最核心的。
Python import 本质：
```txt
sys.path
   ↓
查找 package
   ↓
执行 __init__.py
   ↓
加载 module
```
即：
```python
import app
```
实际上：
Python会：
```txt
1. 找到 app 目录
2. 执行 app/__init__.py
3. app 成为 package 对象
4. 再继续加载子模块
```
所以：
```txt
__init__.py 是 package 的启动入口
```
# 五、为什么会“执行”
例如：
```python
# app/__init__.py
print("app init")
```
当：
```python
import app
```
输出：
```txt
app init
```
因为：
> import package 时，会先执行 `__init__.py`
# 六、现代项目最常见用法
## 1. 空文件（最常见）
```txt
__init__.py
```
什么都不写。
只是告诉 Python：
```txt
这是 package
```
## 2. 统一导出
例如：
```python
# service/__init__.py

from .user_service import UserService
from .order_service import OrderService
```
外部：
```python
from service import UserService
```
而不是：
```python
from service.user_service import UserService
```
类似：
```txt
API 门面层
```
## 3. 初始化配置
例如：
```python
# app/__init__.py

logging.basicConfig(...)
```
或者：
```python
# 初始化数据库
# 注册插件
# 初始化环境变量
```
# 七、为什么 FastAPI 项目几乎都有
因为 FastAPI：
大量依赖：
```txt
from app.xxx import yyy
```
而：
- uvicorn
- pytest
- alembic
- pydantic
- IDE
都依赖稳定 package。
所以：
```txt
大型工程几乎默认全目录带 __init__.py
```
# 八、Java 对比理解（非常像）
你是 Java 后端，可以这样理解：
## Java
```java
package com.demo.app;
```
表示：
```txt
这是一个正式包
```
## Python
```txt
__init__.py
```
相当于：
```txt
声明当前目录是 package
```
# 九、现在为什么有人不用它
因为：
现代 Python 提倡：
```txt
namespace package
```
适合：
- 超大 monorepo
- 插件系统
- 多仓库共享包
例如：
```txt
google/
microsoft/
langchain/
```
这种超大型结构。
但：普通业务项目：
```txt
建议保留
```
因为稳定很多。
