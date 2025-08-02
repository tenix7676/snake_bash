#!/usr/bin/env bash
names=('One name' 'another word' 'third')
function list()
{
	for arg in "$@"
	do
		printf \'"${arg}"\''\n'
	done
}
#My snake game
#snake pos
#list of moves 0,1,2,3
#array that is appended to
#snake size
#
#'print' snake - set chars in map
#take tail pos
#take moves
#
#get all snake positions
#return head pos
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
		map[${i}]='`'
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
			out+=$(mapAt x y)
		done
		out+=\\n
	done
	printf "${out}"
}
function printMap()
{
	clear
	for ((y=0; y<map_height; ++y))
	do
		for ((x=0; x<map_width; ++x)) 
		do
			printf $(mapAt x y)
		done
		printf \\n
	done
}

echo ${#map[@]}
#list "${map[@]}"
showkey -a & >| input.txt
while :
do
	echo "Press [CTRL+C] to stop.."
	sleep 1
done
#hideCursor
#initializeMap
#printMap
#showCursor
