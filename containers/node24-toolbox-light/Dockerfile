# Node 24 Toolbox Light: Node + Python + Rust + Astro + Ansible + 1Password + GCP + Scaleway
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# =============================================================================
# APT: Python, build tools, curl/gnupg prereqs for external repos
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
      apt-transport-https ca-certificates curl gnupg lsb-release unzip \
      build-essential python3 python3-pip python3-venv \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Register external APT repositories
# =============================================================================

# --- 1Password CLI repo ---
RUN curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
      | gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" \
      > /etc/apt/sources.list.d/1password.list \
  && mkdir -p /etc/debsig/policies/AC2D62742012EA22/ \
  && curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol \
      > /etc/debsig/policies/AC2D62742012EA22/1password.pol \
  && mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 \
  && curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
      | gpg --dearmor -o /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# --- Google Cloud CLI repo ---
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
      > /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
      | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# --- Install all APT packages from the repos above ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      1password-cli \
      google-cloud-cli \
      google-cloud-cli-gke-gcloud-auth-plugin \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Scaleway CLI
# =============================================================================
RUN arch=$(dpkg --print-architecture) \
  && SCW_VERSION=$(curl -fsSL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
  && curl -fsSL "https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_VERSION}/scaleway-cli_${SCW_VERSION}_linux_${arch}" -o /usr/local/bin/scw \
  && chmod +x /usr/local/bin/scw

# =============================================================================
# npm global tools: Astro
# =============================================================================
RUN npm i -g astro@latest create-astro@latest

# =============================================================================
# Python packages: Ansible
# =============================================================================
RUN pip install --no-cache-dir --break-system-packages ansible-core

# =============================================================================
# Rust (installed for node user)
# =============================================================================
USER node
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
  && echo '\n# Rust\nsource "$HOME/.cargo/env"' >> /home/node/.zshrc
USER root

# =============================================================================
# Single-volume credential strategy
# =============================================================================
ENV CLOUDSDK_CONFIG=/home/node/.config/gcloud
ENV SCW_CONFIG_PATH=/home/node/.config/scw/config.yaml

RUN mkdir -p /home/node/.dc-toolbelt/gh \
             /home/node/.dc-toolbelt/claude \
             /home/node/.dc-toolbelt/op \
             /home/node/.dc-toolbelt/gcloud \
             /home/node/.dc-toolbelt/scw \
  && rm -rf /home/node/.config/gh /home/node/.claude \
            /home/node/.config/op \
            /home/node/.config/gcloud /home/node/.config/scw \
  && mkdir -p /home/node/.config \
  && ln -s /home/node/.dc-toolbelt/gh      /home/node/.config/gh \
  && ln -s /home/node/.dc-toolbelt/claude  /home/node/.claude \
  && ln -s /home/node/.dc-toolbelt/op      /home/node/.config/op \
  && ln -s /home/node/.dc-toolbelt/gcloud  /home/node/.config/gcloud \
  && ln -s /home/node/.dc-toolbelt/scw     /home/node/.config/scw \
  && chown -R node:node /home/node/.dc-toolbelt /home/node/.config \
  && chown -h node:node /home/node/.claude

USER node

WORKDIR /workspaces
