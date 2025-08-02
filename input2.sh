#!/usr/bin/env bash

./input.sh &

while : 
do
	wc -l input.txt
	sleep 0.5
done
