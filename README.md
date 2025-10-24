<p align="center">
  <img src="brand/dc-toolbelt-logo.png" alt="dc-toolbelt" />
</p>

# 🧰 dc-toolbelt

Opinionated devcontainer images for everyday development work. One repository, multiple pre-configured stacks via tags.

## 🎯 Philosophy

- **Batteries included**: Essential tools pre-installed and configured
- **Consistent environment**: Same setup across different projects and machines
- **Developer friendly**: Oh My Zsh, helpful aliases, and quality-of-life improvements
- **Production ready**: Based on official, minimal base images

## 📦 Available Images

### Node.js 24 (`node24`)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24`

A comprehensive Node.js development environment with:
- **Base**: Node.js 24 on Debian Bookworm (slim)
- **Tools**: Git, GitHub CLI, PostgreSQL client, ripgrep, jq, nano, curl, wget
- **Node.js globals**: TypeScript, ESLint, Prettier, tsx, npm-check-updates
- **Shell**: Zsh with Oh My Zsh (robbyrussell theme)
- **User**: `node` with helpful aliases and git configuration

### Node.js 24 + Google Cloud (`node24-gcloud`)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-gcloud`

Extends the Node.js 24 image with Google Cloud development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Google Cloud CLI**: gcloud, gsutil, bq commands
- **GKE Auth Plugin**: Kubernetes cluster authentication
- **Pre-configured**: Ready-to-use gcloud config directory

## 🚀 Quick Start

### Using with devcontainer.json

Copy the appropriate template from the `templates/` directory:

**For Node.js development:**
```json
{
  "name": "Node 24 Toolbelt",
  "image": "ghcr.io/totophe/dc-toolbelt:node24",
  "remoteUser": "node",
  "mounts": [
    "type=bind,source=${localEnv:HOME}/.config/gh,target=/home/node/.config/gh"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```

**For Node.js + Google Cloud development:**
```json
{
  "name": "Node 24 Toolbelt (gcloud)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-gcloud",
  "remoteUser": "node",
  "mounts": [
    "type=bind,source=${localEnv:HOME}/.config/gh,target=/home/node/.config/gh",
    "type=bind,source=${localEnv:HOME}/.config/gcloud,target=/home/node/.config/gcloud"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      },
      "extensions": [
        "GoogleCloudTools.cloudcode",
        "github.copilot",
        "github.copilot-chat"
      ]
    }
  }
}
```

### Using with Docker

```bash
# Node.js development
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24

# Node.js + Google Cloud development
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24-gcloud
```

## 🛠 What's Included

### System Tools
- **Shell**: Zsh with Oh My Zsh
- **Version Control**: Git + Git LFS + GitHub CLI
- **Database**: PostgreSQL client (psql, pg_dump, pg_restore)
- **Utilities**: ripgrep, jq, curl, wget, nano, less, sudo (passwordless)
- **Locale**: UTF-8 configured

### Node.js Stack
- **Runtime**: Node.js 24 (latest LTS)
- **Global packages**: 
  - TypeScript
  - ESLint
  - Prettier
  - tsx (TypeScript execution)
  - npm-check-updates

### Developer Experience
- **Aliases**: Common git shortcuts (`gs`, `gc`, `gco`)
- **Shell completion**: npm completion enabled
- **Safe directories**: Configured for devcontainer workspaces
- **Default formatter**: Prettier with VS Code integration

### Google Cloud Tools *(node24-gcloud only)*
- **Google Cloud CLI**: gcloud, gsutil, bq commands
- **GKE Auth Plugin**: Kubernetes cluster authentication
- **VS Code Extension**: Google Cloud Code extension pre-configured
- **Config mounting**: Ready-to-mount gcloud config directory

## 📂 Repository Structure

```
dc-toolbelt/
├── containers/          # Dockerfile sources
│   ├── node24/         # Node.js 24 image
│   └── node24-gcloud/  # Node.js 24 + Google Cloud image
├── templates/          # Ready-to-use devcontainer.json templates
│   ├── node24/         # Basic Node.js template
│   └── node24-gcloud/  # Node.js + Google Cloud template
├── brand/             # Logo and branding assets
└── README.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.