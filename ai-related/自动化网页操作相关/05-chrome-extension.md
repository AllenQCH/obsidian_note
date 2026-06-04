
# 0、使用chrome extension
```text
用户
 ↓
Extension
 ↓
固定脚本
 ↓
Playwright
 ↓
Chrome headless mode

```

# 1. Extension 模式
你写：
```
step1()
step2()
step3()
step4()
```
流程是固定的。
例如：
```
点击发布
↓
选择环境
↓
确认
↓
结束
```
用户只能：
```
触发这个流程
```
不能改变流程。
本质：
```
用户
 ↓
Extension
 ↓
固定脚本
 ↓
Playwright
 ↓
Chrome
```

### Extension= 固定流程自动化=开发者提前写好的（全部提前编码）
像：
```
Shell脚本/python脚本
```
你提前写好：
```
A → B → C → D
```
执行即可。

# 4. Playwright 在extension/opencli中其实一样

你说的这部分是正确的：

```
OpenCLI
    ↓
Playwright
```

和：

```
Extension
    ↓
Playwright
```

底层都可能调用：

```
goto()
click()
fill()
```

没有区别。