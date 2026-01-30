# Stage 3: cloud CLIs — the full "kitchen sink" toolbox
FROM ghcr.io/totophe/dc-toolbelt:node24-toolbox-iac

USER root

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

# --- Install all APT packages from the repos above ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      google-cloud-cli \
      google-cloud-cli-gke-gcloud-auth-plugin \
      azure-cli \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Binary downloads: AWS CLI, Scaleway CLI
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

# =============================================================================
# Single-volume credential strategy (stage 3: adds gcloud, azure, aws, scw)
# =============================================================================
ENV CLOUDSDK_CONFIG=/home/node/.config/gcloud
ENV AZURE_CONFIG_DIR=/home/node/.azure
ENV AWS_CONFIG_FILE=/home/node/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/home/node/.aws/credentials
ENV SCW_CONFIG_PATH=/home/node/.config/scw/config.yaml

RUN mkdir -p /home/node/.dc-toolbelt/gcloud \
             /home/node/.dc-toolbelt/azure \
             /home/node/.dc-toolbelt/aws \
             /home/node/.dc-toolbelt/scw \
  && rm -rf /home/node/.config/gcloud /home/node/.azure /home/node/.aws /home/node/.config/scw \
  && ln -s /home/node/.dc-toolbelt/gcloud   /home/node/.config/gcloud \
  && ln -s /home/node/.dc-toolbelt/azure    /home/node/.azure \
  && ln -s /home/node/.dc-toolbelt/aws      /home/node/.aws \
  && ln -s /home/node/.dc-toolbelt/scw      /home/node/.config/scw \
  && chown -R node:node /home/node/.dc-toolbelt/gcloud /home/node/.dc-toolbelt/azure \
                        /home/node/.dc-toolbelt/aws /home/node/.dc-toolbelt/scw \
  && chown -h node:node /home/node/.azure /home/node/.aws

USER node

WORKDIR /workspaces
