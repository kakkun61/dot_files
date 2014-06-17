#!/bin/sh

git_tracked() {
    git ls-files --error-unmatch "$arg" >/dev/null 2>&1
}

opts=()
args=()
endopt=false
for arg in $*
do
    if $endopt || echo $arg | grep -Evq '^-'
    then
        args=("${args[@]}" "$arg")
    else
        opts=("${opts[@]}" "$arg")
        case arg in
            '--') endopt=true;;
        esac
    fi
done

for arg in "${args[@]}"
do
    if git_tracked
    then
        git rm "${opts[@]}" "$arg"
    else
        /bin/rm "${opts[@]}" "$arg"
    fi
done
