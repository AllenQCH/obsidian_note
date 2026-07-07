# How we contain Claude across products

- 原文链接：https://www.anthropic.com/engineering/how-we-contain-claude
- 推荐理由：看 Anthropic 怎么做“能力越强、边界越严”的产品级安全设计。
- 阅读日期：2026-07-07

## 阅读关注点
- containment
- blast radius
- environment layer vs model layer
- Claude Code / Cowork / claude.ai
- agent security

## 一句话总结
这篇文章最核心的结论是：**agent 安全不能只靠模型层的“别乱来”，真正决定上线边界的是 containment——优先在 environment layer 上把 blast radius 硬性锁住，再用 model layer 去引导行为。**

## 中英对照笔记

### 1. The engineering question: how to cap the blast radius
**English**
As agents gain more access and capability, the key engineering question becomes how to cap the **blast radius**.

**中文**
随着 agent 拿到越来越强的能力和访问权限，最核心的工程问题就变成：怎么限制 **blast radius**。

**我的理解**
- 文章一开始就把焦点从“能不能做”切到“就算出事，能坏到什么程度”。
- 这是一种非常工程化、非常现实的安全观。

### 2. Two ways to reduce risk
**English**
Anthropic contrasts two approaches:
- human-in-the-loop supervision
- containment through access boundaries

**中文**
Anthropic 对比了两条路线：
- human-in-the-loop 监督
- 通过访问边界做 containment

**我的理解**
- 他们并没有完全否定 human-in-the-loop，但明确指出它会出现 **approval fatigue**。
- 文中提到 Claude Code 早期用户大约会批准 93% 的 permission prompts，这说明单靠人盯着批并不稳。

### 3. Three types of risk, three components of defense
**English**
They classify risks into:
- user misuse
- model misbehavior
- external attackers

And defenses into three layers:
- the environment
- the model
- the external content the agent can reach

**中文**
他们把风险分成三类：
- **user misuse**
- **model misbehavior**
- **external attackers**

把防御对象分成三层：
- **environment**
- **model**
- **external content**

**我的理解**
- 这篇文章最值得记的框架之一，就是“风险分类 × 防御层级”的二维视角。
- 它提醒我们：安全不是只看 prompt injection，也不是只看模型对齐。

### 4. Pattern 1: The ephemeral container (claude.ai)
**English**
For claude.ai code execution, Claude runs server-side inside an ephemeral container with minimal blast radius.

**中文**
在 claude.ai 的代码执行场景里，Claude 运行在服务端的 **ephemeral container** 中，blast radius 很小，但能力上限也有限。

**我的理解**
- 这是“能力小、边界紧”的典型设计。
- 没有 persistent workspace，没有本地文件系统访问，所以天然更安全。

### 5. Pattern 2: The human-in-the-loop sandbox (Claude Code)
**English**
Claude Code started with user approvals for sensitive actions, then added an OS-level sandbox to reduce approval fatigue and harden the boundary.

**中文**
Claude Code 最开始主要依靠用户审批敏感动作，后来又加了 OS-level sandbox，来降低 approval fatigue 并强化边界。

**文中关键信号**
- 加 sandbox 后 permission prompts 显著下降
- experienced users 会更频繁 auto-approve，也更常中途打断 agent
- 这说明“专家用户监督”虽然可行，但仍然不稳

**我的理解**
- 文章的意思很明确：光靠用户监督很脆弱，必须配硬边界。
- 尤其是多 agent 场景，人工逐条盯会越来越不现实。

### 6. Risks they missed
**English**
The article shares several failures they encountered:
- code executing before the trust dialog
- the user as an injection vector
- exfiltration through an approved domain
- endpoint detection losing visibility because of VM isolation

**中文**
文章很有价值的一点，是它公开讲了自己踩过的坑：
- trust dialog 之前就执行了项目配置
- 用户本身也可能是 injection vector
- 数据可能通过“批准过的域名”被 exfiltrate
- VM 隔离也可能让企业的 EDR 看不到里面发生了什么

**我的理解**
- 这些案例说明：真正危险的常常不是“完全没想到的神奇攻击”，而是**信任边界放错了地方**。
- 比如 allowlist 如果只按 destination 看，而不是按 capability 看，就会漏掉“借正规 API 做坏事”的路径。

### 7. Pattern 3: The local VM (Claude Cowork)
**English**
Claude Cowork uses a local VM to isolate workspace access for less technical users, since they cannot be expected to judge shell commands safely.

**中文**
Claude Cowork 用本地 VM 来隔离工作区访问，因为目标用户不是开发者，不能指望他们安全判断 shell 命令。

**我的理解**
- 这段特别重要：**containment strategy 要匹配用户的监督能力。**
- 开发者和非技术知识工作者，不是同一个 threat model。

### 8. Trusting what the agent reads
**English**
Tool output is itself an attack surface, even if the tool is trusted. Connectors and MCP servers must be treated as both code-execution risk and prompt-injection vectors.

**中文**
即使 tool 本身可信，**tool output** 仍然是攻击面。MCP server、connector、网页结果既可能带来传统供应链风险，也可能带来 prompt injection。

**我的理解**
- 这和你后面做多工具 / 多 agent 编排非常相关。
- “工具可信 ≠ 工具输出可信”。
- 所以返回值检查、代理层扫描、小模型 classifier 都是值得考虑的中间层。

### 9. Summary principles
**English**
Anthropic’s repeated principles are:
- design for containment at the environment layer first
- match isolation strength to the user's capacity for oversight
- be wary of custom components

**中文**
Anthropic 反复回到三条原则：
- **先做 environment layer 的 containment**
- **隔离强度要匹配用户监督能力**
- **对自研组件保持警惕**

**我的理解**
- 文中反复指出：很多真正出问题的不是 gVisor、hypervisor 这些成熟组件，而是自己额外拼出来的代理层、allowlist 逻辑、trust 边界代码。

## 最重要的 3 个观点
1. **agent 安全的第一优先级是 containment，不是“希望模型别乱来”。**
2. **environment、model、external content 三层防御要叠加，而不是单押一层。**
3. **containment 方案必须匹配用户能力和产品形态，开发者工具与知识工作工具不能一刀切。**

## 可以迁移到我自己工作流/产品里的点
- 对 agent / tool / MCP 的设计，优先先问“最坏能坏到哪”，再谈能力开放。
- 把权限分层：read-only、workspace-only、network-deny-by-default 之类的边界应成为默认思路。
- 把 tool output 视为不完全可信输入，必要时做返回值扫描或中间层过滤。
- 尽量依赖 battle-tested containment primitives，少自己发明安全边界。
- 在多 agent 场景里，警惕 sub-agent trust escalation——别因为“这是自己 agent 返回的”就默认更可信。

## 仍然没想明白的问题
- 在个人工作流里，最小可用的 containment 方案应该做到什么程度才算“足够实用”？
- 对本地 MCP / 外部 connector，什么样的 capability granularity 才既安全又不太烦？
- 多 agent 结果回传时，怎样防止 trust escalation 同时又不把系统搞得太慢？

## 想继续延伸阅读的关键词
- containment
- blast radius
- human-in-the-loop
- environment layer
- prompt injection
- egress controls
- trust escalation
- agent security

## 相关链接
- [[Anthropic 学习总览]]
- [[01-Engineering/_index|01-Engineering]]
- [[01-Building-effective-agents]]
- [[04-How-we-built-our-multi-agent-research-system]]
- [[Hermes agent总览]]
- [[my-multi-agents总览]]
