#!/usr/bin/env python3
"""The work-file format's instrument: counts characters, never bytes, and
reads what /genius, /compact, /reconcile and /distill would otherwise count
by hand.

    measure.py status            the /genius view: work dir, in-flight works, done, backlog, history
    measure.py snapshots         every snapshot's count, whole and roster excluded, against the ceiling
    measure.py links [<slug>]    both directions of the invariant: links that resolve, entries nothing links
    measure.py anchors <slug>    a log's branches, their keys and what already links each — for a close that links without opening the log
    measure.py distill           done works and whether their logs carry the distilled line
    measure.py count <file>...   characters in each file
    measure.py append <slug> <branch> <key> [<about>]   stdin → one log entry; see cmd_append

It counts and never decides; the one command that writes, `append`, writes
only what it is handed, where the caller named, and refuses rather than guesses. It always exits 0 and never raises: a skill
that injects this command is aborted whole if the command fails, and a
count that could not be taken is worth reporting, never worth losing the
skill over. The rules it measures against live in FILE-FORMAT.md and
BACKLOG-FORMAT.md beside it; the numbers here are read from there.
"""
import datetime
import glob
import os
import re
import signal
import subprocess
import sys

if hasattr(signal, 'SIGPIPE'):   # a reader that stops early (a pipe into head) is not a failure
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

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


def log_tree(folder, slug):
    """The work's log as a tree: the root `<slug>.log.md` and the branch files under `log/`.
    Returns (root path or None, [branch paths]), each path inside the work's folder."""
    root = os.path.join(folder, slug + '.log.md')
    if not os.path.isfile(root):
        root = None
    branches = sorted(glob.glob(os.path.join(folder, 'log', '*.md')))
    if root:   # the root's order is the tree's: branches in the order they began, unrooted ones last
        order = [os.path.normpath(os.path.join(folder, t)) for t, _ in links_in(root)]
        branches.sort(key=lambda p: order.index(os.path.normpath(p)) if os.path.normpath(p) in order else len(order))
    return root, branches


def log_entries(folder, slug):
    """Every entry of a work's log as (path relative to the folder, anchor, raw key, file):
    the branches' level-2 keys, and any level-2 key the root itself still holds (a log from
    before the tree keeps its entries there)."""
    root, branches = log_tree(folder, slug)
    out = []
    for path in ([root] if root else []) + branches:
        rel = os.path.relpath(path, folder)
        for level, anchor, raw in headings(path):
            if level == 2:
                out.append((rel, anchor, raw, path))
    return out


def links_from(paths):
    """(target relative to the folder, anchor) for every relative link in these files."""
    found = set()
    for p in paths:
        for t, a in links_in(p):
            found.add((os.path.normpath(t), a))
    return found


def cmd_links(only=None):
    d, _ = work_dir()
    if not os.path.isdir(d):
        print(f'work dir {d}/ not present; no links to check')
        return
    broken, unlinked, unrooted, prose_keys, checked = [], [], [], [], 0
    for slug, snap in snapshots(d):
        if only and slug != only:
            continue
        folder = os.path.dirname(snap)
        work_files = [snap] + [p for p in (os.path.join(folder, 'CONTRACT.md'),) if os.path.isfile(p)]
        root, branches = log_tree(folder, slug)
        b, c = check_links(work_files + ([root] if root else []), lambda p, f=folder: f)
        broken += b
        checked += c
        linked = links_from(work_files)
        for rel, anchor, raw, path in log_entries(folder, slug):
            where = os.path.join(folder, rel)
            if not re.fullmatch(r'[A-Za-z0-9-]+', raw):
                prose_keys.append(f'{where} ## {raw}')
            elif (os.path.normpath(rel), anchor) not in linked:
                unlinked.append(f'{where} ## {raw}')
        rooted = {t for t, _ in links_from([root])} if root else set()
        for path in branches:
            if os.path.normpath(os.path.relpath(path, folder)) not in rooted:
                unrooted.append(path)
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
    for line in unrooted:
        print(f'- unrooted: {line} (a branch with no line in the root of the log)')
    for line in prose_keys:
        print(f'- prose after key: {line} (a key is letters, digits and hyphens; links to it are already broken)')
    if not (broken or unlinked or unrooted or prose_keys):
        print('links ok: nothing broken, nothing unlinked')


# ---- anchors: link without opening the log ------------------------------------

def cmd_anchors(slug):
    """Every branch of the work's log and every `##` key in it, with what already links each,
    so a close can append and link without reading the log whole."""
    d, _ = work_dir()
    if not slug:
        print('measure: anchors needs a slug')
        return
    folder = os.path.join(d, slug)
    snap, contract = os.path.join(folder, slug + '.md'), os.path.join(folder, 'CONTRACT.md')
    if not os.path.isfile(snap):
        print(f'no snapshot at {snap}')
        return
    root, branches = log_tree(folder, slug)
    if not root and not branches:
        print(f'{slug}: no log yet — the first entry creates the root and its branch')
        return
    linked = {}
    for name, path in (('snapshot', snap), ('contract', contract)):
        if os.path.isfile(path):
            for t, a in links_in(path):
                if a and name not in linked.setdefault((os.path.normpath(t), a), []):
                    linked[(os.path.normpath(t), a)].append(name)
    body = text(root) if root else ''
    first = body.splitlines()[0].strip() if body.strip() else ''
    sizes = {p: len(text(p)) for p in branches}
    total = len(body) + sum(sizes.values())
    print(f'{slug}: log {total} chars — root {len(body)}, {len(branches)} branches'
          + (f', first line: {first}' if first.startswith('distilled') else ''))
    if not root:
        print(f'- ⚠ no root at {slug}.log.md: the branches have no table of contents')
    entries = log_entries(folder, slug)
    for rel, anchor, raw, path in entries:
        flag = '' if re.fullmatch(r'[A-Za-z0-9-]+', raw) else ' ⚠ prose after key'
        size = f' ({sizes[path]} chars)' if path in sizes else ''
        by = ', '.join(linked.get((os.path.normpath(rel), anchor), [])) or 'nothing'
        print(f'- {rel}{size} ## {raw}{flag} — linked from: {by}')
    for path in branches:
        if not any(e[3] == path for e in entries):
            print(f'- {os.path.relpath(path, folder)} ({sizes[path]} chars) — no `##` key')
    if root:
        rooted = [t for t, _ in LINK.findall(body) if t.startswith('log/')]
        if rooted:
            print(f'newest branch in the root: {rooted[-1]}')


