# GitHub 同步说明

目标仓库：

```text
https://github.com/AllenQCH/obsidian_note
```

## 当前状态

当前 Codex 沙箱无法解析 `github.com`，所以不能直接 clone、pull 或 push。已先在本地创建 Obsidian vault 结构，并准备好 Git remote。

## 首次推送

在本机有 GitHub 网络和认证的终端中运行：

```zsh
cd /Users/heytea/Documents/HeyTea/codex-workspace/obsidian_note
git push -u origin main
```

如果远端仓库已有内容，先拉取合并：

```zsh
cd /Users/heytea/Documents/HeyTea/codex-workspace/obsidian_note
git pull --rebase origin main
git push -u origin main
```

## 认证方式

推荐使用 GitHub CLI：

```zsh
gh auth login
```

或使用已配置好的 SSH / HTTPS 凭据。不要把 token 写进笔记、脚本或 Git remote URL。

## 日常同步

```zsh
cd /Users/heytea/Documents/HeyTea/codex-workspace/obsidian_note
git pull --rebase
git add .
git commit -m "docs: update codex notes"
git push
```

