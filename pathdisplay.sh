#!/bin/bash
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
 
totalLevel=1
cd $1
path=$PWD
 
#echo $path
 
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
                        ls -ld | awk ' {print "   Links: " $2 " Owner: " $3 " Group: " $4 " Size: " $5 " Modified: " $6, $7, $8}'
            fi
                        echo ""
            (( count++ ))
done
 
echo "totalLevel: $totalLevel"
 
lines=`tput lines`
tput cup $(( $lines-2 )) 0
echo "Valid commands: u(p) d(own) q(uit)"
 
tput cup $(( $currentLevel*2+1 )) 24
}           # end of displayPath()             
 
 
#key=
#while [ "$key" != "q" ]
#do
 
displayPath
read string
 
 
# tput cup $(( $totalLevel*2+1 )) 24
# echo -n ""
# read string
 
#done # end of while-loop
