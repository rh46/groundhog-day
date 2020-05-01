# Groundhog Day
A script to prevent you from reliving the same macOS setup routine over and over again. :alarm_clock::repeat:

### Quick Start
No additional software or configuration needed. Just run the commands below with root permissions.
```sh
$ curl -L "https://github.com/rh46/groundhog-day/tarball/master" | tar -xz --strip-components=1
$ sudo bash setup.sh --install-software home --set-preferences
```

### Usage
```
New macOS environment setup script 
Usage: setup.sh [--profile {work|home}] [--set-prefs]

Options:
  --help  Show this help message and exit.
  --install-software {work|home}   Installation additional software for a given profile.
  --set-preferences Set system preferences.
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You might end up with something that doesn't work or a configuration you don't like.

### TODO
- [x] Command line arguments
- [x] Ability to skip home or work installions
- [x] Python packages and Ruby gems
- [x] Set perferences
- [x] Separate softeware, dotfiles, perferences
- [x] macOS Catalina and zsh
- [x] Python environment setup
- [ ] Security hardening functionality
