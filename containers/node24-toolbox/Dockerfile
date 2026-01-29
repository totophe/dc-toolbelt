# Unified toolbox: all cloud CLIs, IaC tools, Python, Astro, Gemini
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# =============================================================================
# APT-based tools: Python, build-essential, pre-requisites for cloud repos
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
      apt-transport-https ca-certificates curl gnupg lsb-release unzip \
      build-essential python3 python3-pip python3-venv \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Register external APT repositories
# =============================================================================

# --- Google Cloud CLI repo ---
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
      > /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
      | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# --- Azure CLI repo ---
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
  && chmod go+r /etc/apt/keyrings/microsoft.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/azure-cli.list

# --- OpenTofu repo ---
RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null \
  && curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null \
  && chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
    | tee /etc/apt/sources.list.d/opentofu.list > /dev/null \
  && chmod a+r /etc/apt/sources.list.d/opentofu.list

# --- Install all APT packages from the repos above ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      google-cloud-cli \
      google-cloud-cli-gke-gcloud-auth-plugin \
      azure-cli \
      tofu \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Binary downloads: AWS CLI, Scaleway CLI, Pulumi
# =============================================================================

# --- AWS CLI v2 ---
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip

# --- Scaleway CLI ---
RUN arch=$(dpkg --print-architecture) \
  && SCW_VERSION=$(curl -fsSL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
  && curl -fsSL "https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_VERSION}/scaleway-cli_${SCW_VERSION}_linux_${arch}" -o /usr/local/bin/scw \
  && chmod +x /usr/local/bin/scw

# --- Pulumi ---
RUN curl -fsSL https://get.pulumi.com/ | bash -s -- --version latest \
  && mv /root/.pulumi/bin/* /usr/local/bin/ \
  && rm -rf /root/.pulumi

# =============================================================================
# npm global tools: Astro, Gemini CLI
# =============================================================================
RUN npm i -g astro@latest create-astro@latest @anthropic-ai/claude-code @google/gemini-cli

# =============================================================================
# Single-volume credential strategy: symlinks from expected config paths
# to a unified volume mount point at /home/node/.dc-toolbelt
# =============================================================================
ENV CLOUDSDK_CONFIG=/home/node/.config/gcloud
ENV AZURE_CONFIG_DIR=/home/node/.azure
ENV AWS_CONFIG_FILE=/home/node/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/home/node/.aws/credentials
ENV SCW_CONFIG_PATH=/home/node/.config/scw/config.yaml

RUN mkdir -p /home/node/.dc-toolbelt/gh \
             /home/node/.dc-toolbelt/claude \
             /home/node/.dc-toolbelt/gemini \
             /home/node/.dc-toolbelt/gcloud \
             /home/node/.dc-toolbelt/azure \
             /home/node/.dc-toolbelt/aws \
             /home/node/.dc-toolbelt/scw \
             /home/node/.dc-toolbelt/pulumi \
  && rm -rf /home/node/.config/gh /home/node/.claude /home/node/.config/gemini \
            /home/node/.config/gcloud /home/node/.azure /home/node/.aws \
            /home/node/.config/scw /home/node/.pulumi \
  && ln -s /home/node/.dc-toolbelt/gh      /home/node/.config/gh \
  && ln -s /home/node/.dc-toolbelt/claude   /home/node/.claude \
  && ln -s /home/node/.dc-toolbelt/gemini   /home/node/.config/gemini \
  && ln -s /home/node/.dc-toolbelt/gcloud   /home/node/.config/gcloud \
  && ln -s /home/node/.dc-toolbelt/azure    /home/node/.azure \
  && ln -s /home/node/.dc-toolbelt/aws      /home/node/.aws \
  && ln -s /home/node/.dc-toolbelt/scw      /home/node/.config/scw \
  && ln -s /home/node/.dc-toolbelt/pulumi   /home/node/.pulumi \
  && chown -R node:node /home/node/.dc-toolbelt \
  && chown -h node:node /home/node/.claude /home/node/.azure /home/node/.aws /home/node/.pulumi \
  && chown -h node:node /home/node/.config/gh /home/node/.config/gemini /home/node/.config/gcloud /home/node/.config/scw

USER node

WORKDIR /workspaces
