# 用 Claude Mods 升级 Working Genius — 设计稿

状态：三步都已落地并实测，见 §7，pane 也已做（kit 证明绘制，终端里看到它仍是待做的交互式测量）。写于 2026-09-23，对照 Claude Code 2.1.280 与 `anthropics/claude-code` 仓库 `mods/` 目录（类型声明由 2.1.277 生成）。本文所有"已测"均为本日在本仓库副本上的一手实测，命令与最小复现件见附录 A。

## 0. 一句话结论

Mods 不替代 skills；对这个插件而言，它恰好接住了 CLAUDE.md 里"只有 Claude Code 读的三样东西"中最脆的两样——**两个 judge** 和 **agent 的 preload**——并且第一次让**地图能常驻屏幕而不占模型上下文**。建议分三步，每一步都是**加法**：classic 机制原样保留做兜底，直到 function hooks 正式发布。

不做的事同样明确：任何让 flow 自己推进的 hook、任何解析 work file 散文并做决定的脚本，都不因为"mod 能做到"而复活（rulings `0cc21de`、`925accf`、`275ed4f`、`f8897e9` 不变）。

## 1. Claude Mods 是什么（一手来源）

- **来历。** issue anthropics/claude-code#91870：9 月 3 日以 "function hooks" 提案，9 月 9 日定名 **Claude Mods**，"a mod is just a plugin that uses function hooks"；built-in 的 `diff`（`/diff` 面板，2.1.260）和 `agents-md`（`AGENTS.md` 读取，2.1.277）都以 mod 形态发布，源码公开在 `mods/`。
- **形态。** 普通插件目录，多一个 `hooks/hooks.json` 写 `{"modules": ["./register.ts"]}`；模块导出 `register(on, options)`；每个 hook 是 `($, e, next)`：`$` 是引擎给的唯一世界入口，`e` 冻结的事件，`next` 链上的下一层——Express/Koa 式嵌套，先注册的包住后注册的。五个 tier：`prepend`（组织）、`user`（用户装的，本插件在此）、`builtin`、`append`、`core`。
- **环境。** 无 Node、无 DOM 的 ES module，TypeScript 进程内转译；副作用只能经 `$`，`claude plugin validate` 对模块做静态分析并列出它 hook 了什么、调了 `$` 的什么（已测：把 `$` 传给非顶层函数直接被判不合法）。
- **工具链。** `/plugin-types` 生成 `claude-code.d.ts`；`claude plugin validate <dir>`；`claude plugin test <dir>` 在引擎自己的宿主里跑 `*.test.ts`，`$` 以下的世界由 `mock` 从内存回答；`claude plugin eval`（2.1.269 已发布——这是 CLAUDE.md 里"claude plugin eval, when it opens, is the next measurement"等的那个测量，**它已经开了**）。
- **状态。** Early access：`CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1` 才装载模块；"API may change between releases without notice"（已测到一处漂移，见 §2）。Team/Enterprise 且有 managed settings 的机器上，built-in `sec-default` 坐最外层，把 `classic.*`、`skill.prompt`、`prompt.section`、`prompt.context`、`attribution.text`、`settings.read` **越过 user tier** 直接交给组织层——即用户装的 mod 在这些事件上不运行。`$.process.run` 标注 "CLI only"。

本插件用得上的事件与名词（全部来自 `claude-code.d.ts`）：

| 事件 / 名词 | 能做什么 | 本插件的对应 |
|---|---|---|
| `classic.Stop` / `classic.SubagentStop` | 收到与 settings hook 相同的 stdin JSON（`stop_hook_active`、`last_assistant_message`、`agent_type`…），返回 `{ block }` 即拦停 | 两个 judge |
| `skill.prompt` | skill 展开给模型时触发（`/name`、Skill 工具、**preload**），可改写文本 | "按调用而非按安装"的布防信号；测 preload 是否到达 |
| `agent.spawn` | Agent 工具启动子代理前，可改写 `prompt`、`model`，或 `deny` | 给 inventor / builder / reviewer 的 preload 上保险 |
| `session.compact` | 压缩前，可改写 `instructions` 或消息 | 压缩后"重读快照"的规则从散文变成引擎行为 |
| `tool.call` | 任一工具调用前后，可给结果附 `context` | 写快照的那一刻报字符数 |
| `ui.open` / `ui.render` / `ui.status` | 侧栏 pane、状态行 | `/genius` 的算术常驻屏幕 |
| `$.model.complete` / `$.model.classify` | 用会话自己的客户端与凭据做一次补全 | 替代嵌套 `claude -p` |
| `$.process.run` / `$.fs.*` / `$.agent.list` / `$.store` | 跑 measure.py、读工作文件、看有无子代理在跑、按插件持久化 | 三个免费检查 |

