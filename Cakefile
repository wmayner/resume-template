fs            = require 'fs'
{print}       = require 'util'
which         = require 'which'
{spawn, exec} = require 'child_process'
watch         = require 'nodewatch'
path          = require 'path'

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

execCoffee = (options, callback) ->
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

buildLess = (callback) ->
  exec 'lessc src/less/custom.less public/css/custom.css', (err, stdout, stderr) ->
    err && throw err
    log 'less compiled!', green
    callback?()

# Compiles app.coffee and src directory to the app directory
buildCoffee = (callback) ->
  execCoffee ['-c','-b', '-o', '.', 'src/app.coffee']
  execCoffee ['-c','-b', '-o', 'routes', 'src/routes']
  callback?()

build = (callback) ->
  buildCoffee -> buildLess -> callback?()

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
    cmd = which.sync 'mocha' 
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout 
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

docco = (target) ->
  fs.readdir target, (err, contents) ->
    files = ("#{target}/#{file}" for file in contents when /\.coffee$/.test file)
    try
      cmd = which.sync 'docco'
      docco = spawn cmd, files
      docco.stdout.pipe process.stdout
      docco.stderr.pipe process.stderr
      docco.on 'exit', (status) -> callback?() if status is 0
    catch err
      log err.message, red
      log 'Docco is not installed - try npm install docco -g', red

task 'docs', 'Generate annotated source code with Docco', ->
  docco "src"

task 'build', ->
  build -> log ":)", green

task 'spec', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'dev', 'start dev env', ->
  build -> log ":)", green
  # watch coffee in src
  execCoffee ['-c','-b', '-w', '-o', '.', 'src/app.coffee'],
    log 'Watching coffee files in src/app', green
  execCoffee ['-c', '-b', '-w', '-o', 'routes', 'src/routes'],
    log 'Watching coffee files in src/routes', green
  # watch less in src/less
  watch.add("./src/less", true).onChange((file,prev,curr,action) ->
    console.log(file)
    ext = path.extname(file).substr(1)
    if ext == 'less'
      buildLess
  )
  # watch_js
  supervisor = spawn 'node', ['./node_modules/supervisor/lib/cli-wrapper.js','-w','views,data,routes,public', '-e', 'js|jade|json|css', 'app']
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
  log 'Watching js, jade, json, and css files and running app', green
