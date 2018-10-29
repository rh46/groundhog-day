# Groundhog Day
A script to prevent you from reliving the same macOS setup routine over and over again.

### Installation
No initial software or configuration needed. Just run the commands below. Make sure to replace `your_real_email_here` with your email address in the third command.
```sh
$ mkdir $HOME/groundhog-day && cd $HOME/groundhog-day
$ curl -L "https://github.com/rh46/groundhog-day/tarball/master" | tar -xz --strip-components=1
$ sed -i 's/your_email@example.com/your_real_email_here/g' setup.sh
$ sh setup.sh
```

### Caution
This script is intended for my personal use so be careful about using it without modification. You'll probably need up with something that either doesn't work or meet your needs if you just copy and paste.

### Acknowledgement
Most of this script was taken from this [hackernoon article](https://hackernoon.com/personal-macos-workspace-setup-adf61869cd79) by [Nenad Novaković](https://github.com/dvlden).