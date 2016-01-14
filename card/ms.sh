#!/usr/bin/env bash
trap 'break' SIGINT 
#_STTY=$(stty -g)
echo -en "\e[?9h" #включаем отслеживание мыши
stty -echo -icanon
while true; do  #главный цикл в котором все и происходит игровой процесс
	read -rn 6 x
	string="$(hexdump -C <<<$x)" #2>/dev/null #конвертируем кракозябки в данные из цифр
#	echo ${string:19:2} #делаем цифры понятными
#	CLICK=${string:19:2}
#	echo ${string:22:2}${string:25:3}
#	MOUSE=${string:22:2}${string:25:3}
#	X=$((16#${string:22:2}))
#	Y=$((16#${string:25:3}))
#	echo ${string:24:3}
	echo $string
done
echo -e "\e[?9l"
#stty "$_STTY"
stty echo icanon
exit
