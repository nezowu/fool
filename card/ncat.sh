#!/usr/bin/env bash
coproc nc -l -p $1
sleep 2
#echo "Привет бродягам" >&${COPROC[1]}
#lisn(){
#	read -u ${COPROC[0]} HELL
#	echo $HELL >>mypipe.txt
#}
while read -u ${COPROC[0]} HELL; do
	echo $HELL >>mypipe.txt
done
#lisn
echo "Ну привет" >&${COPROC[1]}
#lisn
echo "Отвали" >&${COPROC[1]}
sleep 60
