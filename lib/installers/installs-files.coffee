http = require('http')
path = require('path')
fs = require('fs')


# Required propserties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `cwd`) to copy the file.
module.exports =
  install: (cwd, recipeStep, cb) ->
    file = fs.createWriteStream(path.resolve(cwd, recipeStep.dest))
    console.log("Downloading '#{recipeStep.url}'...")
    http.get recipeStep.url, (result) ->
      file.on 'finish', ->
        file.close ->
          console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
          cb(null)

      result.pipe(file)
