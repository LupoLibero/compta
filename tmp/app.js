var PouchDB, angApp, app;

window.$ = window.jQuery = require('jquery');

require('angular');

require('angular-ui-router');

require('ui-select');

require('angular-sanitize');

PouchDB = require('pouchdb/dist/pouchdb.min.js');

angApp = angular.module('canaperp', ['ui.router', 'ngSanitize', 'ui.select']);

require('./Entry');

window.app = app = {};

app.db = new PouchDB('canaperp');

angApp.filter('propsFilter', function() {
  return function(items, props) {
    var out;
    out = [];
    if (angular.isArray(items)) {
      items.forEach(function(item) {
        var i, itemMatches, len, prop, ref, text;
        itemMatches = false;
        ref = Object.keys(props);
        for (i = 0, len = ref.length; i < len; i++) {
          prop = ref[i];
          text = props[prop].toLowerCase();
          if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
            itemMatches = true;
            break;
          }
        }
        if (itemMatches) {
          return out.push(item);
        }
      });
    } else {
      out = items;
    }
    return out;
  };
});

angApp.service('app', function() {
  return app;
});

require('./routes')(app);
