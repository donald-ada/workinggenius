#!/usr/bin/env python3
"""Where a Claude Code session's time and tokens went: per phase, per subagent, per tool.

Reads a session transcript (~/.claude/projects/<project>/<session>.jsonl) and the
subagent transcripts beside it (<session>/subagents/agent-*.jsonl). Counts and never
decides. Given a project directory instead of a file, it reads the newest session.

    python3 .claude/session-time.py ~/.claude/projects/-Users-me-myapp/
    python3 .claude/session-time.py ~/.claude/projects/-Users-me-myapp/<session>.jsonl
"""
import glob
import json
import os
import re
import sys
from collections import defaultdict
from datetime import datetime

IDLE = 120  # seconds; a gap this long with no entry is the user away, not work


def ts(x):
    t = x.get("timestamp")
    return datetime.fromisoformat(t.replace("Z", "+00:00")).timestamp() if t else None


def load(path):
    out = []
    for line in open(path, encoding="utf-8"):
        try:
            out.append(json.loads(line))
        except ValueError:
            pass
    return out


def blocks(x):
    c = (x.get("message") or {}).get("content")
    return c if isinstance(c, list) else []


def human_text(x):
    """The text of a message a person typed, or None for tool results and meta entries."""
    if x.get("type") != "user" or x.get("isMeta") or x.get("isSidechain"):
        return None
    c = (x.get("message") or {}).get("content")
    if isinstance(c, str):
        return c
    if c and all(b.get("type") == "text" for b in c):
        return " ".join(b.get("text", "") for b in c)
    return None


def stats(entries):
    """Tokens, API calls, tool time and characters written, for one transcript."""
    seen, s = set(), defaultdict(float)
    tools = defaultdict(lambda: [0, 0.0])  # name -> [calls, seconds]
    started = {}
    for x in entries:
        t = ts(x)
        m = x.get("message") or {}
        if x.get("type") == "assistant":
            mid = m.get("id")
            if mid and mid not in seen:
                seen.add(mid)
                u = m.get("usage") or {}
                s["calls"] += 1
                s["out"] += u.get("output_tokens", 0)
                s["in"] += u.get("input_tokens", 0) + u.get("cache_creation_input_tokens", 0) + u.get("cache_read_input_tokens", 0)
            for b in blocks(x):
                if b.get("type") == "tool_use":
                    started[b.get("id")] = (b.get("name"), t, b.get("input") or {})
                    inp = b.get("input") or {}
                    if b.get("name") == "Write":
                        s["written"] += len(inp.get("content", ""))
                    elif b.get("name") == "Edit":
                        s["written"] += len(inp.get("new_string", ""))
                    elif b.get("name") == "Bash" and ("<<" in inp.get("command", "") or "append" in inp.get("command", "")):
                        s["written"] += len(inp.get("command", ""))
        elif x.get("type") == "user":
            for b in blocks(x):
                if b.get("type") == "tool_result" and b.get("tool_use_id") in started:
                    name, t0, inp = started.pop(b["tool_use_id"])
                    if name == "Skill":
                        name = "Skill:" + str(inp.get("skill", "?"))
                    tools[name][0] += 1
                    if t and t0:
                        tools[name][1] += t - t0
    s["wall"] = total(intervals(entries))
    return s, tools


def intervals(entries):
    """Working spans: gaps between entries up to IDLE, and every tool call however long,
    because a long test run or a foreground subagent writes nothing while it works.
    AskUserQuestion is waiting on the person, so its span counts only if short."""
    times = sorted(t for t in (ts(x) for x in entries) if t)
    spans = [(a, b) for a, b in zip(times, times[1:]) if b - a <= IDLE]
    started = {}
    for x in entries:
        for b in blocks(x):
            if b.get("type") == "tool_use" and b.get("name") != "AskUserQuestion":
                started[b.get("id")] = ts(x)
            elif b.get("type") == "tool_result" and started.get(b.get("tool_use_id")) and ts(x):
                spans.append((started.pop(b["tool_use_id"]), ts(x)))
    return spans


