#!/usr/bin/env bash

#this script is responsible for
#reading user input

trap "kill 0" SIGINT

function now()
{
	date +%s%3N
}


./snake_print.sh $$ &

key=
last_key=
wait_time=.1
while :
do
	start=$(now)
	if read -s -t $wait_time -n 1 key
	then
		end=$(($(now) - 10)) #-10ms to give some leeway
		echo "$key" >| input.txt
		last_key=$key
		delta_time=$(( (end - start) ))
		sleep $(echo "scale=3; $wait_time - $delta_time / 1000.0" | bc)
	else
		echo "$last_key" >| input.txt
	fi
done
