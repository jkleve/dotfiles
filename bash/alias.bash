# .bash_alias
#
# Most used alias'

alias vi="nvim"
alias nvi="nvim"

# Re-source
alias rload='source ~/.bashrc'

alias c=clear

# filesystem
alias df='df -hT'
# tree
alias tree='tree -FC'
# less is NOT more, but it is...
alias less='less -Ri' # R = raw (ANSI colors). i = case in-sensitive on searches
alias h='history | tail -20'

# ls
alias ls='LC_COLLATE=C ls -FG'
alias l='ls -lFGh'
alias ll='l'
alias lsl='ls -lFh'
alias lsla='ls -lFAh'
alias lla='ls -lFAh'
alias llA='ls -lFah'
alias lA='ls -FA'
alias lsf="ls -lh | grep -E '([0-9]+(M|G)+)*'"
alias lsfa="ls-lha | grep -E '([0-9]+(M|G)+)*'"
alias lsd='ls -lthr'
alias ls-size='ls -lShr'
alias lss='ls-size'

# directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# dirs, pushd, popd
alias dirs='dirs -v'

# tmux
alias tl="tmux ls"
alias tk="tmux kill -t"
alias tn="tmux new -s"
alias ta="tmux attach -t"

alias rcp="rsync -avz --progress -h"
alias rmv="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-sync="rsync -avzu --delete --progress -h"
