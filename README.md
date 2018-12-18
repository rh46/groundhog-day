# Groundhog Day
A script to prevent you from reliving the same macOS setup routine over and over again.

### Installation
No additional software or configuration needed. Just run the commands below with root permissions.
```sh
$ mkdir $HOME/groundhog-day && cd $HOME/groundhog-day
$ curl -L "https://github.com/rh46/groundhog-day/tarball/master" | tar -xz --strip-components=1
$ sudo sh setup.sh -e you@example.com
```

### Usage
```
setup.sh [-e <email>] [-s {work|home}] [-u <github user>]
    
Options:
  -h, --help    Show this help message and exit.
  -e, --email <email>  Email address to associate with SSH keys.
  -p, --set-prefs   Set system preferences."
  -s, --skip-profile {work|home}    Skip installation of certain software.
  -u, --github-user <user>    Github username for dotfile.
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You might end up with something that doesn't work or a configuration you don't like.

### TODO
- [x] ~Command line arguments~
- [x] ~Ability to skip home or work installions~
- [x] ~Python packages and Ruby gems~
- [x] ~Set perferences~
- [ ] Security hardening functionality
- [ ] Separate softeware, dotfiles, perferences, and hardening