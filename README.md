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

- **[Node.js 24 (`node24`)](./containers/node24/README.md)**: Base Node.js environment with Claude CLI
- **[Node.js 24 Toolbox (`node24-toolbox`)](./containers/node24-toolbox/README.md)**: Unified image with all cloud CLIs, IaC, Python, Astro, and AI tools

Specialized single-tool images are also available. See [IMAGES.md](./IMAGES.md) for the complete list.

## 🚀 Quick Start

### Using with devcontainer.json

Copy the appropriate template from the `templates/` directory:

**Base Node.js environment:**
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

**Toolbox (all tools in one image):**
```json
{
  "name": "Node 24 Toolbelt (toolbox)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-toolbox",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-config,target=/home/node/.dc-toolbelt,type=volume"
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
        "GoogleCloudTools.cloudcode",
        "ms-vscode.azure-account",
        "ms-azuretools.vscode-azureresourcegroups",
        "amazonwebservices.aws-toolkit-vscode",
        "astro-build.astro-vscode",
        "ms-python.python",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "hashicorp.hcl"
      ]
    }
  },
  "remoteEnv": {
    "OP_SERVICE_ACCOUNT_TOKEN": "${localEnv:OP_SERVICE_ACCOUNT_TOKEN}"
  },
  "forwardPorts": [4321],
  "portsAttributes": { "4321": { "label": "Astro Dev", "onAutoForward": "notify" } },
  "postStartCommand": "sudo chown -R node:node /home/node/.dc-toolbelt || true && node --version && gcloud --version && az --version && aws --version && scw version && tofu --version && pulumi version && op --version && ansible --version && python --version && astro --version && claude --version && gemini --version"
}
```

### Using with Docker

```bash
# Base Node.js environment
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24

# Toolbox with all tools
docker run -it --rm ghcr.io/totophe/dc-toolbelt:node24-toolbox
```

## 💾 Persistent Configuration with Volumes

All templates use **named Docker volumes** instead of bind mounts for CLI configurations. This approach provides:

- ✅ **Per-devcontainer isolation**: Each project can have its own credentials
- ✅ **Persistent across rebuilds**: Configurations survive container recreations
- ✅ **No host filesystem dependencies**: Works consistently across different machines
- ✅ **Better performance**: Especially on macOS and Windows

The **toolbox** image uses a single volume (`dc-toolbelt-config`) with symlinks to each tool's expected config path. The specialized images use one volume per tool. See [IMAGES.md](./IMAGES.md) for details.

## 🛠 What's Included

### Base Image (`node24`)
- **Shell**: Zsh with Oh My Zsh, helpful aliases (`gs`, `gc`, `gco`, `ll`, `la`)
- **Version Control**: Git + Git LFS + GitHub CLI
- **Database**: PostgreSQL client (psql, pg_dump, pg_restore)
- **Utilities**: ripgrep, jq, curl, wget, nano, less, sudo (passwordless)
- **Node.js 24**: TypeScript, ESLint, Prettier, tsx, npm-check-updates, Claude CLI
- **Locale**: UTF-8 configured

### Toolbox Image (`node24-toolbox`)

Everything from the base, plus:
- **Cloud CLIs**: Google Cloud (gcloud, gsutil, bq + GKE Auth Plugin), Azure CLI, AWS CLI v2, Scaleway CLI
- **IaC / Config Mgmt**: OpenTofu, Pulumi, Ansible
- **Secrets**: 1Password CLI (`op`)
- **AI**: Gemini CLI
- **Languages**: Python 3 (pip, venv)
- **Frameworks**: Astro + create-astro, build-essential

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
│   ├── node24-gcloud-tofu/ # Node.js 24 + Google Cloud + OpenTofu image
│   ├── node24-azure/   # Node.js 24 + Azure image
│   ├── node24-aws/     # Node.js 24 + AWS image
│   ├── node24-astro/   # Node.js 24 + Astro image
│   ├── node24-python/  # Node.js 24 + Python image
│   ├── node24-scaleway/ # Node.js 24 + Scaleway image
│   ├── node24-python-scaleway/ # Node.js 24 + Python + Scaleway image
│   └── node24-toolbox/ # Unified toolbox (all tools combined)
├── templates/          # Ready-to-use devcontainer.json templates
│   ├── node24/         # Basic Node.js template
│   ├── node24-gcloud/  # Node.js + Google Cloud template
│   ├── node24-gcloud-tofu/ # Node.js + Google Cloud + OpenTofu template
│   ├── node24-azure/   # Node.js + Azure template
│   ├── node24-aws/     # Node.js + AWS template
│   ├── node24-astro/   # Node.js + Astro template
│   ├── node24-python/  # Node.js + Python template
│   ├── node24-scaleway/ # Node.js + Scaleway template
│   ├── node24-python-scaleway/ # Node.js + Python + Scaleway template
│   └── node24-toolbox/ # Unified toolbox template
├── templates/astro-github/  # Astro scaffold + installer for GitHub Pages
├── brand/             # Logo and branding assets
└── README.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.