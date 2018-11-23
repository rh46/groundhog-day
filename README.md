# Groundhog Day
A script to prevent you from reliving the same macOS setup routine over and over again.

### Installation
No initial software or configuration needed. Just run the commands below. Make sure to replace `email@exampe.com` with your email address in the third command.
```sh
$ mkdir $HOME/groundhog-day && cd $HOME/groundhog-day
$ curl -L "https://github.com/rh46/groundhog-day/tarball/master" | tar -xz --strip-components=1
$ sh setup.sh -e <email@exampe.com>
```

### Usage
```setup.sh [-h] -e <email> [-s {work|home}]
    
    Options:
      -h, --help      Show this help message and exit.
      -e, --email EMAIL     Email address to associate with SSH keys.
      -s, --skip-profile {work|home}  Skip installation of certain software
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You might end up with something that doesn't work or a configuration you don't like.

### Acknowledgement
Most of this script was taken from this [hackernoon article](https://hackernoon.com/personal-macos-workspace-setup-adf61869cd79) by [Nenad Novaković](https://github.com/dvlden). :bow: