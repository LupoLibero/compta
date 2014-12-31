http   = require('http')
Q      = require('q')
cradle = require('cradle')

module.exports = (host, port)->
  return (dbName, username = null, password = null)->
    params = { cache: false }
    if username isnt null and password isnt null
      params.auth = {username: username, password: password}
    db = new(cradle.Connection)("http://#{host}", port, params).database(dbName)
    {
      changes: (data) ->
        return db.changes(data)

      get: (_id, user = {}) ->
        defer = Q.defer()
        db.get(_id, (err, data)->
          if err
            defer.reject(err)
          else
            defer.resolve(data))
        return defer.promise

      view: (appAndView, data = {}) ->
        [app, view] = appAndView.split('/')
        defer = Q.defer()
        db.view("#{app}/#{view}", data, (err, data)->
          if err
            defer.reject(err)
          else
            defer.resolve(data)
        )
        return defer.promise

      update: (appAndUpdate, id = '', data = {}, user = {}) ->
        [app, updateName] = appAndUpdate.split('/')
        defer  = Q.defer()
        method = (if id is '' then 'POST' else 'PUT')

        if params.auth?
          user.name = user.name || params.auth.username
          user.pass = user.pass || params.auth.password
        if user.name != '' and user.pass?
          basic = new Buffer("#{user.name}:#{user.pass}").toString('base64')
          headers = {
            "Authorization": "Basic #{basic}"
          }
        else if user.name != '' and user.cookie != ''
          headers = {
            "Cookie": user.cookie
          }
        else
          headers = {}

        req = http.request({
          hostname:  host
          method:    method
          port:      port
          path:      "/#{dbName}/_design/#{app}/_update/#{updateName}/#{id}"
          headers:   headers
        }, (res)->
          res.setEncoding('utf8')
          res.on('data', (body)->
            try
              body = JSON.parse(body)

            data = {
              response: body
              status:   res.statusCode
            }

            if res.headers.hasOwnProperty('x-couch-update-newrev')
              data.rev = res.headers['x-couch-update-newrev']
            if res.headers.hasOwnProperty('x-couch-id')
              data._id  = res.headers['x-couch-id']
              data.id   = data._id.split(':')[1..-1].join(':')

            if res.statusCode.toString()[0] > 3
              defer.reject(JSON.stringify(data))
            else
              data.reason =  body.reason?
              data.error  =  body.error?
              data.status =  res.statusCode
              defer.resolve(data)
          )
        )
        req.write(JSON.stringify(data))
        req.end()
        return defer.promise
    }
