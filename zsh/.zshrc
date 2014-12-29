fpath=($ZDOTDIR/zfunctions /usr/local/share/zsh-completions $fpath)

function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ];then #ファイルの存在を確認
                . "$lib"
	else
		echo "${lib}: no such file" 1>2&
        fi
}

loadlib $ZDOTDIR/zshfunc		#関数
loadlib $ZDOTDIR/zshautoload	#autoload
loadlib $ZDOTDIR/zshopts		#optset
loadlib $ZDOTDIR/zshalias		#alias
loadlib $ZDOTDIR/zshvars		#変数


source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

bindkey -v
