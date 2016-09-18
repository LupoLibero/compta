cradle     = require 'cradle'
nodePath   = require 'path'

module.exports = (gulp, plugins, options) ->
  return ->
    argv = yargs.usage 'Usage: $0 bots path url [appName] [envName]'
                .demand 3
                .argv

    installBots.apply(yargs.argv._)

    getEnvs = (basePath = '.') ->
      krcPath = nodePath.join(basePath, '.kansorc')
      return require(krcPath).env

    getUrlFromEnv = (envOrUrl) ->
      if isUrl(envOrUrl)
        return envOrUrl
      envs = getEnvs() or {}
      if  envs.hasOwnProperty(envOrUrl) and
          envs[envOrUrl].hasOwnProperty('db')
        return envs[envOrUrl].db
      else
        throw new Error("can't find the url of this environment: #{envOrUrl}")

    installBots = (basePath, urlOrEnv, appName, envName) ->
      bots = require(nodePath.join(basePath, 'kanso.json')).bots
      if not bots
        console.log "No bot to install in #{basePath}"
        process.exit(0)

      serverUrl = serverUrlFromDbUrl(getUrlFromEnv(envOrUrl))

      console.log "Installation of bots in " + serverUrl.replace(/\/\/.*@/, '\/\/') + "/_config db"
      db = new(cradle.Connection)(serverUrl).database("_config")
      for botName, bot of bots
        words = []
        for word in bot.split(' ')
          words.push(
            if fs.existsSync(word)
              nodePath.resolve(word)
            else
              switch word
                when "_url"      then serverUrl
                when "_app"      then appName
                when "_instance" then instanceName
                else word
          )
        firstExt = words[0].match(/\.\w+$/)
        if firstExt?
          words.unshift(
            switch firstExt[0]
              when ".coffee" then "coffee"
              when ".js"     then "node"
              else ""
          )
        botCmd = words.join(' ')

        if appName?
          botName += "-" + appName
          if instanceName?
            botName += "-" + instanceName

        ( (name)->
          return db.query({
              method: 'PUT'
              path: "os_daemons/#{name}"
              body: botCmd
            }, (err, res)->
              if err
                console.log("#{name}: ERROR")
                console.log(err)
              else
                console.log("#{name}: INSTALLED")
          )
        )(botName)