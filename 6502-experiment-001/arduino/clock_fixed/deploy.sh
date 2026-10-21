#!/usr/bin/env bash

# usage: ./deploy.sh <port>  e.g. ./deploy.sh /dev/cu.usbmodem1101
# arduino-cli board list shows which port is the Mega

arduino-cli upload --fqbn arduino:avr:mega -p "$1" --input-dir sketch-build sketch
