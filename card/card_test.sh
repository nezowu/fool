#!/usr/bin/env bash
num1=1
num2=2
num3=3
y=0
while [[ $y -lt 30 ]]; do
	for i in num1 num2 num3; do
		arvar[y]=${!i}
		((y+=1))
		(($i+=16))
	done
done
echo ${arvar[*]}
