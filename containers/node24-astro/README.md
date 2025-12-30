# Node.js 24 + Astro Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-astro`

Optimized for Astro development.

## Features

- **Everything from `node24`**
- **Web Tooling**: npm-first (pnpm also available), Astro CLI, create-astro
- **Build Essentials**: Light toolchain for native deps when needed

## Usage

Use the `templates/node24-astro/devcontainer.json` template.

```json
{
  "name": "Node 24 Toolbelt (Astro)",
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
        "github.copilot",
        "github.copilot-chat",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```
