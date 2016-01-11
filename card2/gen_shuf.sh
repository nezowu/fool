#!/usr/bin/env bash
#awk 'BEGIN {RS=" |\n"} !t[$0]++' <<<"$(for ((z=0; z<150; z++)); do echo  $((RANDOM%10)); done;)"
shuf -i 0-9
