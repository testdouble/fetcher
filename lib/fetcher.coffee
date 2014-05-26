_ = require('underscore')
downloadsRecipes = require('./downloads-recipes')
installsRecipes = require('./installs-recipes')
async = require('async')

module.exports = (recipe, options, cb = ->) ->
  if _(options).isFunction()
    cb = options
    options = null
  options = _({}).extend(defaultOptions(), options)
  recipes = if _(recipe).isArray() then recipe else [recipe]
  downloadsRecipes.cleanup() if options.cleanTmpDirBeforeFetching

  async.series fetchesFor(options, recipes), (er, results) ->
    downloadsRecipes.cleanup()
    return cb(er) if er?
    cb(null)

  undefined

defaultOptions = ->
  recipeRepo: "git@github.com:linemanjs/fetcher-recipes.git"
  cwd: process.cwd()
  cleanTmpDirBeforeFetching: true

fetchesFor = (options, recipes) ->
  _(recipes).map (recipeName) ->
    (cb) ->
      downloadsRecipes.download options.recipeRepo, recipeName, (er, recipe) ->
        return cb(er) if er?
        installsRecipes.install options, recipe, (er) ->
          return cb(er) if er?
          console.log("Successfully installed '#{recipeName}'.")
          if recipe.message?
            console.log """
                        The '#{recipeName}' recipe left you this message:

                        ---
                        #{recipe.message}
                        ---
                        """
          cb(null)
