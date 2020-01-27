#! /bin/zsh

bindkey -d  # reset

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

bindkey '^r' _peco-hist

bindkey '^[]' _dir-forward
bindkey '^[[' _dir-back
bindkey '^[_' _dir-showstack

bindkey $EASY_ONE_KEYBIND easy-oneliner
