#!/usr/bin/env bash

command=$(basename $0)
email=$(find "/Users/$USER/Library/Application Support/iCloud/Accounts" | grep '@' | awk -F'/' '{print $NF}')
email_hash=$(echo ${email} | md5)

function display_help { 
	echo "New macOS environment setup script" 
	echo "Usage: $0 [-c] [-e <email>] [-p {work|home}]"
    echo ""
    echo "Options:"
    echo "  -h, --help  Show this help message and exit."
    echo "  -c, --config-prefs     Set system preferences."
    echo "  -p, --profile {work|home}  Installation additional software defined in profiles folder."
}

## check user supplied parameters
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h | --help | ? | "")
            display_help
            exit 0
            ;;
        --profile)
            PROFILE=$2
            shift 2
            ;;
        --config-prefs)
            PREF=true
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

function main {
    sh install-software.sh --profile $PROFILE

    sh create-ssh.sh

    ## get rh46 dotfiles (private repo) if you're me
    if [ $email_hash == "8b0a81b8ee543657730b67074c08a332" ]; then
        git clone https://github.com/rh46/dotfiles.git $HOME/rh46/dotfiles
        sh $HOME/rh46/dotfiles/setup.sh
    fi


    # install custom OMZ plugins and themes
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"


    # install powerlines font. required for spaceship the zsh theme
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts && ./install.sh # install
    cd .. && rm -rf fonts # clean-up
}

main