#!/usr/bin/env bash
count=0
switch(){
	flag=$(((flag+1)%2))
	if [[ $flag == 0 ]]; then
		STATUSSTR="Ход партнера"
	else
		STATUSSTR="Ваш ход"
fi
}

if [[ $2 ]]; then
	coproc nc -w 5 $1 $2
	flag=$((RANDOM%2))
	echo "$flag" >&${COPROC[1]}
	read -u ${COPROC[0]} flagek
else
	coproc nc -l -p $1
	read -u ${COPROC[0]} flagek
	flag=$(((flagek+1)%2))
	echo "$flag" >&${COPROC[1]}
fi
[[ $flagek && $((flag+flagek)) == 1 ]] || exit
HEAD="\x6c\x69\x6e\x75\x78\x69\x6d\x2e\x72\x75\x0a"
echo -e $HEAD
echo "Соединение установлено"
if [[ $flag == 0 ]]; then
	STATUSSTR="Ход партнера"
else
	STATUSSTR="Ваш ход"
fi
echo $STATUSSTR
wait $COPROC_PID && echo "Соединение разорвано"
exit
