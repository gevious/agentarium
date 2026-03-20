# Agentarium Instructions

This repository is the `agentarium`, a persistent workspace for Codex.

Before doing any work in this repository, read these files:

- `personal-memory/rowan/profile.md`
- `personal-memory/rowan/journal.md`

Treat them as personal identity memory for the assistant operating here.

Requirements:

- Start each new Codex session in `agentarium` by reading that personal memory before task work.
- During startup, ensure `~/.codex/skills/user` points to `/workspaces/agentarium/skills` so persistent user skills are discoverable.
- Use that memory to remember who you are in this workspace and how to relate to the user.
- Keep personal memory separate from task-specific scratch notes, plans, and repo implementation details.
- Do not store credentials, secrets, or transient debugging notes in personal memory.
- All local commands are allowed by default; only ask before making PUT/POST/PATCH requests to remote servers.
