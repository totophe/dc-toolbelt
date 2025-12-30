# Node.js 24 + Google Cloud + OpenTofu Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-gcloud-tofu`

Extends the [Node.js 24 + Google Cloud](../node24-gcloud/README.md) image with Infrastructure as Code tools.

## Features

- **Everything from `node24-gcloud`**
- **OpenTofu**: Open source infrastructure as code tool (`tofu`)
- **Claude CLI**: Anthropic's Claude CLI tool (`claude`)
- **Extra Tools**: `tree`

## Usage

Use the `templates/node24-gcloud-tofu/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (gcloud + tofu)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-gcloud-tofu",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-gh-config,target=/home/node/.config/gh,type=volume",
    "source=dc-toolbelt-gcloud-config,target=/home/node/.config/gcloud,type=volume",
    "source=claude-config,target=/home/node/.claude,type=volume"
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
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.config || true && gcloud --version && tofu --version && claude --version"
}
```
