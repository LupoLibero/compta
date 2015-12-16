require './home'

settings =
  db:  'canaperp'
  app: 'canapERP-main'
  url: '_db'

angular.module('canaperp').
config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.
		state 'home',
			url: 				 '/'
			templateUrl: 'html/home.html'
			controller:  'HomeCtrl'
			resolve:
        entries: ($http) ->
          $http.get settings.url + '/_design/canapERP-main/_view/entry_all?include_docs=true&descending=true&limit=20'
          .then (response) ->
            return (r.doc for r in response.data.rows)

        config: ($http) ->
          $http.get settings.url + '/config:qualification'
          .then (response) ->
            return response.data


  $urlRouterProvider.otherwise('/')