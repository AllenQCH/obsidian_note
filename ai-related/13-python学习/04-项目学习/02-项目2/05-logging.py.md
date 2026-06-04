```python
import logging  
  
def configure_logger() -> None:  
    """Configure a custom logger."""  
  
    # Create a logger  
    logger = logging.getLogger("fnano")  
    logger.setLevel(logging.INFO)  
  
    # Create a handler (console output in this case)  
    console_handler = logging.StreamHandler()  
    console_handler.setLevel(logging.INFO)  
  
    # Create a formatter and set it to the handler  
    formatter = logging.Formatter(  
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s",  
        datefmt="%Y-%m-%d %H:%M:%S",  
    )  
    console_handler.setFormatter(formatter)  
  
    # Add the handler to the logger  
    if not logger.hasHandlers():  
        logger.addHandler(console_handler)  
  
    # Disable propagation to avoid log duplication via uvicorn  
    logger.propagate = False
```


# 整体作用：

```
创建 logger
    ↓
设置日志等级
    ↓
创建控制台输出 handler
    ↓
定义日志格式
    ↓
handler 绑定 formatter
    ↓
logger 添加 handler
    ↓
关闭日志传播
```

# import logging
导入 Python 内置日志模块。
后面会使用：
- logger
- handler
- formatter
这些日志功能。

# def configure_logger() -> None:
定义一个函数：
configure_logger
作用：
- 配置日志系统。
返回值：-> None；表示：不返回任何内容。

#  logger = logging.getLogger("fnano")
创建 logger。
logger 可以理解成：日志对象；名字是："fnano"
后面打印日志时：- 会带这个名字。
例如：2026-01-01 12:00:00 - fnano - INFO - hello

#     logger.setLevel(logging.INFO)
设置日志级别。这里：logging.INFO表示：INFO 级别及以上会输出。
日志等级大概：
DEBUG
INFO
WARNING
ERROR
CRITICAL
当前设置后：

| 等级      | 是否输出 |
| ------- | ---- |
| DEBUG   | ❌    |
| INFO    | ✅    |
| WARNING | ✅    |
| ERROR   | ✅    |

#     console_handler = logging.StreamHandler()
创建 handler可以理解成：。日志输出目标
这里：StreamHandler表示：输出到控制台，也就是终端。

#     console_handler.setLevel(logging.INFO)
设置 handler 的日志等级。
意味着：有 INFO 以上才会真正输出。
logger 和 handler 都可以设置 level。
最终规则：两边都允许
才会输出

#     formatter = logging.Formatter(
创建日志格式器。定义日志长什么样

#         "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
定义日志格式。
含义：

|字段|意义|
|---|---|
|asctime|时间|
|name|logger 名|
|levelname|日志等级|
|message|日志内容|
例如最终日志：
```
2026-05-28 10:00:00 - fnano - INFO - server started
```
对应：

|部分|来源|
|---|---|
|2026-05-28 10:00:00|asctime|
|fnano|name|
|INFO|levelname|
|server started|message|

#         datefmt="%Y-%m-%d %H:%M:%S",
定义时间格式。
例如：
```
2026-05-28 14:30:01
    )
```
Formatter 创建结束。

#     console_handler.setFormatter(formatter)
把 formatter 绑定到 handler。意思：控制台输出时
按这个格式打印

#     if not logger.hasHandlers():
判断：logger 是否已经有 handler
为什么要判断：
因为：configure_logger()可能被调用很多次。

#         logger.addHandler(console_handler)
把 console handler 添加到 logger。
之后 logger 才真正能输出日志。

#    logger.propagate = False
关闭日志传播。
这是 FastAPI / Uvicorn 很常见的配置。
默认情况下：
当前 logger
会继续向父 logger 传递
例如：
fnano
  ↓
root logger
  ↓
uvicorn logger
这样可能导致：日志打印两次
设置：只在当前 logger 输出，不再向上层传播
避免：
- uvicorn 重复打印
- root logger 重复打印
