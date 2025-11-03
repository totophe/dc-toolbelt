#!/usr/bin/env bash
set -euo pipefail

# Installer for Astro + GitHub Pages scaffold
# - Prompts for project name
# - Generates kebab-case slug
# - Copies template files into current directory
# - Creates .devcontainer using node24-astro image

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
TARGET_DIR="$(pwd)"

# Remote fallback (for curl-installed usage)
REPO_RAW_BASE="https://raw.githubusercontent.com/totophe/dc-toolbelt/main"
TEMPLATE_BASE_URL="$REPO_RAW_BASE/templates/astro-github"
DEVCONTAINER_URL="$REPO_RAW_BASE/templates/node24-astro/devcontainer.json"

echo "→ Astro + GitHub scaffold installer"

# Accept project name via arg 1 or env PROJECT_NAME; fall back to interactive prompt
PROJECT_NAME="${1:-${PROJECT_NAME:-}}"
if [[ -z "${PROJECT_NAME}" ]]; then
  read -rp "Project name: " PROJECT_NAME
fi
if [[ -z "${PROJECT_NAME}" ]]; then
  echo "Project name cannot be empty" >&2
  exit 1
fi

# slugify: lowercase, replace non-alnum with '-', trim dashes, collapse repeats
slugify() {
  local s="$1"
  s="${s,,}"                           # lowercase
  s="${s// /-}"                        # spaces -> -
  s="${s//_/-}"                        # underscores -> -
  s="$(echo "$s" | tr -cd 'a-z0-9-')"  # allow only a-z0-9-
  s="$(echo "$s" | sed -E 's/-+/-/g')" # collapse multiple -
  s="$(echo "$s" | sed -E 's/^-+//; s/-+$//')" # trim leading/trailing -
  printf "%s" "$s"
}

PROJECT_SLUG="$(slugify "$PROJECT_NAME")"
if [[ -z "$PROJECT_SLUG" ]]; then
  echo "Derived slug is empty. Please choose a different name." >&2
  exit 1
fi

echo "→ Using slug: $PROJECT_SLUG"

# Helper for portable in-place sed (macOS/Linux)
sedin() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    # BSD sed (macOS)
    sed -i '' "$@"
  fi
}

need_curl=0
command -v curl >/dev/null 2>&1 || need_curl=1

fetch_or_copy() {
  # $1 = relative path under templates/astro-github
  # $2 = destination path
  local rel="$1" dest="$2"
  local local_src="$TEMPLATE_DIR/$rel"
  if [[ -f "$local_src" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp -n "$local_src" "$dest" 2>/dev/null || cp "$local_src" "$dest"
  else
    if ! command -v curl >/dev/null 2>&1; then
      echo "Missing template '$rel' locally and 'curl' not available to fetch from remote." >&2
      exit 1
    fi
    mkdir -p "$(dirname "$dest")"
    curl -fsSL "$TEMPLATE_BASE_URL/$rel" -o "$dest"
  fi
}

# Copy Astro skeleton (local if available, otherwise fetch from GitHub)
echo "→ Getting Astro project files"
fetch_or_copy "package.json" "$TARGET_DIR/package.json"
fetch_or_copy "astro.config.mjs" "$TARGET_DIR/astro.config.mjs"
mkdir -p "$TARGET_DIR/src/pages" "$TARGET_DIR/public"
fetch_or_copy "src/pages/index.astro" "$TARGET_DIR/src/pages/index.astro"
fetch_or_copy "public/robots.txt" "$TARGET_DIR/public/robots.txt"
fetch_or_copy ".gitignore" "$TARGET_DIR/.gitignore"

# GitHub Pages workflow
echo "→ Adding GitHub Pages workflow"
mkdir -p "$TARGET_DIR/.github/workflows"
fetch_or_copy ".github/workflows/gh-pages.yml" "$TARGET_DIR/.github/workflows/gh-pages.yml"

# Devcontainer for Astro
echo "→ Creating .devcontainer"
mkdir -p "$TARGET_DIR/.devcontainer"
ASTRO_DEVCONTAINER_LOCAL="$SCRIPT_DIR/../node24-astro/devcontainer.json"
if [[ -f "$ASTRO_DEVCONTAINER_LOCAL" ]]; then
  cp "$ASTRO_DEVCONTAINER_LOCAL" "$TARGET_DIR/.devcontainer/devcontainer.json"
else
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$DEVCONTAINER_URL" -o "$TARGET_DIR/.devcontainer/devcontainer.json"
  else
    echo "Warning: Astro devcontainer template not found locally and 'curl' not available to fetch: $ASTRO_DEVCONTAINER_LOCAL" >&2
  fi
fi

# Replace placeholders
echo "→ Applying project values"
sedin "s/__PROJECT_NAME__/${PROJECT_NAME//\//-}/g" "$TARGET_DIR/src/pages/index.astro"
sedin "s/__PROJECT_SLUG__/${PROJECT_SLUG}/g" "$TARGET_DIR/package.json"
sedin "s/__PROJECT_SLUG__/${PROJECT_SLUG}/g" "$TARGET_DIR/astro.config.mjs"
# Leave __GITHUB_USER__ as a placeholder; user can replace later or Pages will still work for org/user pages

# Initialize git repo and make initial commit (non-interactive)
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "→ Initializing git repository"
  git init >/dev/null 2>&1 || true
fi

# Stage all files
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add . >/dev/null 2>&1 || true
  # Attempt commit only if user identity is configured. If not, skip gracefully.
  if git -c user.useConfigOnly=true commit -m "init: Astro site via dc-toolbelt" >/dev/null 2>&1; then
    echo "→ Created initial commit"
  else
    echo "→ Skipped initial commit (configure git user.name and user.email); changes are staged"
  fi
fi

cat <<EOF

✔ Done!

Next steps:
  1) Open this folder in VS Code and reopen in container when prompted.
  2) Create a GitHub repository and push (required for Pages), for example with GitHub CLI:
     gh repo create --source . --public --push
     # or set up a remote and push manually:
     # git remote add origin git@github.com:<you>/${PROJECT_SLUG}.git && git push -u origin main
  3) Enable GitHub Pages in Settings → Pages (build and deployment from GitHub Actions).
  4) If this is a project page (not user/org page), replace __GITHUB_USER__ in astro.config.mjs with your username.

Run dev server:
  npm install
  npm run dev

EOF
