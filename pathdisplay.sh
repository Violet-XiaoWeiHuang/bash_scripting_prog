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

cd $path		# go to the specified directory 
  	
while [ `pwd` != "/" ]
do
	cd ..
	(( totalLevel=totalLevel+1 ))
done

#echo $totalLevel
currentLevel=$totalLevel

clear
tput cup 0 0 

echo "Owner   Group   Other   Filename"
echo "-----   -----   -----   --------"
echo ""

for (( count = $totalLevel; count >= 1; count-- ))
do 
	for (( tmp = $count; tmp > 1; tmp-- ))
	do
		cd ..
	done
	
	perFormat=$( ls -ld `pwd` | sed 's/  */ /g' | cut -d ' ' -f1 )
	perFormat=$( echo $perFormat | sed 's/^d//' | sed 's/\.$//' | sed -r 's/(.)(.)(.)(.)(.)(.)(.)(.)(.)/\1 \2 \3   \4 \5 \6   \7 \8 \9  /' )

	dirFormat=$( ls -ld `pwd` | sed 's/  */ /g' | cut -d ' ' -f9  )
	dirFormat=$( echo $dirFormat | sed -r 's!^\/.*\/!!' | sed 's!/home!home!' )

	echo "$perFormat $dirFormat"
	echo ""

#	ls -ld `pwd` | sed 's/  */ /g' | cut -d ' ' -f1,9 | sed 's/^d//' | sed -r 's/(.)(.)(.)(.)(.)(.)(.)(.)(.)/\1 \2 \3   \4 \5 \6   \7 \8 \9  /'
	cd $path
done

lines=`tput lines`
tput cup $(( $lines-2 )) 0
echo "Valid commands: u(p) d(own) q(uit)"
echo ""

tput cup $(( $totalLevel*2 )) 24
echo -n ""
read string


