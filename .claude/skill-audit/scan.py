#!/usr/bin/env python3
"""The skill audit's instrument: inventories the plugin's prompt surface and
counts the signals the audit's lenses start from. It counts and never
decides — every signal is a place to look, and whether it is a finding is
the auditor's call, then the skeptics'.

    scan.py summary            one screen: the inventory and the signal counts per file
    scan.py json [<out>]       the whole scan as JSON (to <out>, or stdout)
    scan.py units              the audit units, one per line: a skill's name and its files

Run from the repository root. It always exits 0: the workflow runs it first,
and a skill whose injected command fails is aborted whole — a count that
could not be taken is reported, never worth losing the audit over.
"""
import glob
import json
import os
import re
import signal
import subprocess
import sys

if hasattr(signal, 'SIGPIPE'):
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

try:
    import yaml
except Exception:          # the audit still runs; frontmatter is then read by the fallback below
    yaml = None

# The signal table. Each is a regex from claude-api's prompt-audit (Group 1-3
# signals), narrowed to what this repo's prose can contain. A hit is a line to
# read, not a finding: the repo writes reasons beside its rules, and a
# "never" with its "because" in the same sentence is the house style.
SIGNALS = {
    'pressure':     r'\b(MUST|NEVER|ALWAYS|CRITICAL|IMPORTANT)\b|!!|⚠',
    'hedge':        r'\b(try to|if possible|ideally|where possible)\b',
    'trait-claim':  r'\byou (tend to|often|sometimes|usually)\b',
    'step-script':  r'^\s*(STEP \d|\d+\.\s)',
    'prohibition':  r'^\s*[-*]?\s*(Do not|Don\'t|Never|Avoid)\b',
    'dated':        r'\b20\d\d-\d\d-\d\d\b|\bmeasured\b|\bv?\d+\.\d+\.\d+\b',
    'commit-ref':   r'(?<![\w/.-])[0-9a-f]{7,12}(?![\w-])',
    'relative-time': r'\b(no longer|now works|used to|instead of the old|previously)\b',
    'grader-vocab': r'\b(graded|grader|rubric|hidden tests?|you will be scored)\b',
    'think-scaffold': r'think step by step|<scratchpad>|<thinking>|think (harder|less)|take a deep breath',
    'word-cap':     r'\bat most \d+ (words|sentences|lines)\b|\bunder \d+ words\b',
}
CASELESS = ('hedge', 'trait-claim', 'relative-time', 'grader-vocab', 'think-scaffold')
BECAUSE = re.compile(r'\b(because|so that|since|—|: )', re.I)
LINK = re.compile(r'\]\(([^)\s#<>]+)(?:#[^)]*)?\)')


def text(path):
    with open(path, encoding='utf-8', errors='replace') as f:
        return f.read()


def split_frontmatter(body):
    if not body.startswith('---\n'):
        return None, body, 0
    end = body.find('\n---\n', 4)
    if end < 0:
        return None, body, 0
    return body[4:end], body[end + 5:], body[:end + 5].count('\n')


def parse_frontmatter(raw):
    if raw is None:
        return {}, 'no frontmatter'
    if yaml is not None:
        try:
            fm = yaml.safe_load(raw)
            return (fm if isinstance(fm, dict) else {}), None if isinstance(fm, dict) else 'frontmatter is not a mapping'
        except Exception as e:
            return {}, f'yaml: {str(e).splitlines()[0]}'
    fm = {}
    for line in raw.splitlines():
        m = re.match(r'^([A-Za-z_][\w-]*):\s*(.*)$', line)
        if m:
            fm[m.group(1)] = m.group(2).strip().strip('"')
    return fm, None


def git(*args):
    try:
        r = subprocess.run(['git', *args], capture_output=True, text=True, timeout=20)
        return r.stdout if r.returncode == 0 else ''
    except Exception:
        return ''


