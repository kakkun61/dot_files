#! /usr/bin/env bash

set -e

while IFS= read -r line
do
  case "$line" in
    '      profileExtra = "";')
      echo "      profileExtra ="
      echo "        ''"
      cat "$1"
      echo "        '';";;
    '      initExtra = "";')
      echo "      initExtra ="
      echo "        ''"
      cat "$2"
      echo "        '';";;
    '      logoutExtra = "";')
      echo "      logoutExtra ="
      echo "        ''"
      cat "$3"
      echo "        '';";;
    *) echo "$line";;
  esac
done
