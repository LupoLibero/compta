angular.module('canaperp').controller('HomeCtrl', function($scope, Entry, entries, config) {
  var cat, catGroup, group, i, j, len, len1, ref, ref1;
  console.log('loaded', entries);
  $scope.entries = entries;
  $scope.categories = [];
  ref = config.categories;
  for (i = 0, len = ref.length; i < len; i++) {
    catGroup = ref[i];
    group = catGroup[0];
    ref1 = catGroup[1];
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      cat = ref1[j];
      $scope.categories.push({
        label: cat,
        group: group
      });
    }
  }
  return $scope.updateCategory = function(entry, category) {
    console.log("updateCategory", category, entry);
    return Entry.updateCategory(entry, category);
  };
});
