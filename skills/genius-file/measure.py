#!/usr/bin/env python3
"""The work-file format's instrument: counts characters, never bytes, and
reads what /genius and /compact would otherwise count by hand.

    measure.py status            the /genius view: work dir, in-flight works, done, backlog, history
    measure.py snapshots         every snapshot's count, whole and roster excluded, against the ceiling
    measure.py count <file>...   characters in each file

It always exits 0 and never raises: a skill that injects this command is
aborted whole if the command fails, and a count that could not be taken is
worth reporting, never worth losing the skill over. The rules it measures
against live in FILE-FORMAT.md beside it; the numbers here are read from there.
"""
import datetime
import glob
import os
import re
import subprocess
import sys

CEILING = 6000          # FILE-FORMAT.md, "The measure": the snapshot's ceiling, roster excluded
SEED_BOUND = 300        # BACKLOG-FORMAT.md: one seed, one physical line, at most this many characters


def text(path):
    with open(path, encoding='utf-8', errors='replace') as f:
        return f.read()


def work_dir():
    """setup pins it as a `Work files: `<dir>`` line in the project's instruction file."""
    for name in ('CLAUDE.md', 'AGENTS.md', os.path.join('.claude', 'CLAUDE.md')):
        try:
            m = re.search(r'Work files:\s*`([^`]+)`', text(name))
        except OSError:
            continue
        if m:
            return m.group(1).strip().rstrip('/'), name
    return '.genius', None


def frontmatter(body):
    fm = {}
    if not body.startswith('---'):
        return fm
    end = body.find('\n---', 3)
    if end < 0:
        return fm
    for line in body[3:end].splitlines():
        m = re.match(r'^([A-Za-z_][\w-]*):\s*(.*)$', line)
        if m:
            value = re.split(r'\s+#', m.group(2))[0].strip()   # the template's trailing comment
            fm[m.group(1)] = value
    return fm


def roster(body):
    """The Slices section, heading to next heading: what the ceiling excludes."""
    m = re.search(r'^## Slices[^\n]*\n(.*?)(?=^## |\Z)', body, re.S | re.M)
    return m.group(1) if m else ''


def snapshots(d):
    found = []
    for folder in sorted(glob.glob(os.path.join(d, '*', ''))):
        slug = os.path.basename(os.path.dirname(folder))
        path = os.path.join(folder, slug + '.md')
        if os.path.isfile(path):
            found.append((slug, path))
    return found


def last_touched(path):
    try:
        r = subprocess.run(['git', 'log', '-1', '--format=%cs', '--', path],
                           capture_output=True, text=True, timeout=10)
        if r.returncode == 0 and r.stdout.strip():
            return r.stdout.strip()
    except Exception:
        pass
    try:
        return datetime.date.fromtimestamp(os.path.getmtime(path)).isoformat()
    except Exception:
        return '?'


def measure(path):
    body = text(path)
    whole = len(body)
    without_roster = whole - len(roster(body))
    return body, whole, without_roster


def count_lines(path, prefix='- '):
    try:
        return sum(1 for line in text(path).splitlines() if line.startswith(prefix))
    except OSError:
        return None


def cmd_count(paths):
    if not paths:
        print('measure: count needs at least one file')
    for p in paths:
        try:
            print(f'{p} → {len(text(p))} chars')
        except OSError as e:
            print(f'{p} → unreadable ({e.strerror})')


def cmd_snapshots():
    d, _ = work_dir()
    found = snapshots(d)
    if not found:
        print(f'no snapshots under {d}/')
        return
    for slug, path in found:
        body, whole, without = measure(path)
        stage = frontmatter(body).get('stage', '?')
        verdict = 'over the ceiling ⚠' if without > CEILING else 'under the ceiling'
        print(f'- {slug} ({stage}) — {whole} chars whole, {without} roster excluded — {verdict} of {CEILING}')


def cmd_status():
    d, pinned_in = work_dir()
    where = f'pinned in {pinned_in}' if pinned_in else 'default, nothing pinned'
    if not os.path.isdir(d):
        print(f'work dir: {d}/ ({where}) — not present; nothing in flight, no history, no backlog')
        return
    print(f'work dir: {d}/ ({where})')
    in_flight, done = [], 0
    for slug, path in snapshots(d):
        body, whole, without = measure(path)
        fm = frontmatter(body)
        if fm.get('stage') == 'done':
            done += 1
            continue
        r = roster(body)
        marks = (r.count('- [x]'), r.count('- [~]'), r.count('- [ ]'))
        line = (f'- {slug} — stage: {fm.get("stage", "?")} · contract: {fm.get("contract", "none")}'
                f' · next: {fm.get("next", "?")} · snapshot {whole} chars, {without} roster excluded')
        if without > CEILING:
            line += f' ⚠ over the {CEILING} ceiling'
        if any(marks):
            line += f' · slices {marks[0]} done, {marks[1]} in progress, {marks[2]} open'
        line += f' · last commit {last_touched(path)}'
        in_flight.append(line)
    print(f'in flight ({len(in_flight)}):' if in_flight else 'in flight: none')
    for line in in_flight:
        print(line)
    history = count_lines(os.path.join(d, 'HISTORY.md'))
    print(f'done: {done}' + (f' (HISTORY.md: {history} lines)' if history is not None else ' (no HISTORY.md)'))
    backlog = os.path.join(d, 'BACKLOG.md')
    try:
        seeds = [l for l in text(backlog).splitlines() if l.startswith('- ')]
    except OSError:
        print('backlog: no BACKLOG.md')
        return
    over = sum(1 for l in seeds if len(l) > SEED_BOUND)
    print(f'backlog: {len(seeds)} seeds, {over} past the {SEED_BOUND}-character line bound')


def main(argv):
    try:
        cmd = argv[1] if len(argv) > 1 else 'status'
        if cmd == 'status':
            cmd_status()
        elif cmd == 'snapshots':
            cmd_snapshots()
        elif cmd == 'count':
            cmd_count(argv[2:])
        else:
            print(f'measure: unknown command {cmd!r}; one of status, snapshots, count')
    except Exception as e:  # never fail: see the docstring
        print(f'measure: could not measure ({type(e).__name__}: {e})')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
