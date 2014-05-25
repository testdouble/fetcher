# Give it a git repo, get back an install recipe for fetcher.
#
# The repo needs to look like this:
#  .
#  └── recipes
#      └── backbone.cson
#
# .download method will invoke callback with an object
# representing the requested recipe
#
# e.g. calling `download("git@github.com:linemanjs/fetcher-recipes.git", "backbone", function(recipe){ console.log(recipe)})`
# on this object would fetch the repo, print the backbone recipe out, and delete the fetched repo.
#
path = require('path')
os = require('os')
mkdirp = require('mkdirp')
fs = require('fs')
CSON = require('cson-safe')
rimraf = require('rimraf')

module.exports =
  download: (gitRepo, recipeName, cb) ->
    p = path.resolve(os.tmpdir(), "com.testdouble.npm.fetcher", String(new Date().getTime()))
    mkdirp.sync(p)
    cloneGitRepo gitRepo, p, (er, repoPath) ->
      return cb(er) if er?
      recipePath = path.resolve(repoPath, "recipes", "#{recipeName}.cson")
      return cb(new Error("Recipe '#{recipeName}' was not found.")) unless fs.existsSync(recipePath)
      content = fs.readFileSync(recipePath).toString()
      cb(null, CSON.parse(content))
      rimraf.sync(p)

which = require('which')
exec = require("child_process").execFile
cloneGitRepo = (gitRepo, cwd, cb) ->
  console.log("Fetching recipes from '#{gitRepo}'...")
  exec which.sync('git'), ["clone", gitRepo, "recipe-repo"], {cwd}, (er, stdout, stderr) ->
    return cb(er) if er?
    cb(null, path.resolve(cwd, "recipe-repo"))
