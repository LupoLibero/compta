# -*- coding: utf-8 -*-

import argparse
import json

from weboob.core import Weboob
from weboob.capabilities.bank import CapBank

w = Weboob()
w.load_backends(CapBank)

#parser = argparse.ArgumentParser()
#parser.add_argument("backend")


lcl = w.get_backend('lcl')
a   = lcl.get_account(u'07643070496X')

account = {}
account['history']  = []
account['balance']  = str(a.balance)
account['currency'] = a.currency
try:
  account['coming'] = str(a.coming)
except TypeError:
  pass
for t in lcl.iter_history(a):
  transaction = {}
  for (key, value) in t.iter_fields():
    transaction[key] = str(value)
  account['history'].append(transaction)

print json.dumps(account)
