#!/usr/bin/env bash

function now()
{
	date +%s%3N
}
	
echo Initializing input.sh >> input.txt

key=
last_key=
wait_time=.9
for i in {1..10}
do
	start=$(now)
	if read -t $wait_time -n 1 key
	then
		end=$(($(now) - 10)) #-10ms so that delta_time is never bigger than wait_time resulting in negative sleep time
		echo "$key" was pressed >> input.txt
		last_key=$key
		delta_time=$(( (end - start) ))
		echo $((delta_time )) >> input.txt
		sleep $(echo "scale=3; $wait_time - $delta_time / 1000.0" | bc)
	else
		echo nothing pressed last:"$last_key" >> input.txt
	fi
done
