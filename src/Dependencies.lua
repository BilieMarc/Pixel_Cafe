_G.love = require('love')

_G.class = require('src.libs.class')
_G.push = require('src.libs.push')
require('src.libs.StateMachine')
require('src.libs.StateStack')
_G.suit = require('src.libs.SUIT')

require('src.constants')

require('src.states.BaseState')
require('src.states.game.PlayState')
require('src.states.game.StartMenu')
require('src.states.game.DayEndState')