window.$ = window.jQuery = require 'jquery'

require 'coffee-script/register'

#require 'angular-sanitize'

#PouchDB = require 'pouchdb/dist/pouchdb.min.js'

angApp = angular.module('canaperp', ['ui.router', 'ngSanitize', 'ui.select'])

#require './js/Entry'
fs = require 'fs'

window.app = app = {}
app.db = new PouchDB('canaperp')

app.db.get('_design/canaperp')
.then ->
  console.log 'ddoc already installed'
.catch ->
  console.warn 'ddoc not installed'
  fs.readFile 'www/ddoc.json', (err, content) ->
    if(err)
      console.error err
      return
    ddoc = JSON.parse(content)
    ddoc._id = '_design/canaperp'
    app.db.put(ddoc)
    .then ->
      console.log "ddoc successfully installed"
    .catch ->
      console.log "error in ddoc installation"


syncBankData =require '../bots/sync_bank_data/syncBankData.coffee'
path = "/home/eggo/nuage/SASU/banque/"
path += "releve-201503.pdf"

syncBankData.init(app.db, 'canaperp')
syncBankData.parseFiles(path)
#syncBankData.connectToBank()


#
# AngularJS default filter with the following expression:
# "person in people | filter: {name: $select.search, age: $select.search}"
# performs a AND between 'name: $select.search' and 'age: $select.search'.
# We want to perform a OR.
#
angApp.filter 'propsFilter', () ->
  return (items, props) ->
    out = []
    if angular.isArray(items)
      items.forEach (item) ->
        itemMatches = false
        for prop in Object.keys(props)
          text = props[prop].toLowerCase()
          if item[prop].toString().toLowerCase().indexOf(text) != -1
            itemMatches = true
            break
        if itemMatches
          out.push(item)
    else
      # Let the output be the input untouched
      out = items
    return out

angApp.service('app', ->
  return app
)

#require('./routes')(app)
