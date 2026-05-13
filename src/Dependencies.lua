_G.love = require('love')

_G.class = require('src.libs.class')
_G.push  = require('src.libs.push')
require('src.libs.StateMachine')
require('src.libs.StateStack')
_G.suit  = require('src.libs.SUIT')
_G.json = require('src.libs.dkjson')

gFonts = {
    ['large']  = love.graphics.newFont('assets/font.ttf', 32),
    ['medium'] = love.graphics.newFont('assets/font.ttf', 16),
    ['small']  = love.graphics.newFont('assets/font.ttf', 8),
}

gFrames = {
    ['StartMenuBackground'] = love.graphics.newImage('assets/MainScreen.png'),
    ['CoffeeMachine'] = love.graphics.newImage('assets/coffeeMachine.jpg'),
    customers = {
        love.graphics.newImage('assets/Customer1.png'), -- Grumpy Old Man
    },
    ['LoafOfBread'] = love.graphics.newImage('assets/loafOfBread.png'),
    ['BreadBasket'] = love.graphics.newImage('assets/panOfLoavesOfBread.png'),
    ['SliceOfBread'] = love.graphics.newImage('assets/sliceOfBread.png'),
    ['BreadPlate'] = love.graphics.newImage('assets/panOfSlicesOfBread.png'),
    ['SandwichPlate'] = love.graphics.newImage('assets/sandwichPlate.png'),
}

-- Coffee Machine Animation Frames
gFrames['CoffeeMachineAnimation'] = {}
for i = 1, 10 do
    gFrames['CoffeeMachineAnimation'][i] = love.graphics.newImage('assets/CoffeeMachineAnimation/CoffeeMachine' .. i .. '.png')
end

require('src.Animation')
DataManager = require('src.DataManager')
require('src.constants')
InputBox = require('src.InputBox')

-- Audio loading
gMusic = love.audio.newSource('assets/music&SFX/Cafe Love - WOW Sound  The Boba Teashop Main Theme.mp3', 'stream')
gMusic:setLooping(true)
-- SFX 
gSounds = {
    ['click'] = love.audio.newSource('assets/music&SFX/SFX/mouse-click.mp3', 'static'),
}

require('src.states.BaseState')
require('src.states.game.PlayState')
require('src.states.game.StartMenu')
require('src.states.game.DayEndState')
require('src.states.game.PauseMenu')
require('src.states.game.PopupWindow')
require('src.states.game.SettingsState')

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
require('src.states.entity.BreadBasket')
require('src.states.entity.BreadPlate')
require('src.states.entity.SandwichPlate')

require('src.states.GUI.DayEndStateCard')
require('src.states.GUI.PauseMenuCard')
require('src.states.GUI.StartMenuBackground')
require('src.states.GUI.PopupWindowCard')