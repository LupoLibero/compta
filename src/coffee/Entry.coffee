settings =
  db:  'canaperp'
  app: 'canapERP-main'
  url: '_db'


angular.module('canaperp')
.service 'Entry', ($http) ->
  class Entry
    @updateCategory: (entry, category) ->
      entry.category = category.label
      app.db.put(entry)
      .then =>
        console.log "succ"
      .catch (err) =>
        console.log "failure", err