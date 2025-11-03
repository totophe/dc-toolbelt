#!/usr/bin/env bash
set -euo pipefail

# Installer for Astro + GitHub Pages scaffold
# - Prompts for project name
# - Generates kebab-case slug
# - Copies template files into current directory
# - Creates .devcontainer using node24-astro image

SCRIPT_PATH="${BASH_SOURCE[0]:-}"
SCRIPT_DIR=""
if [[ -n "$SCRIPT_PATH" && -f "$SCRIPT_PATH" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
fi
TEMPLATE_DIR="$SCRIPT_DIR"
TARGET_DIR="$(pwd)"

# Remote fallback (for curl-installed usage)
# Try standard branch URL first, then refs/heads form for compatibility
REPO_SLUG="totophe/dc-toolbelt"
REPO_BRANCH="main"
REPO_RAW_BASE_STD="https://raw.githubusercontent.com/${REPO_SLUG}/${REPO_BRANCH}"
REPO_RAW_BASE_REF="https://raw.githubusercontent.com/${REPO_SLUG}/refs/heads/${REPO_BRANCH}"
TEMPLATE_BASE_URL_STD="$REPO_RAW_BASE_STD/templates/astro-github"
TEMPLATE_BASE_URL_REF="$REPO_RAW_BASE_REF/templates/astro-github"
DEVCONTAINER_URL_STD="$REPO_RAW_BASE_STD/templates/node24-astro/devcontainer.json"
DEVCONTAINER_URL_REF="$REPO_RAW_BASE_REF/templates/node24-astro/devcontainer.json"

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
  s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')" # lowercase (portable)
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

# Set destination folder based on slug and ensure it's safe to use
TARGET_DIR="$TARGET_DIR/$PROJECT_SLUG"
if [[ -d "$TARGET_DIR" && -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]]; then
  echo "Target directory already exists and is not empty: $TARGET_DIR" >&2
  echo "Choose a different project name or remove/empty the directory." >&2
  exit 1
fi
mkdir -p "$TARGET_DIR"

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
    # Try standard branch URL first
    if ! curl -fsSL "$TEMPLATE_BASE_URL_STD/$rel" -o "$dest"; then
      # Fallback to refs/heads form
      if ! curl -fsSL "$TEMPLATE_BASE_URL_REF/$rel" -o "$dest"; then
        echo "Failed to fetch template '$rel' from remote." >&2
        echo "Tried: $TEMPLATE_BASE_URL_STD/$rel and $TEMPLATE_BASE_URL_REF/$rel" >&2
        exit 1
      fi
    fi
  fi
}

# Copy Astro skeleton (local if available, otherwise fetch from GitHub)
echo "→ Getting Astro project files into: $TARGET_DIR"
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
    if ! curl -fsSL "$DEVCONTAINER_URL_STD" -o "$TARGET_DIR/.devcontainer/devcontainer.json"; then
      if ! curl -fsSL "$DEVCONTAINER_URL_REF" -o "$TARGET_DIR/.devcontainer/devcontainer.json"; then
        echo "Warning: Failed to fetch Astro devcontainer template from remote." >&2
        echo "Tried: $DEVCONTAINER_URL_STD and $DEVCONTAINER_URL_REF" >&2
      fi
    fi
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
if ! git -C "$TARGET_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "→ Initializing git repository"
  git -C "$TARGET_DIR" init >/dev/null 2>&1 || true
fi

# Stage all files
if git -C "$TARGET_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$TARGET_DIR" add . >/dev/null 2>&1 || true
  # Attempt commit only if user identity is configured. If not, skip gracefully.
  if git -C "$TARGET_DIR" -c user.useConfigOnly=true commit -m "init: Astro site via dc-toolbelt" >/dev/null 2>&1; then
    echo "→ Created initial commit"
  else
    echo "→ Skipped initial commit (configure git user.name and user.email); changes are staged"
  fi
fi

cat <<EOF

✔ Done!

Next steps:
  1) cd ${PROJECT_SLUG}
  2) Open this folder in VS Code and reopen in container when prompted.
  3) Create a GitHub repository and push (required for Pages), for example with GitHub CLI:
     gh repo create --source . --public --push
     # or set up a remote and push manually:
     # git remote add origin git@github.com:<you>/${PROJECT_SLUG}.git && git push -u origin main
  4) Enable GitHub Pages in Settings → Pages (build and deployment from GitHub Actions).
  5) If this is a project page (not user/org page), replace __GITHUB_USER__ in astro.config.mjs with your username.

Run dev server:
  npm install
  npm run dev

EOF
