fpath=($ZDOTDIR/zfunctions $fpath)
function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ];then #ファイルの存在を確認
                . "$lib"
        fi
}

loadlib $ZDOTDIR/zshvars		#変数
loadlib $ZDOTDIR/zshfunc		#関数
loadlib $ZDOTDIR/zshantigen		#antigen 関連
loadlib $ZDOTDIR/zshautoload    #autoload
loadlib $ZDOTDIR/zshopts		#optset
loadlib $ZDOTDIR/zshalias		#alias
loadlib $ZDOTDIR/zshbindkeys	#bindkey
loadlib $HOME/.zshlocal         #local

local sshchk=""
[ "$SSH_CONNECTION$REMOTEHOST" != "" ]&&sshchk='%M:6'
local usercl=3
local umark="$"
[ "$UID" = "0" ]&&usercl=1&&umark="#"
prom1=$'%{$(eval powliner -e $sshchk $(pwdarray -a))\n%}'
prom2=$'$(powliner -e "%n $umark:$usercl")'
PROMPT="$prom1$prom2"
RPROMPT='$(gitstat)'
SPROMPT='Did you mean "%r"?(You typed "%R")[(Y)es (N)o (A)bort (E)dit]'

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


