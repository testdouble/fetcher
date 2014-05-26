path = require('path')
mkdirp = require('mkdirp')
downloadsFiles = require('./../downloads-files')
copiesStuff = require('./../copies-stuff')

# Required properties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `options.cwd`) to copy the file.
module.exports =
  install: (options, recipeStep, cb) ->
    dest = path.resolve(options.cwd, recipeStep.dest)
    mkdirp.sync(path.dirname(dest))
    downloadsFiles.download recipeStep.url, (er, src) ->
      return cb(er) if er?
      copiesStuff.copy src, dest, (er) ->
        return cb(er) if er?
        console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
        cb(null)
