# Start from the Python image
FROM ghcr.io/totophe/dc-toolbelt:node24-python

USER root

# --- Scaleway CLI ---
# https://github.com/scaleway/scaleway-cli
RUN arch=$(dpkg --print-architecture) \
  && curl -fsSL "https://github.com/scaleway/scaleway-cli/releases/latest/download/scaleway-cli_linux_${arch}" -o /usr/local/bin/scw \
  && chmod +x /usr/local/bin/scw

# Ensure the default config path exists and is owned by "node"
ENV SCW_CONFIG_PATH=/home/node/.config/scw/config.yaml
RUN mkdir -p /home/node/.config/scw && chown -R node:node /home/node/.config/scw

USER node
