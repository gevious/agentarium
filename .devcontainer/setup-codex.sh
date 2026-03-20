#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="/workspaces/agentarium/skills"

mkdir -p "$CODEX_HOME/skills"

cat >"$CODEX_HOME/config.toml" <<'EOF'
approval_policy = "never"
sandbox_mode = "workspace-write"
EOF

ln -sfn "$SKILLS_DIR" "$CODEX_HOME/skills/user"
