#!/usr/bin/env bash

#TODO: add arguments for home and work

## install homebrew
if [[ ! -f $(which brew) ]] # check is brew is installed first
then
    echo "Installing homebrew..."

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cleanup && brew upgrade && brew update && brew doctor

    echo "Completed..."
else
    echo "Skipping homebrew..."
fi

## homebrew should install xcode tools but just in case...
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
    xcode-select --install
fi

## install formulas
declare -a formulas=(
    'awscli'
    'bash-completion'
    'cloc'
    'go'
    'mas'
    'terraform'
)

for f in "${formulas[@]}"; do
    brew install "$f"
done

## install casks
#TODO: separate list for home and work
declare -a cask_apps=(
    'aerial'    # tvOS screensavers
    'google-chrome'
    'docker'
    'slack'
    'steam' # skip on work computers
    'powershell'
    'torbrowser'    # skip on work computers
    'virtualbox'
    'visual-studio-code'
    'wireshark'
)

for app in "${cask_apps[@]}"; do
    brew cask install "$app"
done

declare -a mas_apps=(
    '443987910'  # 1Password
)

for app in "${mas_apps[@]}"; do
    mas install "$app"
done

## get dotfiles
git clone https://github.com/rh46/.dotfiles.git $HOME/.dotfiles
sh $HOME/.dotfiles/setup.sh

## set custom terminal
sh terminal/set-terminal
