#!/usr/bin/env bash
trap 'break' 2
echo -en "\e[?9h"
tput civis
#stty -icanon
for ((i=0; i<100; i++)); do
	#exec 6>&1
	#exec >/dev/null
	read -rsN 6 x
	#tput clear
	#string=$(od -b <<<$x)
	#mouse=$(expr $string : '.*\(1b 5b 4d .. .. ..\)')
	string=$(echo -n $x | hexdump -C | sed -n 's/.*1b 5b 4d.\(..\) \(..\) \(..\).*/\1\2\3/p')
	#exec 1>&6 6>&-
	echo "$string" #| tee -a textik.txt
	#unset string
done
echo -en "\e[?9l"
tput cvvis
#stty icanon
