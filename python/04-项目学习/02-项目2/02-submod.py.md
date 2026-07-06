```python
# This is a dummy module.  
# This gets called in mainmod.py.  
  
from __future__ import annotations  --从 Python 官方的 __future__ 模块
  
import random  
  
  
def rand_gen(num: int) -> dict[str, int]:  
    num = int(num)  
    d = {  
        "seed": num,  
        "random_first": random.randint(0, num),  
        "random_second": random.randint(0, num),  
    }  
    return d
```

# 整体流程
传入 num
   ↓
转成 int
   ↓
生成两个随机数
   ↓
组装成 dict
   ↓
return 返回



# 1、from __future__ import annotations  
从 Python 官方的 __future__ 模块导入 annotations 功能
导入 Python 的未来特性。
作用：
- 类型注解不会立即解析
- 会延迟处理
一般用于：
- 避免循环引用
- 提升类型提示兼容性

现在很多现代 Python 项目都会加。

# 2、import random  
导入随机数模块。random.randint()生成随机整数。

# 3、def rand_gen(num: int) -> dict【  str, int ]:
## 定义函数。函数名：rand_gen

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


## d = {
定义一个字典。


## "seed": num,
key：
- `"seed"`
value：
- `num`



## "random_first": random.randint(0, num),
生成一个随机整数。
意思：
- 在 `0 ~ num` 之间随机取一个整数。
- 包含两边。


## return d
返回字典。