def total(spans):
    """Seconds covered by the union of spans."""
    out, end = 0.0, None
    for a, b in sorted(spans):
        if end is None or a > end:
            out += b - a
            end = b
        elif b > end:
            out += b - end
            end = b
    return out


def fmt(sec):
    sec = int(sec)
    return f"{sec // 3600}h{sec % 3600 // 60:02d}m" if sec >= 3600 else f"{sec // 60}m{sec % 60:02d}s"


def phases(entries):
    """The main session cut at each slash command or Skill call: (label, entries)."""
    out, label, cur = [], "(start)", []
    for x in entries:
        new = None
        h = human_text(x)
        if h:
            m = re.search(r"<command-name>/?([^<]+)</command-name>", h)
            new = "/" + m.group(1).strip() if m else None
        for b in blocks(x):
            if b.get("type") == "tool_use" and b.get("name") == "Skill":
                new = "skill:" + str((b.get("input") or {}).get("skill", "?"))
        if new:
            if cur:
                out.append((label, cur))
            label, cur = new, []
        cur.append(x)
    if cur:
        out.append((label, cur))
    return out


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    path = os.path.expanduser(sys.argv[1])
    if os.path.isdir(path):
        files = sorted(glob.glob(os.path.join(path, "*.jsonl")), key=os.path.getmtime)
        if not files:
            sys.exit(f"no session transcript in {path}")
        path = files[-1]
    elif not os.path.isfile(path):
        sys.exit(f"no such file: {path}")
    main_entries = load(path)
    subdir = os.path.join(path[: -len(".jsonl")], "subagents")
    print(f"session: {path}")

    s, tools = stats(main_entries)
    times = [ts(x) for x in main_entries if ts(x)]
    print(f"main session: {fmt(s['wall'])} active ({fmt(max(times) - min(times))} wall clock), "
          f"{int(s['calls'])} model calls, {int(s['out']):,} output tokens, {int(s['in']):,} input tokens read, "
          f"{int(s['written']):,} characters written to files")

    print("\nphases of the main session (active time):")
    for label, ents in phases(main_entries):
        if any(ts(x) for x in ents):
            ps, _ = stats(ents)
            print(f"  {label:28} {fmt(ps['wall']):>8}   {int(ps['out']):>8,} out   {int(ps['written']):>8,} chars written")

    print("\nmain session's tools by time (Agent = waiting on a subagent in the foreground; AskUserQuestion = waiting on you):")
    for name, (n, sec) in sorted(tools.items(), key=lambda kv: -kv[1][1])[:10]:
        print(f"  {name:28} {fmt(sec):>8}   {n} calls")

    subs = sorted(glob.glob(os.path.join(subdir, "agent-*.jsonl")))
    spans = intervals(main_entries) + [sp for f in subs for sp in intervals(load(f))]
    print(f"\nthe whole run, main and subagents together, while anything was working: {fmt(total(spans))}")
    if subs:
        print("\nsubagents:")
        by_type = defaultdict(lambda: [0, 0.0, 0, 0, 0])
        for f in subs:
            meta = {}
            try:
                meta = json.load(open(f[: -len(".jsonl")] + ".meta.json", encoding="utf-8"))
            except (OSError, ValueError):
                pass
            ss, _ = stats(load(f))
            kind = meta.get("agentType", "?")
            print(f"  {kind:28} {fmt(ss['wall']):>8}   {int(ss['out']):>8,} out   {int(ss['in']):>11,} in   "
                  f"{int(ss['written']):>7,} chars written   {meta.get('description', '')[:40]}")
            k = by_type[kind]
            k[0] += 1; k[1] += ss["wall"]; k[2] += ss["out"]; k[3] += ss["in"]; k[4] += ss["written"]
        print("\nsubagents by type (time adds up even where they ran in parallel):")
        for kind, (n, sec, out, inp, wr) in sorted(by_type.items(), key=lambda kv: -kv[1][1]):
            print(f"  {kind:28} x{n:<3} {fmt(sec):>8}   {int(out):>8,} out   {int(inp):>11,} in   {int(wr):>7,} chars written")


if __name__ == "__main__":
    main()
