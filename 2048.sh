#!/bin/zsh

arr=()

# colors - TODO
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; MAGENTA='\e[1;35m' ; CYAN='\e[1;36m' NOR='\e[m'

function printtable {
	help
	echo '-----------------------------'
	echo '|      |      |      |      |'
	printf "| %-4s | %-4s | %-4s | %-4s |\n" "$arr[1]" "$arr[2]" "$arr[3]" "$arr[4]"
	echo '|      |      |      |      |'
	echo '|------|------|------|------|'
	echo '|      |      |      |      |'
	printf "| %-4s | %-4s | %-4s | %-4s |\n" "$arr[5]" "$arr[6]" "$arr[7]" "$arr[8]"
	echo '|      |      |      |      |'
	echo '|------|------|------|------|'
	echo '|      |      |      |      |'
	printf "| %-4s | %-4s | %-4s | %-4s |\n" "$arr[9]" "$arr[10]" "$arr[11]" "$arr[12]"
	echo '|      |      |      |      |'
	echo '|------|------|------|------|'
	echo '|      |      |      |      |'
	printf "| %-4s | %-4s | %-4s | %-4s |\n" "$arr[13]" "$arr[14]" "$arr[15]" "$arr[16]"
	echo '|      |      |      |      |'
	echo '-----------------------------'
}

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

function help {
	echo "Exit: ctrl+c"
	echo "Controls: w/s/a/d"
}

clear
addrandom
addrandom
printtable

while true
do

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
			fi
		fi
	fi
fi

done

