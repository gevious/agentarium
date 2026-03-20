# agentarium

`agentarium` is a long-running DevPod workspace for agent-driven work.

It is intentionally narrower than a personal shell container:
- no host GUI config
- no sway/wayland setup
- no automatic `chezmoi apply`
- no repo-specific bootstrap beyond basic container defaults

It is intentionally broader than a single-repo sandbox:
- persistent workspace for agent sessions
- clone and delete working repos as needed
- suitable for `chezmoi`, app repos, experiments, and one-off automation

## Included

- `bash`, `zsh`
- `git`, `gh`, `openssh`
- `curl`, `wget`, `jq`
- `nodejs`, `npm`
- `codex` CLI (`@openai/codex`)
- `ripgrep`, `fd`, `fzf`
- `neovim`, `tmux`, `less`
- standard Unix text/archive/build tools

## Not Included

- sway, wayland, terminal GUI setup
- automatic dotfiles application
- Proton Pass CLI
- language runtimes beyond what the base OS already provides

Install language/toolchain dependencies per repo, not in the base image, unless they become truly common to most agent tasks.

## Workflow

From this directory:

```bash
./scripts/bootstrap.sh
```

This bootstraps the workspace without launching or depending on VS Code. It configures DevPod for SSH access only.

Then connect:

```bash
./scripts/connect.sh
```

If you want to sign in to Codex with the browser callback flow, open a second terminal and keep this tunnel running:

```bash
./scripts/codex-tunnel.sh
```

This forwards local `localhost:1455` to the container, which is the default Codex OAuth callback port. Keep that terminal open while you complete `codex login`. After login succeeds, you can usually close it because Codex caches auth in `~/.codex/auth.json`.

```bash
codex login
```

If you prefer not to use the callback flow, authenticate Codex with either:

```bash
codex login --device-auth
```

or by copying `~/.codex/auth.json` into the container if you already signed in elsewhere. OpenAI documents both headless-container flows in the Codex authentication docs.

Inside the container:
- clone a repo when needed
- let agents work in branches
- commit and push
- remove the repo if you want a clean workspace afterward

## Codex Memory

This repository includes a root `AGENTS.md`, which Codex reads when a session starts in `agentarium`.

That startup guidance tells Codex to load Rowan's personal memory from:

- `personal-memory/rowan/profile.md`
- `personal-memory/rowan/journal.md`

This keeps identity and long-lived preferences available at session start while keeping personal memory separate from task memory.

## Layout

- `AGENTS.md`: startup instructions for Codex in this workspace
- `.devcontainer/`: container definition for the DevPod workspace
- `scripts/bootstrap.sh`: SSH-first workspace bootstrap
- `scripts/connect.sh`: normal SSH helper
- `scripts/codex-tunnel.sh`: separate Codex auth callback tunnel
- `personal-memory/`: long-lived assistant identity memory

## Principles

- Keep the image stable and minimal.
- Keep host concerns on the host.
- Keep repo-specific dependencies in repos or per-task setup scripts.
- Prefer rebuilding the workspace over carrying large mutable image drift.