## 2. 实测（2026-09-23，Claude Code 2.1.280，本仓库副本）

| # | 试了什么 | 结果 |
|---|---|---|
| 1 | 把整个插件（22 个 skill、3 个 agent、`/enable` `/tenacity` frontmatter 里的 classic hooks）复制一份，加 `hooks/hooks.json` + `hooks/register.ts` | `claude plugin validate --strict` 通过，并列出模块 hook 的事件与 `$` 调用；`CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 claude plugin test` 跑通。**一个插件同时带 skills、agents、classic hooks 和 hooks module，没有冲突。** |
| 2 | `claude -p "/genius"` 下记录事件顺序 | `session.start` → `skill.prompt`（skill 名是 `workinggenius:genius`；**文本进来时 `!` 注入已经完成**：进出都 4973 字符，`work dir:` 可见，原始 ` ```! ` 块不可见）→ `prompt.submit`（origin `sdk`）→ `classic.Stop`（**settings 里没有任何 Stop hook 也照样触发**；`$.agent.list()` 可用）→ `turn.complete`。 |
| 3 | user-tier 的 `classic.Stop` hook 返回 `{ block: '…回复 CONTINUED' }` | 模型收到理由作为下一条指令，回复 `CONTINUED`；第二次 `classic.Stop` 带 `stop_hook_active=true`；`num_turns=2`。**拦停语义与 exit 2 的 command hook 完全一致。** |
| 4 | `$.process.run(['python3','-c','print(7)'])`、`$.session.root()`、`import.meta.url`、`$.env.get('CLAUDE_PLUGIN_ROOT')` | 前三个可用（`import.meta.url` 给出模块自身路径，插件根目录由此可得）；`CLAUDE_PLUGIN_ROOT` 在模块环境里 **undefined**。 |
| 5 | `$.model.complete({model:'haiku', prompt})` | 返回 **对象** `{ isAnswered: true, text: 'PONG', usage }`，而 2.1.277 的声明写的是 `string`——early access 的漂移，代码要两种都读。 |
| 6 | `$.model.classify(text, ['announces-own-next-step','ok'])` | 能答；但两个光秃秃的标签把一段 `/genius` 地图判成了 "announces-own-next-step"（误报）。**judge 的条件文本必须原样经 `complete` 的 `system` 传入，不能压成 classify 的标签。** |
| 7 | 附录 B 的 step-1 草案模块 | `validate --strict` 通过（hook：`skill.prompt`、`classic.Stop`、`classic.SubagentStop`；调用：`$.agent.list`、`$.fs.read`、`$.model.complete`、`$.process.run`、`$.ui.log`）；kit 测试通过。 |

另：hook 自身预算 10 s，`next(e)` 与 `$` 调用期间不计时（`HookBudget`），一次 haiku 判决不会撞预算；judge 一次 haiku 调用约 $0.02 量级。

未测、需要下一步测的：交互式终端（非 `-p`）下 #3 是否同样；`SubagentStop` 在 function hook 下 `agent_type` 的实际取值；模块**允许**放行时 classic 的 command hook 是否也跑一遍（双判）；managed 组织机器上的表现；`$.process.run` 在 Desktop 上是否存在。

## 3. 设计：三样东西逐个对上

### 3.1 Judge → `classic.Stop` / `classic.SubagentStop` function hook（第一步，建议做）

**现状。** `stop-judge.py` 是 command hook，由 `/enable`（`Stop` + `SubagentStop` 匹配 builder）和 `/tenacity`（`Stop`）的 frontmatter 注册；三个免费检查后，嵌套 `claude -p --model haiku`（不能 `--bare`，否则读不到 OAuth；45 s 超时；cwd 挪到 temp 以避开项目指令文件）；自身任何失败都放行。

**新形态。** `hooks/register.ts` 注册 `classic.Stop` 与 `classic.SubagentStop`。三条不变的原则各有落点：

- **按调用布防，绝不按安装。** 模块随插件装载于每个会话，但 judge 只在 `skill.prompt` 看到 `workinggenius:enable` 或 `workinggenius:tenacity` 之后才布防（一个会话级标志）；此前每个 Stop 都是 `next(e)` 直通。这与 frontmatter 注册的语义完全一致，且天然满足 `0e441b8` 测出的"要能撑完整个会话"（标志活到会话结束）。这一条要写进 CLAUDE.md 作为对"plugin-level hooks.json 每个会话都触发"那句的补充：**装载的是模块，布防靠调用**。
- **三个免费检查照旧。** `stop_hook_active`；`$.agent.list()` 里有 `running` 的子代理 → 放行（替代解析 `background_tasks`）；`work_in_build` 仍是"读一个 frontmatter 字段"——通过 `$.process.run` 跑 `measure.py status`，在输出里找 `stage: enablement|tenacity`。计数的家仍是 instrument，TypeScript 里不新增任何对工作文件的解析。
- **判断是模型的，不写任何文件。** `$.model.complete({ model: 'haiku', system: <条件>, prompt: <message> })`，只在清晰的 `{"ok": false, "reason"}` 时返回 `{ block: reason }`；一切异常 → `next(e)`，并用 `$.ui.log(…, { to: 'debug' })` 留痕（替代 `WG_STOP_JUDGE_LOG` 环境变量）。

**得到什么。** 不再嵌套一个 CLI 进程（OAuth/`--bare`、cwd、45 s 墙都消失）；用会话自己的客户端与凭据；判决逻辑可被 `claude plugin test` 用 mock 的 `model.complete` 做 block/allow 矩阵测试——这个仓库第一次有了可以跑的测试。

**必须保留什么。** frontmatter 的 classic hooks 和 `stop-judge.py` 原样留下做兜底：没开标志的用户没有模块；managed 组织机器上 user-tier 的 `classic.*` 被越过。两个 judge 的条件文本不能有两份——建议移到 `skills/genius-file/judge-conditions.md`（两个 `##` 段），Python 读文件、TS 用 `$.fs.read` 读，一处为家；这一条修改与 CLAUDE.md "The judge text is copied into enable and tenacity deliberately" 不冲突（那句说的是 frontmatter 不能指向文件，这里是脚本与模块之间）。

