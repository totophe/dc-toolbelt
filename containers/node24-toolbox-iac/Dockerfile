# Stage 2: IaC tools, secrets management, config management
FROM ghcr.io/totophe/dc-toolbelt:node24-toolbox-code

USER root

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

# --- OpenTofu repo ---
RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null \
  && curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null \
  && chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
    | tee /etc/apt/sources.list.d/opentofu.list > /dev/null \
  && chmod a+r /etc/apt/sources.list.d/opentofu.list

# --- Install APT packages ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      1password-cli \
      tofu \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Binary downloads: Pulumi
# =============================================================================
RUN curl -fsSL https://get.pulumi.com/ | bash -s -- --version latest \
  && mv /root/.pulumi/bin/* /usr/local/bin/ \
  && rm -rf /root/.pulumi

# =============================================================================
# Python packages: Ansible
# =============================================================================
RUN pip install --no-cache-dir --break-system-packages ansible-core

# =============================================================================
# Single-volume credential strategy (stage 2: adds op, pulumi)
# =============================================================================
RUN mkdir -p /home/node/.dc-toolbelt/op \
             /home/node/.dc-toolbelt/pulumi \
  && rm -rf /home/node/.config/op /home/node/.pulumi \
  && ln -s /home/node/.dc-toolbelt/op       /home/node/.config/op \
  && ln -s /home/node/.dc-toolbelt/pulumi   /home/node/.pulumi \
  && chown -R node:node /home/node/.dc-toolbelt/op /home/node/.dc-toolbelt/pulumi \
  && chown -h node:node /home/node/.pulumi

USER node

WORKDIR /workspaces
