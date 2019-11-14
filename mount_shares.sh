#!/bin/bash
# parameters
compname='Windows-Laptop'
winuser='ezmo'
domain='WORKGROUP,vers=2.0'
# Set array of windows shares, keys are windows path and value to linux
declare -A shares
shares['scripts']='/home/ezmodus/scripts'
shares['projects/websites']='/var/www'
shares['images']='/home/ezmodus/images'
shares['videos']='/home/ezmodus/videos'
shares['projects/code-repositories']='/home/ezmodus/repos'

# check some error handling
if ! [ -e "/sbin/mount.cifs" ]; then
        echo "Mount system CIFS is not yet installed, you may install it eg. in Ubuntu:"
        echo "sudo apt install cifs-utils"
        return
fi
# lookup the ip and mount
serverip=$(nmblookup $compname | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1)
if [ -z $serverip ]; then
        echo "Couldn't lookup IP for computer: '$compname'"
        return
fi

echo "Enter password for Windows-user $winuser ($compname):"
read -s mount_pass
[[ -z "mount_pass" ]] && echo "Password empty, exiting" && exit

echo "Mounting..."
for winshare in "${!shares[@]}"; do
	nixpath="${shares[$winshare]}"
	sudo mount -t cifs //$serverip/$winshare $nixpath -ouser=$winuser,password=$mount_pass,noperm,uid=1000,gid=33,dir_mode=0775,iocharset=utf8,domain=$domain
	echo "Windows Share: '$winshare' from $serverip ($compname) to '$nixpath'"
done
unset shares