**要测的一件事。** 模块布防且**放行**时，`next(e)` 会继续跑到 core 里的 settings hooks——也就是 classic 的 `stop-judge.py` 会再判一次。按声明，hook 不调 `next` 而直接返回 `{}` 即跳过其下所有层；若实测成立，则"模块已判"时返回 `{}`，"模块未布防"时 `next(e)`，双判即消失。

### 3.2 Preload → `agent.spawn`（第二步，先测后保）

**现状。** 三个 agent 的 frontmatter 用 `skills:` 按 scoped name 预载纪律 skill；CLAUDE.md 承认"that the preload reaches a spawned agent is unmeasured"。

**先测。** `skill.prompt` 对 preload 也触发。模块记录：一次 builder spawn 前后，是否出现 `skill.prompt` 且 `e.skill` 为 `workinggenius:genius-file` / `record-prose` / `decision-record`。这就是缺失的那次测量，成本一行日志。

**再保（只在测出缺失时）。** `agent.spawn` 匹配 `{ subagentType: 'workinggenius:builder' }`（及 inventor、reviewer），用 `$.fs.read` 读插件根下对应 `SKILL.md`，追加到 `e.prompt` 后 `next({ ...e, prompt })`。不做的：检查 coordinator 的任务消息有没有带快照路径——那是解析消息做判断，属于 judge 的模型而非脚本。

### 3.3 Instrument 注入 → 维持 `!` 注入（已测：mod 无增益）

