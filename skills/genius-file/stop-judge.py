#!/usr/bin/env python3
"""The two judges the flow measured a need for, as one Stop / SubagentStop
command hook registered by /enable and /tenacity — by invocation, never by
installation, so a session that never typed either command has no judge.

Reads the hook's JSON on stdin. Three checks cost nothing and settle most
stops: a stop already continued by a hook is allowed; a stop with a subagent
or workflow still running is a pause, not a stall, and is allowed; a project
with no work at enablement or tenacity has nothing to judge. Only then does a
fast model read the turn's last message — that message alone, never the
transcript — against one condition, and only a clear "ok: false" blocks: exit
2 with the reason on stderr, which Claude Code hands back as the next
instruction. Every failure of the judge's own — no `claude` on the path, a
timeout, unparsable output — allows the stop: a judge that fails closed would
hold a session hostage to its own plumbing.

The script reads one frontmatter field, `stage:`, to know whether to ask; the
judgment is the model's, and no line is written to any file.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
try:
    import measure
except Exception:  # the instrument beside this file; without it, never judge
    measure = None

BUILDING = ('enablement', 'tenacity')
MODEL = 'haiku'
NESTED_TIMEOUT = 45
MESSAGE_TAIL = 6000

COORDINATOR = (
    'A Claude Code turn is ending; the assistant is coordinating a tracked piece of work and nothing is '
    'running in the background. Below is the final message of the turn. Decide one thing: does it announce '
    'a step the assistant itself would take next — dispatching a slice or a builder, spawning or waiting on '
    'a reviewer, running verification, closing a slice — and end there, asking the user nothing and reporting '
    'no result of that step? If yes, answer {"ok": false, "reason": "Dispatching is doing: the step you '
    'announced is yours to take now, before the turn ends — or, if it needs the user, ask them."}. If the '
    'message asks the user something, waits on their decision, reports a close, a hand-back, a finding or an '
    'outcome, or does not concern tracked work, answer {"ok": true}. Respond with that JSON only.'
)

BUILDER = (
    'A builder subagent is finishing; below is what it hands back. Decide one thing: does it claim the slice '
    'is done, built, implemented, passing or complete while carrying no line that names a command and what '
    'it showed for its criteria? If yes, answer {"ok": false, "reason": "Hand back evidence, not a claim: per '
    'criterion, the command and what it showed — or the stop, with what it changes and your recommendation."}. '
    'If it hands back per-criterion command-and-result lines, or a stop — a discovery, what it changes, a '
    'recommendation — or a named blocker it cannot work around, answer {"ok": true}. Respond with that JSON only.'
)


def work_in_build():
    if measure is None:
        return False
    d, _ = measure.work_dir()
    if not os.path.isdir(d):
        return False
    for _slug, path in measure.snapshots(d):
        if measure.frontmatter(measure.text(path)).get('stage') in BUILDING:
            return True
    return False


def ask(condition, message):
    prompt = f'{condition}\n\n<message>\n{message}\n</message>'
    # Not --bare: that mode reads no OAuth login, so it fails for everyone on a subscription
    # (measured: api_error, zero tokens). Instead: no hooks, no skills, no tools, no MCP, and a
    # neutral cwd so the project's instruction files stay out of the judge's context.
    r = subprocess.run(
        ['claude', '-p', prompt, '--model', MODEL, '--max-turns', '1', '--output-format', 'json',
         '--settings', '{"disableAllHooks": true}', '--disable-slash-commands', '--strict-mcp-config',
         '--tools', ''],
        capture_output=True, text=True, timeout=NESTED_TIMEOUT, stdin=subprocess.DEVNULL,
        cwd=tempfile.gettempdir())
    result = json.loads(r.stdout).get('result') or ''
    m = re.search(r'\{.*\}', result, re.S)
    return json.loads(m.group(0)) if m else {}


def log(line):
    path = os.environ.get('WG_STOP_JUDGE_LOG')
    if path:
        try:
            with open(path, 'a', encoding='utf-8') as f:
                f.write(line + '\n')
        except OSError:
            pass


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return 0
    event = data.get('hook_event_name')
    if data.get('stop_hook_active'):
        log(f'{event} allow: stop_hook_active')
        return 0
    message = (data.get('last_assistant_message') or '').strip()
    if not message:
        return 0
    if event == 'Stop':
        running = [t.get('type') for t in (data.get('background_tasks') or []) if isinstance(t, dict)]
        if any(t in ('subagent', 'workflow') for t in running):
            log('Stop allow: background task running')
            return 0
        if not work_in_build():
            log('Stop allow: no work at enablement or tenacity')
            return 0
        condition = COORDINATOR
    elif event == 'SubagentStop':
        if 'builder' not in (data.get('agent_type') or ''):
            return 0
        condition = BUILDER
    else:
        return 0
    try:
        verdict = ask(condition, message[-MESSAGE_TAIL:])
    except Exception as e:
        log(f'{event} allow: judge failed ({type(e).__name__})')
        return 0
    if verdict.get('ok') is False and verdict.get('reason'):
        log(f'{event} block: {verdict["reason"]}')
        sys.stderr.write(str(verdict['reason']))
        return 2
    log(f'{event} allow: {verdict.get("reason", "ok")}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
