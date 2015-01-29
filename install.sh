# /bin/sh
cd $HOME
[ -e "$HOME/.settings" ]&& git clone git@github.com:yu-ichiro/.settings

[ -e "$HOME/.zshenv" ]&& ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv
[ -e "$HOME/.vimrc" ]&& ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc

[ "$SHELL" != "$(which zsh)" ]&& chsh -s $(which zsh)
cd $HOME/.settings 
    git submodule update --recursive --init
cd $HOME

[ ! -f "$HOME/.zshlocal" ]&& echo "#External zsh local settings" >"$HOME/.zshlocal"
