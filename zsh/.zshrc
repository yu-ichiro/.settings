fpath=($ZDOTDIR/zfunctions $fpath)
function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ];then #ファイルの存在を確認
            . "$lib"
        else
            echo '"'$lib'" not found'
        fi
}

loadlib $ZDOTDIR/zshvars.sh        #env
loadlib $ZDOTDIR/zplug.sh          #zplug
loadlib $ZDOTDIR/zshfunc.sh        #関数
loadlib $ZDOTDIR/zshautoload.sh    #autoload
loadlib $ZDOTDIR/zshopts.sh        #optset
loadlib $ZDOTDIR/zshalias.sh       #alias
loadlib $ZDOTDIR/zshbindkeys.sh    #bindkey
loadlib $HOME/.zshlocal            #local

local sshchk=""
[ "$SSH_CONNECTION$REMOTEHOST" != "" ]&&sshchk='%M:6'

local usercl=3
local umark="$"
[ "$UID" = "0" ]&&usercl=1&&umark="#"

function tmuxcheck() {
    local tmuxchk=""
    local tmuxcl=$SOLARIZED[orange]
    if [ "$(echo $(tmux ls >/dev/null 2>&1;echo $?))" != "0" ];then
        return
    fi
    tmuxchk=$'\u1d40\u1d39ux'
    if [ "$TMUX" != "" ];then
        tmuxcl="6"
        tmuxchk="${tmuxchk}:$tmuxcl $(echo -n $TMUX| cut -d$',' -f3):$tmuxcl"
    else;
        if [ "$(echo $(tmux list-sessions 2>&1 | grep -v attached | wc -l ))" = "0" ];then
            tmuxcl="6"
        fi
        tmuxchk="${tmuxchk}:$tmuxcl"
    fi
    printf $tmuxchk
}

prom0=$'%{$(eval powliner -e "\uf120\\ :16" $(ppwalk -l | sed -e "s/login/login:16/" | reverse | tr " " "/" | xargs ):5)\n%}'
prom1=$'%{$(eval powliner -e $(tmuxcheck) $sshchk $(pwdarray -a))\n%}'
prom2=$'%{\e[48;5;${usercl};38;5;15m%}%n $umark %{\e[48;5;%(?.6.1);38;5;${usercl}m%}\ue0b0%{\e[48;5;%(?.6.1);38;5;15m%}%? %{\e[48;5;${SOLARIZED[base03]};38;5;%(?.6.1)m%}\ue0b0'
PROMPT="${prom0}$prom1${prom2}"
RPROMPT=$'$(eval powlinel -e $(gitstat) %D:13 %T:13)'
SPROMPT='Did you mean "%r"?(You typed "%R")[(Y)es (N)o (A)bort (E)dit]'

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

export PATH="$HOME/.poetry/bin:$PATH"
