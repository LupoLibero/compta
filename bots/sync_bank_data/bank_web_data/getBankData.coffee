nodePath    = require 'path'

PythonShell = require('python-shell')

parseDate = (dateString, scheme, startDate) ->
  parts = dateString.split('.')
  if parts.length > 2
    year = parts[2]
    if year.length == 2
      year = "20" + year
  else
    year =
      if startDate?
        startDate.getFullYear()
      else
        new Date().getFullYear()
  return new Date(year, (parts[1] - 1), parts[0])

obj = '{"history": [{"category": "PRLV", "vdate": "2015-02-16", "label": "SEPA OVH SAS", "raw": "PRLV SEPA OVH SAS", "amount": "-1.19", "rdate": "2015-02-16", "date": "2015-02-16", "type": "2", "id": ""}, {"category": "PRLV", "vdate": "2015-02-11", "label": "SEPA ECL GROUPE", "raw": "PRLV SEPA ECL GROUPE", "amount": "-133.53", "rdate": "2015-02-11", "date": "2015-02-11", "type": "2", "id": ""}, {"category": "Not available", "vdate": "2015-02-04", "label": "LCL CREDIT SATISFACTION", "raw": "LCL CREDIT SATISFACTION", "amount": "24.96", "rdate": "2015-02-04", "date": "2015-02-04", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2015-02-02", "label": "CB35EUROPROCUREM 01/02/15", "raw": "CB35EUROPROCUREM 01/02/15", "amount": "-329.73", "rdate": "2015-02-02", "date": "2015-02-02", "type": "0", "id": ""}, {"category": "ABON", "vdate": "2015-02-02", "label": "ABON LCL ACCESS 003,50EUR", "raw": "ABON LCL ACCESS 003,50EUR", "amount": "-3.50", "rdate": "2015-02-02", "date": "2015-02-02", "type": "9", "id": ""}, {"category": "Not available", "vdate": "2015-01-29", "label": "LCL A LA CARTE PRO", "raw": "LCL A LA CARTE PRO", "amount": "0.25", "rdate": "2015-01-29", "date": "2015-01-29", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2015-01-29", "label": "COTISATION DE VOTRE OPTION PRO", "raw": "COTISATION DE VOTRE OPTION PRO", "amount": "-16.00", "rdate": "2015-01-29", "date": "2015-01-29", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2015-01-29", "label": "LCL A LA CARTE PRO", "raw": "LCL A LA CARTE PRO", "amount": "0.77", "rdate": "2015-01-29", "date": "2015-01-29", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2015-01-28", "label": "COTISATION MENSUELLE CARTE 5493", "raw": "COTISATION MENSUELLE CARTE 5493", "amount": "-4.16", "rdate": "2015-01-27", "date": "2015-01-27", "type": "0", "id": ""}, {"category": "CHQ.", "vdate": "2015-01-27", "label": "3415204", "raw": "CHQ. 3415204", "amount": "-240.00", "rdate": "2015-01-27", "date": "2015-01-27", "type": "3", "id": ""}, {"category": "Not available", "vdate": "2015-01-16", "label": "Avance compte associe", "raw": "Avance compte associe", "amount": "1000.00", "rdate": "2015-01-16", "date": "2015-01-16", "type": "0", "id": ""}, {"category": "PRLV", "vdate": "2015-01-16", "label": "SEPA OVH SAS", "raw": "PRLV SEPA OVH SAS", "amount": "-1.22", "rdate": "2015-01-16", "date": "2015-01-16", "type": "2", "id": ""}, {"category": "PRLV", "vdate": "2015-01-12", "label": "SEPA ECL GROUPE", "raw": "PRLV SEPA ECL GROUPE", "amount": "-133.53", "rdate": "2015-01-12", "date": "2015-01-12", "type": "2", "id": ""}, {"category": "ABON", "vdate": "2015-01-02", "label": "ABON LCL ACCESS 003,50EUR", "raw": "ABON LCL ACCESS 003,50EUR", "amount": "-3.50", "rdate": "2015-01-02", "date": "2015-01-02", "type": "9", "id": ""}, {"category": "RESULTAT", "vdate": "2015-01-01", "label": "RESULTAT ARRETE COMPTE 31122014", "raw": "RESULTAT ARRETE COMPTE 31122014", "amount": "-5.17", "rdate": "2014-12-31", "date": "2014-12-31", "type": "9", "id": ""}, {"category": "Not available", "vdate": "2014-12-30", "label": "LCL A LA CARTE PRO", "raw": "LCL A LA CARTE PRO", "amount": "0.25", "rdate": "2014-12-30", "date": "2014-12-30", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2014-12-30", "label": "COTISATION DE VOTRE OPTION PRO", "raw": "COTISATION DE VOTRE OPTION PRO", "amount": "-16.00", "rdate": "2014-12-30", "date": "2014-12-30", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2014-12-30", "label": "LCL A LA CARTE PRO", "raw": "LCL A LA CARTE PRO", "amount": "0.77", "rdate": "2014-12-30", "date": "2014-12-30", "type": "0", "id": ""}, {"category": "Not available", "vdate": "2014-12-28", "label": "COTISATION MENSUELLE CARTE 5493", "raw": "COTISATION MENSUELLE CARTE 5493", "amount": "-4.16", "rdate": "2014-12-26", "date": "2014-12-26", "type": "0", "id": ""}, {"category": "PRLV", "vdate": "2014-12-15", "label": "SEPA OVH SAS", "raw": "PRLV SEPA OVH SAS", "amount": "-1.19", "rdate": "2014-12-15", "date": "2014-12-15", "type": "2", "id": ""}, {"category": "PRLV", "vdate": "2014-12-10", "label": "SEPA ECL GROUPE", "raw": "PRLV SEPA ECL GROUPE", "amount": "-133.53", "rdate": "2014-12-10", "date": "2014-12-10", "type": "2", "id": ""}]}'

basePath = __dirname

module.exports = (callback) ->
  scriptPath = nodePath.join basePath, 'python'
  shell = new PythonShell(
    'bank_get.py'
    {
      scriptPath: scriptPath
      args: [
        "lcl"
      ]
    }
  )
  shell.on 'message', (obj) =>
    account = JSON.parse(obj)

    bankEntries = []

    for tr in account.history
      entry = {
        date:     parseInt Date.parse(tr.date)
        execDate: parseInt Date.parse(tr.vdate)
        title:    tr.raw
        amount:   parseFloat tr.amount
        type:     'entry'
      }
      console.log entry
      bankEntries.push entry


    callback(bankEntries)