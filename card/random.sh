#!/usr/bin/env bash
while [[ $nob != 0 ]]; do
	nob=$((RANDOM%36))
	echo $nob
done