def read_stdin(wait=2.0):
    """The entry body, from stdin — but never a hang: a terminal, or a pipe that sends nothing
    within `wait` seconds, reads as empty, and the append is refused for an empty body."""
    try:
        import select
        if sys.stdin is None or sys.stdin.isatty():
            return ''
        ready, _, _ = select.select([sys.stdin], [], [], wait)
        return sys.stdin.read() if ready else ''
    except Exception:
        return ''


def cmd_append(slug, branch, key, about, body):
    """Append one entry to a work's log: `## <key>` and the body from stdin, at the end of
    `log/<branch>.md`. A branch that does not exist yet is created, and its line appended to
    the root, `- [<branch>](log/<branch>.md) — <date> — <about>`, so the caller must say what
    the branch is about. A key that is already the last entry of that branch takes the body
    below it (a `-wip` entry growing as the loop moves); a key anywhere else in the log is
    refused, because keys are unique and a second copy is a broken anchor. It writes only
    what it is handed, where the caller named: the branch and the key are the caller's call,
    and on anything it cannot do it writes nothing and says why."""
    d, _ = work_dir()
    if not (slug and branch and key):
        print('measure: append needs <slug> <branch> <key> [<about>], the entry body on stdin')
        return
    for name, v in (('branch', branch), ('key', key)):
        if not re.fullmatch(r'[A-Za-z0-9-]+', v):
            print(f'measure: append refused — {name} {v!r} is not letters, digits and hyphens only')
            return
    folder = os.path.join(d, slug)
    if not os.path.isfile(os.path.join(folder, slug + '.md')):
        print(f'measure: append refused — no snapshot at {os.path.join(folder, slug + ".md")}')
        return
    body = body.strip('\n')
    if not body:
        print('measure: append refused — the entry body on stdin is empty')
        return
    path = os.path.join(folder, 'log', branch + '.md')
    rel = f'log/{branch}.md'
    continuing = False
    for erel, anchor, raw, epath in log_entries(folder, slug):
        if raw == key:
            last = [r for lv, _a, r in headings(epath) if lv == 2][-1:]
            if os.path.normpath(epath) == os.path.normpath(path) and last == [key]:
                continuing = True
            else:
                print(f'measure: append refused — key {key!r} already exists in {erel}; '
                      f'take a new key (date-suffixed on collision)')
                return
    root = os.path.join(folder, slug + '.log.md')
    new_branch = not os.path.isfile(path)
    if new_branch and not about:
        print(f'measure: append refused — {rel} is a new branch; say what it is about, '
              f'for its line in the root')
        return
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'a', encoding='utf-8') as f:
        if continuing:
            f.write(body + '\n')
        else:
            prefix = '\n' if os.path.getsize(path) and not text(path).endswith('\n\n') else ''
            f.write(f'{prefix}## {key}\n{body}\n')
    if new_branch:
        line = f'- [{branch}]({rel}) — {datetime.date.today().isoformat()} — {about}\n'
        existing = text(root) if os.path.isfile(root) else ''
        with open(root, 'a', encoding='utf-8') as f:
            f.write(('' if not existing or existing.endswith('\n') else '\n') + line)
    what = 'continued' if continuing else ('new branch, root line added' if new_branch else 'appended')
    print(f'{rel}#{key} — {what}')


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
        root, branches = log_tree(os.path.dirname(snap), slug)
        if not root and not branches:
            rows.append(f'- {slug} — no log')
            continue
        body = text(root) if root else ''
        size = len(body) + sum(len(text(p)) for p in branches)
        shape = f'log {size} chars, {len(branches)} branches'
        first = body.splitlines()[0].strip() if body.strip() else ''
        if first.startswith('distilled'):
            rows.append(f'- {slug} — {shape}, first line: {first}')
        else:
            rows.append(f'- {slug} — {shape}, undistilled')
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
        elif cmd == 'anchors':
            cmd_anchors(argv[2] if len(argv) > 2 else None)
        elif cmd == 'count':
            cmd_count(argv[2:])
        elif cmd == 'append':
            a = argv[2:6] + [None] * (4 - len(argv[2:6]))
            cmd_append(a[0], a[1], a[2], a[3], read_stdin())
        else:
            print(f'measure: unknown command {cmd!r}; one of status, snapshots, links, anchors, distill, count, append')
    except Exception as e:  # never fail: see the docstring
        print(f'measure: could not measure ({type(e).__name__}: {e})')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
