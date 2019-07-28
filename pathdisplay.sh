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