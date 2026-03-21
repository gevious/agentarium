#!/usr/bin/env bash
set -euo pipefail

bash .devcontainer/setup-codex.sh

CHEZMOI_SOURCE="/workspaces/agentarium/repos/chezmoi"
if command -v chezmoi >/dev/null 2>&1 && [[ -d "$CHEZMOI_SOURCE" ]]; then
  chezmoi apply --source "$CHEZMOI_SOURCE"
else
  echo "Skipping chezmoi apply: chezmoi or source repo missing."
fi
