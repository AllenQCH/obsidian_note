# Workspace Onboarding Rule

进入目录时：

1. 如果根目录 `AGENTS.md` 声明了 `Workspace Type`，直接遵守。
2. 如果没有 workspace type，先简要检查目录。
3. 只问一次：`这是已有项目、新项目，还是杂事空间？`
4. 用户回答后，创建或更新根目录 `AGENTS.md`，写入 workspace type 和 entry rules。
5. 后续会话遵守根目录 `AGENTS.md`，除非用户明确要改变类型。

## Workspace Types

### Existing project

- 使用项目 `AGENTS.md`。
- 持久知识放在项目 `docs/`、`openspec/` 或 `.codex/`。

### New project

- 先明确目标和约束。
- 创建项目结构、根目录 `AGENTS.md` 和 `docs/project-brief.md`。

### Miscellaneous workspace

- 不假设这是软件项目。
- 不主动写入项目 docs，除非用户明确要求。

推荐杂事目录：

```text
/Users/heytea/Documents/HeyTea/codex-workspace
```

避免使用 `code`、`project`、`repo` 这类泛名作为杂事空间。

