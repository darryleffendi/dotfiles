eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval $(thefuck --alias)

export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"
alias idea="open -na 'IntelliJ IDEA.app' --args"

alias dir='ls -la'
alias cls='clear'
alias tma='tmux attach'

alias gta='git add'
alias gts='git status'
alias gtf='git fetch origin'
alias gtc='git commit -m'
alias gtp='git push'

alias gotc='go test -coverprofile=coverage_gotc_auto_zshrc.out ./... && go tool cover -html=coverage_gotc_auto_zshrc.out && rm coverage_gotc_auto_zshrc.out'
alias mvnt='mvn clean test'
alias get-claude-md='curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md'

source ~/.bash_profile;

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
