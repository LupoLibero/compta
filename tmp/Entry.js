var settings;

settings = {
  db: 'canaperp',
  app: 'canapERP-main',
  url: '_db'
};

angular.module('canaperp').service('Entry', function($http) {
  var Entry;
  return Entry = (function() {
    function Entry() {}

    Entry.updateCategory = function(entry, category) {
      return $http.put(settings.url + '/_design/canapERP-main/_update/entry_update_category/' + entry._id, category).success((function(_this) {
        return function() {
          return console.log("succ");
        };
      })(this))["catch"]((function(_this) {
        return function(err) {
          return console.log("failure", err);
        };
      })(this));
    };

    return Entry;

  })();
});
