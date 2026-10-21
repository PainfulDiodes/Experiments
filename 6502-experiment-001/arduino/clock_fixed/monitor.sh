#!/usr/bin/env bash

# usage: ./monitor.sh <port>  e.g. ./monitor.sh /dev/cu.usbmodem1101
# arduino-cli board list shows which port is the Mega

# --raw to switch away from line mode
# --quiet to supress the printout of config after startup

arduino-cli monitor -p "$1" -c baudrate=115200 --raw --quiet
