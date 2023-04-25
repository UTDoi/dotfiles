#!/bin/bash -eu

setup_mac_os_config() {
  # General
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true && \
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  sudo nvram SystemAudioVolume=" "

  # Screencapture
  mkdir -p ~/ss
  defaults write com.apple.screencapture location ~/ss/
  defaults write com.apple.screencapture name ""
  defaults write com.apple.screencapture type jpg
  defaults write com.apple.screencapture "disable-shadow" -bool yes

  # Dock
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-time-modifier -int 0.1
  defaults write com.apple.Dock autohide-delay -float 0
  defaults write com.apple.dock magnification -bool false
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock show-process-indicators -bool true

  # Finder
  defaults write com.apple.finder NewWindowTarget -string "PfLo"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
  defaults write com.apple.Finder FXPreferredViewStyle Nlsv
  defaults write com.apple.finder AppleShowAllFiles -bool false
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # QuickTime
  defaults write com.apple.QuickTimePlayerX NSQuitAlwaysKeepsWindows -bool false

  # Keyboard
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write -g KeyRepeat -int 2
  defaults write -g InitialKeyRepeat -int 15
  keyboardid=$(ioreg -n IOHIDKeyboard -r | grep -E 'VendorID"|ProductID' | awk '{ print $4 }' | paste -s -d'-\n' -)'-0'
  defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboardid} -array '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer> <key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

  for app in \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
    killall "$app" &> /dev/null
  done
}
