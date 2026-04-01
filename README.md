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

## Installation

There are two ways to install: the **bootstrap script** (`install.sh`) or the **Makefile**. Both use GNU Stow under the hood.

### Option A: Bootstrap Script (`install.sh`)

The installer checks prerequisites, offers to install missing ones, and then stows configs:

```bash
bash install.sh              # Install default profile (macOS)
bash install.sh omarchy      # Install omarchy profile
bash install.sh --dry-run    # Preview what would happen (no changes)
bash install.sh -n           # Same as --dry-run
bash install.sh -h           # Show help
```

Flags can appear in any order:

```bash
bash install.sh --dry-run macOS   # Also works
```

The script will:
1. Check for / offer to install **Homebrew**, **GNU Stow**, **git**, **nvim**, **tmux**, **sesh**, **television**, **zoxide**, and **fd**
2. Run `stow .` inside the profile directory to symlink configs into `~/.config/`
3. Handle profile-specific extras (e.g., linking `~/.bash_profile` on macOS)

### Option B: Makefile

```bash
make install                  # Install default profile (macOS)
make install PROFILE=omarchy  # Install omarchy profile
make uninstall                # Remove symlinks for current profile
make list                     # Dry-run: show what would be linked
make doctor                   # Check prerequisites
make restow                   # Fix conflicts (unstow + stow)
```

### Migrating from Legacy Symlinks

If you previously used `macOS/setup-symlinks.sh` (the old manual approach), the existing
symlinks will conflict with stow because stow didn't create them. To migrate:

```bash
# 1. Remove old symlinks (they point to the same files, so nothing is lost)
rm ~/.config/ghostty ~/.config/nvim ~/.config/tmux ~/.config/lvim

# 2. Install with stow
make install
# or: bash install.sh
```

Alternatively, if you're sure the symlinks point to the right place, `make restow` will
adopt them (unstow + stow in one step).

### Verifying the Install

After installing, verify everything is healthy:

```bash
# Check prerequisites are available
make doctor

# Confirm stow targets are linked
make list

# Verify Neovim plugins
nvim --headless "+Lazy sync" +qa

# Check Neovim health
nvim --headless "+checkhealth" +qa
```

## How It Works

[GNU Stow](https://www.gnu.org/software/stow/) treats each profile directory as a "stow package". When you run `stow .` inside a profile directory, it creates symlinks from `~/.config/<tool>` pointing back into this repo.

```
~/.dotfiles/macOS/nvim/   →   ~/.config/nvim
~/.dotfiles/macOS/ghostty/ →   ~/.config/ghostty
~/.dotfiles/macOS/tmux/   →   ~/.config/tmux
```

Files that live directly in `$HOME` (like `.bash_profile`) are handled separately by the installer. Each profile has a `.stowrc` file that sets `--target=~/.config` and ignores non-config files (`.bash_profile`, `.stowrc`, `.DS_Store`, etc.).

### Repo Layout

```
.
├── install.sh              # Bootstrap installer (prereqs + stow + extras)
├── Makefile                 # make install / uninstall / doctor / list
├── TODO.md                  # Migration plan (sesh + tv)
├── macOS/                   # macOS profile
│   ├── .stowrc              # Stow config (target=~/.config, ignores)
│   ├── .bash_profile        # Linked to ~/.bash_profile (non-stow)
│   ├── ghostty/             # → ~/.config/ghostty
│   ├── nvim/                # → ~/.config/nvim
│   ├── lvim/                # → ~/.config/lvim
│   ├── sesh/                # → ~/.config/sesh
│   ├── television/          # → ~/.config/television (tv fuzzy finder + cable channels)
│   ├── tmux/                # → ~/.config/tmux
│   └── setup-symlinks.sh    # Legacy fallback (deprecated)
├── omarchy/                 # Omarchy profile
│   ├── .stowrc
│   ├── ghostty/
│   ├── nvim/
│   ├── sesh/                # → ~/.config/sesh
│   ├── television/          # → ~/.config/television (tv fuzzy finder + cable channels)
│   └── tmux/
├── reference/               # Inspiration repos (gitignored)
│   └── omerxx-dotfiles/     # github.com/omerxx/dotfiles
└── AGENTS.md
```

## Prerequisites

| Tool       | Install                              | Required |
|------------|--------------------------------------|----------|
| Git        | `brew install git`                   | Yes      |
| GNU Stow   | `brew install stow`                  | Yes      |
| Neovim     | `brew install neovim`                | No       |
| tmux       | `brew install tmux`                  | No       |
| Ghostty    | [ghostty.org](https://ghostty.org)   | No       |
| sesh       | `brew install joshmedeski/sesh/sesh` | No       |
| television | `brew install television`            | No       |
| zoxide     | `brew install zoxide`                | No       |
| fd         | `brew install fd`                    | No       |

Run `make doctor` to check what's installed.

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
