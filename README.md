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

See [IMAGES.md](./IMAGES.md) for a complete list of available images and their details.

- **[Node.js 24 (`node24`)](./containers/node24/README.md)**: Base Node.js environment
- **[Node.js 24 + Google Cloud (`node24-gcloud`)](./containers/node24-gcloud/README.md)**: With Google Cloud CLI
- **[Node.js 24 + Google Cloud + OpenTofu (`node24-gcloud-tofu`)](./containers/node24-gcloud-tofu/README.md)**: With GCloud, OpenTofu & Claude CLI
- **[Node.js 24 + Azure (`node24-azure`)](./containers/node24-azure/README.md)**: With Azure CLI
- **[Node.js 24 + AWS (`node24-aws`)](./containers/node24-aws/README.md)**: With AWS CLI
- **[Node.js 24 + Astro (`node24-astro`)](./containers/node24-astro/README.md)**: Optimized for Astro

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

**For Node.js + Astro development:**
```json
{
  "name": "Node 24 Toolbelt (astro)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-astro",
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
        "astro-build.astro-vscode",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "github.copilot",
        "github.copilot-chat"
      ]
    }
  },
  "forwardPorts": [4321],
  "portsAttributes": { "4321": { "label": "Astro Dev", "onAutoForward": "openBrowser" } },
  "postStartCommand": "node -v && npm -v && astro --version"
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

# Node.js + Astro development
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24-astro
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

### Astro + GitHub scaffold installer

Use the built-in installer to scaffold an Astro site configured for GitHub Pages, creating a new folder named after your project slug:

```bash
# Interactive (prompts for project name)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/totophe/dc-toolbelt/refs/heads/main/templates/astro-github/install.sh)"

# Non-interactive (pass name as arg)
curl -fsSL https://raw.githubusercontent.com/totophe/dc-toolbelt/refs/heads/main/templates/astro-github/install.sh | bash -s -- "My Awesome Astro Site"

# Non-interactive via env var
PROJECT_NAME="My Awesome Astro Site" \
  curl -fsSL https://raw.githubusercontent.com/totophe/dc-toolbelt/refs/heads/main/templates/astro-github/install.sh | bash
```

What it does:
- Takes a project name (via prompt, CLI arg, or PROJECT_NAME env) and derives a lowercase kebab-case slug
- Copies an Astro skeleton (package.json, astro.config.mjs, src/, public/)
- Adds a .gitignore suitable for Node/Astro projects
- Adds a GitHub Pages workflow (.github/workflows/gh-pages.yml)
- Creates a .devcontainer using the node24-astro image
- Initializes a git repository (if none exists) and creates an initial commit when possible
- Creates a new directory named after the derived slug and scaffolds the project inside it

Notes:
- For GitHub Project Pages, update `astro.config.mjs` to use your username in the `site` URL.
- The `base` is prefilled with the project slug.
- After running the installer, `cd <your-slug>` before starting the dev server.

## 📂 Repository Structure

```
dc-toolbelt/
├── containers/          # Dockerfile sources
│   ├── node24/         # Node.js 24 base image
│   ├── node24-gcloud/  # Node.js 24 + Google Cloud image
│   ├── node24-azure/   # Node.js 24 + Azure image
│   ├── node24-aws/     # Node.js 24 + AWS image
│   └── node24-astro/   # Node.js 24 + Astro image
├── templates/          # Ready-to-use devcontainer.json templates
│   ├── node24/         # Basic Node.js template
│   ├── node24-gcloud/  # Node.js + Google Cloud template
│   ├── node24-azure/   # Node.js + Azure template
│   ├── node24-aws/     # Node.js + AWS template
│   └── node24-astro/   # Node.js + Astro template
├── templates/astro-github/  # Astro scaffold + installer for GitHub Pages
├── brand/             # Logo and branding assets
└── README.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.