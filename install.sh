# /bin/sh

ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv
ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc

chsh -s $(which zsh)
cd .settings 
git submodule init
git submodule update
