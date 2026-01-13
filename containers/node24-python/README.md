# Node.js 24 + Python Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-python`

Extends the [Node.js 24](../node24/README.md) image with Python development tools.

## Features

- **Everything from `node24`**
- **Python 3**: Python runtime from Debian repos
- **pip**: Python package manager
- **venv**: Virtual environment support

## Usage

Use the `templates/node24-python/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (python)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-python",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
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
  "postStartCommand": "sudo chown -R node:node /home/node/.config /home/node/.claude || true && node -v && python --version && claude --version"
}
```
