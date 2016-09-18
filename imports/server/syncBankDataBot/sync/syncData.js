import _ from 'lodash'

const storeEntry = (db, ddoc, entry) => {
  entry._id = 'entry' + ':' + entry.date + ':' + entry.amount
  entry.createdAt = new Date().getTime()
  entry.amount    = parseFloat(entry.amount)
  entry.date      = parseInt(entry.date)
  entry.execDate  = parseInt(entry.date)
  entry.type      = 'entry'

  db.put(entry).then(
    (result) => {
      console.log "succ", result, entry
    },
    (err) => {
      console.log "error", err
    }
  )
}

const probablyEqual = (a, b) => {
  return a.date === b.date and a.amount === b.amount
}

const alreadyInDb = (entry, index) => {
  //console.log indexKey(entry)
  dupl = index[indexKey(entry)]
  if(dupl)
    return probablyEqual(entry, dupl)
  return false
}

const indexKey = (entry) => {
  return entry.date + ' - ' + entry.amount
}

module.exports = (db, ddoc, bankEntries, startDate, endDate) => {
  console.log("db", db, ddoc, startDate, endDate)
  db.query(ddoc + '/entry_all', {
    startkey: parseInt(startDate),
    endkey:   parseInt(endDate),
    include_docs: true
  }).then (result) => {
    const haveBeenStored = []
    const entryToString = (entry) => {
      entry.date + entry.title + entry.execDate + entry.amount
    }
    const dbEntries = result.map((r) => r.doc)
    const index   = _.indexBy dbEntries, indexKey

    for(i in bankEntries) {
      const entry = bankEntries[i]
      //console.log(entry.date, entry.amount, entry.title)
      if(!alreadyInDb(entry, index)){
        console.log("store")
        if(!index[indexKey(entry)]){
          index[indexKey(entry)] = []
        }
        index[indexKey(entry)].push(entry)
        storeEntry(db, ddoc, entry)
        .catch(() => {
          const idx = index[indexKey(entry)].indexOf(entry)
          index[indexKey(entry)].splice(idx, 1)
        })
        haveBeenStored.push(entry)
      }
    }
    console.log("have been stored", haveBeenStored.length)
    console.log(haveBeenStored)
  })
  .catch (err) => {
    console.log(err)
  }
}
