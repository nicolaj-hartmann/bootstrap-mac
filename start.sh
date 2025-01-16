# this is an initial bootstrap of a mac

# install homebrew if it not installed yet and if installed check for of brew (not apps but brew itself)
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

brew install zsh

# remove all shortcuts in the dock
defaults write com.apple.dock persistent-apps -array
# restart dock
killall Dock

# remove all zoom from the display
defaults -currentHost write com.apple.windowserver DisplayResolutionEnabled -bool false
# restart display
killall WindowServer
