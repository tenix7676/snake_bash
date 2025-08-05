#!/usr/bin/env bash

function now()
{
	date +%s%3N
}

input_pid=$1

function hideCursor()
{
	printf '\033[?25l'
}
function showCursor()
{
	printf '\033[?25h'
}

map_width=20
map_height=10
map_size=$(( map_width * map_height ))
declare -a map
function mapAt()
{
	#x, y, char
	if (( $# >= 3 ))
	then
		map[$2 * map_width + $1]="$3"
	else
		printf "${map[$2 * map_width + $1]}"
	fi
}
function initializeMap()
{
	for ((i=0; i<map_size; ++i))
	do
		map[${i}]='` '
	done
}


function printMapSlow()
{
	clear
	out=
	for ((y=0; y<map_height; ++y))
	do
		for ((x=0; x<map_width; ++x)) 
		do
			out+="$(mapAt x y)"
		done
		out+=\\n
	done
	printf "${out}"
}
function printMap()
{
	printf "\033[H"
	for ((y=0; y<map_height; ++y))
	do
		for ((x=0; x<map_width; ++x)) 
		do
			printf "$(mapAt x y)"
		done
		printf \\n
	done
}
key=
function readInput()
{
	key=$(< input.txt)
}
function gameOver()
{
	if ((apples == 1))
	then
		printf "\nYou lost but you ate $apples apple!\n"
	else
		printf "\nYou lost but you ate $apples apples!\n"
	fi
	sleep 1
	kill "$input_pid"
	showCursor
	exit
}

function topGet() {
    local arrayname=$1
    declare -n array=$arrayname
    echo "${array[${#array[@]} - 1]}"
}

function botGet() {
    local arrayname=$1
    declare -n array=$arrayname
    echo "${array[0]}"
}

function topAppend() {
    local arrayname=$1
    declare -n array=$arrayname
    array+=("$2")
}

function topRemove() {
    local arrayname=$1
    declare -n array=$arrayname
    unset 'array[${#array[@]} - 1]'
}

function botAppend() {
    local arrayname=$1
    declare -n array=$arrayname
    for ((i=${#array[@]}; i>=1; --i)); do
        array[i]="${array[i-1]}"
    done
    array[0]="$2"
}

function botRemove() {
    local arrayname=$1
    declare -n array=$arrayname
    for ((i=0; i < ${#array[@]} - 1; ++i)); do
        array[i]="${array[i+1]}"
    done
    unset 'array[${#array[@]} - 1]'
}


declare -a moves
declare -a snake_xs
declare -a snake_ys
snake_x=$((map_width / 2))
snake_y=$((map_height / 2))

apples=0
temp_i=0


function displaySnake()
{
	for ((i=0; (i < apples) ; ++i))
	do
		mapAt "${snake_xs[i]}" "${snake_ys[i]}" "$1"
	done
}


apple_x=$(( $RANDOM % map_width ))
apple_y=$(( $RANDOM % map_height ))
function updateSnake()
{

	((++temp_i))
	snake_vel_x=0
	snake_vel_y=0
	if [[ true ]]
	then
		if [[ $key == w ]] || [[ $key == k ]]
		then
			((snake_vel_y-=1))
		elif [[ $key == s ]] || [[ $key == j ]]
		then
			((snake_vel_y+=1))
		elif [[ $key == d ]] || [[ $key == l ]]
		then
			((snake_vel_x+=1))
		elif [[ $key == a ]] || [[ $key == h ]]
		then
			((snake_vel_x-=1))
		fi
	fi

	((snake_x += snake_vel_x))
	((snake_y += snake_vel_y))

	if [[ $prev_prev_snake_x == $snake_x ]] && [[ $prev_prev_snake_y == $snake_y ]] && (( $apples >= 1 ))
	then
		((snake_x -= snake_vel_x))
		((snake_x -= snake_vel_x))
		((snake_y -= snake_vel_y))
		((snake_y -= snake_vel_y))

	fi


	if (( $snake_y < 0 ))
	then
		gameOver
	fi
	if (( $snake_y >= $map_height ))
	then
		gameOver
	fi
	if (( $snake_x >= $map_width ))
	then
		gameOver
	fi
	if (( $snake_x < 0 ))
	then
		gameOver
	fi
	topAppend snake_xs $snake_x
	topAppend snake_ys $snake_y
	topAppend moves $key
	
	local apple='false'
	mapAt apple_x apple_y '()'

	if (( snake_x == apple_x )) && (( snake_y == apple_y ))
	then
		((apples+=1))
		apple='true'
		topAppend snake_xs $snake_x
		topAppend snake_ys $snake_y
		topAppend moves $key
		apple_x=$(( $RANDOM % map_width ))
		apple_y=$(( $RANDOM % map_height ))
	fi
	displaySnake '<>'

	if [[ "$(mapAt snake_x snake_y)" == "<>" ]] && [[ $apple == 'false' ]] 
	then
		gameOver
	fi
	mapAt snake_x snake_y '**'
	botRemove snake_xs 
	botRemove snake_ys 
	botRemove moves 

	prev_prev_snake_x=$prev_snake_x
	prev_prev_snake_y=$prev_snake_y
	prev_snake_x=$snake_x
	prev_snake_y=$snake_y
}


hideCursor
clear
while :
do
	start=$(now)
	initializeMap
	readInput
	updateSnake
	printMap
	end=$(now)
	delta_time=$((end - start))
	printf "fps: $(echo "scale=3; 1000.0 / $delta_time" | bc)"
	#100ms for each frame, 10 fps
	sleep_time=$((100 - delta_time))
	printf $sleep_time
	if ((sleep_time < 0))
	then
		sleep_time=0
	fi
	sleep $(echo "scale=3; ($sleep_time) / 1000.0" | bc)

done
showCursor
