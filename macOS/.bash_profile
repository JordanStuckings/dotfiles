export PATH="/opt/homebrew/bin:$PATH"

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Fancy PS1 (Omarchy-style)
PS1='\[\e[38;5;204m\]\u\[\e[38;5;110m\]@\h \[\e[38;5;67m\]\w\[\e[0m\]\n$ '

alias vim='nvim'
export GIT_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim

alias ls="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -A --color=auto"

# Source local overrides if they exist
if [ -f "$HOME/.bash_profile.local" ]; then
  source "$HOME/.bash_profile.local"
fi
if [ -f "$HOME/.afm-bin-path-manager.bash" ]; then source "$HOME/.afm-bin-path-manager.bash"; fi
