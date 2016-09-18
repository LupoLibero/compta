nodePath   = require 'path'
gulpif     = require 'gulp-if'
source     = require 'vinyl-source-stream'
browserify = require 'browserify'
uglify     = require 'gulp-uglify'
watchify   = require 'watchify'
try
  browserifyHandlebars = require 'browserify-handlebars'
catch
  ""
process.env.BROWSERIFYSHIM_DIAGNOSTICS=1

module.exports = (gulp, plugins, options) ->
  paths         = options.paths
  production    = options.production
  outFolderPath = options.outFolderPath

  filepath = './' + nodePath.join(outFolderPath('tmp', paths.mainDb), paths.mainJsFile)

  ###
  bundler = watchify(browserify({
    entries:      filepath
    debug:        not production
    cache:        {}
    packageCache: {}
    transform:    [browserifyHandlebars]
  }))

  bundle = ->
    return bundler.bundle()
      .pipe(source(paths.coffee.dest))
      .pipe(gulpif(production, uglify()))
      .pipe(gulp.dest(outFolderPath('static/js', paths.mainDb)))

  bundler.on 'update', bundle
  return ->
    bundle()
  ###
  return ->
    b = browserify({
      entries:      filepath
      debug:        not production
      cache:        {}
      packageCache: {}
    })
    if browserifyHandlebars
      b = b.transform(browserifyHandlebars)
    b.bundle()
      .pipe(source(paths.coffee.dest))
      .pipe(gulpif(production, uglify()))
      .pipe(gulp.dest(outFolderPath('static/js', paths.mainDb)))