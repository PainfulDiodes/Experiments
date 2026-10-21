#!/usr/bin/env bash

cl65 -t none -l main.lst -o main.bin main.s && hexdump -C main.bin > main.hex
