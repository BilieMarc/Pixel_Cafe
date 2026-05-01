_G.love = require('love')

_G.class = require('src.libs.class')
_G.push  = require('src.libs.push')
require('src.libs.StateMachine')
require('src.libs.StateStack')
_G.suit  = require('src.libs.SUIT')

gFonts = {
    ['large']  = love.graphics.newFont('assets/FortAvenue-nAWrg.ttf', 32),
    ['medium'] = love.graphics.newFont('assets/FortAvenue-nAWrg.ttf', 16),
    ['small']  = love.graphics.newFont('assets/FortAvenue-nAWrg.ttf', 8),
}

gFrames = {
    ['StartMenuBackground'] = love.graphics.newImage('assets/MainScreen.png'),
    ['CoffeeMachine'] = love.graphics.newImage('assets/coffeeMachine.jpg'),
    customers = {
        love.graphics.newImage('assets/Customer1.png'), -- Grumpy Old Man
    }
}

require('src.constants')

require('src.states.BaseState')
require('src.states.game.PlayState')
require('src.states.game.StartMenu')
require('src.states.game.DayEndState')
require('src.states.game.PauseMenu')

require('src.states.entity.BaseEntity')
require('src.states.entity.CoffeeMachine')
require('src.states.entity.CustomerState')
require('src.states.entity.CustomerManager')
require('src.states.entity.OrderBox')
require('src.states.entity.FloatingMoney')
require('src.states.entity.MoneyManager')
require('src.states.entity.Cursor')
require('src.states.entity.TimeManager')
require('src.states.entity.Button')
require('src.states.entity.PauseMenuCard')
require('src.states.entity.DayEndStateCard')