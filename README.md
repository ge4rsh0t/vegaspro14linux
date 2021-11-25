# VEGAS Pro 14 for Linux
![Vegas Pro 14 running on Linux](https://i.imgur.com/afIPpAy.png)
This is a bash script made for easy installation of VEGAS Pro 14.0 on GNU/Linux operating systems using Wine and Winetricks. Primarily, this is made for VEGAS Pro 14 but this script can also be modified to install other versions of Vegas Pro as long as it's made around the same decade as 14.

This script has been tested on Arch Linux but it should probably work with most distros. Other Unix-like operating systems such as BSD are not tested and may require some modification (paricularly the gnutls part).

Steam version of VEGAS Pro 14.0 is not supported.
## Prequisites
You will need the following packages to run this script:
- wine
- winetricks
- gnutls (32-bit version)

You are also expected to provide your own executable installer file as this is copyrighted software and I am not authorized to redistribute it. For the sake of accessibiltiy, the downloader executable "VEGAS_Pro_14_Edit_DLM_Etailer_Connect.exe" is used but you can modify the `SETUP=` variable to use a different installer if you desire to do that.
### Arch Linux and it's derivatives (Manjaro, EndeavoursOS, Artix Linux, etc.)
Acquiring the prerequisites can by done by this executing this command:
```
sudo pacman -S wine winetricks lib32-gnutls
```
You will need to have the "multilib" repository enabled since it is disabled by default.
### Debian, Ubuntu, and it's derivatives (Linux Mint, Pop_OS!, MXLinux, etc.)
Debian based distros has an outdated version of Wine and winetricks in their repositories and it's highly recommended to acquire the latest versions.
- Wine for Ubuntu: https://wiki.winehq.org/Ubuntu
- Wine for Debian: https://wiki.winehq.org/Debian
- winetricks: https://github.com/Winetricks/winetricks

As for gnutls, they are usually pre-installed on Ubuntu and Debian but if they aren't, they can be aquired by executing this command:
```
sudo apt-get install gnutls-bin
```

## Variables
There are five variables that can be easily modified to suit whatever needs it may be when it comes to installing Vegas Pro:
- `PREFIX` - This is the name of the Wine prefix. It's not crucial to change this even if using a different version of Vegas Pro as long as there isn't already the prefix made with Vegas already installed.
- `SETUP` - This is the filename of the installer that would be used within the same folder as the script. This can be easily changed to whatever other installer desired whether it is an offline installer for VEGAS Pro 14 or an installer for a different version of Vegas Pro.
- `VEGASVER` - Needs to be exactly as branded. Magix brands Vegas all uppercase like "VEGAS". Sony brands it like "Vegas". They should end in ".0". Like "VEGAS Pro 14.0" or "Vegas Pro 12.0".
- `VEGASEXE` - The executable file for running the main program. Different versions are similar to each other like "vegas140.exe", "vegas120.exe", and "vegas150.exe" as examples.
- `ROOTVEGASFILES` - The name of the root folder for different versions of Vegas Pro located in Program Files of the "C:" directory. Version 13 and older is "Sony". Version 14 and newer is "VEGAS".

## Tutorials
### Basic Installation
This installation method is where if you do not modify the script:

1. Clone the repostory by this command:
```
git clone https://github.com/ge4rsh0t/vegaspro14linux.git
```
2. Download your MAGIX Downloader and Installer for your copy of VEGAS Pro 14 then place the executable it in the "vegaspro14linux" directory.

3. Ensure that the script is executable by performing this command:
```
chmod +x vegaspro14linux.sh
```
4. Run the script:
```
./vegaspro14linux.sh
```
5. Follow on screen instructions and go through installation wizards. Make sure you don't install QuickTime with automatic updates enabled. Wait for a little while after the QuickTime installer.

6. When the MAGIX downloader launches, make sure you only have "VEGAS Pro 14.0" checked and leave other options unchecked. Then proceed to install VEGAS Pro 14.0.

7. If all goes well, you should see the message in your terminal say `Installation of VEGAS Pro 14.0 complete!`. Activate and launch Vegas for the first time.

### Installing for PlayOnLinux
For added stability to keep Vegas Pro from getting new bugs as Wine gets updated (or to simply avoid those annoying Wine configuration window as you start up Vegas after a Wine update), you can install Vegas Pro 14 for a PlayOnLinux drive that uses a static version of Wine.

Modify the `PREFIX` variable and have it install inside the "PlayOnLinux's virtual drives" folder then run the script using your terminal (Do not use the "Open a shell" option in PlayOnLinux). It should look something like this when you modify the script:
```
PREFIX=~/PlayOnLinux's virtual drives/vegaspro14
```
You can also execute the script with the default `PREFIX` variable but you would have to move the ".vegaspro14" directory found in your Home over into "PlayOnLinux's virtual drives" directory.

After that, go into your PlayOnLinux's configuration window and you should see that the virtual drive has already been added. You can then change the Wine version to a static version of Wine. Then you make a new Shortcut for Vegas Pro 14 selecting vegas140.exe for easy access.

### Installing OFX Plugins

Assuming you did the basic installation method without modifying the variables, simply navigate to the location of the installer for your OFX Plugin then execute it with the `WINEPREFIX=~/.vegaspro14` envrionment variable before the `wine` command. Like this:
```
WINEPREFIX=~/.vegaspro14 wine OFX-Installer.exe
```
If you intend on installing multiple plugins, you can type in the `export` command for the `WINEPREFIX` enviornment variable for your Terminal session to make it last until you close it like this:
```
export WINEPREFIX=~/.vegaspro14
```
Then you simply run OFX installers with just `wine` without the need to type in the prefix everytime until you close your Terminal session.

## Known Issues

*NOTE: This is about issues related to Vegas Pro running on Wine. If there are issues with the script, then you need to refer to the issues tab for this repository.*

Wine isn't perfect so there are certain things on VEGAS Pro 14 that doesn't work or work as well as it does on Windows. These such things include:
- Inability to import and render WMV files
- Inability to import and render MOV/M4A files (despite QuickTime being installed)
- MP3 files don't work (use WAV or FLAC files instead)
- Icons above the video preview disappear until you hover your mouse over them sometimes
- Rendering may not be as stable as on Windows (you may need to render in pieces, then combine them together either in VEGAS, in a different video editor like Kdenlive, or by command line tools such as cat and ffmpeg)
