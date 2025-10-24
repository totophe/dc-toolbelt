# Start from your published base image
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- AWS CLI v2 (official installation) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
       unzip curl \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip \
  && rm -rf /var/lib/apt/lists/*

# Ensure the default config path exists and is owned by "node"
ENV AWS_CONFIG_FILE=/home/node/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/home/node/.aws/credentials
RUN mkdir -p /home/node/.aws && chown -R node:node /home/node/.aws

USER node
