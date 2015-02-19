window.$ = window.jQuery = require 'jquery'
require('angular')

require 'angular-ui-router'

angular.module('canaperp', ['ui.router'])

require './routes'
