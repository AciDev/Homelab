#!/bin/bash

if [ $(id -u) -ne 0 ]; then 
    echo "Please run this script as root or using sudo!"
    exit 1
fi

unit="$(basename $PWD)"
folder_loc="./../Docker-data/$unit"
changed=false

directory () {
    local directory_path="$folder_loc/$1"
    if [ ! -d "$directory_path" ]; then
        echo "$1 does not exist."
        echo "Creating $1."
        mkdir -p $directory_path
        changed=true
    fi
}

# Code goes here

echo "Setting up Ntfy folders"
directory "Ntfy/data"
directory "Ntfy/cache"
chown 1000:1000 "$folder_loc/Ntfy/*"

echo "Complete"
echo "$changed"
exit 0