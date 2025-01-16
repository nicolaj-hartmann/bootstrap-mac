# this is an initial bootstrap of a mac

echo "########################################################"
echo "#### Checking for Homebrew and adding to PATH if needed"
echo "########################################################"

echo "Adding touchId sudo support"
sudo grep -Fxq "auth sufficient pam_tid.so" /etc/pam.d/sudo || sudo sed -i.bak '1s/^/auth sufficient pam_tid.so\n/' /etc/pam.d/sudo

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

# Add confsync alias to .zshrc
if ! grep -q "alias confsync=" ~/.zshrc; then
    echo "alias confsync='(cd ~/bootstrap-mac || git clone git@github.com:nicolaj-hartmann/bootstrap-mac.git ~/bootstrap-mac) && cd ~/bootstrap-mac && git pull && ansible-playbook setup.yml'" >> ~/.zshrc
    echo "Added confsync alias to .zshrc"
else
    echo "confsync alias already present in .zshrc"
fi

# remove all shortcuts in the dock
defaults write com.apple.dock persistent-apps -array
# restart dock
killall Dock

#delete garage band, freeform, imovie, pages, numbers, keynote But only do it if they dont exists so may make a list of app filenames to be deleted
apps_to_delete=("GarageBand" "Freeform" "iMovie" "Pages" "Numbers" "Keynote", "Chess")   
for app in "${apps_to_delete[@]}"; do
    if [[ -d "/Applications/$app.app" ]]; then
        echo "Deleting $app"
        sudo rm -rf "/Applications/$app.app"
    fi
done

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "oh my zsh installed"

echo "########################################################"
echo "#### Done"
echo "########################################################"
