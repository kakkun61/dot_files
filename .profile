# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Haskell
if [ -d "${HOME}/.cabal" ]
then
    export PATH=${HOME}/.cabal/bin:$PATH
fi

if mac
then
    # GAE/Go
    #export PATH=$HOME/Programming/go_appengine:$PATH

    # Go
    # Using "launchctl" is for an IntelliJ IDEA's bug.
    launchctl setenv GOROOT /usr/local/go
    launchctl setenv GOPATH /Users/okamoto-k/go
    export PATH=$GOROOT/bin:$PATH

    # Android
    export ANDROID_HOME=$HOME/Applications/android-sdk-macosx
    export PATH=$ANDROID_HOME/platform-tools:$PATH

    # Java
    export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
    export PATH=$JAVA_HOME/bin:$PATH
elif linux
then
    # SandS
    xmodmap -e 'keycode 255=space'; xmodmap -e 'keycode 65=Shift_L'; xcape -e '#65=space'
else
    # SSH
    eval `ssh-agent`
fi
