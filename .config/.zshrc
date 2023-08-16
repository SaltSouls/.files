# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gigapain/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias grep="rg"
alias cat="bat"
alias find="fd"
alias cd="z"
alias cdi="zi"
alias ls="lsd -X"
alias ll="lsd -lhX"
alias ps="procs"
alias back=". back"
# End of aliases
# Starship stuff

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export PATH="$HOME/bin:$PATH"
