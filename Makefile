# ──────────────────────────────────────────────────────────────
# Dotfiles – Makefile
#
# Profiles:
#   macOS    – personal macOS workstation (Ghostty, nvim, tmux, lvim, …)
#   omarchy  – Omarchy Linux / alternative setup
#
# Usage:
#   make install            # install the default profile (macOS)
#   make install PROFILE=omarchy
#   make uninstall          # uninstall the default profile
#   make stow PROFILE=macOS # stow only ~/.config targets
#   make unstow             # remove stow symlinks
#   make doctor             # check prerequisites are installed
#   make list               # show what would be linked
# ──────────────────────────────────────────────────────────────

PROFILE ?= macOS
STOW    := stow
STOW_DIR := $(CURDIR)/$(PROFILE)

.PHONY: help install uninstall stow unstow restow doctor list

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

doctor: ## Check that required tools are installed
	@echo "Checking prerequisites…"
	@command -v stow  >/dev/null 2>&1 && echo "  ✓ stow"  || echo "  ✗ stow   – install with: brew install stow"
	@command -v nvim  >/dev/null 2>&1 && echo "  ✓ nvim"  || echo "  ✗ nvim   – install with: brew install neovim"
	@command -v tmux  >/dev/null 2>&1 && echo "  ✓ tmux"  || echo "  ✗ tmux   – install with: brew install tmux"
	@command -v git   >/dev/null 2>&1 && echo "  ✓ git"   || echo "  ✗ git    – install with: brew install git"
	@echo ""
	@echo "Profile: $(PROFILE)"
	@test -d "$(STOW_DIR)" && echo "  ✓ $(STOW_DIR) exists" || echo "  ✗ $(STOW_DIR) not found"

stow: ## Symlink ~/.config targets via GNU Stow
	@echo "Stowing $(PROFILE) → ~/.config …"
	cd "$(STOW_DIR)" && $(STOW) .

unstow: ## Remove stow-managed symlinks
	@echo "Unstowing $(PROFILE) from ~/.config …"
	cd "$(STOW_DIR)" && $(STOW) -D .

restow: ## Re-stow (unstow then stow — fixes conflicts)
	@echo "Restowing $(PROFILE) → ~/.config …"
	cd "$(STOW_DIR)" && $(STOW) -R .

install: doctor ## Full install: stow + profile-specific extras (e.g. .bash_profile)
	@echo ""
	@echo "── Installing profile: $(PROFILE) ──"
	cd "$(STOW_DIR)" && $(STOW) .
ifeq ($(PROFILE),macOS)
	@# .bash_profile lives at $HOME, not ~/.config — link it separately
	@if [ -f "$(STOW_DIR)/.bash_profile" ]; then \
		if [ -e "$$HOME/.bash_profile" ] && [ ! -L "$$HOME/.bash_profile" ]; then \
			mv "$$HOME/.bash_profile" "$$HOME/.bash_profile.backup-$$(date +%Y%m%d-%H%M%S)"; \
			echo "  Backed up existing ~/.bash_profile"; \
		fi; \
		ln -sfn "$(STOW_DIR)/.bash_profile" "$$HOME/.bash_profile"; \
		echo "  Linked: ~/.bash_profile → $(STOW_DIR)/.bash_profile"; \
	fi
endif
	@echo ""
	@echo "Done ✓  Run 'make doctor' to verify tool availability."

uninstall: ## Remove all symlinks for the profile
	@echo "── Uninstalling profile: $(PROFILE) ──"
	cd "$(STOW_DIR)" && $(STOW) -D .
ifeq ($(PROFILE),macOS)
	@if [ -L "$$HOME/.bash_profile" ]; then \
		rm "$$HOME/.bash_profile"; \
		echo "  Removed: ~/.bash_profile symlink"; \
		if [ -f "$$HOME/.bash_profile.backup-"* ] 2>/dev/null; then \
			echo "  Note: backup(s) remain in $$HOME — restore manually if needed."; \
		fi; \
	fi
endif
	@echo "Done ✓"

list: ## Dry-run: show what stow would link (no changes)
	@echo "Dry run for profile: $(PROFILE)"
	@echo ""
	cd "$(STOW_DIR)" && $(STOW) -n -v . 2>&1 || true
ifeq ($(PROFILE),macOS)
	@echo ""
	@echo "Extra (non-stow):"
	@echo "  ~/.bash_profile → $(STOW_DIR)/.bash_profile"
endif
