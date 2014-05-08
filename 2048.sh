#!/bin/zsh
#
# author: mplonski / sokoli
# web: http://sokoli.pl
#
# license: GNU GPL v2
#

# table used for keeping values from game
arr=()

# colors - TODO
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; MAGENTA='\e[1;35m' ; CYAN='\e[1;36m' NOR='\e[m'

# prints table with values from game
function printtable {
	help
	echo ' -----------------------------'
	echo ' |      |      |      |      |'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$arr[1]" "$arr[2]" "$arr[3]" "$arr[4]"
	echo ' |      |      |      |      |'
	echo ' |------|------|------|------|'
	echo ' |      |      |      |      |'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$arr[5]" "$arr[6]" "$arr[7]" "$arr[8]"
	echo ' |      |      |      |      |'
	echo ' |------|------|------|------|'
	echo ' |      |      |      |      |'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$arr[9]" "$arr[10]" "$arr[11]" "$arr[12]"
	echo ' |      |      |      |      |'
	echo ' |------|------|------|------|'
	echo ' |      |      |      |      |'
	printf " | %-4s | %-4s | %-4s | %-4s |\n" "$arr[13]" "$arr[14]" "$arr[15]" "$arr[16]"
	echo ' |      |      |      |      |'
	echo ' -----------------------------'
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
	if [ "$k" = "0" ]
	then
		echo "You lost!"
		exit 0
	fi
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
				if [ "$arr[$t]" = "" ]; then
					arr[$t]="$arr[$((t+1))]"
					arr[$((t+1))]=""
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
                if [ "$arr[$t]" = "" ]; then
                    arr[$t]="$arr[$((t-1))]"
                    arr[$((t-1))]=""
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
				if [ "$arr[$t]" = "" ]; then
					arr[$t]="$arr[$((t+4))]"
					arr[$((t+4))]=""
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
                if [ "$arr[$t]" = "" ]; then
					arr[$t]="$arr[$((t-4))]"
                    arr[$((t-4))]=""
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
			if [ "$arr[$t]" = "$arr[$((t+1))]" ]; then
				if [ "$arr[$t]" != "" ]; then
					tmp=$arr[$t]
					arr[$t]=$((tmp*2))
					arr[$((t+1))]=""
				fi
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
            if [ "$arr[$t]" = "$arr[$((t-1))]" ]; then
                if [ "$arr[$t]" != "" ]; then
                    tmp=$arr[$t]
                    arr[$t]=$((tmp*2))
                    arr[$((t-1))]=""
                fi
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
            if [ "$arr[$t]" = "$arr[$((t+4))]" ]; then
                if [ "$arr[$t]" != "" ]; then
                    tmp=$arr[$t]
                    arr[$t]=$((tmp*2))
                    arr[$((t+4))]=""
                fi
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
            if [ "$arr[$t]" = "$arr[$((t-4))]" ]; then
                if [ "$arr[$t]" != "" ]; then
                    tmp=$arr[$t]
                    arr[$t]=$((tmp*2))
                    arr[$((t-4))]=""
                fi
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

	if [ "$key" = "w" ]
	then
		makeup
		clear
		addrandom
		printtable
	else
		if [ "$key" = "s" ]
		then
			makedown
			clear
			addrandom
			printtable
		else
			if [ "$key" = "a" ]
			then
				makeleft
				clear
				addrandom
				printtable
			else
				if [ "$key" = "d" ]
				then
					makeright
					clear
					addrandom
					printtable
				else
					if [ "$key" = "q" ]
					then
						exit 0
					fi
				fi
			fi
		fi
	fi

done

