#! /usr/bin/env bash

set -e

if [[ ! $# == 5 ]]
then
    echo "Usage $0 BASH_PROFILE_PATH BASH_INIT_PATH BASH_LOGOUT_PATH GPG_PUBLIC_PATH TMUX_CONF_PATH" >&2
    exit 1
fi

while IFS= read -r line
do
  case "$line" in
    '    bash-profile = "";')
        echo "    bash-profile ="
        echo "        ''"
        cat "$1"
        echo "        '';";;
    '    bash-init = "";')
        echo "    bash-init ="
        echo "        ''"
        cat "$2"
        echo "        '';";;
    '    bash-logout = "";')
        echo "    bash-logout ="
        echo "        ''"
        cat "$3"
        echo "        '';";;
    '    gpg-public-key = "";')
        echo "    gpg-public-key ="
        echo "        ''"
        cat "$4"
        echo "        '';";;
    '    tmux-config = "";')
        echo "    tmux-config ="
        echo "        ''"
        cat "$5"
        echo "        '';";;
    *) echo "$line";;
  esac
done