`!` 注入在 `skill.prompt` 看到文本之前就已完成（§2 #2），mod 既不能"接管"也不该重复。唯一有价值的场景是策略禁用了 shell 注入（skill 里已写明这时显示的是 policy notice）：模块检测文本里没有 `work dir:` 时自己跑 `measure.py` 补上。小、可选、可以永远不做。`allowed-tools` 的预批照旧。

### 3.4 新：地图常驻——pane 与状态行（第三步，可选，UI 收益最大）

仿 `/diff`：`$.ui.open` 一个 pane，内容就是 `measure.py status` 的输出排版——每件在飞的工作、stage、`next:`、快照字符数对 6000 上限、slice 完成/进行/未开数、backlog 条数；在 `tool.call` 命中 `Edit`/`Write`/`Bash` 且路径落在工作目录下时刷新，`turn.complete` 时刷新。`$.ui.status` 放一行：`WG · <slug> · <stage> · next: …`（恰好一件在飞时显示它，否则显示计数）。可顺手加：`tool.call` 命中对快照的 `Write`/`Edit` 后，给结果附一行 `context`——"snapshot 6412 chars, over the 6000 ceiling"——这是 instrument 在动作发生的那一刻说话，只计数不决定。

它遵守的边界：pane 只显示算术，`/genius` skill 仍负责"阅读"（哪一步、什么没完、什么陈旧）；显示 `next:` 只是把文件里已有的那一行搬到屏幕上，与 `/genius` 打印它无异；不建议、不推进、不写文件。它的真正论据是：**这是第一种不花模型一个 token 就能看到状态的方式**——三次手工运行都在为 coordinator 的上下文省钱，pane 把这笔账降到零。

代价：这是三步里代码最多的（`$.ui.resolve` 出 `Box`/`Text`，多 surface 下用 `$.ui.mount` 测试）；`$.process.run` 是 "CLI only"，Desktop 上要能优雅降级为"无计数"。

### 3.5 新：`session.compact` 改写压缩指令（第二步顺手）

`genius-file` 写着"Re-read it after your own context is compacted"，但这一句活在散文里，压缩时模型未必记得。`session.compact` hook 在 `instructions` 后追加一段：保留在飞工作的 slug、stage、`next:`，以及快照与 `CONTRACT.md` 的路径；压缩后第一件事是整读快照。触发条件仍是那一个 frontmatter 字段（`measure.py status` 有在飞的工作）。纯提示，不解析，不决定；对长 build 收益最大。

### 3.6 mod 做得到、但 rulings 说不的

- **`$.prompt.suggest` 把 `next:` 放进输入框（Tab 接受）。** 用户仍要按下回车，但这已是插件在提议下一阶段，触碰 "the flow never advances itself"。默认不做；要做需一次用户裁定。
- **`tool.call` 拒绝对 `*.log.md` 的非追加编辑。** 脚本对工作文件做决定，`275ed4f` 杀过。哪怕只是警告也要解析编辑形状，默认不做；`errata` skill 是它的家。
- **让 judge 在每个会话常驻。** 见 3.1：装载 ≠ 布防。
- **任何自动跑阶段的东西。** 不做。

## 4. 落地结构

```
hooks/
  hooks.json           {"modules": ["./register.ts"]}   ← 插件级，只装载模块；classic hooks 仍在 skill frontmatter
  register.ts          入口：布防标志、classic.Stop / classic.SubagentStop、（第二步）agent.spawn、session.compact
tests/
  register.test.ts     judge 的 block/allow 矩阵（mock model.complete）、未布防直通、布防不改文本
types/
  claude-code.d.ts     /plugin-types 生成，首行标版本；随 release 重生成并提交，作为"测过哪个版本"的记录
tsconfig.json          按 mods/README 给的模板（jsx: react, jsxFactory: h, lib 不含 DOM）
skills/genius-file/judge-conditions.md   两个 judge 条件的唯一家：stop-judge.py 与 register.ts 都读它
```

`plugin.json` 不需要新字段（§2 #1）。README 首行的 skill 数不变。每次落地按规则 bump `version`。`.gitignore` 加 `.claude/types/`（`/plugin-types` 的默认输出位置）。

限制：截至 2.1.280，test kit 的 `$` 上没有 `classic` 名词，`classic.Stop` 的拦停路径只能在真实会话里测；kit 能测的是布防、判决解析、失败放行。

