request = require('request')
path = require('path')
fs = require('fs')

# Required propserties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `options.cwd`) to copy the file.
module.exports =
  install: (options, recipeStep, cb) ->
    console.log("Downloading '#{recipeStep.url}'...")
    request(recipeStep.url).pipe(fs.createWriteStream(path.resolve(options.cwd, recipeStep.dest))).on 'finish', ->
      console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
      cb(null)
