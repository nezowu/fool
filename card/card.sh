#!/usr/bin/env bash
##Запишим в переменные ряды карт для одной масти. Через 16 цифр ряд повторяется для следующей масти
blak_card='\U1F0A0'
number_min=$(bc<<<"ibase=16;1F0A1")
number_min1=$(bc<<<"ibase=16;1F0A6")
number_min2=$(bc<<<"ibase=16;1F0AD")
#number_min=$(printf '%d' '0X1F0A7')
#number_min="$(printf '%b' '\U1F0A1')"
number_max1=$(bc<<<"ibase=16;1F0AB")
number_max2=$(bc<<<"ibase=16;1F0AE")
#echo -e "$number_min, $number_min1, $number_max1, and $number_min2, $number_max2"
#a=0
#for ((i=0; i<4; i++)); do
#	for y in $number_min $(seq $number_min1 $number_max1) $(seq $number_min2 $number_max2); do
#		arrvar[a]=$y
#		((a+=1))
#		eval echo '$y'
#	done
#done
##Запишим набор одной масти в асоциативный массив
z=1
declare -A monst
while read monst["num$z"]; do
	#monst[num$z]
	#echo ${monst["num$z"]}
	((z+=1))
done <<<"$number_min
$(seq $number_min1 $number_max1)
$(seq $number_min2 $number_max2)" 
unset monst["num$z"]
#echo ${!monst[@]}

##Создадим полный набор одной колоды и запишем в массив
declare -a arrvar
a=0
for ((i=0; i<4; i++)); do
	for y in ${!monst[@]}; do
		arrvar[$a]=${monst[$y]}
		((a+=1))
		((monst[$y]+=16))
	done
done
##выведем на экран все карты как есть в колоде
#echo ${arrvar[@]}
#echo ${#arrvar[@]}
#for pof in ${arrvar[@]}; do
#	echo -e "\U$(bc<<<"obase=16;$pof")"
#done
##Перемешаем колоду
declare -a shuf_card
s=0
for p in $(shuf -i 0-35); do
	shuf_card[p]=${arrvar[@]:s:1}
	((s+=1))
done
#echo ${shuf_card[@]}
#echo ${arrvar[@]:1:1}
printColor(){
	for tin in ${!1}; do
		if [[ $tin -gt 127150 && $tin -lt 127185 ]]; then
			tput setaf 1
			printf '%b ' "\U$(bc<<<"obase=16;$tin")"
			tput sgr0
		else
			printf '%b ' "\U$(bc<<<"obase=16;$tin")"
		fi
	done
}
printColor "shuf_card[@]"
tput setaf 4
echo -e '\U1F0A0'
tput sgr0
##раздаем карты в 3 поля(массива) но предусмотренно еще два "бой" и "полебоя"
declare -a headstaf
declare -a onestaf
declare -a twostaf
declare -a battlestaf
declare -a trashstaf