## 5. 分步与各自的门槛

1. **Judge 迁移。** 完成的标准：`validate --strict` 通过；kit 矩阵通过；一次交互式会话里 `/enable` 后的两轮实测出现拦停与继续；一个从未输入 `/enable`/`/tenacity` 的会话里 judge 调用为零；双判问题有答案。CLAUDE.md 与 `enable`/`tenacity` 的 judge 段落随之改写，说明两条路径与兜底关系。
2. **Preload 测量 + `session.compact`。** 完成的标准：一次 builder spawn 的日志回答了 preload 是否到达；一次 slice 中途强制 `/compact` 后的摘要里含 slug、`next:`、快照路径。
3. **Pane + 状态行 + 写时报数。** 完成的标准：终端与 Desktop 两个 surface 的 `$.ui.mount` 测试通过；打开 pane 前后模型上下文 token 差为零（这是它存在的理由，要量）。

独立于三步、但因本次调研而明确的一件事：**`claude plugin eval init`** 给 skills 建 eval suite。CLAUDE.md 说等它开了就是下一次测量，它已经开了；这是一件单独的工作，不混进 mod 里。

## 6. 风险与不做的理由

- **Early access。** 标志门控、API 无预告变动（§2 #5 已测到一处）。所以三步全是加法，classic 路径保留到正式发布；`types/claude-code.d.ts` 首行的版本号就是"测过什么"的记录。
- **Managed 组织。** `sec-default` 越过 user tier 的事件里正好有 `classic.*` 与 `skill.prompt`：这些机器上模块的 judge 与布防信号都不运行，兜底必须在。
- **`process.run` 是 CLI only。** pane 与 `work_in_build` 在 Desktop 上要降级；judge 在没有 `process.run` 的地方等于"没有工作在 build" → 放行，与今天 `measure` 导入失败时的行为一致。
- **一份条件文本两处读。** 若不愿新增 `judge-conditions.md`，过渡期内允许两份拷贝，并在 CLAUDE.md 写明何时删除 `stop-judge.py`。

## 附录 A：实测复现

最小 spike（scratch 目录，本仓库复制一份，加下面两个文件）：

```json
// hooks/hooks.json
{ "modules": ["./register.ts"] }
```

```ts
// hooks/register.ts — 只记录事件，不改行为；$ 只能传给顶层函数声明
import type { EngineInterface, Register } from 'claude-code'
let logPath: string | undefined
let armed = false
let blocked = false
async function mark($: EngineInterface, line: string): Promise<void> {
  try {
    logPath ??= (await $.env.get('WG_SPIKE_LOG')) || ''
    if (!logPath) return
    let prior = ''
    try { prior = (await $.fs.read(logPath, 'text')) as string } catch { prior = '' }
    await $.fs.write(logPath, prior + line + '\n')
  } catch {}
}
export const register: Register = (on) => {
  on('session.start', async ($, e, next) => { await mark($, `session.start cwd=${e.cwd}`); return next(e) })
  on('skill.prompt', async ($, e, next) => {
    if (e.skill.includes('genius')) armed = true
    const r = await next(e)
    await mark($, `skill.prompt ${e.skill} injected=${/work dir:/.test(r.text)} rawBang=${/```!/.test(r.text)}`)
    return r
  })
  on('classic.Stop', async ($, e, next) => {
    await mark($, `classic.Stop armed=${armed} active=${e.stop_hook_active}`)
    if (!armed || e.stop_hook_active || blocked) return next(e)
    blocked = true
    return { block: 'Spike: reply with the single word CONTINUED.' }
  })
}
```

```sh
claude plugin validate . --strict
CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 claude plugin test .
cd <任一项目> && WG_SPIKE_LOG=/tmp/spike.log CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 \
  claude -p "/genius" --plugin-dir <spike目录> --model haiku --max-turns 3 --output-format json --strict-mcp-config
cat /tmp/spike.log
```

## 附录 B：第一步的草案模块（已 validate、kit 测试通过；拦停路径未在交互式会话里测）

```ts
import type { EngineInterface, Register } from 'claude-code'

