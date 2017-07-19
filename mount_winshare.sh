#!/bin/bash
# check if CIFS is installed
if ! [ -e "/sbin/mount.cifs" ]; then
  echo "Mount system CIFS is not yet installed, you may install it eg. in Ubuntu:"
  echo "sudo apt-get intall cifs-utils"
  return
fi
# help text
if [ "$1" = '-h' ] || [ "$1" = '--help' ] || [ "$#" -eq 0 ]; then
  echo "Parameters
  -c    Windows Computer Name
  -s    Windows Share Folder
  -t    Target path in linux, eg. '/home/my_user/shared_folder'
  -u    Windows Username
  -d    Domain (default: WORKGROUP)
  "
  return
fi
# defaults
compname='WINDOWS-FAKE-COMPUTER-NAME'
winshare='MyFakeWindowsSharedFolderName'
nixpath='/home/my_fake_unix_user/sharefolders'
winuser='my_windows_user_name'
domain='WORKGROUP'
# parameter checker
OPTIND=1
while getopts "c:s:t:u:d:" opt; do
  case $opt in
  c)
    compname="$OPTARG"
  ;;
  s)
    winshare="$OPTARG"
  ;;
  t)
    nixpath="$OPTARG"
  ;;
  u)
    winuser="$OPTARG"
  ;;
  d)
    domain="$OPTARG"
  ;;
  \?) echo "Invalid option -$OPTARG. Use -h for help" >&2
  ;;
  esac
done
# check some error handling
if [ $compname = 'WINDOWS-FAKE-COMPUTER-NAME' ]; then
  echo "Parameter '-c' ($compname) is fake default. Please change it to match your Computer Name."
  return
fi
if [ $winshare = 'MyFakeWindowsSharedFolderName' ]; then
  echo "Parameter '-s' ($winshare) is fake default. Please change it to match your Windows Share name."
  return
fi
if [ $nixpath = '/home/my_fake_unix_user/sharefolder' ]; then
  echo "Parameter '-t' ($nixpath) is fake default. Please change it to match your *nix path."
  return
fi
if [ $winuser = 'my_windows_user_name' ]; then
  echo "Parameter '-u' ($winuser) is fake default. Please change it to match your Windows username."
  return
fi
# lookup the ip and mount
serverip=$(nmblookup $compname | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1)
if [ -z $serverip ]; then
  echo "Couldn't lookup IP for computer: '$compname'"
  return
fi
echo "Mounting Windows Share ($winshare) from $serverip ($compname)"
sudo mount -t cifs //$serverip/$winshare $nixpath -ouser=$winuser,uid=1000,gid=1000,iocharset=utf8,domain=$domain
