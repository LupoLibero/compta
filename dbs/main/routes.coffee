require './home'

settings =
  db:  'canaperp'
  app: 'canapERP-main'

angular.module('canaperp').
config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.
		state 'home',
			url: 				 '/'
			templateUrl: 'html/home.html'
			controller:  'HomeCtrl'
			resolve:
        entries: ($http) ->
          $http.get '_view/entry_all?include_docs=true&descending=true&limit=20'
          .then (response) ->
            return (r.doc for r in response.data.rows)

        config: ($http) ->
          $http.get '_doc/config:qualification'
          .then (response) ->
            return response.data


  $urlRouterProvider.otherwise('/')