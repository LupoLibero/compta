dbConnector = require('../../tools/dbForBots/db')
PythonShell = require('python-shell')

host =
port =
dbServer = dbConnector(host, port)

pyshell = new PythonShell(
  'bankstatementparser.py'
  {
    args: ["import/releve-201402.pdf"]
  }
  (err, results) =>
    if err
      throw err
    # results is an array consisting of messages collected during execution
    console.log('results: %j', results)
)

LCL =
  pattern:
    regexp: /(\d\d\.\d\d)\s?(.+?)\s*(\d\d\.\d\d\.\d\d)?\s+([0-9 ,]+)\|$/
    mapping:
      1: 'date'
      2: 'title'
      3: 'exec_date'
      4: 'amount'

parseLine = (line, pattern) ->
  match = pattern.regexp.exec(line)
  if match?
    result = {}
    for id, label of pattern.mapping
      result[label] = match[id]
    return result

pyshell.on 'message', (message) =>
  entry = parseLine(message, LCL.pattern)
  if entry?
    console.log entry
