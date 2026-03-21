FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed \
        bash \
        zsh \
        git \
        github-cli \
        chezmoi \
        openssh \
        curl \
        wget \
        jq \
        nodejs \
        npm \
        ripgrep \
        fd \
        fzf \
        neovim \
        tmux \
        less \
        which \
        file \
        procps-ng \
        findutils \
        sed \
        gawk \
        grep \
        diffutils \
        patch \
        bubblewrap \
        make \
        unzip \
        zip \
        tar \
        gzip \
        xz \
        ca-certificates \
        shadow \
    && pacman -Scc --noconfirm

# Install Proton Pass CLI (pass-cli)
RUN curl -fsSL https://proton.me/download/pass-cli/install.sh | PROTON_PASS_CLI_INSTALL_DIR=/usr/local/bin bash

# Proton Pass local keyring backends are unreliable in headless containers.
ENV PROTON_PASS_KEY_PROVIDER=fs

RUN npm i -g @openai/codex@latest \
    && npm cache clean --force

RUN groupadd --gid 1000 rowan \
    && useradd --uid 1000 --gid 1000 --create-home --shell /usr/bin/zsh rowan

RUN cat <<'EOF' >/etc/zsh/zlogin
autoload -Uz add-zsh-hook

_agentarium_prompt() {
  local container_name="${AGENTARIUM_NAME:-${HOSTNAME:-agentarium}}"
  local prefix="%F{yellow}[${container_name}]%f "

  case "${PROMPT:-}" in
    "${prefix}"*) ;;
    *) PROMPT="${prefix}${PROMPT}" ;;
  esac
}

add-zsh-hook precmd _agentarium_prompt
EOF

USER rowan
