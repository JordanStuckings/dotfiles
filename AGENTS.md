# Repository Guidelines

## Project Structure & Module Organization
- `macOS/setup-symlinks.sh` links dotfiles into `~`, making this script the entry point for fresh setups; keep paths relative so it stays portable.
- `macOS/ghostty/config` holds the Ghostty profile; group related tweaks under comment headers to keep theme, font, and window options readable.
- `macOS/nvim/` mirrors a LazyVim layout: `init.lua` boots plugins, `lua/config/` contains core options, keymaps, and autocommands, and `lua/plugins/` stores feature-specific plugin specs. Add new Lua modules beside similar files to keep discovery simple.

## Build, Test, and Development Commands
- `bash macOS/setup-symlinks.sh` — dry-run friendly; inspect the echoed paths before confirming symlink creation.
- `nvim --headless "+Lazy sync" +qa` — ensures new plugin specs under `lua/plugins/` are installed and synced without launching the UI.
- `stylua macOS/nvim/lua` — formats Lua sources using the repo’s `stylua.toml` rules; run after structural edits or before raising a PR.

## Coding Style & Naming Conventions
- Lua uses 2-space indentation, a 120-column soft limit, and double quotes only when required by the plugin API; match the existing comment style (`-- Section`).
- Name plugin spec files after the capability they deliver (`git.lua`, `lsp.lua`) and expose modules via `return { ... }` tables to align with LazyVim expectations.
- Keep Ghostty options in lowercase key names matching upstream docs; insert blank lines between logical groups for readability.

## Testing Guidelines
- After updating Neovim config, run `nvim --headless "+checkhealth" +qa` to confirm plugins and providers remain healthy.
- Launch Ghostty once per configuration change to visually verify theme, font, and padding adjustments across light/dark modes.
- When altering the symlink script, test with a temporary target directory (`DRY_RUN=1`) to confirm no unintended overwrites.

## Commit & Pull Request Guidelines
- Follow short, imperative commit subjects (e.g., `Update ghostty padding`)—the existing history uses that style.
- Include concise bodies describing the why when the change touches multiple tools or affects setup behavior.
- PRs should summarize the configuration impact, list tested commands (`stylua`, `Lazy sync`, `checkhealth`), and link any related issues or screenshots that demonstrate UI changes.