const ROOT = new URL('../..', import.meta.url).pathname.replace(/\/$/, '')
const MEASURE = `${ROOT}/skills/genius-file/measure.py`
const CONDITIONS = `${ROOT}/skills/genius-file/judge-conditions.md`
const BUILDING = /stage: (enablement|tenacity)\b/
const MESSAGE_TAIL = 6000

let armed = false   // /enable 或 /tenacity 在本会话被调用过：按调用布防，绝不按安装

async function condition($: EngineInterface, key: string): Promise<string | undefined> {
  const text = (await $.fs.read(CONDITIONS, 'text')) as string
  const m = text.match(new RegExp(`^## ${key}\\n([\\s\\S]*?)(?=^## |(?![\\s\\S]))`, 'm'))
  return m?.[1].trim()
}

async function workInBuild($: EngineInterface): Promise<boolean> {
  const r = await $.process.run(['python3', MEASURE, 'status'], { timeoutMs: 10_000 })
  return r.exitCode === 0 && BUILDING.test(r.stdout)
}

async function verdict($: EngineInterface, cond: string, message: string): Promise<string | undefined> {
  const reply = await $.model.complete({ model: 'haiku', system: cond,
    prompt: `<message>\n${message.slice(-MESSAGE_TAIL)}\n</message>`, maxTokens: 200 })
  const text = typeof reply === 'string' ? reply : (reply as { text?: string }).text ?? ''
  const json = text.match(/\{[\s\S]*\}/)
  if (!json) return undefined
  const parsed = JSON.parse(json[0]) as { ok?: boolean; reason?: string }
  return parsed.ok === false && parsed.reason ? parsed.reason : undefined
}

