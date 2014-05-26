path = require('path')
mkdirp = require('mkdirp')
downloadsFile = require('./../downloads-file')
ncp = require('ncp')

# Required propserties:
#  * url - the url of the uncompressed, unminified file
#  * dest - the location (relative to `options.cwd`) to copy the file.
module.exports =
  install: (options, recipeStep, cb) ->
    dest = path.resolve(options.cwd, recipeStep.dest)
    mkdirp.sync(path.dirname(dest))
    downloadsFile.download recipeStep.url, (er, src) ->
      return cb(er) if er?
      ncp src, dest, (er) ->
        return cb(er) if er?
        console.log("Downloaded '#{recipeStep.url}' to '#{recipeStep.dest}'")
        cb(null)
