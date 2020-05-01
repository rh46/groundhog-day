#!/usr/bin/env bash

command=$(basename $0)
computername=$(scutil --get ComputerName)
user=${USER}

## create SSH key and configure auth
ssh-keygen -t rsa -b 4096 -C "${user} on ${computername}"
eval "$(ssh-agent -s)"  # start ssh agent
touch ~/.ssh/config # create ssh config file
cat <<EOT >> $HOME/.ssh/config
Host * 
AddKeysToAgent yes
UseKeychain yes
IdentityFile ~/.ssh/id_rsa
EOT

# add new key agent
ssh-add -K ~/.ssh/id_rsa

# upload ssh key to github
read -p "Enter Github username: " id
read -s -p "Enter Github API token: " token
echo "Writing ssh key to Github profile"
curl -u "$id:$token" --data '{"title":"'"${user} on ${computername}"'","key":"'"$(cat ~/.ssh/id_rsa.pub)"'"}' https://api.github.com/user/keys