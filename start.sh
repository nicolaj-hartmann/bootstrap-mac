# this is an initial bootstrap of a mac

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install zsh

# remove all shortcuts in the dock
defaults write com.apple.dock persistent-apps -array
# restart dock
killall Dock

# remove all zoom from the display
defaults -currentHost write com.apple.windowserver DisplayResolutionEnabled -bool false
# restart display
killall WindowServer