export const register: Register = (on) => {
  on('skill.prompt', ($, e, next) => {
    if (/(^|:)(enable|tenacity)$/.test(e.skill)) armed = true
    return next(e)
  })
  on('classic.Stop', async ($, e, next) => {
    if (!armed || e.stop_hook_active || !e.last_assistant_message) return next(e)
    try {
      const running = (await $.agent.list()).some(a => a.status === 'running')
      if (running || !(await workInBuild($))) return next(e)
      const cond = await condition($, 'coordinator')
      if (!cond) return next(e)
      const reason = await verdict($, cond, e.last_assistant_message)
      return reason ? { block: reason } : next(e)
    } catch (err) {
      $.ui.log(`workinggenius judge allowed the stop: ${String(err)}`, { to: 'debug' })
      return next(e)
    }
  })
  on('classic.SubagentStop', async ($, e, next) => {
    if (!armed || e.stop_hook_active || !e.agent_type.includes('builder') || !e.last_assistant_message) return next(e)
    try {
      const cond = await condition($, 'builder')
      if (!cond) return next(e)
      const reason = await verdict($, cond, e.last_assistant_message)
      return reason ? { block: reason } : next(e)
    } catch (err) {
      $.ui.log(`workinggenius judge allowed the stop: ${String(err)}`, { to: 'debug' })
      return next(e)
    }
  })
}
```

## 附录 C：来源

- 公告与讨论：https://github.com/anthropics/claude-code/issues/91870
- 内置 mod 源码与 README：https://github.com/anthropics/claude-code/tree/main/mods
- 类型声明（2.1.277 生成）：https://github.com/anthropics/claude-code/blob/main/mods/types/claude-code.d.ts
- What's new（Week 36/37：`/skill-doctor`、`claude plugin eval`）：https://code.claude.com/docs/en/whats-new
- Changelog（2.1.269 `claude plugin eval`；2.1.271 agent `omitClaudeMd`；2.1.277 `AGENTS.md`、`SubagentStop` matcher 修复）：https://code.claude.com/docs/en/changelog

## 7. 落地记录

**第一步（2026-09-23，Claude Code 2.1.280）。** `hooks/hooks.json` + `hooks/register.ts` + `hooks/verdict.ts`（纯函数：判决解析、条件切段、在建判断、后台任务判断）、`tests/register.test.ts`（12 个 kit 用例：拦停、放行、三个免费检查、两条失败路径、builder、未布防直通、用例间模块不泄漏）、`types/claude-code.d.ts`（2.1.280 生成）、`tsconfig.json`、`skills/genius-file/judge-conditions.md`（两个条件的唯一家，`stop-judge.py` 改为读它）。门槛逐条：

| 门槛 | 结果 |
|---|---|
| `claude plugin validate .claude-plugin/plugin.json` | 通过；`--strict` 只因根目录 `CLAUDE.md` 的既有警告而失败 |
| `tsc -p tsconfig.json` | 通过（2.1.280 的声明已把 `model.complete` 改为返回 `ModelCompleteResult`；`import.meta.url` 未声明，代码里以断言取用） |
| `claude plugin test .` | 12/12。2.1.280 的 kit 新增了 `$.classic.<Event>`，拦停路径可以在 kit 里测了 |
| `/enable` 后的两轮实测 | 临时项目里一件工作处于 enablement；haiku 被要求只回复"Next I will dispatch slice 2 to a builder."。模块以 coordinator 的理由拦停 → 模型下一轮改为向用户提问 → 第二次 Stop 带 `stop_hook_active`，放行。`num_turns=2` |
| 未输入 `/enable`/`/tenacity` 的会话 | 同一句话，judge 日志为空，一轮结束 |
| 双判 | 日志只有 `[hook]` 行，没有 `stop-judge.py` 的行：模块不经 `next` 直接作答时，其下的 settings hook 不运行。模块自身失败时才 `next(e)` 交给 classic judge |

设计里的一处修正：`hooks/register.ts` 在插件根的 `hooks/`，所以根目录是 `new URL('..', import.meta.url)`，不是草案里的 `'../..'`。

**第二步（同日）。** `session.compact` hook：instrument 的 status 显示有工作在飞时，把"保留 slug、stage、`next:`、快照与 `CONTRACT.md` 路径，压缩后先整读快照"的注释连同 status 原文追加到压缩指令；`skill.prompt` 对三个纪律 skill 各记一行日志，作为 preload 的测量仪。3.2 里"再保"的 `agent.spawn` hook **不需要做**：测量给出的答案是 preload 到达了。

| 门槛 | 结果 |
|---|---|
| builder spawn 的 preload | 一次 `Agent(subagent_type: workinggenius:builder)`，日志出现 `skill.prompt workinggenius:genius-file`、`record-prose`、`decision-record` 三行：三个 preload 都在子代理处展开。第一次只见一行，原因是日志函数并发读写覆盖，改为串行写后三行齐全——测量仪先于结论被修正 |
| `/compact` 后的摘要 | 一轮对话后 `claude -p --continue "/compact keep the numbers"`：日志 `session.compact manual: the work-file note rides the instructions`；摘要末尾出现 "Working Genius Metadata (preserved for re-entry)" 块，含 work dir、slug、stage、contract、`next: /enable demo, slice 2`、快照路径，"Optional Next Step" 也写成了那条命令 |
| kit | 15/15；`tsc` 通过；validate 通过 |

**第三步（同日，最小切片）。** `$.ui.status` 状态行：一件在飞 → `Working Genius · <slug> · <stage> · next: <command>`，多件 → `N in flight · /genius`，没有 → 清空；`session.start` 时有在飞工作则钉上，之后每个 `turn.complete` 刷新，但只在本会话"进入过 flow"（展开过任一 `workinggenius:` skill，或启动时已有在飞工作）之后——没进入过的会话既不跑 instrument 也不显示。`tool.call` 命中 `Write`/`Edit` 且路径形如 `<slug>/<slug>.md` 时，把 `measure.py snapshots` 里该 slug 的那一行作为 `context` 附在工具结果之后。**pane 没做**：三步里代码最多，且它的价值（状态上屏、模型上下文零成本）只能在交互式终端里量；留作下一件工作。

| 门槛 | 结果 |
|---|---|
| kit | 20/20（状态行的三种形态、路径→slug、instrument 行→context、启动钉行与逐轮刷新、未进入 flow 的会话零 instrument 调用）；`tsc` 通过；validate 通过 |
| 写快照后的报数 | 临时项目里让 haiku 用 Edit 改 `demo.md`：会话 transcript 里工具结果之后出现附件 `<system-reminder>\ntool.call hook additional context: Working Genius instrument, after this write: demo (enablement) — 531 chars whole, 393 roster excluded — under the ceiling of 6000</system-reminder>`。`--output-format stream-json` 不显示附件，第一次因此误以为没到 |
| 状态行的显示 | 未测：无头会话没有 surface。kit 证明了调用发生；在终端里看到它是下一次交互式测量 |

**未测清单（接第 2 节）。** 交互式终端下的拦停与状态行；managed 组织机器；Desktop 上 `process.run` 缺席时的降级（代码路径是 catch 后不显示、不判）。

**pane（同日）。** `ui.render` 命中 `Pane`、id `genius-map`：每件在飞工作一个块（slug 与 stage、`next:`、快照对上限与 slice 计数），然后 done 与 backlog 计数；模块在 `session.start` 注册 `/genius-map` 命令切换显示；有在飞工作时自动打开，除非此人关过它（`$.store` 记住）；surface 放不下时撤回打开，仿 `/diff`。kit 24/24：`$.ui.mount` 挂载 pane 后找到 `demo · enablement` 与 `next: /enable demo, slice 2` 两行；命令的开/关与存储；无在飞工作不自动打开。终端里的显示仍未测（无头会话没有 surface）。

**人手势检查点（同日）。** `mcp__workinggenius__confirm` 工具：进入 flow 后（展开过任一 `workinggenius:` skill，或启动时有在飞工作）才向模型声明；调用时开一个带陈述与两个按钮的 pane，只有人按了 *Yes, that's it* 或 *Not yet*、按 Esc 关掉、或十分钟无人按，工具才返回并说明是哪种；无 surface 的会话立刻返回"这里没人能按，请用文字问"。按钮的按下是 surface 的动作，模型做不到。`wonder`、`discern`、`galvanize` 各加一句"会话提供 `confirm` 工具时，yes 经它取得"，理由放在 `genius-file`。另有 `prompt.submit`：进入 flow 后，来源不是 composer/bridge 的消息（peer、coordinator、schedule、notification、sdk）带一行 context 注明来源，只陈述事实。kit 29/29：Yes/Not yet/超时/无 surface 四种结局、工具只在进入 flow 后声明一次、来源注释在进入 flow 后且非 composer 时才出现。两个裁定点的默认答案：`sdk` 一律注明来源（事实），skill 自行决定；按钮结果不写任何文件，只作为工具结果回到模型，由模型按 skill 记录。

**skills 的 eval 套件（同日）。** `evals/` 四个用例，每个对应 skill 的一条主张：`no-hijack`（普通请求不进 flow）、`nothing-in-flight`（问在飞工作，从 instrument 回答、不编造）、`genius-starts-wonder`（新想法进 flow：提问不建设）、`enable-red-before-green`（脚手架项目里建一个 slice：先红后绿，证据进日志）。两个关于 runner 的实测：**斜杠命令不是 prompt**，`/genius`、`/enable demo, slice 2` 作为用例 prompt 得到 0 轮、无报错，所以用户专用命令在 eval 之外，用例改为一个人会怎么说；授权 `Bash`/`Write`/`Edit` 的用例需要 runner 的 sandbox（Linux 上 `bubblewrap` + `socat`），没有则拒跑。分数（2026-09-23，`--runs 1 --ablation none`）：

| 用例 | 模型 | 分数 | 说明 |
|---|---|---|---|
| no-hijack | haiku | 1.0 | 无 `.genius/`、无阶段 skill、任务照做 |
| nothing-in-flight | sonnet | 1.0 | `genius-file` 触发，答"没有在飞"，给出 `/genius <idea>` 或 `/wonder`。haiku 下 skill 根本不触发（0 次），是小模型触发率的事实 |
| genius-starts-wonder | sonnet | 1.0 | `wonder` 触发，分轮提问带建议，不写代码 |
| enable-red-before-green | sonnet | 0.57 | `enable` 触发；测试先写先跑再改实现（Write@16、Bash@11 都先于 Edit@17），套件跑了两次；但日志无 `## slice-2`，roster 的 S2 未勾，hand-back 无逐条证据。纪律成立，close 没落地。这是套件抓到的第一个发现；手动复现的结果另记 |

