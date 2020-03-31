#!/usr/bin/env bash

## check user supplied parameters
PARAMS=""
while (( "$#" )); do
    case "$1" in
        --profile)
            PROFILE=$2
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

# creates array from profile files
function get_profile_values {
    local array_name=$(echo $1 | tr '[:upper:]' '[:lower:]') # make array name lower case
    local location=$(echo $1 | tr '[:lower:]' '[:upper:]') # make location upper case

    # put values from profiles/default into global array
    declare -a -g ${array_name}=( $(sed -n "/$location/{n;p;}" profiles/default) )

    case $PROFILE in
        # sed -n "/$location/{n;p;}" looks for $1 and returns the line below
        # example, $1=formulas so return line below FORMULAS in profiles/home where PROFILE=home
        home) ${array_name}+=( $(sed -n "/$location/{n;p;}" profiles/home) ) ;;
        work) ${array_name}+=( $(sed -n "/$location/{n;p;}" profiles/work) ) ;;
        *) ;;
    esac
}

function main {
    ## install homebrew
    if [[ ! -f $(which brew) ]]; then  # check is brew is installed first
        echo "Installing homebrew..."

        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        
        echo "Updating homebrew..."
        brew upgrade && brew update
        
        echo "Updating homebrew..."
        brew doctor && brew missing

        echo "#[Done]!"
    else
        echo "Skipping homebrew..."
    fi

    ## homebrew should install xcode tools but just in case...
    if [[ -f $(xcode-select -p &> /dev/null) ]]; then
        xcode-select --install
    fi

    ## install homebrew formulas
    get_profile_values formulas
    for f in "${formulas[@]}"; do
        #brew install "$f"
        echo "brew install $f" # for testing
    done

    ## install homebrew casks
    get_profile_values casks
    for c in "${casks[@]}"; do
        #brew cask install "$c"
        echo "brew cask install "$c"" # for testing
    done

    ## install mac apple store apps
    get_profile_values mas_apps
    for app in "${mas_apps[@]}"; do
        #mas install "$app"
        echo "mas install "$app"" # for testing
    done

    ## configure python and install packages
    latest=$(pyenv install --list | grep " 3\.*" | grep -v dev | tail -n1 | awk '{$1=$1;print}') # set latest to stable version
    #pyenv install $latest
    #pyenv global 
    get_profile_values pips
    for p in "${pips[@]}"; do
        #pip install "$p"
        echo "pip install "$p"" # for testing
    done

    ## install gems
    get_profile_values gems
    for g in "${gem[@]}"; do
        #gem install "$g"
        echo "gem install "$g"" # for testing
    done

    ## install vscode extentions
    get_profile_values vscode_exts
    for e in "${vscode_exts[@]}"; do
        #code --install-extension "$e"
        echo "code --install-extension "$e"" # for testing
    done
}

main