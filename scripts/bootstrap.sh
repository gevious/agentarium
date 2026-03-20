#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: agentarium/scripts/bootstrap.sh [options]

Starts or recreates the agentarium workspace for SSH-first use.

Options:
  --workspace <name>   Workspace name (default: agentarium)
  --no-recreate        Do not pass --recreate to devpod up.
  --reset-workspace    Pass --reset to devpod up.
  -h, --help           Show this help text.
USAGE
}

WORKSPACE_NAME="agentarium"
RECREATE_WORKSPACE=true
RESET_WORKSPACE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      [[ $# -ge 2 ]] || { echo "Missing value for --workspace" >&2; exit 1; }
      WORKSPACE_NAME="$2"
      shift 2
      ;;
    --no-recreate)
      RECREATE_WORKSPACE=false
      shift
      ;;
    --reset-workspace)
      RESET_WORKSPACE=true
      RECREATE_WORKSPACE=false
      shift
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

UP_FLAGS=""
if [[ "$RESET_WORKSPACE" == true ]]; then
  UP_FLAGS="--reset"
elif [[ "$RECREATE_WORKSPACE" == true ]]; then
  UP_FLAGS="--recreate"
fi

devpod up "$REPO_ROOT" --id "$WORKSPACE_NAME" --ide none --open-ide=false --configure-ssh=true $UP_FLAGS

echo "Workspace ready. Connect with:"
echo "  ./scripts/connect.sh --workspace $WORKSPACE_NAME"
echo
echo "For Codex ChatGPT login with a browser callback, in a separate terminal:"
echo "  ./scripts/codex-tunnel.sh --workspace $WORKSPACE_NAME"
