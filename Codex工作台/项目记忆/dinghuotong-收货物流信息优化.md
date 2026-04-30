# dinghuotong 收货物流信息优化项目记忆

适用目录：

```text
/Users/heytea/Documents/HeyTea/code/dinghuotong_1.0.1
```

## 需求背景

- 需求标识：`p35_15078 收货物流信息优化`
- OpenSpec change id 优先使用：`optimize-receiving-logistics-info`
- 已有历史 OpenSpec 目录也可能使用：`2026-04-15-p35_15078 收货物流信息优化（国内）`
- 需求核心：收货物流预计到货时间从单点时间扩展为时间窗口，并兼容旧字段。

## 分支规则

- `hsp-pof-domain` 使用 `feature/2.0.1` 分支。
- 除 domain 外，本次相关项目使用 `feature/p35_15078收货物流信息优化` 分支。

## 字段和业务规则

- 旧字段 `expectArriveTime` 必须保持原来的取值逻辑。
- 如果旧字段原本取不到值，则返回空；只做空指针保护，不使用窗口字段覆盖旧字段。
- 新增窗口字段：
  - `earliestExpectArriveTime`
  - `latestExpectArriveTime`
- 涉及预计到货文案时，优先展示 `earliestExpectArriveTime - latestExpectArriveTime`。
- 若窗口字段为空，则兜底使用原 `expectArriveTime` 文案逻辑。
- 若窗口字段和旧字段都为空，文案返回空且不能报错。
- 窗口成对有效性由上游传入时保证，当前消费链路不额外校验，只做 null-safe。

## 本次涉及项目

- `hsp-pof-domain`
- `center-hsp-pof`
- `manager-hsp-pof-biz`
- `manager-hsp-pof`
- `manager-hsp-pof-external`
- `manager-hsp-pom-integration`
- `manager-hsp-pom-order`
- `service-hsp-pom-app`
- `service-hsp-pom-web`
- `service-hsp-pom-bedrock`

## OpenSpec 约定

- 每个涉及项目都要有 OpenSpec 文档链路：
  - `proposal.md`
  - `tasks.md`
  - `specs/*/spec.md`
- 前端对接文档可以额外放在对应 change 下的 `frontend/` 目录。
- 文档正文应尽量使用中文描述。
- OpenSpec 结构关键字需要保留：
  - `ADDED Requirements`
  - `MODIFIED Requirements`
  - `Requirement:`
  - `Scenario:`
- OpenSpec 校验要求 Requirement 正文包含 `SHALL` 或 `MUST`，中文文档中可写成 `MUST（必须）...`。
- 修改后需要执行 `openspec validate <change-id> --strict`。
- 可使用 `env POSTHOG_DISABLED=1 openspec validate ... --strict` 减少 PostHog 网络上报噪声。

## 前端对接点

APP：

- `POST /pof/sh/page`
- `POST /pof/sh/scan/list`
- `POST /pof/sh/detail`
- `POST /pof/sh/deliveryInfo`
- 新增字段：`earliestExpectArriveTime`、`latestExpectArriveTime`
- 修改文案字段：`expectArrivalMsg`、`expectArriveMsg`、`expectArrivalShow`
- 首页 `label` 判断优先使用 `latestExpectArriveTime`

Web / 磐石：

- `POST /biz-order/expressInfo`
- 响应模型：`ExpressInfoVO`
- 新增字段：`earliestExpectArriveTime`、`latestExpectArriveTime`
- 修改文案字段：`expectTimeText`

## 已知注意事项

- 根目录 `/Users/heytea/Documents/HeyTea/code/dinghuotong_1.0.1` 不是 git 仓库，子目录分别是独立仓库。
- `hsp-pof-domain` 曾出现未跟踪 `.DS_Store`，不要纳入提交。
- 文档改动提交前需要跑：
  - `git diff --check`
  - `git diff --cached --check`
  - `openspec validate ... --strict`

