# Stage 1: languages, frameworks, AI tools
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# =============================================================================
# APT-based tools: Python, build-essential, pre-requisites
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
      apt-transport-https ca-certificates curl gnupg lsb-release unzip \
      build-essential python3 python3-pip python3-venv \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  && rm -rf /var/lib/apt/lists/*

# =============================================================================
# npm global tools: Astro, Gemini CLI
# =============================================================================
RUN npm i -g astro@latest create-astro@latest @google/gemini-cli

# =============================================================================
# Single-volume credential strategy (stage 1: gh, claude, gemini)
# =============================================================================
RUN mkdir -p /home/node/.dc-toolbelt/gh \
             /home/node/.dc-toolbelt/claude \
             /home/node/.dc-toolbelt/gemini \
  && rm -rf /home/node/.config/gh /home/node/.claude /home/node/.config/gemini \
  && mkdir -p /home/node/.config \
  && ln -s /home/node/.dc-toolbelt/gh      /home/node/.config/gh \
  && ln -s /home/node/.dc-toolbelt/claude   /home/node/.claude \
  && ln -s /home/node/.dc-toolbelt/gemini   /home/node/.config/gemini \
  && chown -R node:node /home/node/.dc-toolbelt /home/node/.config \
  && chown -h node:node /home/node/.claude

USER node

WORKDIR /workspaces
