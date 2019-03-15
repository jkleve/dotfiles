# .bashrc

# Local definitions (i.e. DOTFILES)
[ -f "${HOME}/.bash_local" ] && source ${HOME}/.bash_local

# If DOTFILES is not defined, warn and exit
[ -z "$DOTFILES" ] && echo "WARNING: Can't find dotfiles" && return

# Source all dotfiles defined here
for DOTFILE in "$DOTFILES"/bash/{functions.bash,path.bash,env.bash,alias_extended.bash,alias.bash,prompt.bash,googlerc}; do
    [ -f "$DOTFILE" ] && source "$DOTFILE"
done
