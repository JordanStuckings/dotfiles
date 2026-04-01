#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# DEPRECATED – Use the root install.sh or Makefile instead.
#
#   cd ~/.dotfiles
#   bash install.sh            # or: make install
#   bash install.sh --dry-run  # preview changes
#
# This script is kept as a fallback for machines without stow.
# It creates the same symlinks manually.
# ──────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "⚠  This script is deprecated. Prefer: bash install.sh (uses GNU Stow)."
echo "   Falling back to manual symlinks…"
echo ""

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "${target}.backup-$(date +%Y%m%d-%H%M%S)"
    echo "  Backed up existing $target"
  fi
}

link_into() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  backup_if_exists "$dest"
  ln -sfn "$src" "$dest"
  echo "  Linked: $dest → $src"
}

main() {
  # ~/.config targets
  link_into "$SCRIPT_DIR/nvim"               "$HOME/.config/nvim"
  link_into "$SCRIPT_DIR/ghostty"            "$HOME/.config/ghostty"
  link_into "$SCRIPT_DIR/lvim"               "$HOME/.config/lvim"
  link_into "$SCRIPT_DIR/tmux"               "$HOME/.config/tmux"
  link_into "$SCRIPT_DIR/tmux-sessionizer"   "$HOME/.config/tmux-sessionizer"

  # $HOME targets
  link_into "$SCRIPT_DIR/.bash_profile"      "$HOME/.bash_profile"

  echo ""
  echo "Done ✓  Open a new shell to pick up changes."
}

main "$@"
