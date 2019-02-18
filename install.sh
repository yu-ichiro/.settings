# /bin/zsh
echo "Getting the remote working environment.."
NOSTACK=1 cd $HOME
[ ! -e "$HOME/.settings" ]&&        echo "Cloning .settings..." && git clone https://github.com/yu-ichiro/.settings.git && echo "Done."

[ ! -e "$HOME/.zshenv" ]&&          print "Linking .zshenv..." && ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv && echo "Done."
[ ! -e "$HOME/.vimrc" ]&&           print "Linking .vimrc..." && ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc && echo "Done."
[ ! -e "$HOME/.tmux.conf" ]&&           print "Linking .tmux.conf..." && ln -sf $HOME/.settings/tmux/.tmux.conf $HOME/.tmux.conf && echo "Done."

[ "$SHELL" != "$(which zsh)" ]&&    echo    "Changing default shell to zsh..." && chsh -s $(which zsh) && echo "Done."
NOSTACK=1 cd $HOME/.settings;       print   "Initializeing & Updating Submodules..."
    git submodule update --recursive --init
NOSTACK=1 cd $HOME;                 echo    "Done."

[ ! -e "$HOME/.zshlocal" ]&&        print  "Creating .zshlocal..." && echo "#External zsh local settings" >"$HOME/.zshlocal" && echo "Done."
printf "Loading .zshenv..."&& source $HOME/.settings/zsh/.zshenv && echo "Done."
printf "Loading .zshrc..." && source $HOME/.settings/zsh/.zshrc && echo "Done."
echo
echo "All Green! Your working environment is complete."
