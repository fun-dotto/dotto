#!/bin/bash

# Pre-commit hook: Dart format check
# Staged .dart files (excluding generated files) that are not properly formatted will block the commit.

staged_files=$(git diff --cached --name-only --diff-filter=ACMR -- '*.dart' | grep -v '^api/' | grep -v '\.g\.dart$' | grep -v '\.freezed\.dart$' | grep -v '\.gen\.dart$')

if [ -z "$staged_files" ]; then
  exit 0
fi

echo "$staged_files" | xargs dart format --output=none --set-exit-if-changed

if [ $? -ne 0 ]; then
  echo ""
  echo "ERROR: Some files are not formatted."
  echo "Run 'dart format .' to fix formatting, then stage the changes."
  exit 1
fi
