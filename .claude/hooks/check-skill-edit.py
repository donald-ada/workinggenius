#!/usr/bin/env python3
"""After an edit to the plugin's prose or instruments, the checks CLAUDE.md
lists under Commands, run on the file that changed — so a dropped
frontmatter block, a dead relative link or a broken instrument surfaces on
the edit that caused it, not at the next release.

Registered in .claude/settings.json as a PostToolUse hook on Edit, Write and
MultiEdit; this repository's maintainer sessions only, never shipped with the
plugin. It checks and never decides: a failure goes back to the session as
exit 2 with the reason on stderr, and any failure of its own exits 0.
"""
import json
import os
import re
import subprocess
import sys

WATCHED = ('skills/', '.claude-plugin/', '.claude/agents/', '.claude/skill-audit/')
LINK = re.compile(r'\]\(([^)#]+)(?:#[^)]*)?\)')


def problems(root, rel):
    path = os.path.join(root, rel)
    out = []
    if rel.endswith('.md'):
        body = open(path, encoding='utf-8').read()
        if rel.endswith('SKILL.md') or '/agents/' in rel:
            if not body.startswith('---\n') or '\n---\n' not in body[4:]:
                out.append('frontmatter block missing or unterminated')
            else:
                try:
                    import yaml
                    fm = yaml.safe_load(body.split('\n---\n')[0][4:])
                    if not isinstance(fm, dict) or not fm.get('name') or not fm.get('description'):
                        out.append('frontmatter parses but lacks name or description')
                except ImportError:
                    pass
                except Exception as e:
                    out.append(f'frontmatter does not parse: {str(e).splitlines()[0]}')
        for t in LINK.findall(body):
            if t.startswith('http') or '<' in t or t == 'CONTRACT.md' or t.endswith('.log.md'):
                continue
            if not os.path.exists(os.path.normpath(os.path.join(os.path.dirname(path), t))):
                out.append(f'relative link does not resolve: {t}')
    elif rel.endswith('.json'):
        try:
            json.load(open(path, encoding='utf-8'))
        except Exception as e:
            out.append(f'json does not parse: {e}')
    elif rel.endswith('.py'):
        r = subprocess.run([sys.executable, '-m', 'py_compile', path], capture_output=True, text=True, timeout=30)
        if r.returncode:
            out.append(f'does not compile: {r.stderr.strip().splitlines()[-1]}')
        elif rel == 'skills/genius-file/measure.py':
            r = subprocess.run([sys.executable, path, 'status'], cwd=root, capture_output=True, text=True, timeout=60)
            if r.returncode:
                out.append(f'measure.py status exits {r.returncode}; an injected command that fails aborts the skill')
        elif rel == 'skills/genius-file/stop-judge.py':
            r = subprocess.run([sys.executable, path], input='x', cwd=root, capture_output=True, text=True, timeout=60)
            if r.returncode:
                out.append(f'stop-judge.py exits {r.returncode} on garbage; it must allow the stop')
    return out


def main():
    try:
        event = json.load(sys.stdin)
        root = os.environ.get('CLAUDE_PROJECT_DIR') or event.get('cwd') or os.getcwd()
        path = (event.get('tool_input') or {}).get('file_path') or ''
        rel = os.path.relpath(os.path.abspath(path), root) if path else ''
        if not rel.startswith(WATCHED) or not os.path.isfile(os.path.join(root, rel)):
            return 0
        found = problems(root, rel)
    except Exception:
        return 0
    if not found:
        return 0
    print(f'{rel}: ' + '; '.join(found), file=sys.stderr)
    return 2


if __name__ == '__main__':
    sys.exit(main())
