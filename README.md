# EraseLogs
This repository contains scripts for clearing logs on Linux/Windows for redteaming activities.

### Clearing log file(s) under Linux - CentOS or its equivalent
In Linux, the log files are usually stored under ```/var/log``` directory and you can see which files are being written in ```/etc/rsyslog.conf```.
Most of the interesting messages you will see under
```
/var/log/messages
```
and is the default way to look into the issue if you are not successdding. Be it be installation, configuration and other
troubleshooting issues.
If there are failed and successful login attempts using sudo, ssh services, look into
```
/var/log/auth.log
```
### Hiding your ip traces
If you wish to remove your own ip being logged, you can use:
```
# grep -v '<src-ip-address>' /path/to/access_log > a && mv a /path/to/access_log
```
What it does is simply to copy all lines except the lines that contain your IP-address. And then move them, and them move them back again.
```
# grep -v <entry-to-remove> <logfile> > /tmp/a ; mv /tmp/a <logfile> ; rm -f /tmp/a
```

### utmp and wtmp activities
These logs are not in plain text but instead, these are binary files! You can use utilities like ```last```, ```lastlog```
to view them.

### Command history
Whatever activities that you do are stored under $HISTFILE. To view them, you can use
```
# echo $HISTFILE
# echo $HISTSIZE
```

You can set your file-size like this to zero, to avoid storing commands.
```
# export HISTSIZE=0
```
If you set it when you get shell you won't have to worry about cleaning up the history.

### Shred file(s)
Shredding files lets you remove files in a more secure way.
```
# shred -zu filename
```
Thanks for the following git repositories for allowing me to experiment and get my own version!
* https://github.com/sundowndev/covermyass

