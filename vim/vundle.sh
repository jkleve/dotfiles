BUNDLE_DIR=~/.vim/bundle

# Install/update Vundle
mkdir -p "$BUNDLE_DIR" && (git clone https://github.com/VundleVim/Vundle.vim "$BUNDLE_DIR/Vundle.vim" || (cd "$BUNDLE_DIR/Vundle.vim" && git pull origin master))

# Install bundles
vim +PluginInstall +qall

# Compile YouCompleteMe
# echo -e "\nInstalling dependencies for YouCompleteMe\n"
# sudo dnf install cmake python-devel -y
# cd "$BUNDLE_DIR/youcompleteme" && ./install.py

cd -
