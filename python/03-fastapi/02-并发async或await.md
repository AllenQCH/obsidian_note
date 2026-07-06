## 并发 + 并行: Web + 机器学习[¶](https://fastapi.tiangolo.com/zh/async/#concurrency-parallelism-web-machine-learning "Permanent link")
使用 **FastAPI**，你可以利用 Web 开发中常见的并发机制的优势（NodeJS 的主要吸引力）。
并且，你也可以利用并行和多进程（让多个进程并行运行）的优点来处理与机器学习系统中类似的 **CPU 密集型** 工作。
这一点，再加上 Python 是**数据科学**、机器学习（尤其是深度学习）的主要语言这一简单事实，使得 **FastAPI** 与数据科学/机器学习 Web API 和应用程序（以及其他许多应用程序）非常匹配。

## async 和 await
要使 `await` 工作，它必须位于支持这种异步机制的函数内。因此，只需使用 `async def` 声明它：
`async def get_burgers(number: int):     # 执行一些异步操作来制作汉堡    return burgers`
而不是 `def`:
这不是异步的 def get_sequential_burgers(number: int):     # 执行一些顺序操作来制作汉堡    return burgers`

使用 `async def`，Python 就知道在该函数中，它将遇上 `await`，并且它可以"暂停" ⏸ 执行该函数，直至执行其他操作 🔀 后回来。
当你想调用一个 `async def` 函数时，你必须"等待"它。因此，这不会起作用：
`# 这样不行，因为 get_burgers 是用 async def 定义的 burgers = get_burgers(2)`
因此，如果你使用的库告诉你可以使用 `await` 调用它，则需要使用 `async def` 创建路径操作函数 ，如：
`@app.get('/burgers') async def read_burgers():     burgers = await get_burgers(2)    return burgers`

await 只能在 `async def` 定义的函数内部使用。
但与此同时，必须"等待"通过 `async def` 定义的函数。因此，带 `async def` 的函数也只能在 `async def` 定义的函数内部调用。


## 协程
**协程**只是 `async def` 函数返回的一个非常奇特的东西的称呼。Python 知道它有点像一个函数，它可以启动，也会在某个时刻结束，而且它可能会在内部暂停 ⏸ ，只要内部有一个 `await`。

通过使用 `async` 和 `await` 的异步代码的所有功能大多数被概括为"协程"。


## 结论

让我们再来回顾下上文所说的：

> Python 的现代版本可以通过使用 `async` 和 `await` 语法创建**协程**，并用于支持**异步代码**。

现在应该能明白其含义了。✨