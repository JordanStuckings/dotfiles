#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Dotfiles – Bootstrap installer
#
# Quick start (from a fresh machine):
#   git clone <this-repo> ~/.dotfiles
#   cd ~/.dotfiles
#   bash install.sh            # defaults to macOS profile
#   bash install.sh omarchy    # use the omarchy profile
#
# What it does:
#   1. Checks / installs prerequisites (Homebrew, stow, etc.)
#   2. Runs GNU Stow to symlink config dirs into ~/.config
#   3. Links profile-specific extras (e.g. .bash_profile)
#
# Flags:
#   -n, --dry-run    Show what would happen without making changes
#   -h, --help       Show this help
# ──────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=""
DRY_RUN=false
STOW_TARGET="$HOME/.config"

# ── Parse flags ──────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=true ;;
    -h|--help)
      sed -n '2,/^set -euo/p' "$0" | grep '^#' | sed 's/^# \?//'
      exit 0
      ;;
    -*) echo "Unknown flag: $arg"; exit 1 ;;
    *) PROFILE="$arg" ;;
  esac
done

PROFILE="${PROFILE:-macOS}"

STOW_DIR="$SCRIPT_DIR/$PROFILE"

# ── Helpers ──────────────────────────────────────────────────
info()  { printf "\033[36m%s\033[0m\n" "$*"; }
ok()    { printf "  \033[32m✓\033[0m %s\n" "$*"; }
warn()  { printf "  \033[33m✗\033[0m %s\n" "$*"; }
err()   { printf "\033[31mError:\033[0m %s\n" "$*" >&2; exit 1; }

require_cmd() {
  local cmd="$1" install_hint="${2:-}"
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd"
  else
    warn "$cmd not found${install_hint:+ — $install_hint}"
    return 1
  fi
}

backup_and_link() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    info "  [dry-run] Would link: $dest → $src"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.backup-$(date +%Y%m%d-%H%M%S)"
    info "  Backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  ok "Linked: $dest → $src"
}

backup_path() {
  local path="$1"
  local backup="${path}.backup-$(date +%Y%m%d-%H%M%S)"
  if $DRY_RUN; then
    info "  [dry-run] Would back up: $path → $backup"
    return
  fi
  mv "$path" "$backup"
  info "  Backed up existing $path"
}

prepare_stow_targets() {
  local pkg src dest resolved

  mkdir -p "$STOW_TARGET"

  while IFS= read -r pkg; do
    src="$STOW_DIR/$pkg"
    dest="$STOW_TARGET/$pkg"

    [ -e "$dest" ] || [ -L "$dest" ] || continue

    if [ -L "$dest" ]; then
      resolved="$(readlink "$dest")"
      case "$resolved" in
        "$src"|"$SCRIPT_DIR/$PROFILE/$pkg"|"$SCRIPT_DIR/${PROFILE,,}/$pkg")
          if $DRY_RUN; then
            info "  [dry-run] Would remove legacy symlink: $dest"
          else
            rm "$dest"
            info "  Removed legacy symlink: $dest"
          fi
          continue
          ;;
      esac
    fi

    backup_path "$dest"
  done < <(find "$STOW_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
}

# ── Validate profile ────────────────────────────────────────
[ -d "$STOW_DIR" ] || err "Profile directory not found: $STOW_DIR"
info "Installing profile: $PROFILE"
echo ""

# ── 1. Prerequisites ────────────────────────────────────────
info "Checking prerequisites…"

# Homebrew (macOS / Linux) — optional on omarchy/Linux
if ! command -v brew &>/dev/null; then
  if [ "$PROFILE" = "omarchy" ]; then
    warn "brew (skipped — not required for omarchy)"
  elif ! $DRY_RUN && [ -t 0 ]; then
    warn "Homebrew not found"
    read -rp "  Install Homebrew? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null)"
    fi
  else
    warn "brew not found"
  fi
else
  ok "brew"
fi

# GNU Stow
if ! command -v stow &>/dev/null; then
  warn "stow not found"
  if ! $DRY_RUN && command -v brew &>/dev/null; then
    read -rp "  Install stow via Homebrew? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      brew install stow
    fi
  fi
else
  ok "stow"
fi

require_cmd git "brew install git" || true
require_cmd nvim "brew install neovim" || true
require_cmd tmux "brew install tmux" || true
require_cmd sesh "brew install joshmedeski/sesh/sesh" || true
require_cmd tv "brew install television" || true
require_cmd zoxide "brew install zoxide" || true
require_cmd fd "brew install fd" || true
echo ""

# ── 2. Stow ~/.config targets ───────────────────────────────
info "Stowing $PROFILE → ~/.config …"
prepare_stow_targets
if $DRY_RUN; then
  cd "$STOW_DIR" && stow --target="$STOW_TARGET" -n -v . 2>&1 || true
else
  cd "$STOW_DIR" && stow --target="$STOW_TARGET" .
  ok "Stow complete"
fi
echo ""

# ── 3. Profile-specific extras ──────────────────────────────
if [ "$PROFILE" = "macOS" ]; then
  info "Linking macOS extras…"
  # .bash_profile → $HOME (not ~/.config)
  if [ -f "$STOW_DIR/.bash_profile" ]; then
    backup_and_link "$STOW_DIR/.bash_profile" "$HOME/.bash_profile"
  fi
fi

echo ""
info "Done ✓"
echo ""
echo "Next steps:"
echo "  • Open a new shell to pick up changes"
echo "  • Run 'nvim --headless \"+Lazy sync\" +qa' to install Neovim plugins"
echo "  • Run 'make doctor' to verify tool availability"
