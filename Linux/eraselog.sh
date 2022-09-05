#!/bin/bash

clearlog(){
    export HISTFILE=
    unset HISTFILE
    shred -zu ~/.bash_history
    find /home/ -name ".bash_history" -exec shred -zu {} \; -exec touch {} \;
    history -c
    touch ~/.bash_history
    unset HISTFILE HISTSIZE
    set history=0
    set +o history
    unset HISTFILE
    find / -type f -exec {}
    echo "Logs cleared!"
    sleep 1.5
}

function isRoot () {
    if [ "$EUID" -ne 0 ]; then
        return 1
    fi
}

function enableHistory () {
        if [[ -L ~/.bash_history ]]; then
                rm -rf ~/.bash_history
                echo "" > ~/.bash_history
                echo "[+] Disabled sending history to /dev/null"
        fi

        if [[ -L ~/.zsh_history ]]; then
                rm -rf ~/.zsh_history
                echo "" > ~/.zsh_history
                echo "[+] Disabled sending zsh history to /dev/null"
        fi

        export HISTFILESIZE=""
        export HISTSIZE=50000
        echo "[+] Restore HISTFILESIZE & HISTSIZE default values."

        set -o history
        echo "[+] Enabled history library"

        echo
        echo "Permenently enabled bash log."
}

function disableHistory () {
        ln /dev/null ~/.bash_history -sf
        echo "[+] Permanently sending bash_history to /dev/null"

        if [ -f ~/.zsh_history ]; then
                ln /dev/null ~/.zsh_history -sf
                echo "[+] Permanently sending zsh_history to /dev/null"
        fi

        export HISTFILESIZE=0
        export HISTSIZE=0
        echo "[+] Set HISTFILESIZE & HISTSIZE to 0"

        set +o history
        echo "[+] Disabled history library"

        echo
        echo "Permenently disabled bash log."
}

echo " Changing directory to /var/log..."
cd /var/log
truncate -s 0 /var/log/*log
find . -name "*.gz" -type f -delete
find . -name "*.0" -type f -delete
find . -name "*.1" -type f -delete
find . -name "*.log.*" -type f -delete
# clear logs to erase traces of activities
cat /dev/null > /var/log/messages
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/secure
for logs in `find /var/log -type f`; do > $logs; done
echo "All logs cleared"
