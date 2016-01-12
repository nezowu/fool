#!/usr/bin/env bash
##Запишим в переменные ряды карт для одной масти. Через 16 цифр ряд повторяется для следующей масти
black_card='\U1F0A0'
number_min=$(bc<<<"ibase=16;1F0A1")
number_min1=$(bc<<<"ibase=16;1F0A6")
number_min2=$(bc<<<"ibase=16;1F0AD")
#number_min=$(printf '%d' '0X1F0A7')
#number_min="$(printf '%b' '\U1F0A1')"
number_max1=$(bc<<<"ibase=16;1F0AB")
number_max2=$(bc<<<"ibase=16;1F0AE")
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
			[[ -n $2 ]] && break
		else
			printf '%b ' "\U$(bc<<<"obase=16;$tin")"
			[[ -n $2 ]] && break
		fi
	done
#echo
}
#printColor "shuf_card[@]"
#echo
##раздаем карты в 3 поля(массива) но предусмотренно еще два "бой" и "полебоя"
#declare -a shuf_card
declare -a onestaf
declare -a twostaf
declare -a battlestaf
declare -a trashstaf

razdacha(){
	local p=0
	local s=0
	for ((i=35; i>23; i--)); do
		if [[ $[ $i%2 ] == 0 ]]; then
			onestaf[p]=${shuf_card[i]}
			((p+=1))
			unset shuf_card[i]
		else
			twostaf[s]=${shuf_card[i]}
			((s+=1))
			unset shuf_card[i]
		fi
	done
unset i
}
razdacha
#printColor "onestaf[@]"
#echo
printColor "twostaf[@]"
echo
printColor "shuf_card[@]"
echo
sleep 3
tput clear
printHead(){
	tput civis
	#tput cnorm
	tput cup 2 1
	tput el
	printColor "shuf_card[@]" 1
	if [[ ${#shuf_card[@]} -gt 1 ]]; then
		tput setaf 4
		printf '%b' "$black_card"
		tput sgr0
	fi
	tput cup 6 1
	tput el
	printColor "onestaf[@]"
}
printHead
sleep 2
tput cnorm
echo
exit
