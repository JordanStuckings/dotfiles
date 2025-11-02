#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root as the folder this script lives in, then go one level up if needed.
# Adjust RELATIVE paths below if your layout differs.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)" # dotfiles repo root

backup_if_real_dir() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "${target}.backup-$(date +%Y%m%d-%H%M%S)"
    echo "Backed up existing $target"
  fi
}

link_into() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  backup_if_real_dir "$dest"
  ln -sfn "$src" "$dest"
  echo "Linked: $dest -> $src"
}

main() {
  # NVIM
  link_into "$REPO_ROOT/macOS/nvim" "$HOME/.config/nvim"
  # Ghostty
  link_into "$REPO_ROOT/macOS/ghostty" "$HOME/.config/ghostty"
  # ⬇️ Add more as you grow your repo, e.g.:
  # link_into "$REPO_ROOT/macOS/kitty" "$HOME/.config/kitty"
  # link_into "$REPO_ROOT/zsh/.zshrc" "$HOME/.zshrc"
}

main "$@"
