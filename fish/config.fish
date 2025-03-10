set fish_greeting
set -gx GPG_TTY (tty)
starship init fish | source
direnv hook fish | source

alias ls='eza --icons'
alias l='eza --all --icons'
alias ll='eza -al --icons'
alias cat='bat'
alias catp='bat -pp'
