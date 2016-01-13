#!/usr/bin/env bash
coproc nc -w 5 localhost $1
#sleep 2
#lisn(){
#	read -u ${COPROC[0]} HELL
#}
echo "Прифет нафаня" >&${COPROC[1]}
while read -u ${COPROC[0]} HELL; do
	echo $HELL >>mypipe.txt
done
echo "Досвиданья Нафаня" >&${COPROC[1]}
echo "До скорых встреч" >&${COPROC[1]}
echo "Че еще?" >&${COPROC[1]}
