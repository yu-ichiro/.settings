# /bin/sh

ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv
ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc

[ "$SHELL" != "$(which zsh)" ]&& chsh -s $(which zsh)
cd $HOME/.settings 
    git submodule init
    git submodule update
cd $HOME

[ ! -f "$HOME/.zshlocal" ]&& echo "#External zsh local settings" >"$HOME/.zshlocal"
