# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Check OS
UNAME=$(uname)
[ $UNAME = Darwin ]
MAC=$?
echo $UNAME | grep CYGWIN 2>&1 > /dev/null
CYGWIN=$?
[ $UNAME = Linux ]
LINUX=$?
mac() {
    return $MAC
}
cygwin() {
    return $CYGWIN
}
linux() {
    return $LINUX
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if mac
then
    #LSCOLORS =...
    alias ls='ls -G'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands. Use like so:
#   sleep 10; alert
if mac
then
    . "$DIR"/alert-mac-os-x/alert.sh
else
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if mac
then
    if [ -f `brew --prefix`/etc/bash_completion ] && ! shopt -oq posix; then
        . `brew --prefix`/etc/bash_completion
    fi
else
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi
fi

# PS1
if type __git_ps1 > /dev/null 2>&1
then
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\e[36m\]$(__git_ps1 " %s")\[\e[0m\]\n\$ '
else
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi

# bashmarks
# https://github.com/huyng/bashmarks
source "$DIR"/bashmarks/bashmarks.sh

# Chromium on Virtual Box
# prevent hardware accelaration to avoid a bug
#alias chromium-browser='chromium-browser --blacklist-accelerated-compositing'

# The Fuck
# https://github.com/nvbn/thefuck
if type thefuck > /dev/null 2>&1
then
    eval "$(thefuck --alias)"
else
    alias fuck='echo -e "thefuck is not installed\nsee https://github.com/nvbn/thefuck"'
fi

# direnv
# http://direnv.net/
if type direnv > /dev/null 2>&1
then
    eval "$(direnv hook bash)"
fi

# add UTF-8 BOM
if type nkf > /dev/null 2>&1
then
    alias add-bom='nkf --overwrite --oc=UTF-8-BOM'
else
    alias add-bom='echo nkf is not installed'
fi
