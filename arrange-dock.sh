#!/bin/bash

command=$(basename $0)

function arrangeDefaultDock {
    # set full path
    DOCKUTIL=$(which dockutil)

    # remove default apps 
    $DOCKUTIL --remove all --no-restart 

    # add items to dock
    $DOCKUTIL --add '/Applications/Google Chrome.app' --position 1 --no-restart
    $DOCKUTIL --add /System/Applications/Notes.app --position 2 --no-restart
    $DOCKUTIL --add /System/Applications/Photos.app --position 3 --no-restart
    $DOCKUTIL --add /System/Applications/Music.app --position 4 --no-restart
    $DOCKUTIL --add /System/Applications/Messages.app --position 5 --no-restart
    $DOCKUTIL --add /Applications/Slack.app --position 6 --no-restart
    $DOCKUTIL --add /Applications/1Password.app --position 7 --no-restart
    $DOCKUTIL --add '/Applications/Visual Studio Code.app' --before 'iTerm' --no-restart
    $DOCKUTIL --add /Applications/iTerm.app --before 'System Preferences' --no-restart 
    $DOCKUTIL --add '/Applications/System Preferences.app' --position end --no-restart

    $DOCKUTIL --add '/Applications' --view grid --display folder --sort name  --section others --position 1 --no-restart
    $DOCKUTIL --add '~/Downloads' --view list --display folder --sort dateadded --section others --position end
}

function main {

    # double check dockutil was installed previously
    if [[ -f $(which dockutil) ]]; then

        # call config function
        arrangeDefaultDock

        # remove dockutil. no longer neeeded
        brew uninstall dockutil

    else
        echo "ERROR: dockutil not installed, skipping dock setup..."
    fi

}

main
