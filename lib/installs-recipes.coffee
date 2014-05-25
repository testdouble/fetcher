_ = require('underscore')
async = require('async')

module.exports =
  install: (cwd, recipe, cb) ->
    async.series installStepsFor(cwd, recipe.steps), (er, results) ->
      return cb(er) if er?
      cb(null, results)

installStepsFor = (cwd, steps) ->
  _(steps).map (step) ->
    (cb) ->
      installer = installerFor(step.type)
      if !installer? then return cb(new Error("This version of fetcher does not know how to install '#{step.type}' recipes."))
      installer.install(cwd, step, cb)

installerFor = (type) ->
  switch (type || "file")
    when "file"
      require('./installers/installs-files')
