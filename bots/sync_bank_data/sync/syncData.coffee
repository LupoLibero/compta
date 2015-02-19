

storeEntry = (db, appName, entry) ->
  db.update(appName + '-main' + '/entry_add', '', entry).then(
    (result) =>
      console.log "succ", result
    (err) =>
      console.log "error", err
  )

module.exports = (db, appName, bankEntries, startDate, endDate) ->
  console.log "db", startDate, endDate
  db.view(appName + '-main/entry_all', {
    startkey: parseInt startDate
    endkey:   parseInt endDate
    include_docs: true
  }).then (result) ->
    entryToString = (entry) ->
      entry.date + entry.title + entry.execDate + entry.amount
    dbEntries = (entryToString(r.doc) for r in result)

    for entry, i in bankEntries
      str = entryToString(entry)
      idx = dbEntries.indexOf(str)
      if idx == -1
        console.log "store", entry
        #storeEntry(db, appName, entry)
      else
        dbEntries.splice(idx, 1)

  .catch (err) ->
    console.log err

