nodePath    = require 'path'
http        = require 'http'
fs          = require 'fs'
httpProxy   = require 'http-proxy'
yargs       = require 'yargs'
#browserSync = require 'browser-sync'
#reload      = browserSync.reload
livereload  = require 'gulp-livereload'


module.exports = (gulp, plugins, options) ->
  paths = options.paths
  outFolderPath = options.outFolderPath
  getRealDbName = options.getRealDbName
  return () ->
    argv = yargs.demand(['url', 'app'])
                .usage("Usage: $0 server url appName [envName]")
                .argv

    [url, dbName, envName] = [argv.url, argv.app, argv.env]
    buildPath = outFolderPath('', paths.mainDb)
    #run("node ./node_modules/coffee-script/bin/coffee ./server.coffee").exec(done)

    port     = 8080
    proxy    = httpProxy.createProxyServer({
      target: "http://127.0.0.1:5984/"
    })
    rewrites     = null
    #dbname       = getRealDbName("main", dbName, envName)
    ddoc = 'canapERP-main'
    rewritesPath = nodePath.join('dbs', 'main', 'lib', 'rewrites.js')

    if fs.existsSync('./.kansorc')
      kanso  = require('./.kansorc')
      kanso  = kanso.env        ? {}
      kanso  = kanso.default    ? {}
      kanso  = kanso.db         ? ""
      if kanso != ""
        kanso  = kanso.split('/')
        dbName = kanso[-1..-1][0]

    if dbName == null
      throw new Error('Impossible to find a .kansorc or to find a default configuration in it')

    if fs.existsSync(rewritesPath)
      rewrites = require(nodePath.resolve(rewritesPath))
      for rewrite in rewrites
        for m, i in rewrite.from.match(/(\:\w+|\*+)/gi) || []
          rewrite.to = rewrite.to.replace(m, "$#{i+1}")

        reg = "^#{rewrite.from}$".replace('/', '\\\/')
        reg = reg.replace('*', '(.*)')
        reg = reg.replace(/\:\w+/, '(\w+)')
        rewrite.from = new RegExp(reg, 'i')
    else
      throw new Error("Impossible to find a rewrites.js here :: #{rewritesPath}")

    #browserSync({})
    livereload()
    livereload.listen()
    gulp.watch("#{buildPath}/!(tmp)/**")
    .on 'change', (file) ->
      console.log "changed", file.path
      livereload.changed(file.path)

    http.createServer( (req, res)->
      found   = null
      request = false
      for rewrite in rewrites
        match = rewrite.from.exec(req.url)
        if match
          console.log "match"
          found = rewrite.to
          for m in rewrite.to.match(/\$\d+/gi) || []
            num = parseInt(m.replace('$', ''))
            found = found.replace(m, match[num])
          console.log "found", found
          break
      console.log req.url
      if found?
        link = nodePath.join buildPath, "./#{found}"
        for dbWord in ['_view', '_show', '_list', '_doc']
          if req.url.indexOf(dbWord) != -1
            request = true
      else
        link = nodePath.join buildPath, "./#{req.url}"

      # normalize link
      #link = link.replace(/\/+/g, nodePath.sep) if not request

      if request
        req.url = '/' + dbName + '/_design/' + ddoc + '/_rewrite' + req.url
        console.log "db request", req.url
        proxy.web(req, res)
      else if fs.existsSync(link)
        file = fs.readFileSync(link, {
          encoding: 'utf-8'
        })
        # Livereload
        if link.match(/.*index.html$/)
          localip = require('ip').address()
          file = file.replace('</body>', '<script src="http://'+localip+':35729/livereload.js?snipver=1"></script></body>')

        res.writeHead(200, {
          "Content-Length": file.length
          "Content-Encoding": 'utf-8'
        })
        res.end(file)
      else
        res.writeHead(404)
        res.end()

    ).listen(port)