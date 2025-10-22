# Start from your published base image
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Google Cloud CLI (official apt repo) ---
# Includes: gcloud, gsutil, bq. We also add the GKE auth plugin.
RUN apt-get update && apt-get install -y --no-install-recommends gnupg curl ca-certificates \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
     > /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
     | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
  && apt-get update && apt-get install -y --no-install-recommends \
       google-cloud-cli \
       google-cloud-cli-gke-gcloud-auth-plugin \
  && rm -rf /var/lib/apt/lists/*

# Ensure the default config path exists and is owned by "node"
ENV CLOUDSDK_CONFIG=/home/node/.config/gcloud
RUN mkdir -p /home/node/.config/gcloud && chown -R node:node /home/node/.config/gcloud

USER node

# (Optional) quick version check when the container starts
# You can keep this in devcontainer.json's postStartCommand instead.
