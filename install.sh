#!/usr/bin/env bash
set -eu

out=$(pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git clone -q --depth 1 --filter=blob:none --no-checkout \
  -b Master https://github.com/busycaesar/Bheru.git "$tmp/repo"

cd "$tmp/repo"

ignore=(.distignore)

if git cat-file -e HEAD:.distignore 2>/dev/null; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    line=${line#"${line%%[![:space:]]*}"}
    line=${line%"${line##*[![:space:]]}"}
    [[ -n "$line" ]] && ignore+=("$line")
  done < <(git show HEAD:.distignore)
fi

files=()
while IFS= read -r path; do
  for p in "${ignore[@]}"; do
    [[ "$path" == "$p" || "$path" == "$p/"* || "${path##*/}" == $p ]] && continue 2
  done
  files+=("$path")
done < <(git ls-tree -r --name-only HEAD)

git checkout HEAD -- "${files[@]}"
cp "${files[@]}" "$out/"