#!/usr/bin/env bash
while true; do
	echo "Первый пошол $i"
	sleep 1
	((i+=1))
	trap i=$((i+100)) 19
	#Ctrl+c  3 Ctrl+\ (выход)
	#Ctrl+s (приостанока вывода на терминал)
	#Ctrl+q (продолжение вывода на терминал)
	#Ctrl+z (послать текущий процесс в bg)
	#Ctrl+c (убить текущий процесс)
	#ctrl+d (конец файла)(выход из терминала)
	#trap 'exit' 2
	#read -p "Пошел: " -s -n 1
	#echo "$REPLAY"
done
