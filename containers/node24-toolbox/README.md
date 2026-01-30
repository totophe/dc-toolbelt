# Node.js 24 Toolbox Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-toolbox`

The unified "kitchen sink" image that includes every tool from every dc-toolbelt variant in a single image. Use this when you work across multiple cloud providers, need IaC tools, and want Python and Astro support all in one environment.

## What's Included

- **Everything from `node24`**: Node.js 24, Git, GitHub CLI, PostgreSQL client, ripgrep, jq, Claude CLI, TypeScript, ESLint, Prettier, tsx, npm-check-updates, Zsh + Oh My Zsh
- **Google Cloud CLI**: gcloud, gsutil, bq + GKE Auth Plugin
- **Azure CLI**: az command with all extensions
- **AWS CLI v2**: aws command with all services
- **Scaleway CLI**: scw command for Scaleway resources
- **Pulumi**: Infrastructure as code across any cloud
- **OpenTofu**: Open source Terraform alternative
- **Gemini CLI**: Google's AI coding assistant
- **Python 3**: Python runtime with pip and venv support
- **1Password CLI**: `op` command for accessing vault secrets (authenticate via `OP_SERVICE_ACCOUNT_TOKEN`)
- **Ansible**: ansible-core for configuration management
- **Astro**: Astro CLI + create-astro + build-essential for native deps

## Single-Volume Credential Strategy

Unlike the specialized images which use one Docker volume per tool, the toolbox uses a **single volume** with symlinks:

```
/home/node/.dc-toolbelt/     (Docker volume: dc-toolbelt-config)
├── gh/          → /home/node/.config/gh
├── claude/      → /home/node/.claude
├── gemini/      → /home/node/.config/gemini
├── gcloud/      → /home/node/.config/gcloud
├── azure/       → /home/node/.azure
├── aws/         → /home/node/.aws
├── scw/         → /home/node/.config/scw
├── op/          → /home/node/.config/op
└── pulumi/      → /home/node/.pulumi
```

Benefits:
- One volume mount instead of 8+
- One `chown` command fixes all permissions
- All credentials persist across container rebuilds

## Usage

Use the template from `templates/node24-toolbox/devcontainer.json`, or add to your own:

```json
{
  "name": "Node 24 Toolbelt (toolbox)",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-toolbox",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-config,target=/home/node/.dc-toolbelt,type=volume"
  ]
}
```

## 1Password Integration

The `op` CLI is pre-installed. To authenticate, set `OP_SERVICE_ACCOUNT_TOKEN` on your host before launching VS Code, or add it to your shell profile:

```bash
export OP_SERVICE_ACCOUNT_TOKEN="your-token-here"
```

The devcontainer template forwards this env var into the container via `remoteEnv`. Once authenticated you can:
- `op read "op://vault/item/field"` — fetch a secret
- `op run --env-file=.env -- command` — inject secrets into a process
- `op inject -i template.env -o .env` — resolve secret references in config files

## Image Size

This image is significantly larger than individual variants because it bundles all tools. If you only need one or two cloud CLIs, prefer the specific variant images for faster pulls.
