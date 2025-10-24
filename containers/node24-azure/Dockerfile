# Start from your published base image
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Azure CLI (official installation script) ---
# Includes: az command with all extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
       ca-certificates curl apt-transport-https lsb-release gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
     | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
  && chmod go+r /etc/apt/keyrings/microsoft.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
     > /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update && apt-get install -y --no-install-recommends azure-cli \
  && rm -rf /var/lib/apt/lists/*

# Ensure the default config path exists and is owned by "node"
ENV AZURE_CONFIG_DIR=/home/node/.azure
RUN mkdir -p /home/node/.azure && chown -R node:node /home/node/.azure

USER node
