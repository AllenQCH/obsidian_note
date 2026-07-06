`pyproject.toml` 是 Python 项目的核心配置文件。

你可以理解成：

```text
Python 项目的总配置中心
```
类似：**Java Maven的pom.xml**

---

# 一、它解决什么问题

以前 Python 很乱：
可能同时有：
```text
requirements.txt
setup.py
setup.cfg
tox.ini
pytest.ini
```
不同工具各管各的，后来 Python 推出了：**pyproject.toml**统一配置。
现在现代 Python 项目基本都用它。

---

# 二、文件名拆解

```text
pyproject.toml
py是python；project是项目；toml配置文件格式（TOML 是一种配置文件格式。）
```

---

# 四、一个典型 pyproject.toml

例如：

```toml
[project]
name = "fastapi-demo"
version = "0.1.0"
description = "My FastAPI Project"
requires-python = ">=3.11"

dependencies = [
    "fastapi",
    "uvicorn",
    "pydantic"
]

[tool.pytest.ini_options]
testpaths = ["tests"]

[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
```

---

# 五、逐块解释

---

## 1. project

```toml
[project]
```

项目基本信息。

类似 Maven：

```xml
<groupId>
<artifactId>
<version>
```

---

### name

```toml
name = "fastapi-demo"
```

项目名。

---

### version

```toml
version = "0.1.0"
```

版本号。

---

### description

```toml
description = "My FastAPI Project"
```

项目描述。

---

### requires-python

```toml
requires-python = ">=3.11"
```

要求 Python 版本。

表示：

```text
Python 3.11+
```

---

## 2. dependencies

```toml
dependencies = [
    "fastapi",
    "uvicorn",
    "pydantic"
]
```

项目依赖。
类似：
```text
requirements.txt
```
安装时：
```bash
uv sync
```

或者：
pip install .
```
会自动安装这些库。

---

# 六、tool.xxx 是什么

---
```toml
[tool.black]
```
意思：
```text
black 工具的配置
```

---

```toml
[tool.ruff]
```
意思：
```text
ruff 工具的配置
```

---

```toml
[tool.pytest.ini_options]
```
意思：
```text
pytest 的配置
```

---

所以：
```text
tool.xxx
```
本质：
```text
给第三方工具放配置
```

---

# 七、为什么现在很多项目只有 pyproject.toml
因为：
```text
它已经统一了整个 Python 工程生态
```
现在：

- uv
    
- poetry
    
- pytest
    
- ruff
    
- black
    
- hatch
    
- mypy
    

都支持它。

---

# 八、和 requirements.txt 的区别

---

## requirements.txt

只是：

```text
依赖列表
```

例如：

```text
fastapi==0.115.0
uvicorn==0.30.0
```

功能有限。

---

## pyproject.toml

不仅能：

- 管依赖
    

还能：

- 管项目
    
- 管测试
    
- 管格式化
    
- 管构建
    
- 管发布
    
- 管 lint
    
- 管类型检查
    

---

# 九、现代 Python 项目典型结构

```text
project/
├── pyproject.toml
├── .venv/
├── svc/
├── tests/
└── README.md
```

---

# 十、uv 为什么依赖 pyproject.toml

例如：

```bash
uv add fastapi
```

本质：

```text
修改 pyproject.toml
```

自动写入：

```toml
dependencies = [
    "fastapi"
]
```

然后：

- 下载依赖
    
- 更新锁文件
    

---

# 十一、真实 FastAPI 示例

例如：

```toml
[project]
name = "my-fastapi-app"
version = "0.1.0"
requires-python = ">=3.11"

dependencies = [
    "fastapi",
    "uvicorn[standard]",
    "sqlalchemy",
    "pydantic-settings"
]

[tool.ruff]
line-length = 100

[tool.pytest.ini_options]
pythonpath = ["."]
```

---

# 十二、整体理解

你可以把：

```text
pyproject.toml
```

理解成：

```text
Python 项目的“大脑配置文件”
```

负责：

```text
项目信息
    ↓
依赖管理
    ↓
工具配置
    ↓
构建发布
    ↓
测试格式化
```

现代 Python 工程基本都围绕它运行。