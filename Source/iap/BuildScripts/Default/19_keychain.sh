#!/bin/sh

echo Running script : `basename "$0"`

security unlock-keychain -p "SwatSwat!" "$HOME/Library/Keychains/login.keychain"
security default-keychain -s "$HOME/Library/Keychains/login.keychain"
