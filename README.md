# Groundhog Day
A script to prevent you from reliving the same macOS setup routine over and over again.

### Installation
No initial software or configuration needed. Just run the commands below.
```sh
$ mkdir $HOME/groundhog-day && cd $HOME/groundhog-day
$ curl -L "https://github.com/rh46/groundhog-day/tarball/master" | tar -xz --strip-components=1
$ sh setup.sh -e you@example.com
```

### Usage
```
setup.sh [-e <email>] [-s {work|home}] [-u <github user>]
    
Options:
  -h, --help    Show this help message and exit.
  -e, --email <email>   Email address to associate with SSH keys.
  -s, --skip-profile {work|home}    Skip installation of certain software.
  -u, --github-user <user>    Github username for dotfile.
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You might end up with something that doesn't work or a configuration you don't like.

### Acknowledgement
Most of this script was taken from this [hackernoon article](https://hackernoon.com/personal-macos-workspace-setup-adf61869cd79) by [Nenad Novaković](https://github.com/dvlden). :bow:

### TODO
- [x] ~Command line arguments~
- [x] ~Ability to skip home or work installions~
- [x] ~Python packages and Ruby gems~
- [ ] Hardening functionality
- [ ] Separate functions for softeware, dotfiles, and hardening