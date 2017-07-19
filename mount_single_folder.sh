#!/bin/bash
# Tip: rename file to something more specific
# parameters
compname='WINDOWS-FAKE-COMPUTER-NAME'
winshare='MyFakeWindowsSharedFolderName'
nixpath='/home/my_fake_unix_user/sharefolders'
winuser='my_windows_user_name'
domain='WORKGROUP'
# check some error handling
if ! [ -e "/sbin/mount.cifs" ]; then
  echo "Mount system CIFS is not yet installed, you may install it eg. in Ubuntu:"
  echo "sudo apt-get intall cifs-utils"
  return
fi
if [ $compname = 'WINDOWS-FAKE-COMPUTER-NAME' ]; then
  echo "Parameter 'compname' ($compname) is example. Please change it to match your Computer Name."
  return
fi
if [ $winshare = 'MyFakeWindowsSharedFolderName' ]; then
  echo "Parameter 'winshare' ($winshare) is example. Please change it to match your Windows Share name."
  return
fi
if [ $nixpath = '/home/my_fake_unix_user/sharefolder' ]; then
  echo "Parameter 'nixpath' ($nixpath) is example. Please change it to match your *nix path."
  return
fi
if [ $winuser = 'my_windows_user_name' ]; then
  echo "Parameter 'winuser' ($winuser) is example. Please change it to match your Windows username."
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
