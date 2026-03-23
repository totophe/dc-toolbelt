# Node.js 24 Toolbox Light Devcontainer

**Image**: `ghcr.io/totophe/dc-toolbelt:node24-toolbox-light`

An opinionated mid-weight image that bundles Node.js with Python, Rust, Astro, Ansible, and two cloud CLIs (GCP + Scaleway). Lighter than the full toolbox — no Azure, AWS, OpenTofu, Pulumi, or extra AI CLIs.

## What's Included

- **Everything from `node24`**: Node.js 24, Git, GitHub CLI, PostgreSQL client, ripgrep, jq, Claude CLI, TypeScript, ESLint, Prettier, tsx, npm-check-updates, Zsh + Oh My Zsh
- **Python 3**: Python runtime with pip, venv, and build-essential
- **Rust**: Stable toolchain via rustup (cargo, rustc, rustfmt, clippy)
- **Astro**: Astro CLI + create-astro
- **Ansible**: ansible-core for configuration management
- **Google Cloud CLI**: gcloud, gsutil, bq + GKE Auth Plugin
- **Scaleway CLI**: scw command for managing Scaleway resources
- **1Password CLI**: `op` command for vault secrets via service account token

## Single-Volume Credential Strategy

Like the full toolbox, credentials are managed through a **single volume** with symlinks:

```
/home/node/.dc-toolbelt/     (Docker volume: dc-toolbelt-config)
├── gh/          → /home/node/.config/gh
├── claude/      → /home/node/.claude
├── op/          → /home/node/.config/op
├── gcloud/      → /home/node/.config/gcloud
└── scw/         → /home/node/.config/scw
```

Benefits:
- One volume mount instead of 5+
- One `chown` command fixes all permissions
- All credentials persist across container rebuilds

## Usage

Use the template from `templates/node24-toolbox-light/devcontainer.json`, or add to your own:

```json
{
  "name": "Node 24 Toolbox Light",
  "image": "ghcr.io/totophe/dc-toolbelt:node24-toolbox-light",
  "remoteUser": "node",
  "mounts": [
    "source=dc-toolbelt-config,target=/home/node/.dc-toolbelt,type=volume"
  ]
}
```

## 1Password Integration

The `op` CLI is pre-installed. Authenticate using a service account token — set `OP_SERVICE_ACCOUNT_TOKEN` on your host before launching VS Code, or add it to your shell profile:

```bash
export OP_SERVICE_ACCOUNT_TOKEN="your-token-here"
```

The devcontainer template forwards this env var into the container via `remoteEnv`. Once authenticated you can:
- `op read "op://vault/item/field"` — fetch a secret
- `op run --env-file=.env -- command` — inject secrets into a process
- `op inject -i template.env -o .env` — resolve secret references in config files

## Rust

Rust is installed via rustup for the `node` user. The stable toolchain is available out of the box. Cargo's env is sourced automatically in Zsh.

## Comparison with Full Toolbox

| Tool | Toolbox Light | Toolbox |
|------|:---:|:---:|
| Node.js 24 + base tools | x | x |
| Python 3 + pip | x | x |
| Rust (rustup) | x | - |
| Astro | x | x |
| Ansible | x | x |
| Google Cloud CLI | x | x |
| Scaleway CLI | x | x |
| 1Password CLI | x | x |
| Azure CLI | - | x |
| AWS CLI v2 | - | x |
| Pulumi | - | x |
| OpenTofu | - | x |
| Gemini CLI | - | x |
