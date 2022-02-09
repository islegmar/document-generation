import lxml.etree as ET
import sys

xslt = ET.parse(sys.argv[1])
dom = ET.parse(sys.argv[2])
transform = ET.XSLT(xslt)
newdom = transform(dom, fData=ET.XSLT.strparam(sys.argv[3]))
print (newdom)
print (transform.error_log,file=sys.stderr)
