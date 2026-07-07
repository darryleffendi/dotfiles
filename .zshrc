eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval $(thefuck --alias)

# IDEs
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"
alias idea="open -na 'IntelliJ IDEA.app' --args"

# Command line aliases
alias dir='ls -la'
alias cls='clear'
alias tma='tmux attach'
alias tm='tmux'
unalias nv 2>/dev/null  # drop any stale `nv` alias so the function can be defined
nv() {
  # Rename the current tmux window after the project (git root or cwd),
  # but only if the window doesn't already have a custom name.
  if [[ -n "$TMUX" ]]; then
    project=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")")
    tmux rename-window "$project"
  fi
  nvim "$@"
}

# Git Aliases
alias gta='git add'
alias gts='git status'
alias gtf='git fetch origin'
alias gtc='git commit -m'
alias gtps='git push'
alias gtpl='git pull'
alias lg='lazygit'

# Docker & Kube
alias ldk='lazydocker'
alias k='kubectl'
alias dk='docker'
alias dkc='docker-compose'

# Dev Aliases
alias gotc='go test -coverprofile=coverage_gotc_auto_zshrc.out ./... && go tool cover -html=coverage_gotc_auto_zshrc.out && rm coverage_gotc_auto_zshrc.out'
alias mvnt='mvn clean test'
alias get-claude-md='curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md'
alias av='cd ~/codespace/Avalon && tree -L 2'
alias cl='claude'

# Zsh plugins
source ~/.bash_profile;
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Dart + Flutter
export PATH="$HOMEBREW_PREFIX/opt/dart@3.7.2/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"

# SDKMAN (Must be at the end of the file)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/darryl.effendi/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
