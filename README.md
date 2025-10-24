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

### Node.js 24 + Azure (`node24-azure`)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-azure`

Extends the Node.js 24 image with Azure development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **Azure CLI**: az command with all extensions
- **Pre-configured**: Ready-to-use Azure config directory

### Node.js 24 + AWS (`node24-aws`)
**Image**: `ghcr.io/totophe/dc-toolbelt:node24-aws`

Extends the Node.js 24 image with AWS development tools:
- **Everything from `node24`**: All Node.js tools and configurations
- **AWS CLI v2**: aws command with all services
- **Pre-configured**: Ready-to-use AWS config directory

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
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume"
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
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-gcloud-config,target=/home/node/.config/gcloud,type=volume"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        "GoogleCloudTools.cloudcode",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```

**For Node.js + Azure development:**
```json
{
  "name": "Node 24 Toolbelt (azure)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-azure",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-azure-config,target=/home/node/.azure,type=volume"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        "ms-vscode.azure-account",
        "ms-azuretools.vscode-azureresourcegroups",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```

**For Node.js + AWS development:**
```json
{
  "name": "Node 24 Toolbelt (aws)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-aws",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-aws-config,target=/home/node/.aws,type=volume"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        "amazonwebservices.aws-toolkit-vscode",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
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

# Node.js + Azure development
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24-azure

# Node.js + AWS development
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24-aws
```

## 💾 Persistent Configuration with Volumes

All templates use **named Docker volumes** instead of bind mounts for CLI configurations. This approach provides:

- ✅ **Per-devcontainer isolation**: Each project can have its own credentials
- ✅ **Persistent across rebuilds**: Configurations survive container recreations
- ✅ **No host filesystem dependencies**: Works consistently across different machines
- ✅ **Better performance**: Especially on macOS and Windows

### Volume Names Used
- `dc-toolbelt-gh-config` - GitHub CLI configuration
- `dc-toolbelt-gcloud-config` - Google Cloud CLI configuration
- `dc-toolbelt-azure-config` - Azure CLI configuration
- `dc-toolbelt-aws-config` - AWS CLI configuration

You can customize volume names in your devcontainer.json to separate configurations per project if needed.

## �🛠 What's Included

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

### Cloud Platform Tools

#### Google Cloud *(node24-gcloud only)*
- **Google Cloud CLI**: gcloud, gsutil, bq commands
- **GKE Auth Plugin**: Kubernetes cluster authentication
- **VS Code Extension**: Google Cloud Code extension pre-configured
- **Persistent config**: Volume-mounted configuration

#### Azure *(node24-azure only)*
- **Azure CLI**: az command with all extensions
- **VS Code Extensions**: Azure Account and Resource Groups extensions
- **Persistent config**: Volume-mounted configuration

#### AWS *(node24-aws only)*
- **AWS CLI v2**: aws command with all services
- **VS Code Extension**: AWS Toolkit extension pre-configured
- **Persistent config**: Volume-mounted configuration

## 📂 Repository Structure

```
dc-toolbelt/
├── containers/          # Dockerfile sources
│   ├── node24/         # Node.js 24 base image
│   ├── node24-gcloud/  # Node.js 24 + Google Cloud image
│   ├── node24-azure/   # Node.js 24 + Azure image
│   └── node24-aws/     # Node.js 24 + AWS image
├── templates/          # Ready-to-use devcontainer.json templates
│   ├── node24/         # Basic Node.js template
│   ├── node24-gcloud/  # Node.js + Google Cloud template
│   ├── node24-azure/   # Node.js + Azure template
│   └── node24-aws/     # Node.js + AWS template
├── brand/             # Logo and branding assets
└── README.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.