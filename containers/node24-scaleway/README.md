# Node.js 24 + Scaleway Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-scaleway`

Extends the [Node.js 24](../node24/README.md) image with Scaleway cloud development tools.

## Features

- **Everything from `node24`**
- **Scaleway CLI**: `scw` command for managing Scaleway resources

## Usage

Use the `templates/node24-scaleway/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (scaleway)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-scaleway",
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
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.config /home/node/.claude || true && scw version && claude --version"
}
```
