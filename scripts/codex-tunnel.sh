#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: agentarium/scripts/codex-tunnel.sh [options]

Keep the Codex localhost callback tunnel open for browser login.

Run this in a separate terminal and leave it open while using Codex.

Options:
  --workspace <name>   Workspace name (default: agentarium)
  -h, --help           Show this help text.
USAGE
}

WORKSPACE_NAME="agentarium"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      [[ $# -ge 2 ]] || { echo "Missing value for --workspace" >&2; exit 1; }
      WORKSPACE_NAME="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

require_cmd() {
  local cmd=$1
  command -v "$cmd" >/dev/null 2>&1 || { echo "Required command missing: $cmd" >&2; exit 1; }
}

require_cmd devpod

exec devpod ssh \
  --forward-ports 1455:localhost:1455 \
  --command "echo 'Codex auth tunnel active on localhost:1455. Leave this terminal open.'; tail -f /dev/null" \
  "$WORKSPACE_NAME"
