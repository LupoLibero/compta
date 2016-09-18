yargs = require 'yargs'
run   = require 'gulp-run'


module.exports = (gulp, plugins, options) ->
  paths         = options.paths
  production    = options.production
  outFolderPath = options.outFolderPath
  getDbs        = options.getDbs

  serverUrlFromDbUrl = (dbUrl) ->
    # get the address without the database name
    dbUrl.match(/^(http(?:s)?:\/\/[^\/]*)\/?/)[1]

  runKanso = (path, serverUrl, dbName) ->
    cmd = "kanso push #{serverUrl}/#{dbName}"
    console.log cmd
    folder = outFolderPath('', path)
    run("cd #{folder} && #{cmd}").exec()

  runMultipleKansoPush = (serverUrl, dbs) ->
    cmd = ""
    for db in dbs
      folder = outFolderPath('', db.path)
      cmd += "&& kanso push #{folder} #{serverUrl}/#{db.name}"
    cmd = cmd[3..]
    console.log cmd
    run(cmd).exec()

  return  ->
    argv = yargs.demand(['url', 'app'])
                .usage("Usage: $0 push url appName [envName]")
                .argv

    [url, appName, envName] = [argv.url, argv.app, argv.env]
    serverUrl = serverUrlFromDbUrl(url)
    console.log "serverURL", serverUrl
    runMultipleKansoPush(serverUrl, getDbs(appName, envName))