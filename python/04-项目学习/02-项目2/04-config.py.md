```python
from functools import lru_cache  
from pathlib import Path  
  
from pydantic_settings import BaseSettings, SettingsConfigDict  
  
ROOT = Path(__file__).resolve().parent.parent  # svc/  
BASE_DIR = ROOT.parent  # ./  
  
class Settings(BaseSettings):  
    api_username: str  
    api_password: str  
    api_secret_key: str  
    api_algorithm: str = "HS256"  
    api_access_token_expire_minutes: int  
  
    model_config = SettingsConfigDict(env_file=BASE_DIR / ".env", extra="ignore")  
  
@lru_cache  
def get_settings() -> Settings:  
    return Settings()
```


# 整体作用：

```
读取项目 .env 配置        
↓
自动转换成 Python 对象        
↓
全项目统一使用        
↓
并且只初始化一次
```

# from functools import lru_cache
从 Python 内置模块 `functools` 导入：lru_cache
这是一个缓存装饰器。
作用：
- 函数第一次执行后，会缓存结果。
- 后续再次调用时，直接返回缓存结果。
后面这里会用到：@lru_cache

# from pathlib import Path
导入：导入：
这是 Python 现代化路径处理工具。
用于：
- 文件路径
- 文件夹路径
- 拼接路径
比传统：os.path更好用。

# from pydantic_settings import BaseSettings, SettingsConfigDict
导入 Pydantic Settings 功能。

BaseSettings：作用：自动读取环境变量；自动读取 `.env`
例如：API_USERNAME=admin；会自动映射到：api_username

SettingsConfigDict：用于：配置 Settings 行为。
例如：
- `.env` 文件位置
- 是否允许多余字段等。

# ROOT = Path(__ file__).resolve().parent.parent
__ file__表示：当前 py 文件路径
例如：/project/svc/config/settings.py
然后：Path(__ file__)变成 Path 对象。然后：.resolve()获取绝对路径。
例如：/Users/allen/project/svc/config/settings.py然后：.parent
上一层目录：/Users/allen/project/svc/config
再：.parent再上一层：/Users/allen/project/svc
所以：ROOT最终代表：svc/目录。

# BASE_DIR = ROOT.parent
继续往上一层：/Users/allen/project也就是项目根目录。
最终：
project/
├── .env
├── svc/

# class Settings(BaseSettings):
定义一个配置类。继承：BaseSettings
后：
- 会自动读取 `.env`
- 自动读取系统环境变量
- 自动做类型转换

# api_username: str
定义配置字段。表示：api_username必须是字符串。会自动读取：API_USERNAME=xxx或者：api_username=xxx

#     api_password: str
同理。

# api_secret_key: str
JWT 或加密密钥。

# api_algorithm: str = "HS256"
定义默认值。如果 `.env` 没配置：API_ALGORITHM那么默认：HS256

#     api_access_token_expire_minutes: int
token 过期时间。例如：API_ACCESS_TOKEN_EXPIRE_MINUTES=30
Pydantic 会自动转成：30整数。

# model_config = SettingsConfigDict(env_file=BASE_DIR / ".env",extra="ignore")
配置 Settings 行为。这里：env_file=BASE_DIR / ".env"表示：从项目根目录读取 .env
例如：project/.env
这里：BASE_DIR / ".env"是 Path 的路径拼接。等价于：project/.env
这里：extra="ignore"表示：.env 中多余字段直接忽略；例如：XXX=123即使类里没有：- 也不报错。

# @lru_cache
装饰器。
作用：- 缓存函数结果。
意味着：get_settings()
只会真正创建一次：Settings()后面都直接复用。
# def get_settings() -> Settings:
定义获取配置的方法。返回：Settings对象。

# return Settings()
实例化配置类。
这里会自动：
- 读取 `.env`
- 读取环境变量
- 做类型转换
- 做字段校验
例如：
`.env`
API_USERNAME=admin
API_PASSWORD=123456
API_SECRET_KEY=abc
API_ACCESS_TOKEN_EXPIRE_MINUTES=30
最终：settings = get_settings()
得到：
settings.api_username 是admin
settings.api_access_token_expire_minutes 是30
