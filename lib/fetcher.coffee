_ = require('underscore')
downloadsRecipes = require('./downloads-recipes')
installsRecipes = require('./installs-recipes')

module.exports = (recipeName, options, cb = ->) ->
  downloadsRecipes.cleanup()
  if _(options).isFunction()
    cb = options
    options = null
  options = _({}).extend(defaultOptions(), options)

  downloadsRecipes.download options.recipeRepo, recipeName, (er, recipe) ->
    return handleError(er, cb) if er?
    installsRecipes.install options.cwd, recipe, (er) ->
      return handleError(er, cb) if er?
      console.log("Successfully installed '#{recipeName}'.")
      if recipe.message?
        console.log """
                    The '#{recipeName}' recipe left you this message:

                    ---
                    #{recipe.message}
                    ---
                    """
      downloadsRecipes.cleanup()
      cb(null)
  undefined

defaultOptions = ->
  recipeRepo: "git@github.com:linemanjs/fetcher-recipes.git"
  cwd: process.cwd()

handleError = (er, cb) ->
  downloadsRecipes.cleanup()
  cb(er)
