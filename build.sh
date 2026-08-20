#!/usr/bin/env bash
# src/*.html (조각) → 독립 실행 가능한 페이지
#   src/syllabus.html → index.html          (강의계획서)
#   src/deck.html     → deck/index.html     (발표 키노트)
set -euo pipefail
cd "$(dirname "$0")"
python3 - <<'PY'
import re, pathlib

PAGES = [
  ('src/syllabus.html', 'index.html',
   '은퇴·은퇴예정 사무직을 대상으로 한 12주 AI 활용 실무 과정 강의계획서. 국내 공공·민간 시니어 AI 교육 운영 사례를 조사해 대조 검증했습니다.',
   '두 번째 명함 — AI 활용 실무 과정 강의계획서', 'light dark'),
  ('src/deck.html', 'deck/index.html',
   '「두 번째 명함」 과정 발표용 키노트. 화살표 키로 이동합니다.',
   '두 번째 명함 — 발표 키노트', 'dark'),
]

for src, dst, desc, og, scheme in PAGES:
    s = pathlib.Path(src).read_text(encoding='utf-8')
    m = re.search(r'(<title>.*?</title>\s*<style>.*?</style>)', s, re.S)
    head_part, body_part = m.group(1), s[m.end():]
    head = f'''<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="{desc}">
<meta name="color-scheme" content="{scheme}">
<meta property="og:title" content="{og}">
<meta property="og:description" content="{desc}">
<style>*,*::before,*::after{{box-sizing:border-box}}body{{margin:0}}</style>
'''
    out = head + head_part + '\n</head>\n<body>\n' + body_part.strip() + '\n</body>\n</html>\n'
    p = pathlib.Path(dst); p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(out, encoding='utf-8')
    print(f'{dst}: {len(out)} chars')
PY
