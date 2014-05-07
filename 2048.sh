#!/bin/zsh

arr=()

function printtable {
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

addrandom
addrandom
printtable
makeright
printtable

