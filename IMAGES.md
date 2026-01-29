# 📦 Available Images

This repository provides several pre-configured devcontainer images.

## [Node.js 24 (`node24`)](./containers/node24/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24`

A comprehensive Node.js development environment with:
- **Base**: Node.js 24 on Debian Bookworm (slim)
- **Tools**: Git, GitHub CLI, PostgreSQL client, ripgrep, jq, nano, curl, wget
- **Node.js globals**: TypeScript, ESLint, Prettier, tsx, npm-check-updates, Claude CLI
- **Shell**: Zsh with Oh My Zsh (robbyrussell theme)
- **User**: `node` with helpful aliases and git configuration

## [Node.js 24 + Google Cloud (`node24-gcloud`)](./containers/node24-gcloud/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-gcloud`

Extends the Node.js 24 image with Google Cloud development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Google Cloud CLI**: gcloud, gsutil, bq commands
- **GKE Auth Plugin**: Kubernetes cluster authentication
- **Pre-configured**: Ready-to-use gcloud config directory

## [Node.js 24 + Google Cloud + OpenTofu (`node24-gcloud-tofu`)](./containers/node24-gcloud-tofu/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-gcloud-tofu`

Extends the Node.js 24 + Google Cloud image with Infrastructure as Code tools:
- **Everything from `node24-gcloud`**: All Node.js and Google Cloud tools
- **OpenTofu**: Open source infrastructure as code tool

## [Node.js 24 + Azure (`node24-azure`)](./containers/node24-azure/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-azure`

Extends the Node.js 24 image with Azure development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Azure CLI**: az command with all extensions
- **Pre-configured**: Ready-to-use Azure config directory

## [Node.js 24 + AWS (`node24-aws`)](./containers/node24-aws/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-aws`

Extends the Node.js 24 image with AWS development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **AWS CLI v2**: aws command with all services
- **Pre-configured**: Ready-to-use AWS config directory

## [Node.js 24 + Astro (`node24-astro`)](./containers/node24-astro/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-astro`

Optimized for Astro development:
- **Everything from `node24`**: Base tooling and shell
- **Web tooling**: npm-first (pnpm also available), Astro CLI, create-astro
- **Build essentials**: Light toolchain for native deps when needed

## [Node.js 24 + Python (`node24-python`)](./containers/node24-python/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-python`

Extends the Node.js 24 image with Python development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Python 3**: Python runtime with pip and venv support

## [Node.js 24 + Scaleway (`node24-scaleway`)](./containers/node24-scaleway/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-scaleway`

Extends the Node.js 24 image with Scaleway cloud development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Scaleway CLI**: scw command for managing Scaleway resources
- **Pre-configured**: Ready-to-use Scaleway config directory

## [Node.js 24 + Python + Scaleway (`node24-python-scaleway`)](./containers/node24-python-scaleway/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-python-scaleway`

Combines Python and Scaleway cloud tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Python 3**: Python runtime with pip and venv support
- **Scaleway CLI**: scw command for managing Scaleway resources
- **Pre-configured**: Ready-to-use Scaleway config directory

## [Node.js 24 Toolbox (`node24-toolbox`)](./containers/node24-toolbox/README.md)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-toolbox`

The unified "kitchen sink" image with every tool included:
- **Everything from `node24`**: All Node.js tools and configurations
- **Google Cloud CLI**: gcloud, gsutil, bq + GKE Auth Plugin
- **Azure CLI**: az command with all extensions
- **AWS CLI v2**: aws command with all services
- **Scaleway CLI**: scw command for managing Scaleway resources
- **Pulumi**: Infrastructure as code across any cloud
- **OpenTofu**: Open source infrastructure as code tool
- **Gemini CLI**: Google's AI coding assistant
- **Python 3**: Python runtime with pip and venv support
- **Astro**: Astro CLI + create-astro + build-essential
- **Single-volume credentials**: All configs in one Docker volume with symlinks
