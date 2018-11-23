#!/usr/bin/env bash

#TODO: separate functions for softeware, dotfiles, hardening
#TODO: allow options to skip home or work

display_help() { 
	echo "New macOS setup script" 
	echo "Usage: $0 [-h] -e <email> [-s {work|home}]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit."
    echo "  -e, --email EMAIL     Email address to associate with SSH keys."
    echo "  -s, --skip-profile {work|home}  Skip installation of certain software"
	}

## must have 
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

## check user supplied parameters
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h | --help)
            display_help
            exit 0
            ;;
        -e | --email)
            EMAIL=$2
            shift 2
            ;;
        -s | --skip-profile)
            if [$2="home"];then
                SKIP=$2
                shift 2
            fi
            ;;
        --) # end argument parsing
            shift
            break
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

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
    'kubernetes-cli'
    'mas'
    'terraform'
)

for f in "${formulas[@]}"; do
    brew install "$f"
done

## install casks
declare -a cask_apps=(
    'aerial'    # tvOS screensavers
    'google-chrome'
    'visual-studio-code'
    'docker'
    'minikube'
    'powershell'
    'virtualbox'
    'wireshark' #work
    'slack' # work
    'google-drive-file-stream'  # work
    'torbrowser'    # home
    'steam' # home
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

## set custom terminal.app
sh terminal/set-terminal

## create SSH key and configure auth
ssh-keygen -t rsa -b 4096 -C "${EMAIL} on ${HOSTNAME%.*}"
eval "$(ssh-agent -s)"  # start ssh agent
touch ~/.ssh/config # create ssh config file
cat <<EOT >> ~/.ssh/config
Host * 
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
EOT
ssh-add -K ~/.ssh/id_rsa    # add new key agent
echo "REMINDER: upload new ssh key to github profile. https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/"

## install vscode extentions
declare -a vscode_exts=(
    'ms-python.python'
    'ms-vscode.Go'
    'ms-vscode.PowerShell'
    'PeterJausovec.vscode-docker'
)

for ext in "${vscode_exts[@]}"; do
    code --install-extension "$ext"
done