# 前提准备：
最简单的 FastAPI 项目：需要哪些前提条件：
Python---编码能力
pip-------Python依赖安装工具
FastAPI---Web开发框架
uvicorn---HTTP服务器
venv------项目独立Python环境
# 一、python

# 二、pip（包管理工具）
pip 是 Python 的“包管理工具”。
类似于：
语言     ｜包管理工具
Java     ｜Maven / Gradle
Node.js｜npm
Python ｜pip

作用：pip install fastapi
意思：从 Python 官方仓库下载 fastapi 并安装
# 三、FastAPI（Web 框架）

因为：Python 本身不会做 Web 服务
Python 默认只有：print()、list、dict、文件操作等基础功能
没有：路由、HTTP 服务、JSON API、Swagger、请求解析
所以需要 Web 框架。

FastAPI 就是：帮你快速开发 Web API 的框架
例如：
```python
@app.get("/")
def hello():
    return {"msg": "hello"}
```
它背后会帮你：
- 接收 HTTP 请求
- 路由匹配
- JSON 序列化
- 返回响应
# 四、uvicorn（启动服务器）
FastAPI 只是：“定义规则”
但它自己不会真正监听端口。
真正启动 HTTP 服务的是：uvicorn
关系：
```text
浏览器
   ↓
uvicorn（Web服务器）
   ↓
FastAPI（业务逻辑）

你访问：http://127.0.0.1:8000
实际上：
1. uvicorn 监听 8000 端口 
2. 收到请求
3. 转发给 FastAPI
4. FastAPI 执行业务代码
5. 返回 JSON
```
**为什么需要 uvicorn**
因为：FastAPI 本质是 ASGI 应用，它不能直接运行
必须有：uvicorn/hypercorn/gunicorn + uvicorn worker这种“服务器”托管。
类似：
东西     ｜类比
FastAPI｜Java SpringMVC
uvicorn｜Tomcat

# 五、venv虚拟环境
本质：给当前项目单独准备一套 Python 环境
例如：
```text
项目A:
  fastapi==0.110
项目B:
  fastapi==0.95
```
如果都装到系统 Python：版本会冲突
所以：每个项目独立安装依赖

## 没有虚拟环境会怎样
例如：你电脑全局安装：
pip install fastapi；那么：所有项目共用
问题：
### （1）版本冲突
项目A需要：pydantic v1
项目B需要：pydantic v2
这时候各种冲突
### （2）环境污染
你装一堆：numpy、torch、fastapi、langchain
系统 Python 会越来越乱。
### （3）无法复现
别人拉你代码：不知道你装过什么
项目无法运行。
## 有虚拟环境后
项目目录：
```text
project/
 ├── venv/
 ├── main.py
 └── requirements.txt
```
特点：这个项目依赖只属于这个项目，不会影响别的项目。
## Python 项目几乎默认都用 venv
尤其：
- FastAPI
- Django
- AI项目
- LangChain
- Dify
- Agent项目
都会使用：venv、conda、poetry之一。




# 六、常见目录结构
后面一般会变成：
fastapi-demo/
│
├── app/
│   ├── main.py
│   ├── router/
│   ├── service/
│   ├── model/
│   └── config/
│
├── venv/
├── requirements.txt
└── README.md

很像 Java：
controller
service
dao
config

## requirements.txt
导出依赖：
pip freeze > requirements.txt
安装依赖：
pip install -r requirements.txt
## 开发中最常用命令
启动
uvicorn main:app --reload
指定端口
uvicorn main:app --reload --port 9000
指定IP（允许局域网访问）
uvicorn main:app --reload --host 0.0.0.0

#  七、整体运行流程
```python
浏览器
   ↓
uvicorn HTTP Server
   ↓
FastAPI Router
   ↓
Python函数
   ↓
返回JSON
```

和 SpringBoot：本质非常接近。
```java
Browser
  ↓
Tomcat
  ↓
DispatcherServlet
  ↓
Controller
  ↓
JSON
```


# 八、创建最简单项目
创建：
main.py
内容：
from fastapi import FastAPI
app = FastAPI()
@app.get("/")
def hello():
    return {"msg": "hello fastapi"}

