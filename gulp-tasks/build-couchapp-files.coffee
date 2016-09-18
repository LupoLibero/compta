nodePath   = require 'path'
fs         = require 'fs'

# TODO: gulpify
module.exports = (gulp, plugins, options) ->
  outFolderPath = options.outFolderPath
  kansoModules  = options.kansoModules
  return ->
    libPath = 'lib'
    unless fs.existsSync(libPath)
      fs.mkdir(libPath)
    firstLines = "var reExports = require('./utils').reExports;"
    for module in kansoModules
      #TODO: each module could be a folder
      filename = module + '.js'
      content = ""
      for model in fs.readdirSync(libPath)
        if fs.existsSync(nodePath.join(libPath, model, filename))
          moduleName = "lib/#{model}/" + filename.split('.')[0]
          content += "\n\nreExports(exports, '#{moduleName}');"
      if content.length > 0
        content = firstLines + content
        fs.writeFileSync(
          nodePath.join(libPath, filename)
          content
        )