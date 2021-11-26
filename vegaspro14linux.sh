#!/bin/bash
## This script will install a 64-bit version of Vegas Pro on Linux using Wine

# Variables
## This is useful for if you want to install a different version of 64-bit Vegas Pro. This is where you can easily change things without looking through the script.

PREFIX=~/.vegaspro14
SETUP="VEGAS_Pro_14_Edit_DLM_Etailer_Connect.exe" # Make sure this is the exact filename of the installer you plan to use
VEGASVER="VEGAS Pro 14.0" # CASE SENSITIVE! Needs to be exactly as branded! Magix brands Vegas all uppercase like VEGAS. Sony brands it like "Vegas". They should end in ".0"
VEGASEXE="vegas140.exe" # Change acordingly based on version of Vegas Pro
ROOTVEGASFILES="VEGAS" # Should be either "Sony" or "VEGAS". Versions 13 and older are "Sony". Versions 14 and newer are "VEGAS".

# Prevents this script from being run as root

if (( $EUID == 0 )); then
    echo "Please run this script as a normal user."
    echo "Running this script as root is a very bad idea."
    exit 1
fi

# Prevents this script from being run on non-64 bit systems (such as i386 or ARM)

if [ ! $(uname -m) = "x86_64" ]; then
    echo "This script is made for 64-bit systems only."
    echo "This system is not supported."
    exit 1
fi

# Make sure the user has the necessary prerequisites

function require_binary {
if ! [ -x "$(command -v "$1")" ]; then
    echo "The required executable '$1' is not installed."
    exit 1
fi
}

require_binary wine
require_binary winetricks
require_binary cabextract

function require_gnutls_arch {
if [ ! -f "/usr/lib32/libgnutls.so" ]; then
    echo "The required 32-bit binaries for 'gnutls' is not installed."
    exit 1
fi
}

function require_gnutls_deb {
if [ ! -f "/usr/lib/i386-linux-gnu/libgnutls.so.30" ]; then
    echo "The required 32-bit binaries for 'gnutls' is not installed."
    exit 1
fi
}

if [ -x "$(command -v "$pacman")" ]; then
    require_gnutls_arch
fi

if [ -x "$(command -v "$dpkg")" ]; then
    require_gnutls_deb
fi

if [ ! -f "./$SETUP" ]; then
    echo "$VEGASVER installation file not found."
    echo "Please place '$SETUP' in the same directory where this script is located then try again."
    exit 1
fi

# Creates a log folder for trouble shooting purposes

if [ ! -d "./logs" ]; then
    mkdir "./logs"
fi

# Detect the Wine prefix and ask user if they want to delete the prefix

function prefix_detect_and_ask {
if [ -d "$PREFIX" ]; then
    echo "Wine prefix ($PREFIX) has been detected."
    read -p "Delete this prefix and start fresh? (yes/no/cancel)" choice
    case "$choice" in 
        yes|YES|Yes ) echo "Deleting '$PREFIX'..." && rm -rf $PREFIX;;
        no|NO|No ) echo "Wine prefix will not be deleted.";;
        cancel|CANCEL|Cancel ) echo "Script aborted." && exit 1 ;; 
        * ) echo "Invalid Answer" && prefix_detect_and_ask;;
    esac
fi
}

prefix_detect_and_ask

# Wine prefix setup

if [ ! -d "$PREFIX" ]; then
    echo "Creating new Wine prefix..."
    WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree=d;mshtml=d" wineboot -u > ./logs/1-prefix-create.txt 2>&1
    echo "Created $PREFIX"
fi

# Components installation and setup process

echo "Installing components. Please wait..."
WINEPREFIX=$PREFIX winetricks "quartz" > ./logs/2-components-1.txt 2>&1

echo "Go through installation prompts to continue installing components."
WINEPREFIX=$PREFIX winetricks "vcrun2005" "vcrun2008" "vcrun2010" "vcrun2012" "vcrun2013" "vcrun2015" "dotnet20sp2" "dotnet40" "quicktime76" > ./logs/3-components-2.txt 2>&1

echo "Installing more components. This may take a while..."
WINEPREFIX=$PREFIX winetricks "corefonts" "d3dx10" "d3dx11_42" "d3dx11_43" "d3dx9" "directmusic" "directplay" "dsound" > ./logs/4-components-4.txt 2>&1

echo "Done!"

# Installing Vegas Pro

echo "Installing $VEGASVER..."
WINEPREFIX=$PREFIX wine "./$SETUP" > ./logs/5-vegas-setup.txt 2>&1

# For whenever the installer fails to do what it's supposed to do or if the user cancels the installer

if [ ! -f "$PREFIX/drive_c/Program Files/$ROOTVEGASFILES/$VEGASVER/$VEGASEXE" ]; then
    echo "Installation failed or aborted."
    echo "Check the log files for any errors."
    exit 1
fi

# FileIO startup crash or hang fix

rm "$PREFIX/drive_c/Program Files/$ROOTVEGASFILES/$VEGASVER/FileIOProxyStubx64.dll"

# Display message of completion

echo "Installation of $VEGASVER complete!"
