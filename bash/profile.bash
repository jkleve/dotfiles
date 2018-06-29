# .bash_profile

set -o vi

# If non-interactive shell, exit
[ -z "$PS1" ] && return

# If ~/.bash_local exists, source it
if [ -f "${HOME}/.bash_local" ]; then
    source ${HOME}/.bash_local
    [ -f "${DOTFILES}/bash/bashrc.bash" ] && source ${DOTFILES}/bash/bashrc.bash
fi
