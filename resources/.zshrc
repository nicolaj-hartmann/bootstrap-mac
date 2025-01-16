# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## ALIASES

export ZSH="$HOME/.oh-my-zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"

plugins=(git)

alias confsync='(cd ~/bootstrap-mac || git clone git@github.com:nicolaj-hartmann/bootstrap-mac.git ~/bootstrap-mac) && cd ~/bootstrap-mac && git pull && ansible-playbook setup.yml'
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
