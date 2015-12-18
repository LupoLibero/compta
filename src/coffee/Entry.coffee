settings =
  db:  'canaperp'
  app: 'canapERP-main'
  url: '_db'


angular.module('canaperp')
.service 'Entry', ($http) ->
  class Entry
    @updateCategory: (entry, category) ->
      $http.put settings.url + '/_design/canapERP-main/_update/entry_update_category/' + entry._id,
                category
      .success =>
        console.log "succ"
      .catch (err) =>
        console.log "failure", err