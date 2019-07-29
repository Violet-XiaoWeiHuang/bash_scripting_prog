#!/bin/bash

if [ $# != 1 ]
then
	echo "Usage: pathdisplay [ dir-name ]" >&2 
	exit 1
elif [ ! -d "$1" ]
then
	echo "$1 is not a valid directory name" >&2
	exit 1
fi 

totalLevel=1
currentLevel=1
path=`cd $1 ; pwd`

#echo $path

cd $path                # go to the specified directory

while [ `pwd` != "/" ]
do
    cd ..
    (( totalLevel=totalLevel+1 ))
done

#echo $totalLevel
currentLevel=$totalLevel
