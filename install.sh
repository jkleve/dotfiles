#!/usr/bin/env bash
set -e
DOTFILES_URL="https://github.com/jkleve/dotfiles.git"
DOTFILES_DIR="${HOME}/.dotfiles"

link_files() {
    pushd $HOME
    ln -sf ${DOTFILES_DIR}/git/gitconfig .gitconfig
    ln -sf ${DOTFILES_DIR}/input/inputrc .inputrc
    ln -sf ${DOTFILES_DIR}/tmux/tmux.conf .tmux.conf
    ln -sf ${DOTFILES_DIR}/zsh/zshrc .zshrc
    popd
}

main() {
    if [ -d "$DOTFILES_DIR" ]; then
        rm -rf $DOTFILES_DIR
    fi

    git clone $DOTFILES_URL $DOTFILES_DIR

    link_files

    echo "source ${DOTFILES_DIR}/bash/bashrc.bash" >> ${HOME}/.bashrc
    echo "export DOTFILES=$DOTFILES_DIR" >> .bash_local
    echo "export DOTFILES=$DOTFILES_DIR" >> .zsh_local
}

main
