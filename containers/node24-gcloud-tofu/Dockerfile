FROM ghcr.io/totophe/dc-toolbelt:node24-gcloud

USER root

# --- OpenTofu ---
# https://opentofu.org/docs/intro/install/deb/
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates curl gnupg \
  && install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null \
  && curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null \
  && chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
    | tee /etc/apt/sources.list.d/opentofu.list > /dev/null \
  && chmod a+r /etc/apt/sources.list.d/opentofu.list \
  && apt-get update && apt-get install -y --no-install-recommends tofu \
  && rm -rf /var/lib/apt/lists/*

# --- Claude CLI ---
RUN npm install -g @anthropic-ai/claude-code

USER node