def signals(body, first_line):
    hits = {}
    in_fence = False
    for i, line in enumerate(body.splitlines(), start=first_line + 1):
        if line.lstrip().startswith('```'):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        for name, rx in SIGNALS.items():
            flags = re.I if name in CASELESS else 0
            if re.search(rx, line, flags):
                entry = {'line': i, 'text': line.strip()[:200]}
                if name == 'pressure':
                    entry['reason_beside'] = bool(BECAUSE.search(line))
                hits.setdefault(name, []).append(entry)
    return hits


def prohibition_runs(hits):
    """Three or more prohibition lines in a row: prompt-audit's 1c/1e cluster."""
    lines = [h['line'] for h in hits.get('prohibition', [])]
    runs, cur = [], []
    for n in lines:
        if cur and n == cur[-1] + 1:
            cur.append(n)
        else:
            if len(cur) >= 3:
                runs.append([cur[0], cur[-1]])
            cur = [n]
    if len(cur) >= 3:
        runs.append([cur[0], cur[-1]])
    return runs


def broken_links(path, body):
    base = os.path.dirname(path)
    out = []
    for t in LINK.findall(body):
        if t.startswith('http') or t.endswith('.log.md') or t == 'CONTRACT.md':
            continue
        if not os.path.exists(os.path.normpath(os.path.join(base, t))):
            out.append(t)
    return out


def file_record(path):
    body = text(path)
    raw, rest, fm_lines = split_frontmatter(body)
    fm, fm_error = parse_frontmatter(raw) if path.endswith('.md') else ({}, None)
    hits = signals(rest, fm_lines) if path.endswith('.md') else {}
    log = git('log', '--format=%h %cs %s', '--', path).splitlines()
    rec = {
        'path': path,
        'chars': len(body),
        'lines': body.count('\n') + 1,
        'frontmatter': fm,
        'frontmatter_error': fm_error,
        'signals': {k: v for k, v in hits.items()},
        'signal_counts': {k: len(v) for k, v in hits.items()},
        'prohibition_runs': prohibition_runs(hits),
        'broken_links': broken_links(path, body) if path.endswith('.md') else [],
        'commits': len(log),
        'last_commit': log[0] if log else None,
    }
    if path.endswith('.md'):
        rec['description_chars'] = len(str(fm.get('description', '')))
    return rec


def shingles(body, n=9):
    words = re.findall(r'[\w`\'-]+', body.lower())
    return {' '.join(words[i:i + n]) for i in range(len(words) - n + 1)}


def shared_passages(records, min_shared=3):
    """Pairs of files sharing runs of nine identical words: the one-home rule's
    first place to look. Shared wording is not drift by itself — a pointer
    quotes its rule's name — so the pair and its count go to the lens, whole."""
    sh = {r['path']: shingles(text(r['path'])) for r in records if r['path'].endswith('.md')}
    paths = sorted(sh)
    out = []
    for i, a in enumerate(paths):
        for b in paths[i + 1:]:
            common = sh[a] & sh[b]
            if len(common) >= min_shared:
                out.append({'a': a, 'b': b, 'shared_9grams': len(common),
                            'sample': sorted(common)[:3]})
    return sorted(out, key=lambda x: -x['shared_9grams'])


def plugin_checks(skill_names):
    out = {}
    try:
        pj = json.loads(text('.claude-plugin/plugin.json'))
        out['version'] = pj.get('version')
        out['agents_missing'] = [a for a in pj.get('agents', []) if not os.path.isfile(a)]
    except Exception as e:
        out['error'] = str(e)
    try:
        first = text('README.md').splitlines()
        m = re.search(r'(\d+) skills', ' '.join(first[:5]))
        out['readme_skill_count'] = int(m.group(1)) if m else None
    except Exception:
        out['readme_skill_count'] = None
    out['skill_count'] = len(skill_names)
    return out


