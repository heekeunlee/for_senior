#!/usr/bin/env bash
# src/syllabus.html (조각) → index.html (독립 실행 가능한 페이지)
set -euo pipefail
cd "$(dirname "$0")"
{
  cat <<'HEAD'
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="은퇴·은퇴예정 사무직을 대상으로 한 12주 AI 활용 실무 과정 강의계획서. 국내 공공·민간 시니어 AI 교육 운영 사례를 조사해 대조 검증했습니다.">
<meta name="color-scheme" content="light dark">
<meta property="og:title" content="두 번째 명함 — AI 활용 실무 과정 강의계획서">
<meta property="og:description" content="은퇴 사무직을 위한 12주 AI 과정. 국내 운영 사례 벤치마크 포함.">
<meta property="og:type" content="website">
<style>*,*::before,*::after{box-sizing:border-box}body{margin:0}</style>
HEAD
  cat src/syllabus.html
  printf '\n</head>\n<body>\n'
  printf '</body>\n</html>\n'
} > /tmp/_raw.html

# <title>/<style>은 head에, 나머지는 body에 오도록 재조립
python3 - <<'PY'
import re, pathlib
src = pathlib.Path('src/syllabus.html').read_text(encoding='utf-8')
m = re.search(r'(<title>.*?</title>\s*<style>.*?</style>)', src, re.S)
head_part, body_part = m.group(1), src[m.end():]
head = '''<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="은퇴·은퇴예정 사무직을 대상으로 한 12주 AI 활용 실무 과정 강의계획서. 국내 공공·민간 시니어 AI 교육 운영 사례를 조사해 대조 검증했습니다.">
<meta name="color-scheme" content="light dark">
<meta property="og:title" content="두 번째 명함 — AI 활용 실무 과정 강의계획서">
<meta property="og:description" content="은퇴 사무직을 위한 12주 AI 과정. 국내 운영 사례 벤치마크 포함.">
<style>*,*::before,*::after{box-sizing:border-box}body{margin:0}</style>
'''
out = head + head_part + '\n</head>\n<body>\n' + body_part.strip() + '\n</body>\n</html>\n'
pathlib.Path('index.html').write_text(out, encoding='utf-8')
print('index.html written:', len(out), 'bytes')
PY
