#!/bin/bash

# =================================================
# Variables
# =================================================
silent=0
tmpFile=/tmp/$(basename $0).$$
dataDir="./docs"

dOut=./tmp
fDst=out.odt
fSrc=""
fXsl=""
fXml=""
dir=""

# fSrc=seed.web/list.odt
# fXsl=seed.web/list.xsl
# fXml=list.xml
# 
# fSrc=seed.web/tallySheet.odt
# fXsl=seed.web/tallySheet.xsl
# fXml=tallySheet.xml

fSrc=docs/tallySheet/report.odt
fXsl=docs/tallySheet/report.xsl
fXml=report.xml
#dir=~/projects/reportchangelog/repos

# =================================================
# Functions
# =================================================
function help() {
  cat<<EOF
NAME
       `basename $0` - Generates a report using a template in ODT + XML sith the data + XSL with the transforms

SYNOPSIS
       `basename $0` [-s] [-h] [-d dir]

DESCRIPTION
       INFO

       -s
              Silent mode

       -h
              Show this help

       -d dir
             Folder where are located the following files:
              - ODT : $dataDir/[dir]/report.odt
              - XML : $dataDir/[dir]/report.xml
              - XSL : $dataDir/[dir]/report.xsl
EOF
}

function trace() {
  [ $silent -eq 0 ] && echo $* >&2
}

# =================================================
# Arguments
# =================================================
while getopts "hsd:" opt
do
  case $opt in
    h)
      help
      exit 0
      ;;
    s) silent=1 ;;
    d) dir=$OPTARG ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $(( OPTIND - 1 ))

# --- Check Arguments
errors=""

[[ -z "$dir" ]] && errors="${errors}A folder must be specified. "

if [[ ! -z "$errors" ]]
then
  trace $errors
  exit 1
fi

# =================================================
# main
# =================================================
rm ${tmpFile}* 2>/dev/null

fSrc="$dataDir/$dir/report.odt"
fXsl="$dataDir/$dir/report.xsl"
fXml="report.xml"

# -----------------------------------------
# 1) Build tmplReport.odt with the text TMPL_IMG 
#    using tmplLandscape.odt
# -----------------------------------------
# Unzip
echo "Unzip $fSrc into $dOut ..."
[ -d $dOut ]  && rm -fR $dOut
[ ! -d $dOut ] && mkdir -p $dOut
unzip $fSrc -d $dOut >/dev/null

# Apply XSL
echo "Converting $dOut/content.xml ..."
mv $dOut/content.xml $dOut/content.xml.tmp
python3 xslt.py $fXsl $dOut/content.xml.tmp $fXml > $dOut/content.xml
rm $dOut/content.xml.tmp
#mv $dOut/content.xml.tmp .
#echo "Copied file content.xml.tmp"

# Zip
echo "Creating new file $fDst & cleanup ..."
[ -f $fDst ] && rm $fDst
# TODO - Can I zip without the cd? As in -C for tar
cd $dOut
zip -r - * 1> ../$fDst 2>/dev/null
cd ..
#rm -fR $dOut

echo "File $fDst created!"

rm ${tmpFile}* 2>/dev/null
