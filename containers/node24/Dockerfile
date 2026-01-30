# containers/base/Dockerfile
FROM node:24-bookworm-slim

USER root

# --- System utilities (lean but useful) ---
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     zsh git git-lfs curl wget ca-certificates gnupg nano less openssh-client \
     jq ripgrep locales postgresql-client sudo procps tree \
     dnsutils net-tools iputils-ping traceroute \
  && rm -rf /var/lib/apt/lists/*

# --- Grant passwordless sudo to node user ---
RUN echo "node ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/node \
  && chmod 0440 /etc/sudoers.d/node

# --- UTF-8 locale (prevents weird encoding issues) ---
RUN sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# --- GitHub CLI (official repo) ---
RUN mkdir -p -m 755 /etc/apt/keyrings \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
     | dd of=/etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
     > /etc/apt/sources.list.d/github-cli.list \
  && apt-get update && apt-get install -y --no-install-recommends gh \
  && rm -rf /var/lib/apt/lists/*

# --- Global npm tools (npm-only) ---
RUN npm i -g typescript eslint prettier tsx npm-check-updates @anthropic-ai/claude-code

# --- Shell setup: zsh default for node user ---
RUN chsh -s /bin/zsh node

# --- Oh My Zsh + quality-of-life ---
USER node
ENV ZSH="/home/node/.oh-my-zsh"
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' /home/node/.zshrc \
  && sed -i 's/^plugins=(git)/plugins=(git npm)/' /home/node/.zshrc \
  && printf "\n# Aliases\nalias ll='ls -alF'\nalias la='ls -A'\nalias l='ls -CF'\n" >> /home/node/.zshrc \
  && printf "alias gs='git status'\nalias gc='git commit'\nalias gco='git checkout'\n" >> /home/node/.zshrc \
  && npm completion >> /home/node/.zshrc \
  && echo '\n# ripgrep nicer defaults\nalias rg="rg --hidden --glob !.git"' >> /home/node/.zshrc

# --- Git LFS (global init) + safe directory for devcontainers ---
RUN git lfs install --skip-repo \
  && git config --global --add safe.directory /workspaces/*

WORKDIR /workspaces
