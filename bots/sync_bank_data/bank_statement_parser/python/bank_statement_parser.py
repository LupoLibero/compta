# -*- coding: utf-8 -*-

import re
import sys
import argparse

from pdftables.pdf_document import PDFDocument
from pdftables.pdftables import page_to_tables
from pdftables.config_parameters import ConfigParameters
from pdftables.display import to_string

parser = argparse.ArgumentParser()
parser.add_argument("filepath")
parser.add_argument("--fromword")
parser.add_argument("--toword")

args = parser.parse_args()

config = ConfigParameters(n_glyph_column_threshold=3,table_top_hint=args.fromword, table_bottom_hint=args.toword)

doc = PDFDocument.get_backend("pdfminer")(args.filepath)

for page_number, page in enumerate(doc.get_pages()):
  tables = page_to_tables(page, config)
  for table in tables:
    print to_string(table.data).encode('utf-8').replace('\n', '\\n')