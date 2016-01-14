#!/usr/bin/env bash

switch(){
	count=0
	if [[ $flag == 0 ]]; then
		flag=1
		STATUSSTR="Ход партнера"
	else
		flag=0
		STATUSSTR="Ваш ход"
	fi
	((count++))
}

if [[ $2 ]]; then
	coproc nc -w 5 $1 $2
	echo "one" >&${COPROC[1]}
	read -u ${COPROC[0]} STAT
else
	coproc nc -l -p $1
	read -u ${COPROC[0]} STAT 
	echo "two" >&${COPROC[1]}
fi

if [[ $STAT == "one" ]]; then
       	echo "Соединение установлено"
	STATUSSTR="Ваш ход"
	flag=0
elif [[ $STAT == "two" ]]; then
	echo "Соединение установлено"
	STATUSSTR="Ход партнера"
	flag=1
else
	echo "Выход"
	exit
fi
echo $STATUSSTR
switch
echo $STATUSSTR
echo $flag
echo $count
wait $COPROC_PID && echo "Соединение разорвано"
exit
