describe 'fetcher', ->
  Given -> @subject = require('../lib/fetcher')
  When -> @subject()
  Then -> #yay!
