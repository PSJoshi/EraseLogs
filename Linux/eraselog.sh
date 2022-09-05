#!/bin/bash

clear_history(){
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

function enable_history () {
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

function disable_history () {
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

LOGS_FILES=(
        /var/log/messages # General message and system related stuff
        /var/log/auth.log # Authenication logs
        /var/log/kern.log # Kernel logs
        /var/log/cron.log # Crond logs
        /var/log/maillog # Mail server logs
        /var/log/boot.log # System boot log
        /var/log/mysqld.log # MySQL database server log file
        /var/log/qmail # Qmail log directory
        /var/log/httpd # Apache access and error logs directory
        /var/log/lighttpd # Lighttpd access and error logs directory
        /var/log/secure # Authentication log
        /var/log/utmp # Login records file
        /var/log/wtmp # Login records file
        /var/log/yum.log # Yum command log file
        /var/log/system.log # System Log
)

function clearLogs () {
        for i in "${LOGS_FILES[@]}"
        do
                if [ -f "$i" ]; then
                        if [ -w "$i" ]; then
                                echo "" > "$i"
                                echo "[+] $i cleaned."
                        else
                                echo "[!] $i is not writable! Retry using sudo."
                        fi
                elif [ -d "$i" ]; then
                        if [ -w "$i" ]; then
                                rm -rf "${i:?}"/*
                                echo "[+] $i cleaned."
                        else
                                echo "[!] $i is not writable! Retry using sudo."
                        fi
                fi
        done
}

echo " Welcome to Erase Logs tool..."
echo "This script will erase all your system and application logs on the system. So, Be careful!!"
echo "It is presumed that you know what you are doing and are ready to accept the risk and consequences!!"
echo 
read -p "Continue.. Press 'Y'to proceed or 'N' to quit   " option 
echo
case $option in
	y ) echo "Proceeding to erase logs...";
		clearlogs;
		clear_history;
		exit;;
	n ) echo "Quitting..";
		exit;;
	* ) echo "Invalid response";
		exit 1;;
esac

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
