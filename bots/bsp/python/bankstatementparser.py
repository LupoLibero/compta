# -*- coding: utf-8 -*-

import re
import sys

from pdftables.pdf_document import PDFDocument
from pdftables.pdftables import page_to_tables
from pdftables.display import to_string


filepath = sys.argv[1]
#fileobj = open(filepath,'rb')


doc = PDFDocument.get_backend("pdfminer")(filepath)
#doc = PDFDocument.from_path(filepath)

for page_number, page in enumerate(doc.get_pages()):
  tables = page_to_tables(page)
  for table in tables:
    result = to_string(table.data).encode('utf-8')

print result

p = re.compile(r"(?P<date>\d\d\.\d\d)\s?"
  r"(?P<title>.+?)\s*"
  "(?P<exec_date>\d\d\.\d\d\.\d\d)?\s+"
  r"(?P<amount>[0-9 ,]+)\|$", re.M)
for line in result.split('\n'):
  #print line
  m = p.search(line)
  #if m:
  #  print "date", m.group('date')
  #  print "intitulé", m.group('title')
  #  print "date réelle", m.group('exec_date')
  #  print "montant", m.group('amount')
  #  print ""

#print result
