#!/usr/bin/env python3
"""The work-file format's instrument: counts characters, never bytes, and
reads what /genius, /compact, /reconcile and /distill would otherwise count
by hand.

    measure.py status            the /genius view: work dir, in-flight works, done, backlog, history
    measure.py snapshots         every snapshot's count, whole and roster excluded, against the ceiling
    measure.py links [<slug>]    both directions of the invariant: links that resolve, entries nothing links
    measure.py distill           done works and whether their logs carry the distilled line
    measure.py count <file>...   characters in each file

It counts and never decides. It always exits 0 and never raises: a skill
that injects this command is aborted whole if the command fails, and a
count that could not be taken is worth reporting, never worth losing the
skill over. The rules it measures against live in FILE-FORMAT.md and
BACKLOG-FORMAT.md beside it; the numbers here are read from there.
"""
import datetime
import glob
import os
import re
import subprocess
import sys

CEILING = 6000          # FILE-FORMAT.md, "The measure": the snapshot's ceiling, roster excluded
SEED_BOUND = 300        # BACKLOG-FORMAT.md: one seed, one physical line, at most this many characters
CROSS_WORK = ('BACKLOG.md', 'BACKLOG.log.md', 'DECIDED.md', 'HISTORY.md')   # the files at the work dir itself


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


# ---- links: the invariant, both directions ----------------------------------

LINK = re.compile(r'\]\(([^)\s#<>]+)(?:#([^)]*))?\)')
HEADING = re.compile(r'^(#{1,6})\s+(.*?)\s*$')


def slug_of(heading_text):
    """A heading's anchor the way markdown readers make it: lowercased, spaces to hyphens."""
    t = heading_text.strip().lower()
    t = re.sub(r'[^\w\s-]', '', t, flags=re.UNICODE)
    return re.sub(r'\s+', '-', t).strip('-')


def headings(path):
    """(level, anchor, raw text) per heading; the log's entries are the level-2 ones."""
    out = []
    try:
        for line in text(path).splitlines():
            m = HEADING.match(line)
            if m:
                out.append((len(m.group(1)), slug_of(m.group(2)), m.group(2)))
    except OSError:
        pass
    return out


def links_in(path):
    try:
        body = text(path)
    except OSError:
        return []
    return [(t, a) for t, a in LINK.findall(body) if not t.startswith('http')]


def check_links(files, base_of):
    """For each file, every relative link: does its target exist, does its anchor resolve.
    base_of(path) gives the directory links in that file are relative to."""
    broken, checked = [], 0
    for path in files:
        base = base_of(path)
        for target, anchor in links_in(path):
            checked += 1
            full = os.path.normpath(os.path.join(base, target))
            if not os.path.isfile(full):
                broken.append(f'{path} → {target}{"#" + anchor if anchor else ""} (file missing)')
                continue
            if anchor and anchor not in {a for _, a, _ in headings(full)}:
                broken.append(f'{path} → {target}#{anchor} (anchor missing)')
    return broken, checked


def cmd_links(only=None):
    d, _ = work_dir()
    if not os.path.isdir(d):
        print(f'work dir {d}/ not present; no links to check')
        return
    broken, unlinked, prose_keys, checked = [], [], [], 0
    for slug, snap in snapshots(d):
        if only and slug != only:
            continue
        folder = os.path.dirname(snap)
        work_files = [snap] + [p for p in (os.path.join(folder, 'CONTRACT.md'),) if os.path.isfile(p)]
        b, c = check_links(work_files, lambda p, f=folder: f)
        broken += b
        checked += c
        log = os.path.join(folder, slug + '.log.md')
        if not os.path.isfile(log):
            continue
        linked = {a for p in work_files for t, a in links_in(p) if t == slug + '.log.md' and a}
        for level, anchor, raw in headings(log):
            if level != 2:
                continue
            if not re.fullmatch(r'[A-Za-z0-9-]+', raw):
                prose_keys.append(f'{log} ## {raw}')
            elif anchor not in linked:
                unlinked.append(f'{log} ## {raw}')
    if not only:
        cross = [os.path.join(d, n) for n in CROSS_WORK if os.path.isfile(os.path.join(d, n))]
        b, c = check_links(cross, lambda p: d)
        broken += b
        checked += c
    print(f'links: {checked} checked' + (f' in {only}' if only else f' across {d}/'))
    for line in broken:
        print(f'- broken: {line}')
    for line in unlinked:
        print(f'- unlinked: {line} (no link from the snapshot or CONTRACT.md)')
    for line in prose_keys:
        print(f'- prose after key: {line} (a key is letters, digits and hyphens; links to it are already broken)')
    if not (broken or unlinked or prose_keys):
        print('links ok: nothing broken, nothing unlinked')


# ---- distill: the scope rule as a scan ---------------------------------------

def cmd_distill():
    d, _ = work_dir()
    if not os.path.isdir(d):
        print(f'work dir {d}/ not present; nothing done, nothing to distill')
        return
    rows = []
    for slug, snap in snapshots(d):
        if frontmatter(text(snap)).get('stage') != 'done':
            continue
        log = os.path.join(os.path.dirname(snap), slug + '.log.md')
        if not os.path.isfile(log):
            rows.append(f'- {slug} — no log')
            continue
        body = text(log)
        first = body.splitlines()[0].strip() if body.strip() else ''
        if first.startswith('distilled'):
            rows.append(f'- {slug} — log {len(body)} chars, first line: {first}')
        else:
            rows.append(f'- {slug} — log {len(body)} chars, undistilled')
    print(f'done works: {len(rows)}')
    for r in rows:
        print(r)


# ---- the rest ----------------------------------------------------------------

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
        elif cmd == 'links':
            cmd_links(argv[2] if len(argv) > 2 else None)
        elif cmd == 'distill':
            cmd_distill()
        elif cmd == 'count':
            cmd_count(argv[2:])
        else:
            print(f'measure: unknown command {cmd!r}; one of status, snapshots, links, distill, count')
    except Exception as e:  # never fail: see the docstring
        print(f'measure: could not measure ({type(e).__name__}: {e})')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
