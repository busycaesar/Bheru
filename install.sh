#!/usr/bin/env bash
set -euo pipefail

REPO="${BHERU_REPO:-busycaesar/Bheru}"
BRANCH="${BHERU_BRANCH:-Master}"
OUTPUT_DIR="${BHERU_OUTPUT_DIR:-.}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install files from the Bheru GitHub repo, excluding paths listed in .distignore.
Only the files you need are downloaded (requires Git).

Options:
  -d, --dir DIR       Output directory (default: current directory)
  -r, --repo OWNER/REPO
                      GitHub repository (default: ${REPO})
  -b, --branch BRANCH
                      Branch to install (default: ${BRANCH})
  -h, --help          Show this help message

Environment:
  BHERU_REPO          Same as --repo
  BHERU_BRANCH        Same as --branch
  BHERU_OUTPUT_DIR    Same as --dir

Example:
  curl -fsSL https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh | bash
  ./install.sh --dir ~/.cursor/rules
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -r|--repo)
      REPO="$2"
      shift 2
      ;;
    -b|--branch)
      BRANCH="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required." >&2
  exit 1
fi

REPO_URL="https://github.com/${REPO}.git"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

export GIT_TERMINAL_PROMPT=0

echo "Fetching file list from ${REPO} (${BRANCH})..."
git clone -q --depth 1 --filter=blob:none --no-checkout -b "$BRANCH" "$REPO_URL" "$TMP_DIR/repo"

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

echo "Downloading ${#files_to_install[@]} file(s)..."
git checkout HEAD -- "${files_to_install[@]}"

mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"

for relpath in "${files_to_install[@]}"; do
  dest="${OUTPUT_DIR}/${relpath}"
  mkdir -p "$(dirname "$dest")"
  cp "$relpath" "$dest"
done

echo "Installed ${#files_to_install[@]} file(s) to ${OUTPUT_DIR}"
