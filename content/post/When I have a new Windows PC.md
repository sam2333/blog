---
title: "When I Have a New Windows PC"
date: 2020-08-19T22:34:24+08:00
draft: true
tags:
  - "Windows"
categories:
  - "HowTo"
summary: "When I have a new Windows PC or reinstall the system, I must do these things..."
---

# Uninstall the Built-in Apps

Run the PowerShell console as an administrator.

```
Get-AppxPackage | select Name,PackageFullName,NonRemovable
Remove-AppxPackage -AllUsers Microsoft.BingWeather_4.25.20211.0_x64__8wekyb3d8bbwe
# or
Get-AppxPackage * BingWeather * -AllUsers| Remove-AppPackage –AllUsers
```

# Scoop

A command-line installer for Windows.

Make sure PowerShell 5 (or later, include PowerShell Core) and .NET Framework 4.5 (or later) are installed.
```
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# or shorter
iwr -useb get.scoop.sh | iex
```

Note: if you get an error you might need to change the execution policy (i.e. enable Powershell) with
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

Config the default install path:
```
# User
[environment]::setEnvironmentVariable('SCOOP','C:\Users\Sam\Scoop','User')
$env:SCOOP='C:\Users\Sam\Scoop'

# Global
[environment]::setEnvironmentVariable('SCOOP_GLOBAL','C:\Program Files\Scoop','Machine')
$env:SCOOP_GLOBAL='C:\Program Files\Scoop'
```

Config proxy
```
scoop config proxy 127.0.0.1:1080
```

Remove proxy
```
scoop config rm proxy
```

Add Bucket
```
scoop bucket known
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nightlies
scoop bucket add java
scoop bucket add php
scoop bucket add games
scoop bucket add nerd-fonts
scoop bucket add nonportable
scoop bucket add nirsoft
scoop bucket add jetbrains
scoop bucket add main/extras/versions/nightlies/java/php/games/nerd-fonts/nonportable/nirsoft/jetbrains
scoop bucket add dodorz https://github.com/dodorz/scoop-bucket
```

Install software
```
scoop update

scoop install aria2
scoop config aria2-enabled true/false

scoop install 7zip git openssh everything --global
scoop install mysql57 mysql-workbench redis tomcat maven adb android-sdk orclejdk13 python ruby gradle scala go perl nvm hugo hugo-extended postman sublime-text cmder annie ffmpeg xmind8 mpc-hc akelpad geany sumatrapdf hwmonitor frp robo3t android-studio CLion-portable IntelliJ-IDEA-Ultimate-portable openvpn megasync jq docker helm terraform vault gow sed less touch grep dig curl wget vim gpg openssh
scoop install dodorz/<app_name>

# change version
scoop reset python
scoop reset python27

# remove old version
scoop cleanup *

# export software list
scoop export > app_list.txt
```

# Config Cmder

Regist right button menu
```
Cmder.exe /REGISTER ALL
```

Remove right button menu
```
@echo off
Reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\Cmder" /f
pause
```

Uninstall
```
cmder.exe /UNREGISTER ALL
delete HKEY_CLASSES_ROOT\Directory\Background\shell\Cmder
delete HKEY_CLASSES_ROOT\Directory\shell\Cmder
```

Change `λ` to `$`
```
# cmder\vendor\clink.lua:41 {lamb}->$
local cmder_prompt = "\x1b[1;32;40m{cwd} {git}{hg} \n\x1b[1;30;40m$ \x1b[0m"
```

# Disable Keyboard Shortcuts

Open `regedit` and into this:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
```

Add new string value: `DisabledHotkeys=S`

# WSL

Windows Subsystem for Linux

Open PowerShell as Administrator and run:
```
# 1. Enable the Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 2. Check requirements for running WSL 2
# For x64 systems: Version 1903 or higher, with Build 18362 or higher.

# 3. Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 4. Download the Linux kernel update package
# https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

# 5. Set WSL 2 as your default version
wsl --set-default-version 2

# 6. Install your Linux distribution of choice
# Open the Microsoft Store and select your favorite Linux distribution.
```

CentOS
```
scoop install lxrunoffline

# Download centos
https://github.com/CentOS/sig-cloud-instance-images/tree/CentOS-7.8.2003-x86_64

# LxRunOffline install -n centos -d Target_Path -f centos-7-x86_64-docker.tar.xz
LxRunOffline.exe install -n centos -d D:\Program\WSL\CentOS7 -f D:\Users\Sam\Downloads\centos-7.8.2003-x86_64-docker.tar.xz

# Start
lxrunoffline run -n centos
wsl -d centos
```

Commands
```
wsl --list --verbose
wsl --set-version <distribution name> <versionNumber>

wslconfig /list /all
wslconfig /setdefault centos
wslconfig /unregister Ubuntu-20.04

lxrunoffline list
lxrunoffline.exe set-uid -n Name_of_Distro -v user_UID
```

# Keep 1080 port
```
netstat -aon | findstr "1080"
netsh interface ipv4 show excludedportrange protocol=tcp
netsh int ipv4 show dynamicport tcp
netsh int ipv4 set dynamic tcp start=49152 num=16384
# netsh int ipv4 add excludedportrange protocol=tcp startport=1080 numberofports=1
# restart
```

# See also

- [How to Uninstall Built-in UWP (APPX) Apps on Windows 10?](http://woshub.com/how-to-uninstall-modern-apps-in-windows-10/)
- [lukesampson/scoop - Github](https://github.com/lukesampson/scoop)
- [scoop](https://scoop.sh/)
- [Install WSL & update to WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Install and set up Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/get-started)
- [issues/3171 - Github](https://github.com/docker/for-win/issues/3171)
- [issues/1835 - Github](https://github.com/shadowsocks/shadowsocks-windows/issues/1835)

