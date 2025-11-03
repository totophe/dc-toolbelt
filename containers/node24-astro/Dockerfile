# Node 24 + Astro tooling
FROM ghcr.io/totophe/dc-toolbelt:node24

USER root

# --- Web build essentials for common Astro deps (kept minimal) ---
# Many prebuilt binaries work on Node 24; keep toolchain light but available
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     build-essential \
  && rm -rf /var/lib/apt/lists/*

# --- Package managers and CLIs ---
# Prefer corepack-managed pnpm; also install Astro CLI for DX
RUN corepack enable \
  && npm i -g pnpm@latest astro@latest create-astro@latest

USER node

# Helpful defaults in shell
RUN echo '\n# Astro helpers' >> /home/node/.zshrc \
  && echo "alias astro='astro'" >> /home/node/.zshrc \
  && echo "alias pn=pnpm" >> /home/node/.zshrc

WORKDIR /workspaces
