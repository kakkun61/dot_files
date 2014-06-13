#!/bin/sh

for path in $*
do
    if git ls-files --error-unmatch ${path} >/dev/null 2>&1
    then
        git rm ${path}
    else
        rm ${path}
    fi
done
