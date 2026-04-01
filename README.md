# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Clone
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles

# Install (macOS profile, the default)
bash install.sh

# …or use the Makefile
make install
```

## Profiles

This repo supports multiple machine profiles. Each profile is a top-level directory containing tool configs that map to `~/.config/<tool>`.

| Profile   | Description                          |
|-----------|--------------------------------------|
| `macOS`   | Personal macOS workstation           |
| `omarchy` | Omarchy / alternative Linux setup    |

Switch profiles:

```bash
bash install.sh omarchy
# or
make install PROFILE=omarchy
```

## How It Works

[GNU Stow](https://www.gnu.org/software/stow/) treats each profile directory as a "stow package". When you run `stow .` inside a profile directory, it creates symlinks from `~/.config/<tool>` pointing back into this repo.

```
~/.dotfiles/macOS/nvim/   →   ~/.config/nvim
~/.dotfiles/macOS/ghostty/ →   ~/.config/ghostty
~/.dotfiles/macOS/tmux/   →   ~/.config/tmux
```

Files that live directly in `$HOME` (like `.bash_profile`) are handled separately by the installer.

### Repo Layout

```
.
├── install.sh              # Bootstrap installer (prereqs + stow + extras)
├── Makefile                 # make install / uninstall / doctor / list
├── macOS/                   # macOS profile
│   ├── .stowrc              # Stow config (target=~/.config, ignores)
│   ├── .bash_profile        # Linked to ~/.bash_profile (non-stow)
│   ├── ghostty/             # → ~/.config/ghostty
│   ├── nvim/                # → ~/.config/nvim
│   ├── lvim/                # → ~/.config/lvim
│   ├── tmux/                # → ~/.config/tmux
│   ├── tmux-sessionizer/    # → ~/.config/tmux-sessionizer
│   └── setup-symlinks.sh    # Legacy fallback (deprecated)
├── omarchy/                 # Omarchy profile
│   ├── .stowrc
│   ├── ghostty/
│   ├── nvim/
│   └── tmux/
└── AGENTS.md
```

## Prerequisites

| Tool       | Install                       | Required |
|------------|-------------------------------|----------|
| Git        | `brew install git`            | Yes      |
| GNU Stow   | `brew install stow`           | Yes      |
| Neovim     | `brew install neovim`         | No       |
| tmux       | `brew install tmux`           | No       |
| Ghostty    | [ghostty.org](https://ghostty.org) | No |

Run `make doctor` to check what's installed.

## Common Commands

```bash
make install                  # Install default profile (macOS)
make install PROFILE=omarchy  # Install omarchy profile
make uninstall                # Remove symlinks for current profile
make list                     # Dry-run: show what would be linked
make doctor                   # Check prerequisites
make restow                  # Fix conflicts (unstow + stow)
```

## Adding a New Tool

1. Create a directory under your profile matching the `~/.config` target name:
   ```bash
   mkdir -p macOS/starship
   ```
2. Add your config files inside it (e.g. `macOS/starship/starship.toml`).
3. Re-run the installer:
   ```bash
   make restow
   ```

For files that belong in `$HOME` rather than `~/.config`, add them to the `.stowrc` ignore list and handle them in `install.sh`.

## Uninstalling

```bash
make uninstall
# or
cd macOS && stow -D .
```

This removes the symlinks but leaves the repo intact.

## Legacy Fallback

If GNU Stow is unavailable, the legacy `macOS/setup-symlinks.sh` script creates symlinks manually:

```bash
bash macOS/setup-symlinks.sh
```
