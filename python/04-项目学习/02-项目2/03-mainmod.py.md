```python
from __future__ import annotations  

from .submod import rand_gen  
  
def main_func(num: int) -> dict[str, int]:  
    d = rand_gen(num)  
    return d
```

# 整体流程
调用 main_func(10)
        ↓
调用 rand_gen(10)
        ↓
submod.py 生成随机数据
        ↓
得到 dict
        ↓
return 返回

整个 `main_func` 本质上是：对 rand_gen 的再次封装


# 1、from __ future__ import annotations 
从 Python 官方的 __ future__ 模块导入 annotations 功能
导入 Python 的未来特性。
作用：
- 类型注解不会立即解析
- 会延迟处理
一般用于：
- 避免循环引用
- 提升类型提示兼容性

现在很多现代 Python 项目都会加。

# 2、from .submod import rand_gen  
这是“相对导入”。
从当前包里的 submod.py
导入 rand_gen 函数

# 3、def main_func(num: int) -> dict【str, int]:  
## 定义函数。函数名：main_func
## num: int
表示：
- 参数名是 `num`
- 期望类型是 `int`
## -> dict[str, int]
表示返回：字典
## num = int(num)
把传入值强制转成整数。
例如：rand_gen("10")，这里 `"10"` 是字符串。执行后：num = 10
为什么需要：
- 防止用户传字符串。
- 保证后面 `random.randint` 正常运行。


##     4、d = rand_gen(num)
调用rand_gen并传进去

## 5、return d
返回字典。