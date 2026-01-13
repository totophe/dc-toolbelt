# Node.js 24 + Python + Scaleway Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-python-scaleway`

Extends the [Node.js 24 + Python](../node24-python/README.md) image with Scaleway cloud development tools.

## Features

- **Everything from `node24-python`**
- **Scaleway CLI**: `scw` command for managing Scaleway resources

## Usage

Use the `templates/node24-python-scaleway/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (python + scaleway)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-python-scaleway",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-scw-config,target=/home/node/.config/scw,type=volume",
    "source=dc-toolbelt-claude-config,target=/home/node/.claude,type=volume"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      },
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.config /home/node/.claude || true && node -v && python --version && scw version && claude --version"
}
```
