#!/usr/bin/env bash
# 저장소 내 README/docs/references 파일들을 하나의 통합 마크다운 파일로 합친다.
# 실행 위치와 무관하게 동작하도록 스크립트 자신의 위치 기준으로 경로를 계산한다.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$(cd "$REPO_DIR/.." && pwd)"
OUT_FILE="$OUT_DIR/뛰뛰빵빵_통합자료.md"
REPO_NAME="$(basename "$REPO_DIR")"

cd "$REPO_DIR"

# README + docs/*.md + references/*.md 순서로, 각 폴더 내부는 파일명 정렬
FILES=()
[ -f README.md ] && FILES+=("README.md")
if [ -d docs ]; then
  while IFS= read -r f; do FILES+=("$f"); done < <(find docs -maxdepth 1 -name "*.md" | sort)
fi
if [ -d references ]; then
  while IFS= read -r f; do FILES+=("$f"); done < <(find references -maxdepth 1 -name "*.md" | sort)
fi

{
  echo "# 뛰뛰빵빵 IR / 사업계획서 — 통합자료"
  echo ""
  echo "> 이 파일은 \`$REPO_NAME\` 저장소의 내용을 원문 그대로 한 파일에 모은 것이다. 내용은 수정하지 않았으며, 각 절 제목 아래에 원본 파일 경로를 표시했다."
  echo "> 이 파일은 커밋 시 자동으로 재생성된다 (scripts/generate-integrated-doc.sh, post-commit hook). 직접 수정하지 말 것."
  echo ""
  echo "## 목차 / 원본 출처"
  echo ""
  i=1
  for f in "${FILES[@]}"; do
    echo "$i. \`$REPO_NAME/$f\`"
    i=$((i+1))
  done
  echo ""
  echo "---"
  echo ""

  i=1
  for f in "${FILES[@]}"; do
    echo "## $i. \`$REPO_NAME/$f\`"
    echo ""
    cat "./$f"
    echo ""
    echo "---"
    echo ""
    i=$((i+1))
  done
} > "$OUT_FILE"

echo "통합파일 갱신 완료: $OUT_FILE"
