#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/workspace}"
export HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export PLAYWRIGHT_BROWSERS_PATH="${PLAYWRIGHT_BROWSERS_PATH:-/opt/playwright}"
export PATH="/opt/hermes/venv/bin:$PATH"

mkdir -p \
  "$HOME" \
  "$HERMES_HOME" \
  "$XDG_CACHE_HOME" \
  "$HERMES_HOME/sessions" \
  "$HERMES_HOME/memories" \
  "$HERMES_HOME/skills" \
  "$HERMES_HOME/cron" \
  "$HERMES_HOME/hooks" \
  "$HERMES_HOME/logs" \
  "$HERMES_HOME/skins"

if [ ! -f "$HERMES_HOME/.env" ] && [ -f /opt/hermes/.env.example ]; then
  cp /opt/hermes/.env.example "$HERMES_HOME/.env"
fi

if [ ! -f "$HERMES_HOME/config.yaml" ] && [ -f /opt/hermes/config.yaml ]; then
  cp /opt/hermes/config.yaml "$HERMES_HOME/config.yaml"
fi

if [ ! -f "$HERMES_HOME/SOUL.md" ] && [ -f /opt/hermes/SOUL.md ]; then
  cp /opt/hermes/SOUL.md "$HERMES_HOME/SOUL.md"
fi

exec "$@"
