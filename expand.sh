#!/bin/bash
# =============================================================

if [ $# -eq 0 ]
then
  echo "Use : `basename $0` odt-file"
  exit 1
fi

dOut=./tmp
fSrc=$1

# Unzip
echo "Unzip $fSrc into $dOut ..."
[ -d $dOut ]  && rm -fR $dOut
[ ! -d $dOut ] && mkdir -p $dOut
unzip $fSrc -d $dOut >/dev/null
