#! /bin/zsh
#functions read into .zshrc
function gitstat {
    local name st color action gitdir

    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(git rev-parse --abbrev-ref=loose HEAD 2> /dev/null)
    if [[ -z ${name} ]]; then
        return
    fi
    [[ -n $(git status -sb | head -1 | grep "\.\.\." ) ]]&&name="${name} \uf45c"
    gitdir=`git rev-parse --git-dir 2> /dev/null`
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${SOLARIZED[green]}
        if [[ -n `echo "$st" | grep ahead` ]]; then
            color=${SOLARIZED[magenta]}
        fi
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=${SOLARIZED[yellow]}
    elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then
        color=${SOLARIZED[blue]}
    else
        color=${SOLARIZED[red]}
    fi
    commits_to_push=""
    if [[ -n `echo "$st" | grep ahead` ]]; then
        commits_to_push=' "↑ '`echo "$st" | grep ahead | grep -o -E '[0-9]+'`:$SOLARIZED[magenta]'"'
    fi
    stash=""
    if [[ "$(echo $(git stash list | wc -l))" != "0" ]]; then
        stash=' " ❐ '$(echo $(git stash list|wc -l))':'$SOLARIZED[yellow]'"'
    fi
    printf '" '$name:$color'"'$commits_to_push$stash
}

function zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

function addopt() {
    opt=${@:?"Specify the opt"}
    if [ -f $ZDOTDIR/zshopts ];then
        echo "${opt}" >> $ZDOTDIR/zshopts
    fi
}

function chpwd () {
    if [ "$NOSTACK" != "1" -a "$DIRSTACK[$DIRPOINT]" != "$PWD" ];then
        DIRSTACK=( $(for (( i=1; i<=$DIRPOINT; ++i ));do; printf "$DIRSTACK[i] ";done) "$PWD" )
        DIRPOINT=$#DIRSTACK
    else
        return 0;
    fi
    local abbr=4
    cmd='CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command ls -ACFG $(ls --color&>/dev/null&&printf "--color")'
    lines=$( eval $cmd | grep -c "" )
    if [ ${lines:-0} -gt $(($abbr*2)) ]; then
        eval $cmd | head -n $abbr
        echo
        for i in {1..$(( ($COLUMNS - 28) / 2  ))};do printf " ";done
        printf "~~ Not Showing %4d lines ~~\n" $(($lines - $abbr*2))
        echo
        eval $cmd | tail -n $abbr
    else
        eval $cmd
    fi
}

function byte2size () {
    byte=$1
    fsize=""
    suffix=""
    if [ $byte -ge $((1024**4)) ]; then
        fsize=`echo "scale=1;${byte}/$((1024**4))"|bc`
        suffix="TB"
    elif [ $byte -ge $((1024**3)) ]; then
        fsize=`echo "scale=1;${byte}/$((1024**3))"|bc`
        suffix="GB"	
    elif [ $byte -ge $((1024**2)) ]; then
        fsize=`echo "scale=1;${byte}/$((1024**2))"|bc`
        suffix="MB"
    elif [ $byte -ge 1024 ]; then
        fsize=`echo "scale=1;${byte}/1024"|bc`
        suffix="KB"	
    else
        fsize=$byte
        suffix="B"
    fi
    echo $fsize$suffix
}

function agvim () {
    IFSTMP=$IFS
    IFS=$'\n'
    buffer=($(ag ${@} | peco --query "$LBUFFER"))
    IFS=$IFSTMP
    filename=$(echo $buffer | awk -F : '{print $1}')
    linenum=$(echo $buffer | awk -F : '{print $2}')
    [ "$buffer" != "" ] && vim -c $linenum $filename
}

function _peco-hist () {
    if which tac >/dev/null 2>&1;then
        rev="tac"
    else
        rev="tail -r"
    fi
    tmpbuf=$(history -n 1 | eval $rev | peco --query="$LBUFFER" --prompt="HISTSEARCH>")
    BUFFER=${tmpbuf:-$BUFFER}
    CURSOR=$#BUFFER
    zle -c -r
}
zle -N _peco-hist

function _dir-back () {
    if [ $DIRPOINT -gt 1 ]; then
        DIRPOINT=$(( DIRPOINT - 1 ))
        NOSTACK=1 cd $DIRSTACK[$DIRPOINT]
        zle reset-prompt
    else
        zle -M "Can not go further"
    fi
}
zle -N _dir-back

