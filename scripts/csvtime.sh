#!/bin/bash
# Format output from time for .csv file
# Usage: csvtime.sh FILENAME

sed '/user.*/,$d' "$1" | sed 's/real\t//g' | sed 's/m/,/g' | sed 's/s//g' | sed '/./,$!d'
