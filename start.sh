ensure_line_in_file() {
  local line="$1"
  local file="$2"
  local prepend="$3"

  if ! grep -Fxq "$line" "$file"; then
    if [ "$prepend" = "true" ]; then
      sudo sed -i.bak "1s|^|$line\n|" "$file"
    else
      echo "$line" | sudo tee -a "$file" > /dev/null
    fi
  fi
}

# Define repository variables
REPO_URL="git@github.com:nicolaj-hartmann/bootstrap-mac.git"
REPO_PATH="$HOME/bootstrap-mac"

# Clone repository if it doesn't exist
if [ ! -d "$REPO_PATH" ]; then
    echo "Cloning bootstrap repository..."
    git clone "$REPO_URL" "$REPO_PATH"
    cd "$REPO_PATH" || exit 1
else
    echo "Bootstrap repository already exists"
    cd "$REPO_PATH" || exit 1
    git pull
fi

echo "########################################################"
echo "#### Checking for Homebrew and adding to PATH if needed"
echo "########################################################"

echo "Adding touchId sudo support"
ensure_line_in_file "auth sufficient pam_tid.so" "/etc/pam.d/sudo" true

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

# Simplified confsync alias
if ! grep -q "alias confsync=" ~/.zshrc; then
    echo "alias confsync='cd $REPO_PATH && git pull && ansible-playbook setup.yml'" >> ~/.zshrc
    echo "Added confsync alias to .zshrc"
else
    echo "confsync alias already present in .zshrc"
fi

# install oh my zsh
[ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ensure_line_in_file "source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zshrc" false

P10K_SOURCE="$HOME/.p10k.zsh"
P10K_TARGET="$REPO_PATH/resources/.p10k.zsh"

if [ -f "$P10K_TARGET" ]; then
    if [ -f "$P10K_SOURCE" ]; then
        echo "Removing existing p10k configuration symlink..."
        rm "$P10K_SOURCE"
    fi
    echo "Creating symlink for p10k configuration..."
    ln -s "$P10K_TARGET" "$P10K_SOURCE"
else
    echo "Warning: p10k configuration file not found in home directory $P10K_SOURCE"
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



echo "########################################################"
echo "#### Done"
echo "########################################################"