function _dir-forward () {
    if [ $DIRPOINT -lt $#DIRSTACK ]; then
        DIRPOINT=$(( DIRPOINT + 1 ))
        NOSTACK=1 cd $DIRSTACK[$DIRPOINT]
        zle reset-prompt
    else
        zle -M "Can not go further"
    fi
}
zle -N _dir-forward

function _dir-showstack () {
    tmppoint=$(for (( i=1; i <= $#DIRSTACK; ++i ));do echo "$i ${DIRSTACK[$i]}"; done | peco --prompt="DIRSTACK>" --initial-index=$((DIRPOINT-1)) | awk '{print $1}')
    if [ "$tmppoint" != "" -a "$tmppoint" != $DIRPOINT ]; then
        DIRPOINT=$tmppoint 
        NOSTACK=1 cd $DIRSTACK[$DIRPOINT]
        zle reset-prompt
    fi
}
zle -N _dir-showstack

function pwdarray () {
    local pwdarray curpath itr ATTR
    [ "$1" = "-a" ]&&ATTR=true||ATTR=false
    pwdarray=( $(echo -n $PWD | tr ' ' ':' | tr '/' ' ') )
    pwdarray[1]=/$pwdarray[1]
    for dir in $pwdarray; do
        itr=$((itr+1))
        pwdarray[$itr]=$(printf "$dir"|tr ':' ' ')
        curpath=$curpath$dir/
        if [ $itr -eq $#pwdarray -a -e "${curpath}.git" ];then
            $ATTR&&pwdarray[$itr]="$pwdarray[$itr]:g$SOLARIZED[blue]"
        elif [ $itr -eq $#pwdarray ];then
            $ATTR&&pwdarray[$itr]="$pwdarray[$itr]:$SOLARIZED[blue]"
        elif [ -e "${curpath}.git" ];then
            $ATTR&&pwdarray[$itr]="$pwdarray[$itr]:g$SOLARIZED[green]"
        fi
    done
    for dir in $pwdarray; do
        printf '"'$dir'" '
    done
}

function ch_color () {
    local front back
    [[ "$1" = "-e" ]]&&esc_flag=$1&&shift
    [[ "$1" != "" && "$1" != "clear" ]]&&front="38;5;$1;"
    [[ "$2" != "" && "$2" != "clear" ]]&&back="48;5;$2;"
    [[ "$esc_flag" != "-e" ]]&&echo -n "\e[${front}${back}m"||echo -n "%{\e[${front}${back}m%}"
}

function powline () {
    function separator () {
        local esc_flag
        [[ "$1" = "-e" ]]&&esc_flag=$1&&shift
        mode=$1;shift
        direction=$1;shift
        from=$1;shift
        to=$1;shift
        local symbol
        if [[ "$mode" = "powerline" ]];then
            [[ "$direction" = "right" && "$from" != "$to" ]]&&symbol="\ue0b0"
            [[ "$direction" = "right" && "$from"  = "$to" ]]&&symbol="\ue0b1"
            [[ "$direction" = "left"  && "$from" != "$to" ]]&&symbol="\ue0b2"
            [[ "$direction" = "left"  && "$from"  = "$to" ]]&&symbol="\ue0b3"
        else
            [[ "$direction" = "right" ]]&&symbol=">"
            [[ "$direction" = "left"  ]]&&symbol="<"
        fi
        local output
        if [[ "$mode" = "powerline" ]];then
            if [[ "$from" = "$to" ]];then
                output=${symbol}
            else
                [[ "$direction" = "right" ]]&&start=$(ch_color ${esc_flag} ${from} ${to})
                [[ "$direction" = "left" ]]&&start=$(ch_color ${esc_flag} ${to} ${from})
                end=$(ch_color ${esc_flag} ${SOLARIZED[base3]} ${to})
                output=${start}${symbol}${end}
            fi
        else
            output=${symbol}
        fi
        echo -n " ${output}"
    }

    local esc_flag
    [[ "$1" = "-e" ]]&&esc_flag=$1&&shift

    ${POWERLINE}&&mode="powerline"||mode="no-powerline"
    direction=$1;shift

    front_color=$SOLARIZED[base3]
    local first last
    current_color=$SOLARIZED[base03]
    [[ "$direction" = "right" ]]&& last=":$SOLARIZED[base03]"
    [[ "$direction" = "left"  ]]&&first=":$SOLARIZED[base03]"
    previous_color=${current_color}

    data=(${first} $@ ${last})
    idx=0
    buffer=""
    for item in $data;do
        [[ "$mode" = "powerline"  ]]&&current_color=$SOLARIZED[base01]
        [[ "$mode" != "powerline"  ]]&&current_color=$front_color
        output=$(echo -n "$item" | sed -e "s/\"//g" | awk 'BEGIN{FS=":";OFS=":"}{if (NF!=1) $NF="";print $0}' | sed -e 's/:$//' )
        attr=$(echo -n "$item" | tr "\"" ' ' | awk 'BEGIN{FS=":";OFS=":"}{print $NF}')
        [[ "$attr" = "$output" ]]&&attr=""
        [[ "$(echo ${attr}|grep -o -E 'g')" != "" ]]&&output="$output \ue0a0"
        [[ "$(echo ${attr}|grep -o -E 'c')" != "" ]]&&current_color="clear"
        [[ "$(echo ${attr}|grep -o -E '[0-9]+')" != "" ]]&&current_color=$(echo ${attr}|grep -o -E '[0-9]+')

        [[ "$mode" = "powerline" && "$idx" = "0"  ]]&&buffer="$(ch_color ${esc_flag} ${front_color} ${current_color})"
        [[ "$mode" != "powerline"  ]]&&output="$(ch_color ${esc_flag} ${current_color})$output$(ch_color ${esc_flag})"

        [[ "$idx" != "0" ]]&&output="$(separator ${esc_flag} ${mode} ${direction} ${previous_color} ${current_color})$output"
        buffer="${buffer}${output}"
        previous_color=${current_color}
        idx=$((idx+1))
    done
    echo -n ${buffer}$(ch_color ${esc_flag})
}

function powliner () {
    [[ "$1" = "-e" ]]&&esc_flag=$1&&shift
    powline ${esc_flag} right $@
}

function powlinel () {
    [[ "$1" = "-e" ]]&&esc_flag=$1&&shift
    powline ${esc_flag} left $@
}

function trashEmptyDirectory () {
    OLDIFS=$IFS
    IFS=$'\n'
    folders=( $(find $PWD -maxdepth 1 -type d) )
    for folder in $folders; do
        [ -z "$(ls -A ${folder})" ]&& rmdir "${folder}"
    done
    IFS=$OLDIFS
}

function php-serve () {
    php -dxdebug.remote_enable=1 -dxdebug.remote_autostart=1 -dxdebug.remote_host=localhost -dxdebug.remote_port=$((${1:-8000} + 1000)) -dxdebug.remote_log=/tmp/xdebug.log -S 127.0.0.1:${1:-8000} -t  public/
}
