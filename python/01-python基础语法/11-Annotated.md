`Annotated` 是 Python 类型注解里的一个增强工具：给类型附加“额外元数据”。
```
from typing import Annotated
或者
from typing_extensions import Annotated
```
基本写法：
```
Annotated[类型, 额外信息]
e.g.：
Annotated[int, "年龄字段"]
意思是：
这是一个 int，  
并且附带说明：年龄字段
```
## 为什么需要
普通类型：age: int；只知道是，类型是 int
但很多框架还需要：
- 参数校验
- 描述信息
- 长度限制
- API文档
- 数据约束
### FastAPI / Pydantic 中非常常见
例如：
```
from typing import Annotatedfrom pydantic import Fieldage: Annotated[int, Field(gt=0)]
```
意思：
```
age 是 int并且必须 > 0
```
### 本质
Annotated不会改变原类型。
它只是：给类型增加附加信息。