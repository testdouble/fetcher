request = require('request')
path = require('path')
fs = require('fs')
mkdirp = require('mkdirp')

# Required propserties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `options.cwd`) to copy the file.
module.exports =
  install: (options, recipeStep, cb) ->
    dest = path.resolve(options.cwd, recipeStep.dest)
    mkdirp.sync(path.dirname(dest))
    console.log("Downloading '#{recipeStep.url}'...")
    request(recipeStep.url).pipe(fs.createWriteStream(dest)).on 'finish', ->
      console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
      cb(null)
