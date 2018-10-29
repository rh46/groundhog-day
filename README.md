# Groundhog Day
A script for macOS that should prevent you from reliving the same setup routine over and over again.

### Installation
No initial software or configuration needed. Just paste this into a Terminal prompt and hit enter.
```sh
$ mkdir $HOME/groundhog-day && curl -L "https://github.com/rd46/groundhog-day/tarball/master" | tar -xz -C $HOME/groundhog-day --strip-components=1 && cd $HOME/groundhog-day && sh setup.sh
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You'll probably need up with something that doesn't meet your needs if you just copy and paste.

### Acknowledgement
Most of this script was taken from this [hackernoon article](https://hackernoon.com/personal-macos-workspace-setup-adf61869cd79) by [Nenad Novaković](https://github.com/dvlden).