#!/usr/bin/env bash

# JavaScript/TypeScript (Biome)
if [ -f package.json ] && grep -q biome package.json; then
  npx biome check --apply . > /dev/null 2>&1
fi

# Python (Black + Ruff)
if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
  black . 2>/dev/null || true
  ruff check --fix . 2>/dev/null || true
fi