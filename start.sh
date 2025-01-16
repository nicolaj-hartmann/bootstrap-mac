# this is an initial bootstrap of a mac

echo "########################################################"
echo "#### Checking for Homebrew and adding to PATH if needed"
echo "########################################################"

# Check for Homebrew and add to PATH if needed
if [[ ! -f "/opt/homebrew/bin/brew" ]]; then
    echo "Homebrew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew found, updating..."
    brew update
fi

brew install zsh

# remove all shortcuts in the dock
defaults write com.apple.dock persistent-apps -array
# restart dock
killall Dock

# remove all zoom from the display and have 1:1 pixel density - by using more space for the display
defaults write com.apple.windowserver DisplayResolutionEnabled -bool true
# restart display
killall WindowServer
