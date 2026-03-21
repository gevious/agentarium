#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="/workspaces/agentarium/skills"
CONFIG_FILE="$CODEX_HOME/config.toml"
USER_SKILLS_LINK="$CODEX_HOME/skills/user"
CODEX_APPROVAL_POLICY="${CODEX_APPROVAL_POLICY:-on-request}"
CODEX_SANDBOX_MODE="${CODEX_SANDBOX_MODE:-danger-full-access}"

mkdir -p "$CODEX_HOME/skills"

DESIRED_CONFIG=$(
  cat <<EOC
approval_policy = "${CODEX_APPROVAL_POLICY}"
sandbox_mode = "${CODEX_SANDBOX_MODE}"
EOC
)

if [[ ! -f "$CONFIG_FILE" ]] || [[ "$(cat "$CONFIG_FILE")" != "$DESIRED_CONFIG" ]]; then
  printf '%s\n' "$DESIRED_CONFIG" >"$CONFIG_FILE"
fi

if [[ ! -L "$USER_SKILLS_LINK" ]] || [[ "$(readlink "$USER_SKILLS_LINK")" != "$SKILLS_DIR" ]]; then
  ln -sfn "$SKILLS_DIR" "$USER_SKILLS_LINK"
fi
