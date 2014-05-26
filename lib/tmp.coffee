path = require('path')
os = require('os')
mkdirp = require('mkdirp')
fs = require('fs')
rimraf = require('rimraf')

p = path.resolve(os.tmpdir(), "com.testdouble.npm.fetcher", String(new Date().getTime()))

module.exports =
  path: ->
    mkdirp.sync(p) unless fs.existsSync(p)
    p

  clean: ->
    rimraf.sync(p)
