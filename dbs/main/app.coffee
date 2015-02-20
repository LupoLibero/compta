window.$ = window.jQuery = require 'jquery'
require('angular')

require 'angular-ui-router'

require 'ui-select'

require 'angular-sanitize'

app = angular.module('canaperp', ['ui.router', 'ngSanitize', 'ui.select'])

#
# AngularJS default filter with the following expression:
# "person in people | filter: {name: $select.search, age: $select.search}"
# performs a AND between 'name: $select.search' and 'age: $select.search'.
# We want to perform a OR.
#
app.filter 'propsFilter', () ->
  return (items, props) ->
    out = []
    if angular.isArray(items)
      items.forEach (item) ->
        itemMatches = false
        for prop in Object.keys(props)
          text = props[prop].toLowerCase()
          if item[prop].toString().toLowerCase().indexOf(text) != -1
            itemMatches = true
            break
        if itemMatches
          out.push(item)
    else
      # Let the output be the input untouched
      out = items
    return out


require './routes'
