以下是 Ghostty 配置分屏布局并绑定文件路径的完整方案。

***

## 核心分屏操作

Ghostty 的分屏通过 `new_split` 动作实现，支持四个方向 ： [ghostty](https://ghostty.org/docs/config/keybind/reference)

- `new_split:right` — 向右新建分屏
- `new_split:down` — 向下新建分屏
- `new_split:left` — 向左新建分屏
- `new_split:up` — 向上新建分屏
- `new_split:auto` — 自动选择最优方向（按当前窗口长边分割）

默认快捷键为 `Cmd+D`（右分屏）和 `Cmd+Shift+D`（下分屏） 。 [x](https://x.com/0xhardman/status/2032463302933332149)

***

## 自定义快捷键绑定分屏

编辑配置文件 `~/.config/ghostty/config`，通过 `keybind` 重新绑定分屏方向 ： [mintlify](https://www.mintlify.com/ghostty-org/ghostty/cli/list-actions)

```ini
# 用 Cmd+\ 向右分屏，Cmd+- 向下分屏
keybind = super+backslash=new_split:right
keybind = super+minus=new_split:down

# 用 Vim 风格在分屏间跳转
keybind = super+alt+h=goto_split:left
keybind = super+alt+l=goto_split:right
keybind = super+alt+j=goto_split:down
keybind = super+alt+k=goto_split:up

# 放大/还原当前分屏
keybind = super+z=toggle_split_zoom
```

***

## 绑定特定文件路径到分屏

Ghostty **原生不支持**在 `keybind` 里直接指定 `--working-directory` 打开分屏。实现"按快捷键在指定目录开新分屏"的主流方案有以下两种：

### 方案一：Shell 函数 + 外部脚本（推荐）

创建一个 shell 函数，在指定目录启动新 Ghostty 窗口（非分屏） ： [github](https://github.com/ghostty-org/ghostty/issues/1392)

```bash
# 加入 ~/.zshrc
function gcd() {
  ghostty --working-directory="$1" &
}

# 使用示例：在项目目录打开新窗口
gcd ~/projects/my-app
```

### 方案二：keybind + `send_text` 模拟 cd

通过 `send_text` 在新分屏建立后自动发送 `cd` 命令 ： [mintlify](https://www.mintlify.com/ghostty-org/ghostty/cli/list-actions)

```ini
# 右分屏后自动 cd 到项目目录
keybind = super+shift+p=new_split:right,send_text:cd ~/projects/my-app\n
```

> ⚠️ `send_text` 会直接输入到 shell，依赖 shell 集成正常工作。

***

## 分屏布局预设（通过 Shell 脚本）

Ghostty 本身没有原生"布局预设"功能，可以用 shell 脚本模拟 。创建文件 `~/.config/ghostty/layouts/dev.sh`： [github](https://github.com/ghostty-org/ghostty/issues/1392)

```bash
#!/bin/bash
# 开发布局：左侧编辑器 + 右侧终端 + 下方日志
ghostty \
  --working-directory=~/projects/my-app \
  -- zsh -c "nvim . & sleep 0.5 && ghostty --working-directory=~/projects/my-app" &
```

更实用的替代方案是配合 **tmux** 或直接在 `~/.zshrc` 中定义布局函数：

```bash
# ~/.zshrc 中定义项目布局快捷函数
function dev-layout() {
  # 假设已在 Ghostty 中，通过 ghostty CLI 打开多窗口
  ghostty --working-directory=~/projects/my-app &
  ghostty --working-directory=~/projects/my-app/backend &
  ghostty --working-directory=~/projects/my-app/frontend &
}
```

***

## 分屏导航快捷键速查

| 操作 | 默认快捷键 |
|---|---|
| 右分屏 | `Cmd+D` |
| 下分屏 | `Cmd+Shift+D` |
| 切换到上一个分屏 | `Cmd+[` |
| 切换到下一个分屏 | `Cmd+]` |
| 均分所有分屏大小 | 可自定义绑定 `equalize_splits` |
| 重载配置 | `Cmd+Shift+,` |

 [juejin](https://juejin.cn/post/7467618287381397567)

***

## 配置文件拆分（多项目管理）

可以将不同项目的配置分文件管理，主配置中引入 ： [ghostty](https://ghostty.org/docs/config)

```ini
# ~/.config/ghostty/config
config-file = themes/my-theme
config-file = ?projects/work   # 可选文件，不存在不报错
```

这样不同项目的 `keybind`、`working-directory` 等配置可以模块化维护。