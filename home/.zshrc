# Set up the prompt

autoload -Uz promptinit
promptinit
setopt prompt_subst

function take() {
    mkdir -p $@ && cd ${@:$#}
}

function _get_current_git_branch() {
    BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n $BRANCH ]] && echo "{%F{yellow}${BRANCH}%f} "
}

if [[ "$TERM" != "dumb" ]]; then
    # time with seconds; optional return code (bold, yellow); user name (cyan); current Git branch (yellow)
    #export PROMPT='%D{%H:%M:%S} %B%F{yellow}%(?..[%?] )%f%b<%F{cyan}%n%f> $(_get_current_git_branch)$ '

    # time with seconds; optional return code (bold, yellow); current Git branch (yellow)
    export PROMPT='%D{%H:%M:%S} %B%F{yellow}%(?..[%?] )%f%b$(_get_current_git_branch)%F{cyan}$%f '

    export RPROMPT="%F{green}%~%f"
else
    export PROMPT="%D{%H:%M:%S} %(?..[%?] )<%n> %~ $ "
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Activate autojump
. /usr/share/autojump/autojump.sh

export CHROMIUM_FLAGS="--force-dark-mode --ignore-gpu-blocklist --incognito"

export EDITOR=/usr/bin/gvim

# set LANG
export LANG="de_DE.UTF-8"

# Colorize manpages
export PAGER='/usr/bin/most -s'

# default printer
export PRINTER="that_printer_name"

if [ "$(tty)" = "/dev/tty1" ]; then
    setxkbmap de
    startx
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh)"

. ~/.zprofile
