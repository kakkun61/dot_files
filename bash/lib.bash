set -o errexit -o pipefail

setup_history() {
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