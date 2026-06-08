#!/usr/bin/env bash

# Stop on errors and catch typos in variable names early.
set -eu

# Remember where the user ran the script — files land here, not in the temp folder.
out=$(pwd)

# Git needs a workspace to fetch into; we delete it when the script exits.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Shallow partial clone: get the file tree without downloading every file's content yet.
# --depth 1          → latest commit only, no history
# --filter=blob:none → skip file contents until we explicitly ask for them
# --no-checkout      → don't write any files to disk yet
git clone -q --depth 1 --filter=blob:none --no-checkout \
  -b Master https://github.com/busycaesar/Bheru.git "$tmp/repo"

cd "$tmp/repo"

# .distignore is always excluded — it controls distribution, not the installed output.
ignore=(.distignore)

# Read .distignore from the repo and add each entry to the skip list.
if git cat-file -e HEAD:.distignore 2>/dev/null; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}                              # strip comments
    line=${line#"${line%%[![:space:]]*}"}          # trim leading whitespace
    line=${line%"${line##*[![:space:]]}"}         # trim trailing whitespace
    [[ -n "$line" ]] && ignore+=("$line")
  done < <(git show HEAD:.distignore)
fi

# Walk every file in the repo and keep only those not on the skip list.
files=()
while IFS= read -r path; do
  for p in "${ignore[@]}"; do
    [[ "$path" == "$p" || "$path" == "$p/"* || "${path##*/}" == $p ]] && continue 2
  done
  files+=("$path")
done < <(git ls-tree -r --name-only HEAD)

# Download content for the allowed files only — ignored files are never fetched.
git checkout HEAD -- "${files[@]}"

# Copy installed files into the user's directory (flat, by filename).
cp "${files[@]}" "$out/"
