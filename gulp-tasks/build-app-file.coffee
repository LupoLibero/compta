nodePath   = require 'path'
fs         = require 'fs'

module.exports = (gulp, plugins, options) ->
  paths         = options.paths
  production    = options.production
  kansoModules  = options.kansoModules
  return ->
    libPath = 'lib'
    content = []
    content.push "var app = {"
    content.push "  language: 'javascript',"
    for module in kansoModules
      filename = module + '.js'
      if fs.existsSync(nodePath.join(libPath, filename))
        if module == "validate"
          content.push "  validate_doc_update: require('./validate').validate_doc_update,"
        else
          content.push "  #{module}: require('./#{module}'),"
    content.push '}'
    if fs.existsSync(nodePath.join(libPath, 'properties.js'))
      content.push "var properties = require('./properties')"
      content.push "for(var key in properties) {"
      content.push "  app[key] = properties[key];"
      content.push "}"
    content.push "module.exports = app"
    fs.writeFileSync(
      nodePath.join(libPath, 'app.js')
      content.join '\n'
    )