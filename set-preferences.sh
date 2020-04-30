#!/usr/bin/env bash

command=$(basename $0)

##### get sudo status
if [[ "$EUID" = 0 ]]; then
        SUDOER=true
else
        echo "Skipping preferneces that require sudo. Re-run with sudo to enable"
fi


##### launch chrome and make it the default broswer
if open -Ra "Google Chrome" ; then
        open -a "Google Chrome" --args --make-default-browser
        pkill -a -i "Google Chrome"
        # Disable too sensitive backswipe on trackpads in Chrome
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
        defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
else
        echo "ERROR: Google Chrome not installed, skipping setup..."
fi


##### dock, spaces, and touchbar
defaults write com.apple.dashboard mcx-disabled -boolean YES    # disable dashboard
defaults delete com.apple.dock && killall Dock    # reset defaults
defaults write com.apple.dock autohide -bool true   # enable autohide
defaults write com.apple.dock dashboard-in-overlay -bool true   # don't show dashboard as space
defaults write com.apple.dock mru-spaces -bool false    # do not automatically rearrange spaces on recent use
defaults write com.apple.dock show-recents -bool false # disable show recent applications in dock 
bash arrange-dock.sh    # call script to arrange dock items
killall Dock    # restart dock
defaults write ~/Library/Preferences/com.apple.controlstrip MiniCustomized '(com.apple.system.do-not-disturb, com.apple.system.volume, com.apple.system.mute, com.apple.system.mission-control)' # configure touchbar mini options
killall ControlStrip # restart touchbar


##### firewall
if [[ $SUDOER ]]; then
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on    # enable firewall
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned   # allow signed built-in applications automatically
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on    # enable stealth mode
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on    # enable log mode
        sudo pkill -HUP socketfilterfw  # apply changes
fi


##### security & privacy
defaults write com.apple.screensaver askForPassword -int 1  # ask for password on screensaver
defaults write com.apple.screensaver askForPasswordDelay -int 0 # no delay on password for screensaver
#defaults write com.apple.CrashReporter DialogType -string "none" # disable the crash reporter
if [[ $SUDOER ]]; then
        sudo spctl --master-enable  # enable gatekeeper
        sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false # disable guest account
fi


##### dns
networksetup -setdnsservers 1.1.1.1 9.9.9.9


##### auto updates
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true     # check for updates automatically
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1    # check for updates daily
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1    # auto-download updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1    # auto-install updates


##### finder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true    # no .DS files on network drives
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true    # no .DS files on usb drives
#defaults write com.apple.finder DisableAllAnimations -bool true # disable window animations and Get Info animations
defaults write com.apple.finder _FXSortFoldersFirst -bool true  # folders on top when sorting by name
defaults write com.apple.finder EmptyTrashSecurely -bool true   # secure trash empty by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"     # search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # disable warning when changing a file extension
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true  # show external drives on desktop
defaults write com.apple.finder ShowPathbar -bool true  # show path in finder window
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true  # show removeable media on desktop
defaults write NSGlobalDomain AppleShowAllExtensions -bool true # show all filename extensions
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true # prevent Photos from opening automatically
killall Finder  # restart finder


##### spotlight
defaults write com.apple.spotlight orderedItems -array \
        '{"enabled" = 1;"name" = "APPLICATIONS";}' \
        '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
        '{"enabled" = 1;"name" = "DIRECTORIES";}' \
        '{"enabled" = 0;"name" = "PDF";}' \
        '{"enabled" = 0;"name" = "FONTS";}' \
        '{"enabled" = 0;"name" = "DOCUMENTS";}' \
        '{"enabled" = 0;"name" = "MESSAGES";}' \
        '{"enabled" = 1;"name" = "CONTACT";}' \
        '{"enabled" = 0;"name" = "EVENT_TODO";}' \
        '{"enabled" = 0;"name" = "IMAGES";}' \
        '{"enabled" = 0;"name" = "BOOKMARKS";}' \
        '{"enabled" = 0;"name" = "MUSIC";}' \
        '{"enabled" = 0;"name" = "MOVIES";}' \
        '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
        '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
        '{"enabled" = 0;"name" = "SOURCE";}' \
        '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
        '{"enabled" = 0;"name" = "MENU_OTHER";}' \
        '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
        '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
        '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
        '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

killall mds > /dev/null 2>&1    # Load new settings before rebuilding the index
if [[ $SUDOER ]]; then
        sudo mdutil -E / > /dev/null    # Rebuild the index from scratch
fi


##### disable siri
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnable -bool true
defaults write com.apple.assistant.support 'Assistant Enabled' 0
# clear and lock siri analytics database which is created even if the siri launch agent disabled
#rm -rfv ~/Library/Assistant/SiriAnalytics.db
#chmod -R 000 ~/Library/Assistant/SiriAnalytics.db
#chflags -R uchg ~/Library/Assistant/SiriAnalytics.db


##### menu bar
defaults write com.apple.menuextra.clock IsAnalog -bool false   # view clock as digital
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false    # no flashing
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm a" # set date string like "Thu Dec 13  1:45 AM"
defaults write com.apple.menuextra.battery ShowPercent -bool true   # show battery percentage
defaults write com.apple.airplay showInMenuBarIfPresent -bool true      # show airplay options when available
defaults write com.apple.systemuiserver menuExtras -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
        "/System/Library/CoreServices/Menu Extras/Battery.menu" \
        "/System/Library/CoreServices/Menu Extras/Clock.menu" \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
        "/System/Library/CoreServices/Menu Extras/User.menu" \
        "/System/Library/CoreServices/Menu Extras/Displays.menu"


##### safari. copy pasta from https://github.com/mathiasbynens/dotfiles/blob/master/.macos

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true        # show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari HomePage -string "about:blank"  # set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false       # prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true     # allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari ShowFavoritesBar -bool false    # hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowSidebarInTopSites -bool false       # hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2       # disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true     # enable Safari’s debug menu
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false     # make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari ProxiesInBookmarksBar "()"      # eemove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true     # enable “Do Not Track”
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true # update extensions automatically
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true # warn about fraudulent websites
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true    # enable continuous spellchecking
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false       # disable auto-correct
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true  # add a context menu item for showing the Web Inspector in web views

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable AutoFill
#defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Disable auto-playing video
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false


##### NSGlobalDomain settings from https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Alway show scroll bars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"


##### other

defaults write com.apple.TextEdit RichText -int 0       # use plain text mode for new TextEdit documents
defaults write com.apple.terminal SecureKeyboardEntry -bool true        # enable Secure Keyboard Entry in Terminal.app
#defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false    # save to disk (not to iCloud) by default
defaults write com.apple.screencapture type -string "png"       # save screenshots in PNG format
defaults write com.apple.screencapture disable-shadow -bool true        # disable shadow in screenshots
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false # disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false # disable smart quotes as it’s annoying for messages that contain code
#defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false   # disable continuous spell checking

if [[ $SUDOER ]]; then
        # disable captive portal
        #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

        ##### apply changes
        sudo killall -HUP cfprefsd && killall SystemUIServer
fi