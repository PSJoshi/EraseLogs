#!/bin/bash

# CTRL_C trap
ctrl_c()
{
	echo
	cleanup
	e "Installation aborted by user!" 31
}
trap ctrl_c INT

## Checking root access
if [ $EUID -ne 0 ]; then
	ee "This script has to be ran as root!"
fi

## Check for wget or curl or fetch
echo "Checking for HTTP clients"
if [ `which curl 2> /dev/null` ]; then
	download="$(which curl) -s -O"
elif [ `which wget 2> /dev/null` ]; then
	download="$(which wget) --no-certificate"
elif [ `which fetch 2> /dev/null` ]; then
	download="$(which fetch)"
else
	echo "No HTTP client found, Please install clients like curl, wget"
fi

## Check for package manager (apt or yum)
echo "Checking for package manager..."
if [ `which apt-get 2> /dev/null` ]; then
	download="$(which apt-get) -y --force-yes install"
elif [ `which yum 2> /dev/null` ]; then
	download="$(which yum) -y install"
else
	echo "No package manager found."
fi

## Check for package manager (dpkg or rpm)
if [ `which dpkg 2> /dev/null` ]; then
	download="$(which dpkg)"
elif [ `which rpm 2> /dev/null` ]; then
	download="$(which rpm)"
else
	ee "No package manager found."
fi

## Check for init system (update-rc.d or chkconfig)
echo "Checking for init system..."
if [ `which update-rc.d 2> /dev/null` ]; then
	init="$(which update-rc.d)"
elif [ `which chkconfig 2> /dev/null` ]; then
	init="$(which chkconfig) --add"
else
	echo "Init system not found, service not started!"
fi
