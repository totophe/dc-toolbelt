# Node.js 24 + Google Cloud Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-gcloud`

Extends the [Node.js 24](../node24/README.md) image with Google Cloud development tools.

## Features

- **Everything from `node24`**
- **Google Cloud CLI**: `gcloud`, `gsutil`, `bq`
- **GKE Auth Plugin**: `google-cloud-cli-gke-gcloud-auth-plugin`

## Usage

Use the `templates/node24-gcloud/devcontainer.json` template.

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
  },
  "postStartCommand": "sudo chown -R node:node /home/node/.config || true && gcloud --version"
}
```
