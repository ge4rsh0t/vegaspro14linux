#!/bin/bash
## This script will install a 64-bit version of Vegas Pro on Linux using Wine

# Prevents this script from being run as root

if (( $EUID == 0 )); then
    echo "Please run this script as a normal user."
    echo "Running this script as root is a very bad idea."
    exit
fi

# Creates a log folder for trouble shooting purposes

if [ ! -d "./logs" ]
then
    mkdir "./logs"
fi

# Variables
## This is useful for if you want to install a different version of 64-bit Vegas Pro. This is where you can easily change things without looking through the script.

PREFIX=~/.vegaspro14
SETUP="VEGAS_Pro_14_Edit_DLM_Etailer_Connect.exe" # Make sure this is the exact filename of the installer you plan to use
VEGASVER="VEGAS Pro 14.0" # CASE SENSITIVE! Needs to be exactly as branded! Magix brands Vegas all uppercase like VEGAS. Sony brands it like "Vegas". They should end in ".0"
VEGASEXE="vegas140.exe" # Change acordingly based on version of Vegas Pro
ROOTVEGASFILES="VEGAS" # Should be either "Sony" or "VEGAS". Versions 13 and older are "Sony". Versions 14 and newer are "VEGAS".

# Make sure the user has the necessary prerequisites

function require_binary {
if ! [ -x "$(command -v "$1")" ]; then
    echo "The required executable '$1' is not installed."
    exit 1
fi
}

require_binary wine
require_binary winetricks

if [ ! -f "/usr/lib32/libgnutls.so" ]
then
    echo "The required 32-bit binaries for 'gnutls' is not installed."
    exit 1
fi

if [ ! -f "./$SETUP" ]
then
    echo "$VEGASVER installation file not found."
    echo "Please place '$SETUP' in the same directory where this script is located then try again."
    exit 1
fi

# Wine prefix setup

echo "Creating new Wine prefix..."
WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree=d;mshtml=d" wineboot -u > ./logs/1-prefix-create.txt 2>&1
echo "Created $PREFIX"

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

if [ ! -f "$PREFIX/drive_c/Program Files/$ROOTVEGASFILES/$VEGASVER/$VEGASEXE" ]
then
    echo "Installation failed or aborted."
    echo "You may want to delete the Wine prefix ($PREFIX) before trying again."
    echo "Check the log files for any errors."
    exit 1
fi

# FileIO startup crash or hang fix

rm "$PREFIX/drive_c/Program Files/$ROOTVEGASFILES/$VEGASVER/FileIOProxyStubx64.dll"

# Display message of completion

echo "Installation of $VEGASVER complete!"
