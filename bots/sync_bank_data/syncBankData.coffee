dbConnector  = require('../../tools/dbForBots/db')
parser       = require './bank_statement_parser/pdfParser.coffee'
getBankData  = require './bank_web_data/getBankData.coffee'
sync         = require './sync/syncData.coffee'

host = 'localhost'
port = '5984'
dbServer = dbConnector(host, port)
appName = 'canapERP-main'
dbName = 'canaperp'
mainDb = dbServer(dbName, 'admin', 'admin')


parser "/home/eggo/ownCloud/box/banque/", (entries) ->
  if entries.length
    sync(
      mainDb
      appName
      entries
      entries[0].date
      entries[-1..][0].date
    )


getBankData (entries) ->
  if entries.length
    sync(
      mainDb
      appName
      entries
      entries[-1..][0].date
      entries[0].date
    )
