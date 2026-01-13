# Project Context for AI Assistants

This file provides context for AI assistants working on this repository.

## Project Overview

**dc-toolbelt** is a collection of opinionated devcontainer images for Node.js development, with variants for different cloud providers and tools.

## Repository Structure

```
dc-toolbelt/
├── .github/workflows/
│   └── build.yml              # CI/CD - builds and pushes all images to GHCR
├── containers/                 # Dockerfile sources (one folder per image)
│   ├── node24/                # Base image - all others extend from this
│   ├── node24-gcloud/         # Google Cloud CLI
│   ├── node24-gcloud-tofu/    # Google Cloud + OpenTofu
│   ├── node24-azure/          # Azure CLI
│   ├── node24-aws/            # AWS CLI
│   ├── node24-astro/          # Astro framework
│   ├── node24-python/         # Python 3
│   ├── node24-scaleway/       # Scaleway CLI
│   └── node24-python-scaleway/ # Python + Scaleway
├── templates/                  # Ready-to-use devcontainer.json files
│   └── <same variants>/       # One folder per image variant
├── brand/                      # Logo and branding assets
├── README.md                   # Main documentation
├── IMAGES.md                   # List of all available images
├── CONTEXT.md                  # This file
└── LICENSE
```

## Image Hierarchy

```
node24 (base)
├── node24-gcloud
│   └── node24-gcloud-tofu
├── node24-azure
├── node24-aws
├── node24-astro
├── node24-python
│   └── node24-python-scaleway
└── node24-scaleway
```

## Base Image (`node24`) Includes

- Node.js 24 on Debian Bookworm (slim)
- System tools: Git, GitHub CLI, PostgreSQL client, ripgrep, jq, nano, curl, wget, procps, tree
- Node.js globals: TypeScript, ESLint, Prettier, tsx, npm-check-updates, **Claude CLI**
- Shell: Zsh with Oh My Zsh (robbyrussell theme)
- User: `node` with passwordless sudo

## CI/CD Workflow (`.github/workflows/build.yml`)

The workflow has **3 stages** that run sequentially:

1. **build-base**: Builds the `node24` base image
2. **build-cloud**: Builds variants that depend on `node24` (runs in parallel via matrix):
   - gcloud, azure, aws, astro, python, scaleway
3. **build-extra**: Builds variants that depend on other variants (runs in parallel via matrix):
   - gcloud-tofu (depends on gcloud)
   - python-scaleway (depends on python)

To add a new image:
1. Create `containers/<variant>/Dockerfile`
2. Create `templates/<variant>/devcontainer.json`
3. Create `containers/<variant>/README.md`
4. Add to the appropriate matrix in `build.yml`:
   - If it extends `node24`: add to `build-cloud` matrix
   - If it extends another variant: add to `build-extra` matrix
5. Update `IMAGES.md` with the new variant
6. Update `README.md` if needed (available images list)

## Documentation to Update

When adding/modifying images, update these files:

1. **`containers/<variant>/README.md`** - Image-specific documentation
2. **`templates/<variant>/devcontainer.json`** - Template for users to copy
3. **`IMAGES.md`** - Summary of all available images
4. **`README.md`** - Main documentation (available images section, quick start examples)
5. **`.github/workflows/build.yml`** - CI/CD pipeline

## Persistent Volumes

All devcontainer templates use named Docker volumes for configuration persistence:

- `dc-toolbelt-gh-config` - GitHub CLI (`/home/node/.config/gh`)
- `dc-toolbelt-claude-config` - Claude CLI (`/home/node/.claude`)
- `dc-toolbelt-gcloud-config` - Google Cloud (`/home/node/.config/gcloud`)
- `dc-toolbelt-azure-config` - Azure CLI (`/home/node/.azure`)
- `dc-toolbelt-aws-config` - AWS CLI (`/home/node/.aws`)
- `dc-toolbelt-scw-config` - Scaleway CLI (`/home/node/.config/scw`)

## Common Patterns

### Dockerfile Pattern

```dockerfile
FROM ghcr.io/totophe/dc-toolbelt:node24  # or another variant

USER root

# Install tools...
RUN apt-get update && apt-get install -y --no-install-recommends \
       <packages> \
  && rm -rf /var/lib/apt/lists/*

# Set up config directories
ENV <CONFIG_VAR>=/home/node/.<config-path>
RUN mkdir -p /home/node/<config-path> && chown -R node:node /home/node/<config-path>

USER node
```

### devcontainer.json Pattern

```json
{
  "name": "Node 24 Toolbelt (<variant>)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-<variant>",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-claude-config,target=/home/node/.claude,type=volume"
    // Add variant-specific mounts...
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.inlineSuggest.enabled": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        // Variant-specific extensions...
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.config /home/node/.claude || true && <version-checks>"
}
```

## Image Registry

All images are published to GitHub Container Registry (GHCR):
- `ghcr.io/totophe/dc-toolbelt:<tag>`

Tags follow the pattern:
- `node24` - Latest for that variant
- `v1.0.0-node24` - Specific version
- `v1-node24` - Major version only
- `latest-node24` - Explicit latest tag
