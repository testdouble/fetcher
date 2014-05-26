request = require('request')
path = require('path')
fs = require('fs')

# Required propserties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `cwd`) to copy the file.
module.exports =
  install: (cwd, recipeStep, cb) ->
    console.log("Downloading '#{recipeStep.url}'...")
    request(recipeStep.url).pipe(fs.createWriteStream(path.resolve(cwd, recipeStep.dest))).on 'finish', ->
      console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
      cb(null)
