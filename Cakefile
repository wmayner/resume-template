fs            = require 'fs'
{print}       = require 'util'
which         = require 'which'
{spawn, exec} = require 'child_process'
watchr        = require 'watchr'
path          = require 'path'

###########
# Helpers #
########################################

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg = JSON.parse fs.readFileSync('./package.json')
testCmd = pkg.scripts.test
startCmd = pkg.scripts.start

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

execute = (cmd, options, callback) ->
  command = spawn cmd, options
  command.stdout.pipe process.stdout
  command.stderr.pipe process.stderr
  command.on 'exit', (status) -> callback?() if status is 0

prefixer = (inputFiles, outputFile, callback) ->
  exec 'cssprefixer '+inputFiles+' > '+outputFile+' --minify', (err, stdout, stderr) ->
    log 'prefixed '+inputFiles+' to '+outputFile, green 
    callback?()

lessc = (inputFiles, outputFile, callback) ->
  exec "node_modules/less/bin/lessc #{inputFiles} #{outputFile}", (err, stdout, stderr) ->
    log 'compiled '+inputFiles+' to '+outputFile, green 
    callback?()

####################
# Project-specific #
########################################

# Compiles app.coffee and src directory to the app directory
buildCoffee = (callback) ->
  execute 'node_modules/coffee-script/bin/coffee', ['-c','-b', '-o', '.', 'src/app.coffee'],
    log 'compiled app.coffee', green
  execute 'node_modules/coffee-script/bin/coffee', ['-c','-b', '-o', 'routes', 'src/routes'],
    log 'compiled routes', green
  callback?()

# mocha test
test = (callback) ->
  options = [
    '--compilers'
    'coffee:coffee-script'
    '--colors'
    '--require'
    'should'
    '--require'
    './app'
  ]
  try
    execute 'node_modules/mocha/bin/mocha', options, callback?()
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

# generate coffee docs
docco = (target) ->
  fs.readdir target, (err, contents) ->
    files = ("#{target}/#{file}" for file in contents when /\.coffee$/.test file)
    try
      execute 'node_modules/docco/bin/docco', files, callback?()
    catch err
      log err.message, red
      log 'Docco is not installed - try npm install docco -g', red

# compile custom.less
buildLess = (callback) ->
  lessc 'src/less/custom.less', 'src/css/custom.css', callback?()

# prefix custom.css
prefixCSS = (callback) ->
  prefixer 'src/css/custom.css', 'public/css/custom.css', callback
  prefixer 'src/css/print.css', 'public/css/print.css', callback

# build the whole project
build = (callback) ->
  buildCoffee -> buildLess -> prefixCSS -> callback?()

#########
# Tasks #
########################################

task 'build', 'compile, minify, and prefix everything', ->
  build -> log ":)", green

task 'prefixcss', 'add cross-browser compatibility to css', ->
  prefixCSS -> log "prefixed CSS!", green

task 'docs', 'generate annotated source code with Docco', ->
  docco "src"

task 'spec', 'run mocha tests', ->
  build -> test -> log ":)", green

task 'dev', 'start dev env', ->
  #initial build
  build -> log ":)", green

  # watch coffee in src
  execute 'node_modules/coffee-script/bin/coffee',
    ['-c','-b', '-w', '-o', '.', 'src/app.coffee'],
    log 'Watching coffee files in src/app', green
  execute 'node_modules/coffee-script/bin/coffee',
    ['-c', '-b', '-w', '-o', 'routes', 'src/routes'],
    log 'Watching coffee files in src/routes', green

  # prefix css
  watchr.watch {
    path: 'src/css/'
  , listeners: {
    , log: (logLevel) ->
        console.log 'watchr log:', arguments
    , error: (err) ->
        log 'prefixer:', err, green
    , watching: (err, watcherInstance, isWatching) ->
        if (err)
          log "Failed to watch #{watcherInstance.path} with error", err, green 
        else
          log 'Watching CSS in '+watcherInstance.path, green
    , change: (changeType, filePath, fileCurrentStat, filePreviousStat) ->
        prefixer filePath, 'public/css/'+path.basename(filePath)
    }
  }
  watchr.watch {
    path: 'src/less/'
  , listeners: {
    , log: (logLevel) ->
        console.log 'watchr log:', arguments
    , error: (err) ->
        log 'lessc:', err, green
    , watching: (err, watcherInstance, isWatching) ->
        if (err)
          log "Failed to watch #{watcherInstance.path} with error", err, green 
        else
          log 'Watching Less in '+watcherInstance.path, green
    , change: (changeType, filePath, fileCurrentStat, filePreviousStat) ->
        lessc filePath, 'src/css/'+path.basename(filePath).split(path.extname(filePath))[0]+'.css'
    }
  }

  # auto restart node with supervisor
  supervisor = spawn 'node', [
    './node_modules/supervisor/lib/cli-wrapper.js'
    ,'-w'
    ,'views,routes,data'
    ,'-e'
    ,'js|jade|json|css'
    ,'app'
  ]
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
