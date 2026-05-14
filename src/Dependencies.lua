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
    ['CoffeeMachine'] = love.graphics.newImage('assets/coffeeMachine.png'),
    customers = {
        love.graphics.newImage('assets/Customer1.png'), -- Grumpy Old Man
    },
    ['Coffee'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume4by4.png'),
    ['LoafOfBread'] = love.graphics.newImage('assets/loafOfBread.png'),
    ['BreadBasket'] = love.graphics.newImage('assets/panOfLoavesOfBread.png'),
    ['SliceOfBread'] = love.graphics.newImage('assets/sliceOfBread.png'),
    ['BreadPlate'] = love.graphics.newImage('assets/panOfSlicesOfBread.png'),
    ['SandwichPlate'] = love.graphics.newImage('assets/sandwichPlate.png'),
    ['EmptyTray'] = love.graphics.newImage('assets/Cups and stack/EmptyTray.png'),
    ['CoffeeCupStack'] = love.graphics.newImage('assets/Cups and stack/coffeecupstack.png'),
    ['DisposableCoffeeCup'] = love.graphics.newImage('assets/Cups and stack/DisposableCoffeeCup.png'),
    ['DisposableCoffeeCupFilled'] = love.graphics.newImage('assets/Cups and stack/DisposableCoffeeCupFilled.png'),
    ['TrayWithEmptyCups1'] = love.graphics.newImage('assets/Cups and stack/TrayWithEmptyCups1.png'),
    ['TrayWithEmptyCups2'] = love.graphics.newImage('assets/Cups and stack/TrayWithEmptyCups2.png'),
    ['TrayWithEmptyCups3'] = love.graphics.newImage('assets/Cups and stack/TrayWithEmptyCups3.png'),
    ['TrayWithEmptyCups4'] = love.graphics.newImage('assets/Cups and stack/TrayWithEmptyCups4.png'),
    ['TrayWithCupsFilled1'] = love.graphics.newImage('assets/Cups and stack/TrayWithCupsFilled1.png'),
    ['TrayWithCupsFilled2'] = love.graphics.newImage('assets/Cups and stack/TrayWithCupsFilled2.png'),
    ['TrayWithCupsFilled3'] = love.graphics.newImage('assets/Cups and stack/TrayWithCupsFilled3.png'),
    ['TrayWithCupsFilled4'] = love.graphics.newImage('assets/Cups and stack/TrayWithCupsFilled4.png'),
    -- Mixed fill stages: [N]CupsFillStage[filled]by[total]
    ['FourCupFillStage1by4'] = love.graphics.newImage('assets/Cups and stack/CupFillStage4/FourCupFillStage1by4.png'),
    ['FourCupFillStage2by4'] = love.graphics.newImage('assets/Cups and stack/CupFillStage4/FourCupFillStage2by4.png'),
    ['FourCupFillStage3by4'] = love.graphics.newImage('assets/Cups and stack/CupFillStage4/FourCupFillStage3by4.png'),
    ['ThreeCupsFillStage1by3'] = love.graphics.newImage('assets/Cups and stack/CupFillStage3/ThreeCupsFillStage1by3.png'),
    ['ThreeCupsFillStage2by3'] = love.graphics.newImage('assets/Cups and stack/CupFillStage3/ThreeCupsFillStage2by3.png'),
    ['TwoCupsFillStage1by2'] = love.graphics.newImage('assets/Cups and stack/CupFillStage2/2CupsFillStage1by2.png'),
}

-- Coffee Machine Animation Frames
gFrames['CoffeeMachineAnimation'] = {}
for i = 1, 11 do
    gFrames['CoffeeMachineAnimation'][i] = love.graphics.newImage('assets/CoffeeMachineAnimation/CoffeeMachine' .. i .. '.png')
end
gFrames['CoffeeMachineHold'] = love.graphics.newImage('assets/CoffeeMachineAnimation/CoffeeMachineHold.png')



-- CoffeeMachine fill stage frames: 4=full jar (4/4), 1=almost empty (1/4)
gFrames['CoffeeMachinesFillStages4'] = love.graphics.newImage('assets/Fill stages/CoffeeMachinesFillStages4.png')
gFrames['CoffeeMachinesFillStages3'] = love.graphics.newImage('assets/Fill stages/CoffeeMachinesFillStages3.png')
gFrames['CoffeeMachinesFillStages2'] = love.graphics.newImage('assets/Fill stages/CoffeeMachinesFillStages2.png')
gFrames['CoffeeMachinesFillStages1'] = love.graphics.newImage('assets/Fill stages/CoffeeMachinesFillStages1.png')

-- Jar volume stages for dragging
gFrames['CoffeeJarVolume0by4'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume0by4.png')
gFrames['CoffeeJarVolume1by4'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume1by4.png')
gFrames['CoffeeJarVolume2by4'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume2by4.png')
gFrames['CoffeeJarVolume3by4'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume3y4.png')
gFrames['CoffeeJarVolume4by4'] = love.graphics.newImage('assets/JarVolumeStages/CoffeeJarVolume4by4.png')


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
require('src.states.entity.CoffeeCupStack')
require('src.states.entity.CoffeeTray')

require('src.states.GUI.DayEndStateCard')
require('src.states.GUI.PauseMenuCard')
require('src.states.GUI.StartMenuBackground')
require('src.states.GUI.PopupWindowCard')