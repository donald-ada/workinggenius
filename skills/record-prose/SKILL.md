---
name: record-prose
description: How the flow's records are written — every document under .genius/, snapshot to backlog line. Use when writing or rewriting any of them, or when another skill needs the prose discipline.
---

# Record Prose

Every file under `.genius/` is read by two audiences the writer never meets: a cold session with no memory of the conversation, and the owner of the project, months later, looking for one fact. The `genius-file` skill owns *where* things go; this owns *how the sentences carrying them are made*.

- **Write it for someone who wasn't there.** Short sentences carrying one fact each, the actor named rather than implied, one term per concept held constant — [Simplified Technical English](https://asd-ste100.org/)'s form, minus its ban on reasoning, because these files carry reasoning on purpose.
- **Reasoning stays where it is load-bearing.** A kill-reason names the attack that broke the option, a repeat weakness names its adjustment, a technology names what selected it — never compressed to a verdict. No ceiling or cleanup buys itself a shortened kill-reason: a verdict whose reasoning is gone is destroyed, not shorter.
- **Quoted words are a record, not prose to conform.** The user's confirmation goes in as they said it; the form binds your sentences, never theirs.
- **Write in the owner's language, plainly.** The project's terms (`CONTEXT.md`) and the flow's own names (slice, contract, snapshot) are vocabulary; jargon coined on the spot, buzzwords and decorated restatement are noise both readers pay for.
- **Evidence is data, not prose.** A criterion's record is the command and what it showed — `cargo test config::profiles → 14 passed` — one line, never a paragraph narrating that testing occurred. Reasoning earns sentences; results never do.
- **A backlog line is a seed, and 300 characters is its pot.** One physical line carrying what it is, why it is worth doing, and where it came from. Characters, not lines, because one physical line hides any length, and the file is read whole on every `/genius`. Over 300 the line has stopped being a seed: it is a piece of work that wants its own file, or it carries detail that belongs elsewhere.
- **Route before trimming — a seed's detail is displaced, never deleted.** An entry over its pot usually carries facts recorded nowhere else: check the log its link names, append the entry verbatim there where the detail is missing, and point the seed at the new anchor. Compression may drop what the log already holds, never what nothing else does; an entry already inside its pot is left exactly as it is. A link the original lacked is an inference: verify the anchor records the thing before writing it.
- **A checked fact carries its scope, and a negative one carries its instrument.** A later session inherits it as a constraint: write `no headless browser installed in this project`, not `no headless browser`. An over-broad fact costs more than a missing one, because the missing one gets looked up and the over-broad one becomes a seam nobody questions. An absence is evidence only where the check could have come back positive — `which` is blind to everything off `PATH`, a test running as root cannot see a permission.

## Written in the reader's language, never translated into it

A model composes in the language it thinks in and renders into the one it writes in, and the render shows: sentences grammatical in Chinese and shaped like English, words that are the dictionary's nearest entry rather than what an engineer here would say. A record that costs a translation costs a misreading. No list of banned words fixes it — a list catches yesterday's words — it is fixed by writing from the fact, not from the sentence:

- **Start from the fact, in the record's language.** Could the sentence have been produced by translating an English one clause by clause? Then throw it away and say the fact the way it would be said here. In Chinese: the condition before the conclusion (除非 Y，否则 X), the verb doing the work rather than a noun with 进行 in front of it (改了配置, not 对配置进行了修改), and 一个, 的-chains, 它/它们, 当……时 only where Chinese would put them.
- **A person or a file acts; an abstraction doesn't.** 该设计确保了、这个方法允许 leave the reader asking who did what. Name the actor the record knows — the slice, the user, the test, the file — and give it a plain verb.
- **Use the word a colleague would say aloud on this project.** A test 挂了, not 被打破了; a value 钉死了, not 被固定; an interface 提供, not 暴露; code that is 稳定, not 健壮. Said to a teammate, would it make them pause? Then it was translated. English has the same failure — *robust*, *seamless*, *leverage*, *delve*, *comprehensive* — and the same test catches it.
- **A word that carries no fact is decoration.** 成功地通过了 says what 通过了 says; 显著、至关重要、值得注意的是 tell the reader how to feel instead of stating a fact. Remove the word: if the fact is intact, the word was never part of it.
- **A record greets nobody and concludes nothing.** No opening that announces what follows, no 总的来说 that says it again, no offer at the end. The first sentence is the first fact.
- **Rhythm belongs to arguments, and a record is not arguing.** Three of anything for the sound of three, 不仅……而且……, the empty contrast 这不是 X，而是 Y, 首先/其次/最后 over facts that have no order — these make a reader look for a point the record isn't making.
- **The flow's own names are rendered once per project.** Left to the moment they come out differently every time (切片 today, 分片 tomorrow). The `domain-glossary` skill names which words and records each rendering in `CONTEXT.md`; the record uses that one.

This governs the records under `.genius/` and the project docs the flow writes — not conversation, and not the skills' own voice. The test for all of it is one reader: someone who wasn't there, finding the one fact they came for, believing it exactly as far as it deserves.
