#!/bin/zsh
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export LESSKEY=${HOME}/.settings/less/less
DIRSTACK=( "$HOME" );export DIRSTACK
export DIRPOINT=1
[[ "$TERM" = "xterm-256color" || "$TERM" = "screen-256color" ]]&&POWERLINE=true||POWERLINE=false
typeset -A -g SOLARIZED
SOLARIZED=(
base03  8
base02  0
base01  10
base00  11
base0   12
base1   14
base2   7
base3   15
yellow  3
orange  9
red     1
magenta 5
violet  13
blue    4
cyan    6
green   2
)

KEY=(
    BackSpace  "${terminfo[kbs]}"
    Home       "${terminfo[khome]}"
    End        "${terminfo[kend]}"
    Insert     "${terminfo[kich1]}"
    Delete     "${terminfo[kdch1]}"
    Up         "${terminfo[kcuu1]}"
    Down       "${terminfo[kcud1]}"
    Left       "${terminfo[kcub1]}"
    Right      "${terminfo[kcuf1]}"
    PageUp     "${terminfo[kpp]}"
    PageDown   "${terminfo[knp]}"
)