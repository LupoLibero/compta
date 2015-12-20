gulp        = require "gulp"
plugins     = require('gulp-load-plugins')()
browserSync = require "browser-sync"
gutil       = require 'gulp-util'
watch       = require 'gulp-watch'
nodePath    = require 'path'
source      = require 'vinyl-source-stream'
browserify  = require 'browserify'
proxy       = require 'proxy-middleware'
url         = require 'url'
yargs       = require 'yargs'

production = yargs.argv.prod ? false
# Gulp plugins
{
sass
flatten
jade
debug
concat
coffee
plumber
sourcemaps
autoprefixer
} = plugins

getTask = (name, options) ->
  if typeof options != 'object'
    options = {}

  options.paths         = options.paths         || paths
  options.production    = options.production    || production

  return require('./gulp-tasks/' + name)(gulp, plugins, options)

reload = browserSync.reload
build = false

couchAppModules = ['updates', 'views', 'shows', 'lists', 'rewrites', 'validate']
kansoModules    = couchAppModules.concat(['types', 'fields'])

BUILD_DIR = "./www"
paths =
  root: ''
  coffee: 'src/coffee/'
  tmp:    'www/js'
  jade: 'src/views/'
  fonts: 'src/fonts/'
  sass: 'src/scss/'
  assets: 'assets/'
  output: BUILD_DIR + '/'
  js: BUILD_DIR + '/js/'
  vendorsIn: 'src/vendors/'
  vendorsOut: BUILD_DIR + '/vendors/'
  kanso:   ("models/**/#{modName}.js" for modName in kansoModules).concat ['lib/*']

onError = (error) ->
  gutil.beep()
  gutil.log gutil.colors.red error

gulp.task 'build', ['coffee', 'copy-vendors', 'jade', 'sass', 'build-app-file']

gulp.task 'kanso-files', ->
  gulp.src(paths.kanso)
    .pipe(plumber(onError))
    .pipe(gulp.dest('lib'))

gulp.task 'build-couchapp-files', ['kanso-files'], getTask('build-couchapp-files', {
  kansoModules: kansoModules
})

gulp.task 'build-app-file', ['build-couchapp-files'], getTask('build-app-file', {
  kansoModules: kansoModules
})

gulp.task 'sass', ->
  gulp.src paths.sass + '{app,lib}.scss'
  .pipe plumber(
    errorHandler: onError
  )
  .pipe sourcemaps.init()
  .pipe debug title: "sass:"
  .pipe sass
    errLogToConsole: true
    includePaths: ['bower_components/foundation/scss']
  .pipe sourcemaps.write({includeContent: false})
  .pipe sourcemaps.init({loadMaps: true})
  .pipe autoprefixer()
  .pipe sourcemaps.write()
  .pipe gulp.dest paths.output + "css/"
  .pipe reload stream: true

  return

gulp.task 'jade', ->
  pluginsJs = []
  pluginsCss = []
  pluginsHTML = []

  if (build)
    pluginsJs.push plugins.uglify()
    pluginsCss.push plugins.minifyCss()
    pluginsHTML.push plugins.minifyHtml()

  gulp.src(paths.jade + '**/*.jade')
  .pipe plumber(
    errorHandler: onError
  )
  .pipe jade
    pretty: true

  .pipe gulp.dest paths.output
  .pipe plugins.usemin(
    css: pluginsCss
    html: pluginsHTML
    js: pluginsJs)
  .pipe gulp.dest paths.output

gulp.task 'coffee', ->
  gulp.src paths.coffee + '**/*.coffee'
  .pipe plumber(
    errorHandler: onError
  )
  .pipe coffee bare: true
  .pipe gulp.dest paths.tmp

gulp.task 'browserify', ->
  filepath = './' + nodePath.join(paths.tmp, 'app.js')
  b = browserify({
    entries:      filepath
    cache:        {}
    packageCache: {}
  })
  b.bundle()
    .pipe(source('main.js'))
    .pipe(gulp.dest(paths.js))

gulp.task 'copy-assets', ->
  gulp.src paths.assets + '**/*.*'
  .pipe gulp.dest paths.output

gulp.task 'copy-vendors', ->
  gulp.src paths.vendorsIn + '**/*.*'
  .pipe gulp.dest paths.vendorsOut

gulp.task 'copy-fonts', (done) ->
  gulp.src [paths.fonts + '**/*.{woff,woff2,eot,ttf}', 'bower_components/' + '**/*.{woff,woff2,eot,ttf}']
  .pipe flatten()
  .pipe gulp.dest paths.output + "fonts/"
  .on 'end', done
  .pipe reload({stream: true})
  return

gulp.task 'jade-watch', ['jade'], ->#reload
#gulp.task 'coffee-watch', ['coffee'], reload
#gulp.task 'browserify-watch', ['browserify'], reload
gulp.task 'copy-vendors-watch', ['copy-vendors'], ->#reload
gulp.task 'copy-assets-watch', ['copy-assets'], ->#reload

gulp.task 'serve', ->
  proxyOptions = url.parse 'http://localhost:5984/canaperp'
  proxyOptions.route = '/_db'
  browserSync
    port: 4500
    open: false
    https: false
    ghostMode: false
    logConnections: true
    server:
      baseDir: paths.output
      middleware: [proxy(proxyOptions)]
    notify: false

  watch paths.coffee + "**/*.coffee", {interval: 300}, -> gulp.start 'coffee'
  watch paths.vendorsIn + "**/*.*", {interval: 300}, -> gulp.start 'copy-vendors-watch'
  #watch [paths.tmp + "**/*.js", "!**/main.js"], {interval: 300}, -> gulp.start 'browserify-watch'
  watch paths.jade + "**/*.jade", {interval: 300}, -> gulp.start 'jade-watch'
  watch paths.sass + "**/*.*", {interval: 300}, -> gulp.start 'sass'
  watch paths.assets + "**/*.*", {interval: 300}, -> gulp.start 'copy-assets-watch'
  return


gulp.task 'default', ['build', 'serve']
