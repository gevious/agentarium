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

Then connect:

```bash
devpod ssh agentarium
```

Inside the container:
- clone a repo when needed
- let agents work in branches
- commit and push
- remove the repo if you want a clean workspace afterward

## Principles

- Keep the image stable and minimal.
- Keep host concerns on the host.
- Keep repo-specific dependencies in repos or per-task setup scripts.
- Prefer rebuilding the workspace over carrying large mutable image drift.
