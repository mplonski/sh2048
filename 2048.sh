#!/bin/zsh
#
# author: mplonski / sokoli
# web: http://sokoli.pl
# it's my first game in zsh, stay calm and fork / commit / pull request this repo :-)
#
# license: GNU GPL v2
#

# table used for keeping values from game
arr=()

# colors
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; MAGENTA='\e[1;35m' ; CYAN='\e[1;36m'; NOR='\e[m'; BOLD='\e[1m'

# print using colors
function cprint {
	case "$1" in
		'') printf "    "
			;;
		2) printf "${BOLD}  2 $NOR"
			;;
		4) printf "${CYAN}  4 $NOR"
			;;
		8) printf "${MAGENTA}  8 $NOR"
			;;
		16) printf "${BLUE} 16 $NOR"
			;;
		32) printf "${YELLOW} 32 $NOR"
			;;
		64) printf "${GREEN} 64 $NOR"
			;;
		*)  printf "${RED}%-4s$NOR" "$1"
			;;
	esac
}

# prints table with values from game
function printtable {
	help
	echo ' ┌──────┬──────┬──────┬──────┐'
	echo ' │      │      │      │      │'
	printf " | %4s │ %4s │ %4s │ %4s |\n" "$(cprint "$arr[1]")" "$(cprint "$arr[2]")" "$(cprint "$arr[3]")" "$(cprint "$arr[4]")"
	echo ' │      │      │      │      │'
	echo ' ├──────┼──────┼──────┼──────┤'
	echo ' │      │      │      │      │'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$(cprint "$arr[5]")" "$(cprint "$arr[6]")" "$(cprint "$arr[7]")" "$(cprint "$arr[8]")"
	echo ' │      │      │      │      │'
	echo ' ├──────┼──────┼──────┼──────┤'
	echo ' │      │      │      │      │'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$(cprint "$arr[9]")" "$(cprint "$arr[10]")" "$(cprint "$arr[11]")" "$(cprint "$arr[12]")"
	echo ' │      │      │      │      │'
	echo ' ├──────┼──────┼──────┼──────┤'
	echo ' │      │      │      │      │'
	printf " | %-4s | %-4s | %-4s │ %-4s │\n" "$(cprint "$arr[13]")" "$(cprint "$arr[14]")" "$(cprint "$arr[15]")" "$(cprint "$arr[16]")"
	echo ' │      │      │      │      │'
	echo ' └──────┴──────┴──────┴──────┙'
}

# checking if game is over
function checkiflost {
	k=0
	for i in {1..16}
	do
		if [ "$arr[i]" = '' ]; then
			(( k++ ))
		fi
	done
	if [ "$k" = "0" ]; then
		echo "You lost!"
		exit 0
	fi
}

# adds '2' in random place
function addrandom {
	k=0
	tmp=()
	for i in {1..16}
	do
		if [ "$arr[i]" = '' ]; then
			(( k++ ))
			tmp[$k]="$i"
		fi
	done
	ran=$[ $[ RANDOM % k ] + 1 ]
	arr[$tmp[$ran]]=2
}

# move data to the left
function moveleft {
	for s in {1..3}
	do
		for i in {0..3}
		do
			t1=$((4*i+1))
			for t in {$t1..$((t1+2))}
			do
				if [ "$arr[$t]" = "" ] && [ "$arr[$((t+1))]" != "" ]; then
					arr[$t]="$arr[$((t+1))]"
					arr[$((t+1))]=""
					moved=1
				fi
			done
		done
	done
}

# move data to the right
function moveright {
    for s in {1..3}
    do
        for i in {4..1}
        do
            t1=$((4*i))
            for t in {$t1..$((t1-2))}
            do
				if [ "$arr[$t]" = "" ] && [ "$arr[$((t-1))]" != "" ]; then
                    arr[$t]="$arr[$((t-1))]"
                    arr[$((t-1))]=""
					moved=1
                fi
            done
        done
    done
}

# move data up
function moveup {
	for s in {1..3}
	do
		for i in {1..4}
		do
			for t in "$i" "$((i+4))" "$((i+8))"
			do
				if [ "$arr[$t]" = "" ] && [ "$arr[$((t+4))]" != "" ]; then
					arr[$t]="$arr[$((t+4))]"
					arr[$((t+4))]=""
					moved=1
				fi
			done
		done
	done
}

# move data down
function movedown {
    for s in {1..3}
    do
        for i in {1..4}
        do
            for t in "$((i+12))" "$((i+8))" "$((i+4))"
            do
				if [ "$arr[$t]" = "" ] && [ "$arr[$((t-4))]" != "" ]; then
					arr[$t]="$arr[$((t-4))]"
                    arr[$((t-4))]=""
					moved=1
                fi
            done
        done
    done

}

# add matching values (to the left)
function makeleft {
	moveleft
	for i in {0..3}
	do
		t1=$((4*i+1))
		for t in {$t1..$((t1+2))}
		do
			if [ "$arr[$t]" = "$arr[$((t+1))]" ] && [ "$arr[$t]" != "" ]; then
				tmp=$arr[$t]
				arr[$t]=$((tmp*2))
				arr[$((t+1))]=""
				moved=1
			fi
		done
	done
	moveleft
}

# add matching values (to the right)
function makeright {
    moveright
    for i in {4..1}
    do
        t1=$((4*i))
        for t in {$t1..$((t1-2))}
        do
            if [ "$arr[$t]" = "$arr[$((t-1))]" ] && [ "$arr[$t]" != "" ]; then
				tmp=$arr[$t]
                arr[$t]=$((tmp*2))
                arr[$((t-1))]=""
				moved=1
            fi
        done
    done
    moveright
}

# add matching values (to the top)
function makeup {
    moveup
    for i in {1..4}
    do
        for t in "$i" "$((i+4))" "$((i+8))"
        do
            if [ "$arr[$t]" = "$arr[$((t+4))]" ] && [ "$arr[$t]" != "" ]; then
				tmp=$arr[$t]
                arr[$t]=$((tmp*2))
                arr[$((t+4))]=""
				moved=1
            fi
        done
    done
    moveup	
}

# add matching values (to the bottom)
function makedown {
    movedown
    for i in {1..4}
    do
        for t in "$((i+12))" "$((i+8))" "$((i+4))"
        do
            if [ "$arr[$t]" = "$arr[$((t-4))]" ] && [ "$arr[$t]" != "" ]; then
				tmp=$arr[$t]
                arr[$t]=$((tmp*2))
                arr[$((t-4))]=""
				moved=1
            fi
        done
    done
    movedown
}

# help :)
function help {
	echo "\n Hi, my name is sh2048!"
	echo " Exit: q"
	echo " Controls: w/s/a/d"
}

# clear console, set 2 random numbers, print table
clear
addrandom
addrandom
printtable

# have fun
while true
do
	# read 2 key
	read -sk key

	moved=0
	case "$key" in
		w)  makeup
			;;
		s)  makedown
			;;
		a)  makeleft
			;;
		d)  makeright
			;;
		q)  exit 0
			;;
	esac

	checkiflost
	# add new '2' only if there was any move!
	if [ $moved -eq 1 ]; then
		addrandom
	fi
	clear
	printtable

done