def scan():
    skill_dirs = sorted(d for d in glob.glob('skills/*/') if os.path.isfile(os.path.join(d, 'SKILL.md')))
    units, records = [], []
    for d in skill_dirs:
        name = os.path.basename(os.path.dirname(d))
        files = sorted(f for f in glob.glob(os.path.join(d, '**', '*'), recursive=True)
                       if os.path.isfile(f) and f.endswith(('.md', '.py')) and '__pycache__' not in f)
        recs = [file_record(f) for f in files]
        records += recs
        skill = next(r for r in recs if r['path'].endswith('/SKILL.md') and os.path.dirname(r['path']) == d.rstrip('/'))
        fm = skill['frontmatter']
        units.append({
            'name': name,
            'files': files,
            'chars': sum(r['chars'] for r in recs),
            'invocation': 'user-typed' if fm.get('disable-model-invocation') else 'model-invoked',
            'name_matches_folder': fm.get('name') == name,
            'has_hooks': 'hooks' in fm,
            'allowed_tools': fm.get('allowed-tools'),
            'agents': [f for f in files if '/agents/' in f],
        })
    return {
        'units': units,
        'files': records,
        'shared_passages': shared_passages(records),
        'plugin': plugin_checks([u['name'] for u in units]),
        'descriptions': {u['name']: next(r for r in records if r['path'] == f'skills/{u["name"]}/SKILL.md')['frontmatter'].get('description', '')
                         for u in units},
    }


def cmd_summary(s):
    p = s['plugin']
    print(f"plugin {p.get('version')}: {p['skill_count']} skills (README says {p.get('readme_skill_count')}), "
          f"agents missing: {p.get('agents_missing') or 'none'}")
    print()
    print('unit | invocation | chars | files | pressure (no reason beside) | prohibition runs | dated | broken links | fm error')
    by_path = {r['path']: r for r in s['files']}
    for u in s['units']:
        recs = [by_path[f] for f in u['files']]
        pressure = sum(r['signal_counts'].get('pressure', 0) for r in recs)
        bare = sum(1 for r in recs for h in r['signals'].get('pressure', []) if not h.get('reason_beside'))
        runs = sum(len(r['prohibition_runs']) for r in recs)
        dated = sum(r['signal_counts'].get('dated', 0) for r in recs)
        broken = sum(len(r['broken_links']) for r in recs)
        fme = '; '.join(f"{r['path']}: {r['frontmatter_error']}" for r in recs
                        if r['frontmatter_error'] and (r['path'].endswith('SKILL.md') or '/agents/' in r['path']))
        print(f"{u['name']} | {u['invocation']} | {u['chars']} | {len(u['files'])} | {pressure} ({bare}) | {runs} | {dated} | {broken} | {fme or '-'}")
    print()
    unit_of = lambda path: path.split('/')[1]
    top = [x for x in s['shared_passages'] if unit_of(x['a']) != unit_of(x['b'])][:10]
    if top:
        print('most shared wording across skills (9-word runs), a place to look for a rule with two homes:')
        for x in top:
            print(f"  {x['shared_9grams']:>3}  {x['a']}  ~  {x['b']}")


def main(argv):
    cmd = argv[1] if len(argv) > 1 else 'summary'
    try:
        s = scan()
        if cmd == 'json':
            out = json.dumps(s, ensure_ascii=False, indent=1)
            if len(argv) > 2:
                os.makedirs(os.path.dirname(argv[2]) or '.', exist_ok=True)
                with open(argv[2], 'w', encoding='utf-8') as f:
                    f.write(out)
                print(f'scan written to {argv[2]}: {len(s["units"])} units, {len(s["files"])} files')
            else:
                print(out)
        elif cmd == 'units':
            for u in s['units']:
                print(u['name'], ' '.join(u['files']))
        else:
            cmd_summary(s)
    except Exception as e:     # never abort the skill that injects this
        print(f'scan could not complete: {type(e).__name__}: {e}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
