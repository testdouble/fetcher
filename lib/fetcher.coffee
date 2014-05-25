_ = require('underscore')
downloadsRecipes = require('./downloads-recipes')
installsRecipes = require('./installs-recipes')

module.exports = (recipeName, options, cb = ->) ->
  if _(options).isFunction()
    cb = options
    options = null
  options = _({}).extend(defaultOptions(), options)

  downloadsRecipes.download options.recipeRepo, recipeName, (er, recipe) ->
    return cb(er) if er?
    installsRecipes.install options.cwd, recipe, (er) ->
      return cb(er) if er?
      console.log("Successfully installed '#{recipeName}'.")
      if recipe.message?
        console.log """
                    The '#{recipeName}' recipe left you this message:

                    ---
                    #{recipe.message}
                    ---
                    """
      cb(null, recipe)
  undefined

defaultOptions = ->
  recipeRepo: "git@github.com:linemanjs/fetcher-recipes.git"
  cwd: process.cwd()
