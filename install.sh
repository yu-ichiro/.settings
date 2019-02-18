# /bin/zsh
echo "Getting the remote working environment.."
NOSTACK=1 cd $HOME
[ ! -e "$HOME/.settings" ]&&        echo "Cloning .settings..." && git clone https://github.com/yu-ichiro/.settings.git && echo "Done."

[ ! -e "$HOME/.zshenv" ]&&          printf "Linking .zshenv..." && ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv && echo "Done."
[ ! -e "$HOME/.vimrc" ]&&           printf "Linking .vimrc..." && ln -sf $HOME/.settings/vim/vimrc $HOME/.vimrc && echo "Done."
[ ! -e "$HOME/.tmux.conf" ]&&           printf "Linking .tmux.conf..." && ln -sf $HOME/.settings/tmux/.tmux.conf $HOME/.tmux.conf && echo "Done."

[ "$SHELL" != "$(which zsh)" ]&&    echo    "Changing default shell to zsh..." && chsh -s $(which zsh) && echo "Done."
NOSTACK=1 cd $HOME/.settings;       printf   "Initializeing & Updating Submodules..."
    git submodule update --recursive --init
NOSTACK=1 cd $HOME;                 echo    "Done."

[ ! -e "$HOME/.zshlocal" ]&&        printf  "Creating .zshlocal..." && echo "#External zsh local settings" >"$HOME/.zshlocal" && echo "Done."

echo "Checking if brew is installed..."

which brew > /dev/null;[ "$?" = "1" ] && {
    echo "brew not installed. installing brew"
    [ "$(uname -a | cut -d' ' -f1)" = "Darwin" ]&&MAC=true||MAC=false
    MAC && {
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    } || {
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.zshlocal
    }
}
which brew > /dev/null;[ "$?" = "0" ]&& {
    echo "brew installed! installing brew packages"
    brew install peco
} || {
    echo "!! brew install failed !!"
    echo "you need to install brew yourself"
    exit 1
}
echo "All Green! Your working environment is complete."
