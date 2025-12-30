# Node.js 24 + Azure Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-azure`

Extends the [Node.js 24](../node24/README.md) image with Azure development tools.

## Features

- **Everything from `node24`**
- **Azure CLI**: `az` command with all extensions

## Usage

Use the `templates/node24-azure/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (Azure)",
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
        "ms-azuretools.vscode-azurefunctions",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.azure || true && az --version"
}
```
