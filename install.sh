# /bin/zsh
NOSTACK=1 cd $HOME
[ ! -e "$HOME/.settings" ]&&        echo    "Cloning .settings..." && git clone git@github.com:yu-ichiro/.settings && echo "Done."

[ ! -e "$HOME/.zshenv" ]&&          printf	"Linking .zshenv..." && ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv && echo "Done."
[ ! -e "$HOME/.vimrc" ]&&           printf	"Linking .vimrc..." && ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc && echo "Done."

[ "$SHELL" != "$(which zsh)" ]&&    echo    "Changing default shell to zsh..." && chsh -s $(which zsh) && "Done."
NOSTACK=1 cd $HOME/.settings;       printf	"Initializeing & Updating Submodules..."
    git submodule update --recursive --init
NOSTACK=1 cd $HOME;                 echo    "Done."

[ ! -f "$HOME/.zshlocal" ]&&        echo    "Creating .zshlocal..." && echo "#External zsh local settings" >"$HOME/.zshlocal" && "Done."
printf "Loading .zshenv..."&& source $HOME/.settings/zsh/.zshenv && echo "Done."
printf "Loading .zshrc..." && source $HOME/.settings/zsh/.zshrc && echo "Done."
echo
echo "All Green! Your working environment is complete."
