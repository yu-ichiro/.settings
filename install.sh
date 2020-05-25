#! /bin/zsh

echo "Getting the remote working environment.."
NOSTACK=1 cd $HOME
[[ ! -e "$HOME/.settings" ]]&&          printf "Cloning .settings..."                   && git clone https://github.com/yu-ichiro/.settings.git                                         && echo "Done."
[[ ! -e "$HOME/.zshenv" ]]&&            printf "Linking .zshenv..."                     && ln -sf $HOME/.settings/zsh/.zshenv $HOME/.zshenv                                             && echo "Done."
[[ ! -e "$HOME/.vimrc" ]]&&             printf "Linking .vimrc..."                      && ln -sf $HOME/.settings/vim/.vimrc $HOME/.vimrc                                               && echo "Done."
[[ ! -e "$HOME/.tmux.conf" ]]&&         printf "Linking .tmux.conf..."                  && ln -sf $HOME/.settings/tmux/.tmux.conf $HOME/.tmux.conf                                      && echo "Done."
[[ ! -e "$HOME/.tigrc" ]]&&             printf "Linking .tigrc..."                      && ln -sf $HOME/.settings/.tigrc $HOME/.tigrc                                                   && echo "Done."
[[ ! -e "$HOME/.zshlocal.before" ]]&&   printf "Creating .zshlocal.before..."           && echo "#External zsh local settings loaded before initialization" > "$HOME/.zshlocal.before"  && echo "Done."
[[ ! -e "$HOME/.zshlocal" ]]&&          printf "Creating .zshlocal..."                  && echo "#External zsh local settings" > "$HOME/.zshlocal"                                      && echo "Done."
[[ ! -e "$HOME/.bin" ]]&&               printf "Creating .bin..."                       && mkdir "$HOME/.bin"                                                                           && echo "Done."

NOSTACK=1 cd $HOME/.settings;       printf   "Initializing & Updating Submodules..."
    git submodule update --recursive --init
NOSTACK=1 cd $HOME;                 echo    "Done."


echo "Checking if brew is installed..."

[[ "$(uname -a | cut -d' ' -f1)" = "Darwin" ]]&&MAC=true||MAC=false
which brew > /dev/null;[[ "$?" = "1" ]] && {
    echo "brew not installed. installing brew"
    ${MAC} && {
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    } || {
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.zshlocal.before
    }
}
which brew > /dev/null;[[ "$?" = "0" ]]&& {
    echo "brew installed! installing brew packages"
    cd $HOME/.settings
    brew bundle --verbose
    cd $HOME
} || {
    echo "!! brew install failed !!"
    echo "you need to install brew yourself"
    exit 1
}

sudo echo "/usr/local/bin/zsh" >> /etc/shells
ZSH_PATH=$(which zsh)
[[ "$SHELL" != "$ZSH_PATH" ]]&& echo "Changing default shell to zsh..." && chsh -s ${ZSH_PATH} && echo "Done."
${MAC} && {
    echo "Setting macOS defaults..."
    cd $HOME/.settings
    [[ -e "defaults.sh" ]]&&zsh defaults.sh
    cd $HOME
}

echo "setting up vim"
${MAC} && {
    mkdir -p $HOME/Library/Frameworks/
    [[ ! -e $HOME/Library/Frameworks/Python.framework/ ]]&&ln -s /usr/local/Frameworks/Python.framework ~/Library/Frameworks/
}
$HOME/.settings/vim/bundle/neobundle.vim/bin/neoinstall
pip3 install powerline-status
echo "All Green! Your working environment is complete."
