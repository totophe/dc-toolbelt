# Start from your published base image
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Python 3 (from Debian repos) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
       python3 python3-pip python3-venv \
  && rm -rf /var/lib/apt/lists/* \
  && ln -sf /usr/bin/python3 /usr/bin/python

USER node
