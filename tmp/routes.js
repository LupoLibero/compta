var os, settings;

require('./home');

settings = {
  db: 'canaperp',
  app: 'canapERP-main',
  url: '_db'
};

os = require('os');

console.log(os.cpus().length, "cpus");

module.exports = function(app) {
  return angular.module('canaperp').config(function($stateProvider, $urlRouterProvider) {
    $stateProvider.state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl',
      resolve: {
        entries: function($http) {
          return app.db.view('entry_all').then(function(response) {
            var r;
            return (function() {
              var i, len, ref, results;
              ref = response.data.rows;
              results = [];
              for (i = 0, len = ref.length; i < len; i++) {
                r = ref[i];
                results.push(r.doc);
              }
              return results;
            })();
          });
        },
        config: function($http) {
          return app.get('config:qualification').then(function(response) {
            return response.data;
          });
        }
      }
    });
    return $urlRouterProvider.otherwise('/');
  });
};
