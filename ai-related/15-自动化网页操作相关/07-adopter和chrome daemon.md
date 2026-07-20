### 1. Adapter 是什么？
你可以把 Adapter 理解成：
> 某个网站的“专属驱动程序”。
例如：
你公司的发流水线页面：
- 点击登录
- 选择环境
- 输入分支
- 点击发布

对于人来说很简单，但 AI 不知道：
- 哪个按钮是发布
- 哪个输入框是分支
- 成功状态长什么样
所以要写 Adapter：
```python
publish_pipeline(
    env="prod",
    branch="master"
)
```
内部：
```python
1. 找到分支输入框
2. 输入 master
3. 找到发布按钮
4. 点击
5. 等待成功提示
```

### 没有 Adapter
AI 只能看到：
```html
<div class="btn_xxx_123">
```
它需要猜：
```text
这个是不是发布按钮？
```
容易出错。
### 有 Adapter
AI 直接调用：
```text
publish_pipeline()
```
成功率高很多。
所以：
```text
没有 Adapter
↓
AI 猜页面

有 Adapter
↓
AI 调用业务能力
```
这就是为什么 OpenCLI 强调 Adapter。



## 2. 为什么网站改版后 Adapter 会失效
例如今天页面：
```html
<button id="publish">
```
Adapter：
```python
page.click("#publish")
```
下周前端改版：
```html
<button id="submit-release">
```
那么：
```python
page.click("#publish")
```
直接报错。

再比如：
以前：
```text
发布成功
```
现在：
```text
流水线执行成功
```
Adapter 的判断逻辑：
```python
if "发布成功" in page.text:
```
也会失效。
所以：
```text
网站升级
↓
DOM变化
↓
Adapter失效
↓
需要维护
```
这是所有 RPA 的通病。


## 3. Chrome / 扩展 / Daemon 是什么

### 3.1、Chrome
OpenCLI 本质上是在控制浏览器。
类似：
```text
AI
 ↓
OpenCLI
 ↓
Chrome
 ↓
网站
```
所以必须有 Chrome。

### 扩展（Extension）
浏览器插件。
例如：
```text
OpenCLI Extension
```
安装到 Chrome 里面。
作用：
- 读取当前页面
- 获取 Cookie
- 获取登录状态
- 与 OpenCLI 通信

相当于：
```text
Chrome ↔ 插件 ↔ OpenCLI
```


### 3.2、Daemon
Daemon = 后台服务。
类似：
```text
opencli daemon
```
一直在电脑后台运行。
作用：
- 接收 AI 命令
- 调用 Chrome
- 执行 Adapter
- 返回结果

架构：

```text
Claude/Codex
      ↓
 OpenCLI
      ↓
   Daemon
      ↓
 Chrome
      ↓
 网站
```


## 为什么能复用登录态？
因为 OpenCLI 用的是你正在登录的 Chrome。
例如：
```text
你登录了公司SSO
↓
Cookie存在Chrome
↓
OpenCLI接管Chrome
↓
自动带上Cookie
```
所以：

```text
不需要重新登录
```

这也是你之前发流水线场景最大的价值。


## 对你公司的流水线场景
实际上最适合的是：

```text
SSO登录
    ↓
Chrome保持登录
    ↓
OpenCLI Adapter
    ↓
发布流水线
```
而不是：
```text
SSO登录 Adapter
发布流水线 Adapter
```
登录本身没必要 Adapter 化。

真正值得 Adapter 化的是：
```text
发流水线
发版审批
查看日志
回滚
查看告警
```
这些业务动作。
所以对于你来说：
```text
SSO = 利用现有Chrome登录态
Adapter = 流水线发布能力
```
这是 OpenCLI 最典型、最有价值的使用方式。