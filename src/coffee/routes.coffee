#require './home'

settings =
  db:  'canaperp'
  app: 'canapERP-main'
  url: '_db'

fs = require 'fs'
Q  = require 'q'

#module.exports = (app) ->
angular.module('canaperp').
config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.
		state 'home',
			url: 				 '/'
			templateUrl: 'home.html'
			controller:  'HomeCtrl'
			resolve:
        entries: ($http) ->
          console.log app
          app.db.query('canaperp/entry_all', {include_docs: true, descending: true})
          #$http.get settings.url + '/_design/canapERP-main/_view/entry_all?include_docs=true&descending=true&limit=20'
          .then (response) ->
            console.log response
            return (r.doc for r in response.rows)
          .catch (error) ->
            console.error(error)

        config: ($http) ->
          Q.promise (resolve, reject) ->
            fs.readdir './', (err, content) ->
              console.log "parent", content
            fs.readFile 'data/config_qualification', (err, content) ->
              c = JSON.parse(content)
              console.log(c)
              resolve(c)


  $urlRouterProvider.otherwise('/')