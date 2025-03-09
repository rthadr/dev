if not type -q 'fisher'
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher update
    fisher install edc/bass
    fisher install jorgebucaran/autopair.fish
    fisher install jhillyerd/plugin-git
end

bass source /etc/profile

set fish_greeting
set -gx GPG_TTY (tty)
starship init fish | source
direnv hook fish | source

alias ls='eza --icons'
alias l='eza --all --icons'
alias ll='eza -al --icons'
alias cat='bat'
alias catp='bat -pp'
