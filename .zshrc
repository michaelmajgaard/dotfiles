# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/michael/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simpleton"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# general
function hsearch {
    grep -i $1 ~/.zsh_history
}

function uuidgen {
    ~/bin/uuidgen $@ | tr -d '\n' | pbcopy
}

function glngen {
    ~/bin/glngen $@ | tr -d '\n' | pbcopy
}

#alias uuidgen="~/bin/uuidgen | tr -d '\n' | pbcopy"
alias ls='gls -lh --group-directories-first --color'
alias ll='ls'
alias lla='ls -a'

function dl {
    if [[ -z "$1" ]]; then
        cd "./" && ls 
    else
        cd "$@" && ls
    fi
}

function cd {
    builtin cd $@ && ll
}

alias rr='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias cl="clear && printf '\e[3J'"
alias vi="nvim"
alias vit="nvim -c 'terminal' -c 'startinsert'"
#alias vim="nvim"
alias sed="gsed"
alias vout="sed $'s/\033[[][^A-Za-z]*[A-Za-z]//g' | vi -"
#alias less="vi -c 'set nonumber' -MR -"
alias vilog="vi -c'set autoread' -MR"

alias notes="vi ~/notes/"

export EDITOR=vi
export VISUAL=vi
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.dotnet/tools:$PATH

# vim mode
bindkey -v
export KEYTIMEOUT=1

bindkey '^k' history-beginning-search-backward
bindkey '^j' history-beginning-search-forward

zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
      [[ ${KEYMAP} == viins ]] ||
      [[ ${KEYMAP} = '' ]] ||
      [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { clear && echo -ne '\e[5 q' ;} # clear prompt and use beam shape cursor for each new prompt.

# wsl specific
if [[ $(grep -i Microsoft /proc/version 2>/dev/null) ]]; then
    function vi {
        cl && vim $@
    }

    function open {
        args=$(echo $@ | sed "s/\/mnt\/c/c:/g")
        powershell.exe -c "& $args"
    }

    function code {
        open code.cmd $1
    }

    function ie {
        #args=$(echo $@ | sed "s/\/mnt\/c/c:/g")
        #args=$(echo $args | sed "s/\//\\/g")
        #echo $args
        open explorer.exe .
    }

    function lock {
        powershell.exe -c "Rundll32.exe user32.dll,LockWorkStation"
    }

    alias dotnet='dotnet.exe'
    alias gitk='gitk.exe'
    alias git='git.exe'
    alias nuget='nuget.exe'

    LS_COLORS="ow=01;36;40" && export LS_COLORS
    LS_COLORS="ow=01;36;40" && export LS_COLORS

    # hack to make colors in autocomplete menu correct in wsl..
    plts=$(<~/lts 2>/dev/null)
    clts=$(date +%s)
    if [[ $((clts-plts)) > 1 ]]; then
        echo -n ${clts} > ~/lts
        source ~/.zshrc
    fi

    cd /mnt/c/udv/ 2>/dev/null
fi


# pnpm
export PNPM_HOME="/Users/michael/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/michael/.bun/_bun" ] && source "/Users/michael/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
