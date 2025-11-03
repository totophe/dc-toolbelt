# Node 24 + Astro tooling
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Web build essentials for common Astro deps (kept minimal) ---
# Many prebuilt binaries work on Node 24; keep toolchain light but available
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     build-essential \
  && rm -rf /var/lib/apt/lists/*

# --- CLIs ---
# Install Astro CLI globally (npm-first); pnpm remains available via corepack if needed
RUN npm i -g astro@latest create-astro@latest

USER node

WORKDIR /workspaces
