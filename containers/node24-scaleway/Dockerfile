# Start from your published base image
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Scaleway CLI ---
# https://github.com/scaleway/scaleway-cli
RUN arch=$(dpkg --print-architecture) \
  && SCW_VERSION=$(curl -fsSL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
  && curl -fsSL "https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_VERSION}/scaleway-cli_${SCW_VERSION}_linux_${arch}" -o /usr/local/bin/scw \
  && chmod +x /usr/local/bin/scw

# Ensure the default config path exists and is owned by "node"
ENV SCW_CONFIG_PATH=/home/node/.config/scw/config.yaml
RUN mkdir -p /home/node/.config/scw && chown -R node:node /home/node/.config/scw

USER node