启动项目
执行：
uvicorn main:app --reload
含义：
main      -> main.py
app       -> app = FastAPI()
--reload  -> 代码变化自动重启

## 访问项目
启动后会看到：
Uvicorn running on http://127.0.0.1:8000
浏览器访问：
http://127.0.0.1:8000
返回：
{"msg":"hello fastapi"}
##  Swagger 文档
FastAPI 自动生成接口文档。
访问：
http://127.0.0.1:8000/docs
这是最常用的。
还有：
http://127.0.0.1:8000/redoc

## 停止项目
终端：
Ctrl + C
即可停止。

## 重启项目
重新执行：
uvicorn main:app --reload
即可。
## 自动重启机制
如果带：
--reload
修改代码后会自动重启。
开发环境基本都这么用。


# UV是什么？
`uv` 是一个现代 Python 工具链，理解成：**uv = 超高速版 pip + venv + pyenv + poetry 的组合体**
# 一、先理解传统 Python 环境
以前 Python 一般这样：
```bash
python -m venv .venv
source .venv/bin/activate

pip install fastapi
pip install uvicorn
```
这里其实有三套东西：

|工具|作用|
|---|---|
|python|解释器|
|venv|虚拟环境|
|pip|安装依赖|

# 二、uv 的目标
uv 想做的是：把 Python 工程化工具统一
类似：

|Java|Node|Python(现代)|
|---|---|---|
|Maven/Gradle|npm/pnpm|uv|
# 三、uv 和 venv + pip 的关系
核心关系：uv = 更高级、更快、更现代的替代方案
它内部：
- 仍然会创建 venv
- 仍然会安装 package
- 仍然会管理依赖
但：你不用再分别操作 venv/pip/python
# 四、对比理解
传统：
```bash
python -m venv .venv

source .venv/bin/activate

pip install fastapi

pip freeze > requirements.txt
```
uv：
```bash
uv venv

uv add fastapi
```
就结束了。
# 五、uv 到底做了什么
## 1. 创建虚拟环境
```bash
uv venv
等价于：
python -m venv .venv
```
## 2. 安装依赖

```bash
uv add fastapi
等价于：
pip install fastapi
```
并且自动：
- 更新 pyproject.toml
- 更新 uv.lock
## 3. 同步依赖
```bash
uv sync
等价于：
pip install -r requirements.txt
```
## 4. 运行项目

```bash
uv run main.py
等价于：
source .venv/bin/activate
python main.py
```
# 六、为什么 uv 很火

因为 Python 以前很乱：

|功能|工具|
|---|---|
|包安装|pip|
|虚拟环境|venv|
|Python版本|pyenv|
|锁版本|pip-tools|
|项目管理|poetry|
|加速|无|

现在 uv：全部统一
而且：速度极快（Rust写的）
很多时候：比 pip 快 10~100 倍
# 七、你截图里的 uv.lock 是什么
类似：

|Java|Node|Python|
|---|---|---|
|pom.xml.lock|package-lock.json|uv.lock|
作用：锁死依赖版本
例如：
```text
fastapi==0.116.1
pydantic==2.11.7
```
保证团队一致。
# 八、pyproject.toml 和 uv 的关系
现在现代 Python：
```text
pyproject.toml = 项目定义
uv.lock         = 依赖锁定
uv              = 工具链
```
类似：
```text
pom.xml
 + Maven
```
# 九、现代 Python 基本已经是这种模式了
现在很多新项目：
```text
FastAPI
LangChain
AI Agent
MCP
```
基本都：uv + pyproject.toml
而不是：requirements.txt + pip
# 十、你可以这样理解（最重要）
```text
pip:
只负责“安装包”

venv:
只负责“隔离环境”

uv:
负责整个 Python 项目生命周期
```
# 十一、对于你（Java背景）最好的类比

| Java                  | Python         |
| --------------------- | -------------- |
| JDK                   | Python         |
| Maven                 | uv             |
| pom.xml               | pyproject.toml |
| maven dependency lock | uv.lock        |
| target/               | .venv/         |
# 十二、建议你现在的学习方式
如果你要转 AI / FastAPI：
直接学：
```bash
uv
pyproject.toml
FastAPI
```
不要再重点学：
```bash
pip
virtualenv
requirements.txt
```
因为现在新项目基本已经升级了。



