#!/usr/bin/env bash
set -euo pipefail

REPO="busycaesar/Bheru"
BRANCH="Master"
OUTPUT_DIR="$(pwd)"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

export GIT_TERMINAL_PROMPT=0

git clone -q --depth 1 --filter=blob:none --no-checkout \
  -b "$BRANCH" "https://github.com/${REPO}.git" "$TMP_DIR/repo"

cd "$TMP_DIR/repo"

IGNORE_PATTERNS=(".distignore")

if git cat-file -e "HEAD:.distignore" 2>/dev/null; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line%"${line##*[![:space:]]}"}"
    line="${line#"${line%%[![:space:]]*}"}"
    [[ -n "$line" ]] && IGNORE_PATTERNS+=("$line")
  done < <(git show HEAD:.distignore)
fi

matches_pattern() {
  local relpath="$1"
  local pattern="$2"
  local name="${relpath##*/}"

  if [[ "$pattern" == */ ]]; then
    pattern="${pattern%/}"
    [[ "$relpath" == "$pattern" || "$relpath" == "$pattern"/* ]]
    return
  fi

  if [[ "$pattern" == */* ]]; then
    [[ "$relpath" == "$pattern" || "$relpath" == "$pattern"/* ]]
    return
  fi

  [[ "$name" == $pattern || "$relpath" == $pattern || "$relpath" == */"$pattern" ]]
}

should_ignore() {
  local relpath="$1"
  local pattern

  for pattern in "${IGNORE_PATTERNS[@]}"; do
    if matches_pattern "$relpath" "$pattern"; then
      return 0
    fi
  done

  return 1
}

files_to_install=()
while IFS= read -r relpath; do
  if ! should_ignore "$relpath"; then
    files_to_install+=("$relpath")
  fi
done < <(git ls-tree -r --name-only HEAD)

if [[ ${#files_to_install[@]} -eq 0 ]]; then
  echo "Error: no files to install." >&2
  exit 1
fi

git checkout HEAD -- "${files_to_install[@]}"

for relpath in "${files_to_install[@]}"; do
  dest="${OUTPUT_DIR}/${relpath##*/}"
  cp "$relpath" "$dest"
done

echo "Installed ${#files_to_install[@]} file(s) to ${OUTPUT_DIR}"
