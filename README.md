# Mount Windows Shares
Mount Windows Shared Folder easily to your Linux by using CIFS

## Requirements

    sudo apt-get install cifs-utils

## Script: **mount_single_folder.sh**
Use this script when you have predefined parameters for single specific Windows shared folder.

Open script and manually edit parameters to match  your configuration

    compname='WINDOWS-FAKE-COMPUTER-NAME'
    winshare='MyFakeWindowsSharedFolderName'
    nixpath='/home/my_fake_unix_user/sharefolders'
    winuser='my_windows_user_name'
    domain='WORKGROUP'

Script does a lookup to find a current IP for given computer name. When mounting it asks two passwords your linux sudoer password and and Windows user's password.

Tip: this file should be named more describing eg. mount_computername_project_folder.sh

## Script: **mount_winshare.sh**

This script is more dynamic and allows user to give parameters directly.

    -c    Windows Computer Name
    -s    Windows Share Folder
    -t    Target path in linux, eg. '/home/my_user/shared_folder'
    -u    Windows Username
    -d    Domain (default: WORKGROUP)

Example to run command:

    . mount_winshare.sh -c my_computer_name -s shared_folder_name -t /home/user/shared -u windows_username

## Problems?

* Did you remember to give execution rights to .sh file?
* Script uses 'sudo'-command, does your Linux distro support it? change it to match your own.
