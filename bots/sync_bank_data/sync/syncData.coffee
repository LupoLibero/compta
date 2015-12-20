_ = require 'lodash'

storeEntry = (db, ddoc, entry) ->
  entry._id = 'entry' + ':' + entry.date + ':' + entry.amount
  entry.createdAt = new Date().getTime()
  entry.amount   = parseFloat(entry.amount)
  entry.date     = parseInt(entry.date)
  entry.execDate = parseInt(entry.date)
  entry.type     = 'entry'

  db.put(entry).then(
    (result) =>
      console.log "succ", result, entry
    (err) =>
      console.log "error", err
  )

probablyEqual = (a, b) ->
  return a.date == b.date and a.amount == b.amount

alreadyInDb = (entry, index) ->
  #console.log indexKey(entry)
  dupl = index[indexKey(entry)]
  if dupl?
    return probablyEqual(entry, dupl)
  return false

indexKey = (entry) ->
  return entry.date + ' - ' + entry.amount

module.exports = (db, ddoc, bankEntries, startDate, endDate) ->
  console.log "db", db, ddoc, startDate, endDate
  db.query(ddoc + '/entry_all', {
    startkey: parseInt startDate
    endkey:   parseInt endDate
    include_docs: true
  }).then (result) ->
    haveBeenStored = []
    entryToString = (entry) ->
      entry.date + entry.title + entry.execDate + entry.amount
    dbEntries = (r.doc for r in result)
    index   = _.indexBy dbEntries, indexKey

    for entry, i in bankEntries
      #console.log entry.date, entry.amount, entry.title
      if not alreadyInDb(entry, index)
        console.log "store"
        if not index[indexKey(entry)]
          index[indexKey(entry)] = []
        index[indexKey(entry)].push entry
        storeEntry(db, ddoc, entry)
        .catch =>
          idx = index[indexKey(entry)].indexOf(entry)
          index[indexKey(entry)].splice idx, 1
        haveBeenStored.push(entry)

    console.log "have been stored", haveBeenStored.length
    console.log haveBeenStored

  .catch (err) ->
    console.log err

