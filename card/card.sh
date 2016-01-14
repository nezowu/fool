#!/usr/bin/env bash
IP=$2
flag=0 #переключатель хода
#switch(){
	(( flag )) && ((flag--)) || ((flag++))
#}

#if [[ ! $IP ]]; then
#	coproc nc -l -p 3333
	#[[ $? ]] && exit
#else
#	coproc nc $1 3333
	#[[ $? ]] && exit
#fi
tput civis
stty -icanon
#Ставим переключатель и делаем рабочим следующий код для первого игрока с меткой flag=0 или 1 параметром

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
#Здесь заканчивается переключатель и посылоются готовые массивы для отрисовки партнеру
tput clear
battlestaf=(127150 127137)
printHead(){
	trashstaf=(1 5)
	#tput civis
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
		tput cup 16 30
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
		tput cup 16 30
		tput el
		printColor ${twostaf[@]}
	fi
	#Здесь блок кода для вывода строки статуса STATUSSTR по переключателю переход хода
}
printHead
echo # Cледующий блок кода доступен играющему, ждущий зависает на команде read через пайпы по своему флагу
# и следующий участок кода переключается просто пока не считает все присланные изменения
# начнет игру когода получит массивы и отрисует из на экране может стоит отслеживание мышы поднять
echo -en "\e[?9h" #включаем отслеживание мыши
while true; do  #главный цикл в котором все и происходит игровой процесс
	read -rsn 6 x
	string="$(hexdump -C <<<$x)" #конвертируем кракозябки в данные из цифр
	#echo ${string:19:2}
	CLICK=${string:19:2}
	#echo ${string:22:2}${string:25:3}
	MOUSE=${string:22:2}${string:25:3}
	X=$((16#${string:22:2}))
	Y=$((16#${string:25:3}))
	if [[ $(($X%2)) == 0 ]]; then #карта состоит из двух столбцов объединим это 
		ZNAK=$((($X-33)/2))
		#echo $ZNAK
	else
		ZNAK=$((($X-34)/2))
	fi
	#echo ${string:24:3}
	#echo -e "$CLICK\n$MOUSE" >>mouse.txt #здесь мы записывали координаты на стадии отладки
	#выходим из игры по нажатии СКМ
	#Сравниваем battlestaf < 11 или не нажата ли правая клавиша на батлстаф - переход хода
	# или забрал если игрок под номером 2 и отправка к блоку набора карт
	#правой кнопкой мыши на любую из карт на поле боя
	[[ $CLICK == 21 ]] && break
	if [[ $CLICK == 20 && $Y == 47 ]]; then #назначаем действиям для мыши действия
		#if [[ $(($X%2)) == 0 ]]; then #нужно вынести высше 164 строчки
		#	ZNAK=$((($X-33)/2))
		#	echo $ZNAK
		#else
		#	ZNAK=$((($X-34)/2))
		#fi
		[[ ${onestaf[ZNAK]} ]] || continue
		battlestaf+=(${onestaf[ZNAK]})
		unset onestaf[ZNAK]
		onestaf_tmp=(${onestaf[@]})
		unset onestaf[@]
		onestaf=(${onestaf_tmp[@]})
		unset onestaf_tmp
		#printHead
		#echo "hi" >&${COPROC[1]}
		#read -u ${COPROC[0]} HELL
		#echo $HELL
		printHead
	#elif [[ battlestaf[ZNAK]
	else
		echo "Че за хрень?"
	fi
	#Переключаем право хода
	#Здесь отправляем рабочие массивы от действующего игрока к ожидающему
	#Cчетчик цикла должен изменится
done
echo -en "\e[?9l"
stty icanon
#По идее можно поставить ожидание coproc_pid
tput cvvis
#tput cnorm
