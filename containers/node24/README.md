# Node.js 24 Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24`

A comprehensive Node.js development environment based on Debian Bookworm (slim).

## Features

- **Node.js 24**: Latest LTS version
- **System Tools**: Git, GitHub CLI, PostgreSQL client, ripgrep, jq, nano, curl, wget, procps
- **Node.js Globals**: TypeScript, ESLint, Prettier, tsx, npm-check-updates
- **Shell**: Zsh with Oh My Zsh (robbyrussell theme)
- **User**: `node` (non-root) with passwordless sudo

## Usage

Use the `templates/node24/devcontainer.json` template.

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
