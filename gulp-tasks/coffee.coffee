notify     = require('gulp-notify')
plumber    = require('gulp-plumber')
coffee     = require 'gulp-coffee'
gulpif     = require 'gulp-if'
sourcemaps = require('gulp-sourcemaps')
changed    = require 'gulp-changed'

module.exports = (gulp, plugins, options) ->
  paths         = options.paths
  production    = options.production
  outFolderPath = options.outFolderPath

  out = outFolderPath('tmp', paths.mainDb)
  return ->
    console.log "out", out
    gulp.src(paths.coffee.src)
      .pipe(changed(out))
      .pipe(plumber(notify.onError('<%=error.stack%>')))
      .pipe(gulpif(not production, sourcemaps.init()))
      .pipe(coffee({bare: true}))
      .pipe(gulpif(not production, sourcemaps.write()))
      .pipe(gulp.dest(out))