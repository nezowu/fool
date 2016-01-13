#!/usr/bin/env bash
IP=$1
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

##Перемешаем колоду
declare -a shuf_card
s=0
for p in $(shuf -i 0-35); do
	shuf_card[p]=${arrvar[@]:s:1}
	((s+=1))
done
printColor(){
	for tin in $@; do
		if [[ $tin -gt 127150 && $tin -lt 127185 ]]; then
			tput setaf 1
			printf '%b ' "\U$(bc<<<"obase=16;$tin")"
			tput sgr0
		else
			printf '%b ' "\U$(bc<<<"obase=16;$tin")"
		fi
	done
}

##раздаем карты в 2 поля(массива) но предусмотренно еще два "бой" и "полебоя"
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
tput clear
printHead(){
	battlestaf=(127150 127137)
	trashstaf=(1 5)
	tput civis
	#tput cnorm
	tput cup 2 1
	tput el
	printColor ${shuf_card[@]:0:1}
	if [[ ${#shuf_card[@]} -gt 1 ]]; then
		tput setaf 4
		printf '%b' "$black_card"
		tput sgr0
	fi
	tput cup 6 48
	tput el
	if [[ ${#trashstaf} -gt 0 ]]; then
		tput setaf 4
		printf '%b' "$black_card"
		tput sgr0
	tput cup 10 25
	tput el
	if [[ ${#battlestaf[@]} -gt 0 ]]; then
		printColor ${battlestaf[@]}
	fi

	fi
	tput cup 14 1
	tput el
	if [[ -z $IP ]]; then
		printColor ${onestaf[@]}
		tput cup 16 40
		tput el
		for ((i=0; i<${#twostaf[@]}; i++)); do
			tput setaf 4
			printf '%b ' "$black_card"
		done
		tput sgr0
	else
		for ((i=0; i<${#onestaf[@]}; i++)); do
			tput setaf 4
			printf '%b ' "$black_card"
		done
		tput sgr0
		tput cup 16 40
		tput el1
		printColor ${twostaf[@]}
	fi

}
printHead
sleep 2
tput cnorm
echo
exit
#array+=(six) добавить элемент в конец массива
#${intArray[@]:(-1)}
