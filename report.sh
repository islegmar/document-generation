#!/bin/bash
# =============================================================

dOut=./tmp
fDst=out.odt

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
