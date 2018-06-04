# .bash_profile

set -o vi

# If non-interactive shell, exit
[ -z "$PS1" ] && return

# If ~/.bashrc exists, source it
[ -f "${HOME}/.bashrc" ] && source ${HOME}/.bashrc

