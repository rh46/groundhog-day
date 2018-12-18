#!/usr/bin/env bash

display_help() { 
	echo "New macOS setup script" 
	echo "Usage: $0 [-e <email>] [-s {work|home}] [-u <github user>]"
    echo ""
    echo "Options:"
    echo "  -h, --help  Show this help message and exit."
    echo "  -e, --email <email> Email address to associate with SSH keys."
    echo "  -p, --set-prefs     Set system preferences."
    echo "  -s, --skip-profile {work|home}  Skip installation of certain software."
    echo "  -u, --github-user <user>    Github username for dotfile."
}

## Variables
EMAIL=$USER
GUSER=""

## check user supplied parameters
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h | --help | ?)
            display_help
            exit 0
            ;;
        -e | --email)
            EMAIL=$2
            shift 2
            ;;
        -p | --set-prefs)
            PREF=true
            shift 2
            ;;
        -u | --github-user)
            GUSER=$2
            shift 2
            ;;
        -s | --skip-profile)
            SKIP=$2
            shift 2
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
if [[ ! -f $(which brew) ]]; then  # check is brew is installed first
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
    'python3'
    'terraform'
)

for f in "${formulas[@]}"; do
    brew install "$f"
done

## install casks
declare -a casks_core=(
    'aerial'    # tvOS screensavers
    'google-chrome'
    'visual-studio-code'
    'docker'
    'minikube'
    'powershell'
    'virtualbox'
)

declare -a casks_home=(
    'tor-browser'
    'steam'
)

declare -a casks_work=(
    'wireshark'
    'slack'
    'google-drive-file-stream'
)

case $SKIP in
    "")
        declare -a cask_apps=( ${casks_core[@]} ${casks_work[@]} ${casks_home[@]})
        ;;
    home)
        declare -a cask_apps=( ${casks_core[@]} ${casks_work[@]} )
        ;;
    work)
        declare -a cask_apps=( ${casks_core[@]} ${casks_home[@]} )
        ;;
esac

for app in "${cask_apps[@]}"; do
    brew cask install "$app"
done

## install mac apple store apps
declare -a mas_apps=(
    '443987910'  # 1Password
)

for app in "${mas_apps[@]}"; do
    mas install "$app"
done

## install python3 packages
declare -a pip3s=(
    'boto3'
    'PyGithub'
    'PyPDF2'
    'virtualenvwrapper'
)

for p in "${pip3s[@]}"; do
    pip3 install "$p"
done

## install gems
declare -a gems=(
    'aws-sdk'
    'aws_public_ips'
)

for g in "${gem[@]}"; do
    gem install "$g"
done

## get dotfiles
git clone https://github.com/rh46/.dotfiles.git $HOME/.dotfiles
sh $HOME/.dotfiles/setup.sh -u $GUSER

## set custom terminal.app
sh terminal/set-terminal

## set custom preferernces
if [[ $PREF = true ]]; then
    sh set-preferernces
fi

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

for e in "${vscode_exts[@]}"; do
    code --install-extension "$e"
done