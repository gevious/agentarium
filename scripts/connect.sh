#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: agentarium/scripts/connect.sh [options]

Open an SSH session to the workspace.

Options:
  --workspace <name>   Workspace name (default: agentarium)
  --codex-auth         Forward localhost:1455 for Codex browser login callbacks.
  --command <command>  Run a remote command instead of opening an interactive shell.
  -h, --help           Show this help text.
USAGE
}

WORKSPACE_NAME="agentarium"
FORWARD_CODEX_AUTH=false
REMOTE_COMMAND=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      [[ $# -ge 2 ]] || { echo "Missing value for --workspace" >&2; exit 1; }
      WORKSPACE_NAME="$2"
      shift 2
      ;;
    --codex-auth)
      FORWARD_CODEX_AUTH=true
      shift
      ;;
    --command)
      [[ $# -ge 2 ]] || { echo "Missing value for --command" >&2; exit 1; }
      REMOTE_COMMAND="$2"
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

SSH_ARGS=()

if [[ "$FORWARD_CODEX_AUTH" == true ]]; then
  SSH_ARGS+=("--forward-ports" "1455:localhost:1455")
fi

if [[ -n "$REMOTE_COMMAND" ]]; then
  SSH_ARGS+=("--command" "$REMOTE_COMMAND")
fi

exec devpod ssh "${SSH_ARGS[@]}" "$WORKSPACE_NAME"
