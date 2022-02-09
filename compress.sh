#!/bin/bash

if [ $# -eq 0 ]
then
  echo "Use : `basename $0` final-odt-file"
  exit 1
fi

file=$1
[ -f $file ] && rm $file
cd tmp
zip -r - * 1> ../$file
# zip -r $file * >/dev/null
echo "File $file created!"
