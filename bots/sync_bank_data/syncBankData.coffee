dbConnector  = require('../../tools/dbForBots/db')
parser       = require './bank_statement_parser/pdfParser.coffee'
getBankData  = require './bank_web_data/getBankData.coffee'
sync         = require './sync/syncData.coffee'
fs           = require 'fs'
nodePath     = require 'path'

host = 'localhost'
port = '5984'
dbServer = dbConnector(host, port)
appName = 'canapERP-main'
dbName = 'canaperp'
mainDb = dbServer(dbName, 'admin', 'admin')

statementPath = 'statements'
if not fs.existsSync(statementPath)
  fs.mkdirSync(statementPath)


path = "/home/eggo/nuage/SASU/banque/"
files = []
if fs.statSync(path).isDirectory()
  for file in fs.readdirSync(path) when file.split('.')?[1] == 'pdf'
    files.push(file)
    folder = path
else
  folder = nodePath.dirname(path)
  files = [nodePath.basename(path)]
for file in files when not fs.existsSync(nodePath.join(statementPath, file))
  path = nodePath.join(folder, file)
  parser path, (entries) ->
    if entries.length
      sync(
        mainDb
        appName
        entries
        entries[0].date
        entries[-1..][0].date
      )
  ((path, file) ->
    fs.readFile(path, (err, content) ->
      console.log path
      console.log content
      fs.writeFile(nodePath.join(statementPath, file), content))
  )(path, file)
###
getBankData (entries) ->
  if entries.length
    sync(
      mainDb
      appName
      entries
      entries[-1..][0].date
      entries[0].date
    )
###