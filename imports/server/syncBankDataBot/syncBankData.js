import parser       from './bank_statement_parser/pdfParser.coffee'
import getBankData  from './bank_web_data/getBankData.coffee'
import sync         from './sync/syncData.coffee'
import fs           from 'fs'
import nodePath     from 'path'

const statementPath = 'statements'
if(!fs.existsSync(statementPath)) fs.mkdirSync(statementPath)

const pageCallback = (entries) => {
  console.log("callback", entries)
  if(entries.length) {
    sync(
      this._db,
      this._appName,
      entries,
      entries[0].date,
      entries[-1..][0].date
    )
  }
}

module.exports = {
  _db:      mainDb,
  _appName: appName,

  init: (db, appName) => {
    this._db      = db
    this._appName = appName
  },

  parseFiles: (path) => {
    console.log("parseFiles", this._db, this._appName)
    const files = []
    if(fs.statSync(path).isDirectory()){
      for(file in fs.readdirSync(path)) {
        if(file.split('.')?[1] !== 'pdf')
          continue;
        files.push(file)
        folder = path
      }
    }
    else {
      folder = nodePath.dirname(path)
      files = [nodePath.basename(path)]
    }
    for(let file in files) {
      if(fs.existsSync(nodePath.join(statementPath, file)))
        continue;
      path = nodePath.join(folder, file)
      parser(path, pageCallback.bind(this))
      ((path, file) => {
        fs.readFile(path, (err, content) => {
          fs.writeFile(nodePath.join(statementPath, file), content)
        })
      })(path, file)
    }
  },

  connectToBank: () => {
    getBankData (entries) => {
      if(entries.length) {
        sync(
          this._db,
          this._appName,
          entries,
          entries[-1..][0].date,
          entries[0].date
        )
      }
    }
  }
}
