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
function get_install_list {
    local list_name=$(echo $1 | tr '[:upper:]' '[:lower:]') # make input lower case
    
    case $list_name in
        # set type based on input
        formulas) local type="formula" ;;
        casks) local type="cask" ;;
        mas_apps) local type="mas" ;;
        pips) local type="pip" ;;
        gems) local type="gem" ;;
        vscode_exts) local type="vscode" ;;
        *) ;;
    esac

    # put default software from apps.csv into array
    local software=( $(awk -F ',' -v type=$type '{ if ($2 == type && $3 == "default") print $1 }' apps.csv) )

    case $PROFILE in
        # get list of software for selected profile
        home) software+=( $(awk -F ',' -v type=$type '{ if ($2 == type && $3 == "home") print $1 }' apps.csv) ) ;;
        work) software+=( $(awk -F ',' -v type=$type '{ if ($2 == type && $3 == "work") print $1 }' apps.csv) ) ;;
        *) ;;
    esac

    # print list
    echo ${software[@]}
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
    for f in $(get_install_list formulas); do
        #brew install "$f"
        echo "brew install $f" # for testing
    done

    ## install homebrew casks
    for c in $(get_install_list casks); do
        #brew cask install "$c"
        echo "brew cask install "$c"" # for testing
    done

    ## install mac apple store apps
    for a in $(get_install_list mas_apps); do
        #mas install "$a"
        echo "mas install "$a"" # for testing
    done

    ## configure python and install packages
    latest=$(pyenv install --list | grep " 3\.*" | grep -v dev | tail -n1 | awk '{$1=$1;print}') # set latest to stable version
    #pyenv install $latest
    #pyenv global 
    for p in $(get_install_list pips); do
        #pip install "$p"
        echo "pip install "$p"" # for testing
    done

    ## install gems
    for g in $(get_install_list gems); do
        #gem install "$g"
        echo "gem install "$g"" # for testing
    done

    ## install vscode extentions
    for e in $(get_install_list vscode_exts); do
        #code --install-extension "$e"
        echo "code --install-extension "$e"" # for testing
    done
}

main