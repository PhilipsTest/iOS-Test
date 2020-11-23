#!/bin/bash

# Copyright (c) Koninklijke Philips N.V., 2016
# All rights are reserved. Reproduction or dissemination
# in whole or in part is prohibited without the prior written
# consent of the copyright holder.

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
blue=`tput setaf 4`

if [ "$EUID" -ne 0 ]
  then echo "${red}Please run as root${reset}"
  exit
fi

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
   test -d "${xpath}" && test -x "${xpath}" ; then
   echo "${green}Xcode is Installed${reset}"
else
   #... isn't correctly installed
   echo "${red}Error: Xcode-select command not found, please install Xcode command line tools using this command 'xcode-select --install' and try again${reset}"
   exit
fi

xcodeDirectory=${HOME}/Library/Developer/Xcode

if [ -d "${xcodeDirectory}" ] 
then
    installDirectory=${xcodeDirectory}/Templates/Philips/
    mkdir -p ${installDirectory}
else
    echo "${red}Error: Xcode Directory not found at path ${xcodeDirectory}. Please verify and try again${reset}"
    exit
fi

if [ -d "${installDirectory}" ]
then
	echo "${green}Philips UAPPTemplate will be installed to ${installDirectory}${reset}"
    cp -r Philips\ uApp.xctemplate "${installDirectory}"
else
    echo "${red}Error: Directory not found at path ${installDirectory}. Please verify and try again${reset}"
    exit
fi

echo "${green}Philips uApp template installation is successful${reset}"

echo "${blue}Restart Xcode in order to use the new Template${reset}"