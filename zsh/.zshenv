# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi
# local bin
export PATH=$HOME/.bin:$PATH
export ZDOTDIR=$HOME/.settings/zsh
export VIRTUAL_ENV_DISABLE_PROMPT=1
