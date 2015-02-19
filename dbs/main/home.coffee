angular.module('canaperp').
controller 'HomeCtrl', ($scope, entries) ->
  console.log 'loaded', entries
  $scope.entries = entries