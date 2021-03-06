#!/bin/bash

# Assignment 1
# Course:                UNX510
# Family Name:           Huang
# Given Name:            Xiaowei
# Student Number:        133-717-165
# Login name:            xhuang110
# Professor:             Les Czegel
# Due Date:              August 2, 2019
#
# I declare that the attached assignment is my own work in accordance with
# Seneca Academic Policy.  No part of this assignment has been copied manually
# or electronically from any other source (including web sites) or distributed
# to other students.

if [[ $# > 1 ]]
then
	 echo "Usage: pathdisplay [ dir-name ]" >&2 
         exit 1
fi
            
if [ ! -d $1 ]
then
            echo "$1 is not a valid directory name" >&2
            exit 1
fi
 
if [[ $# = 0 ]]
then
	path=$PWD
else 
	cd $1
	path=$PWD
fi

totalLevel=1
while [ $PWD != "/" ]
do
            totalLevel=$(( $totalLevel + 1 ))
            cd ..
done
 
currentLevel=$totalLevel
 
displayPath(){
clear
 
echo "Owner   Group   Other   Filename"
echo "-----   -----   -----   --------"
echo ""
 
cd $path	# go to the specified directory 
count=1		# compare to the currentLevel to deplay the extra infor or nor
 
for dir in / $(pwd | tr '/' ' ')
do
            cd $dir             # get access to specified dir
            
            perFormat=$( ls -ld `pwd` | sed 's/  */ /g' | cut -d ' ' -f1 )
            perFormat=$( echo $perFormat | sed 's/^d//' | sed 's/\.$//' | sed -r 's/(.)(.)(.)(.)(.)(.)(.)(.)(.)/\1 \2 \3   \4 \5 \6   \7 \8 \9   /' )
            
            echo "${perFormat}$dir"
            
            if [ $count = $currentLevel ]
            then
		    ls -ld | awk '{printf "  Links: %s  Owner: %s  Group: %s  Size: %s  Modified: %s %s %s\n", $2, $3, $4, $5, $6, $7, $8}'
		   #ls -ld | awk '{print "   Links: " $2 " Owner: " $3 " Group: " $4 " Size: " $5 " Modified: " $6, $7, $8}'
	    else
                        echo
	    fi    
	    (( count++ ))
done
 
lines=`tput lines`
tput cup $(( $lines-2 )) 0
echo "Valid commands: u(p) d(own) q(uit)"
 
tput cup $(( $currentLevel*2+1 )) 24
}           # end of displayPath()             
 
oldsettings=$(stty -g)
stty -icanon min 1 time 0 -icrnl -echo
key=
while [ "$key" != "q" ]
do
	displayPath
	key=$(dd bs=3 count=1 2> /dev/null)	
	if [[ "$key" = "u" && $currentLevel > 1 ]]
	then
		(( currentLevel-- ))
		tput cuu 2
	elif [[ "$key" = "d" && $currentLevel < $totalLevel ]]
	then
		(( currentLevel++ ))
		tput cud 2
	fi
 
done	# end of while-loop

tput cup $lines 0
stty $oldsettings
