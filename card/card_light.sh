#!/usr/bin/env bash
num1=127137
num2=127142
num3=127143
num4=127144
num5=127145
num6=127146
num7=127147
num8=127149
num9=127150
a=0
for ((i=0; i<4; i++)); do
	for y in num1 num2 num3 num4 num5 num6 num7 num8 num9; do
		arrvar[a]=${!y}
		((a+=1))
		(($y+=16))
	done
done
echo ${arrvar[@]}
echo ${#arrvar[@]}
echo '127198 - 127137'
#echo "$((RANDOM%62+127137))"
#declare -a rand
#c=0
while read -d' ' d; do
	while true; do
	b=$((RANDOM%36))
	if [[ ${!rand[@]} == "$b" ]]; then
		continue
	else
		rand[b]=$d
		#echo $d
		break
	fi
done
done <<<"${arrvar[@]} "
echo ${!rand[@]}
echo ${rand[@]}
