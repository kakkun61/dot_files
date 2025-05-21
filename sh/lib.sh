add_path() {
    PATH="$1:$PATH"
    export PATH
}

setup_sands() {
    xmodmap -e 'keycode 255=space'
    xmodmap -e 'keycode 65=Shift_L'
    xcape -e '#65=space'
}

start_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]
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

start_ssh_agent_wsl() {
    SSH_AUTH_DIR="$(mktemp -d /tmp/ssh-auth.XXXX)"
    SSH_AUTH_SOCK="$SSH_AUTH_DIR/sock"
    setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:'npiperelay.exe -ei -v //./pipe/openssh-ssh-agent',nofork >>"$SSH_AUTH_DIR/log" 2>&1 &
    SSH_AUTH_PID=$!
    export SSH_AUTH_DIR
    export SSH_AUTH_SOCK
    export SSH_AUTH_PID
}

stop_ssh_agent_wsl() {
    echo stop_ssh_agent_wsl
    if [ -n "$SSH_AUTH_PID" ]
    then
        kill "$SSH_AUTH_PID"
        unset SSH_AUTH_PID
    fi
    if [ -n "$SSH_AUTH_DIR" ]
    then
        rm -r "$SSH_AUTH_DIR"
        unset SSH_AUTH_DIR
    fi
    if [ -n "$SSH_AUTH_SOCK" ]
    then
        unset SSH_AUTH_SOCK
    fi
}

setup_nix() {
    # shellcheck source=/dev/null
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
}

setup_less() {
    LESSOPEN="|lesspipe.sh %s"
    export LESSOPEN
}

setup_prompt() {
    # shellcheck source=lib/git/contrib/completion/git-prompt.sh
    . "$1/lib/git/contrib/completion/git-prompt.sh"
    if type __git_ps1 > /dev/null 2>&1
    then
        PS1='\[\e]0;\w\a\]\e[34m($?)\e[0m\n\[\e[32m\]\u@\h [$SHLVL] \[\e[33m\]\w\[\e[0m\]\[\e[36m\]`__git_ps1 " %s"`\[\e[0m\]\n\$ '
    else
        PS1='\[\e]0;\w\a\]\e[34m($?)\e[0m\n\[\e[32m\]\u@\h [$SHLVL] \[\e[33m\]\w\[\e[0m\]\n\$ '
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
    # shellcheck source=/dev/null
    . "$1/lib/bashmarks/bashmarks.sh"
}

setup_fuck() {
    eval "$(thefuck --alias)"
}

setup_gpg() {
    GPG_TTY="$(tty)"
    export GPG_TTY
}

setup_saml2aws() {
    export SAML2AWS_DISABLE_KEYCHAIN=1
}

setup_make() {
    alias make='make -j'
}
