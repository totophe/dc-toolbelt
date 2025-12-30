# Node.js 24 + AWS Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-aws`

Extends the [Node.js 24](../node24/README.md) image with AWS development tools.

## Features

- **Everything from `node24`**
- **AWS CLI v2**: `aws` command with all services

## Usage

Use the `templates/node24-aws/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (AWS)",
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
        "AmazonWebServices.aws-toolkit-vscode",
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.aws || true && aws --version"
}
```
