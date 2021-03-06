#!/bin/zsh
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source ${ZPLUG_HOME}/init.zsh

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "supercrabtree/k"
zplug "yu-ichiro/zsh-helpers"
zplug "b4b4r07/easy-oneliner", if:"which fzf"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
