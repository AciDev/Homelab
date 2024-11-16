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

own () {
    directory "$1"
    local directory_path="$folder_loc/$1"
    local user="$(stat -c %u "$directory_path")"
    local group="$(stat -c %g "$directory_path")"
    if [ "$user" -ne 1000 ] || [ "$group" -ne 1000 ]; then
        echo "Chowning 1000:1000 $1"
        chown 1000:1000 "$directory_path"
        changed=true
    fi
}

# Code goes here

echo "Setting up Grafana folders"
directory "Grafana/data"

echo "Setting up Prometheus folders"
directory "Prometheus/root"
directory "Prometheus/data"

echo "Setting up Influx DB folders"
directory "InfluxDB/etc"
directory "InfluxDB/data"

echo "Setting up Telegraf folders"
directory "Telegraf/data"

echo "Setting up Netdata folders"
directory "Netdata/lib"
directory "Netdata/cache"
directory "Netdata/config"

echo "Complete"
echo "$changed"
exit 0