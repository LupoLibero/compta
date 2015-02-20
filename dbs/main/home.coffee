angular.module('canaperp').
controller 'HomeCtrl', ($scope, entries, config) ->
  console.log 'loaded', entries
  $scope.entries = entries
  $scope.categories = []
  for catGroup in config.categories
    group = catGroup[0]
    for cat in catGroup[1]
      $scope.categories.push {label: cat, group: group}