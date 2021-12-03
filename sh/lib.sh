add_local_bin() {
    PATH="$HOME/bin:$PATH"
    PATH="$HOME/.cabal/bin:$PATH"
    PATH="$HOME/.local/bin:$PATH"
}

setup_sands() {
    xmodmap -e 'keycode 255=space'
    xmodmap -e 'keycode 65=Shift_L'
    xcape -e '#65=space'
}

start_ssh_agent() {
    if [ -z "$SSH_AGENT_PID" ]
    then
        eval "$(ssh-agent -s)"
    fi
}

stop_ssh_agent() {
    if [ -n "$SSH_AGENT_PID" ]
    then
        eval "$(ssh-agent -sk)"
    fi
}

setup_nix() {
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
}

setup_less() {
    eval "$(SHELL=/bin/sh lesspipe)"
}

setup_terminal() {
    if type __git_ps1 > /dev/null 2>&1
    then
        PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\e[36m\]$(__git_ps1 " %s")\[\e[0m\]\n\$ '
    else
        PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
    fi
}

setup_dircolors() {
    if [ -r "$HOME/.dircolors" ]
    then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
}

setup_bashmarks() {
    . "$1/lib/bashmarks/bashmarks.sh"
}

setup_fuck() {
    eval "$(thefuck --alias)"
}

setup_gpg() {
    export GPG_TTY=$(tty)
}
