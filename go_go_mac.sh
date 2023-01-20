#!/usr/bin/env bash

# Inspired by JoeJag's "How to go from zero to productive in 40 minutes on a brand new Mac" 
#   — https://code.joejag.com/2021/zero-to-working-developer-mac-in-40-minutes.html

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "mkdir -p ~/Projects"
mkdir -p "~/Projects"

echo "installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "brew install the Brewfile"
brew bundle install

echo "brew install wget for use through-out this script"
brew install wget

echo "installing node (via nvm)"
nvm install node
echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"

echo "Installing Java via Sdkman"
curl -s "https://get.sdkman.io" | bash
sdk install java 17.0.6-amzn
echo "java --version: $(java --version)"

echo "Setup Git"
wget -O ~/.gitconfig https://raw.githubusercontent.com/joejag/dotfiles/main/.gitconfig

#echo "making system modifications:"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
  "Address Book" \
  "Calendar" \
  "cfprefsd" \
  "Contacts" \
  "Dock" \
  "Finder" \
  "Mail" \
  "Messages" \
  "Photos" \
  "Safari" \
  "SystemUIServer" \
  "iCal"; do
  killall "${app}" &> /dev/null
done

echo "Bootstrap complete, uninstall wget"
brew uninstall wget

echo "Done. Note that some of these changes require a logout/restart to take effect."