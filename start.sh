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

brew install \
    zsh \
    ansible \

# Only add Homebrew to PATH in .zshrc if not already present
if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zshrc; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    echo "Added Homebrew to PATH in .zshrc"
else
    echo "Homebrew already in PATH in .zshrc"
fi

# remove all shortcuts in the dock
defaults write com.apple.dock persistent-apps -array
# restart dock
killall Dock

#delete garage band, freeform, imovie, pages, numbers, keynote
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/Freeform.app
sudo rm -rf /Applications/iMovie.app
sudo rm -rf /Applications/Pages.app
sudo rm -rf /Applications/Numbers.app
sudo rm -rf /Applications/Keynote.app

echo "########################################################"
echo "#### Done"
echo "########################################################"