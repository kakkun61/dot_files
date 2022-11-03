setup_bash_config() {
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
    shopt -s globstar

    # Don't use ^D to exit
    set -o ignoreeof

    # Use case-insensitive filename globbing
    shopt -s nocaseglob
}

setup_ls() {
    alias ls='ls --color=auto'
}

setup_shellcheck() {
    alias shellcheck='shellcheck --color=always'
}

setup_direnv() {
    eval "$(direnv hook bash)"
}

setup_git_env() {
    export GIT_PS1_SHOWDIRTYSTATE=1
}

setup_git_completion() {
    # shellcheck source=/dev/null
    source "$1/lib/git/contrib/completion/git-completion.bash"
}
