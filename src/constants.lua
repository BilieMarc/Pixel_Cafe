WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

COFFEE_MACHINE_ENTITY = {
    frame = gFrames['CoffeeMachine'],
    x = 10,
    y = 130,
    desired_width = 32,
    desired_height = 32,
}

-- Customer waiting positions at the counter (slots).
-- y=55: sprite is 64px tall, bottom edge = y=119, clears counter at y=130.
WAITING_SLOTS = {
    {x = 60,  y = 55, id = 'left'},
    {x = 160, y = 55, id = 'center'},
    {x = 260, y = 55, id = 'right'},
}

-- Entrance (right, off-screen) and exit (left, off-screen)
ENTRANCE_X = 420
EXIT_X     = -70

-- Customer movement and behavior
CUSTOMER_CONFIG = {
    moveSpeed         = 100,  -- pixels per second
    spawnInterval     = 4,    -- seconds between arrivals
    patienceMax       = 100,  -- full patience value
    patienceDecayRate = 2,    -- patience lost per second while waiting
    baseTip           = 0.2,  -- 20% base tip
    patienceBonus     = 0.3,  -- up to 30% extra tip based on patience
}

MONEY_CONFIG = {
    startingMoney   = 50,
    minUnit         = 5,
    countUpSpeed    = 5, -- lowering countup speed is not looking good ( 120 is already fine ig)
}

UI_CARD = {
    width  = 200,
    height = 140,
    x      = VIRTUAL_WIDTH / 2 - 100,
    y      = VIRTUAL_HEIGHT / 2 - 70,
    color  = {0.15, 0.15, 0.2, 0.95},
    border = {0.6, 0.6, 0.7, 0.8},
}

PAUSE_MENU_CONFIG = {
    btnW = 100,
    btnH = 16,
    btnX = UI_CARD.x + UI_CARD.width / 2 - 50, -- 50 is btnW /2
    btnStartY = UI_CARD.y + 55,
    spacing = 22
}

AVAILABLE_ITEMS = {
    'Coffee',
}

-- Order types: name -> {price, name}
ORDER_TYPES = {
    ['Coffee'] = {price = 5, name = 'Coffee'},
}

gColors = {
    ['white'] = {1, 1, 1, 1},
    ['black'] = {0, 0, 0, 1},
    ['green'] = {0.2, 1, 0.2, 1},
    ['red'] = {1, 0.2, 0.2, 1},
    ['blue'] = {0.2, 0.2, 1, 1},
    ['yellow'] = {1, 1, 0.2, 1},
    ['purple'] = {0.5, 0.2, 0.5, 1},
    ['orange'] = {1, 0.5, 0, 1},
    ['gray'] = {0.5, 0.5, 0.5, 1},
    ['scarlet'] = {0.8, 0.25, 0.25, 1},
}

BUTTON_PARAMS = {
    ['Play'] = {
        text = 'Play',
        x = VIRTUAL_WIDTH / 2 - 16,
        y = VIRTUAL_HEIGHT / 2 - 16,
        desired_width = 32,
        desired_height = 16,
        action = function()
            gStateStack:clear()
            gStateStack:push(PlayState())
        end,
        clickable = true,
        defaultColor = gColors['white'],
        hoverColor = gColors['yellow'],
    },
    ['Pause'] = {
        text = '=',
        x = 5,
        y = 2,
        desired_width = 16,
        desired_height = 16,
        action = function()
            gStateStack:pause()
            gStateStack:push(PauseMenu())
        end,
        clickable = true,
        defaultColor = gColors['white'],
        hoverColor = gColors['yellow'],
    },
    ['Resume'] = {
        text = 'Resume',
        x = PAUSE_MENU_CONFIG.btnX,
        y = PAUSE_MENU_CONFIG.btnStartY,
        desired_width = PAUSE_MENU_CONFIG.btnW,
        desired_height = PAUSE_MENU_CONFIG.btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
        end,
        clickable = true,
        defaultColor = gColors['white'],
        hoverColor = gColors['yellow'],
    },
    ['Restart'] = {
        text = 'Restart',
        x = PAUSE_MENU_CONFIG.btnX,
        y = PAUSE_MENU_CONFIG.btnStartY + PAUSE_MENU_CONFIG.spacing,
        desired_width = PAUSE_MENU_CONFIG.btnW,
        desired_height = PAUSE_MENU_CONFIG.btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
            gStateStack:clear()
            gTodayMoney = 0
            gStateStack:push(PlayState())
        end,
        clickable = true,
        defaultColor = gColors['white'],
        hoverColor = gColors['yellow'],
    },
    ['PauseQuit'] = {
        text = 'Quit',
        x = PAUSE_MENU_CONFIG.btnX,
        y = PAUSE_MENU_CONFIG.btnStartY + PAUSE_MENU_CONFIG.spacing * 2,
        desired_width = PAUSE_MENU_CONFIG.btnW,
        desired_height = PAUSE_MENU_CONFIG.btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
            gStateStack:clear()
            gMoney = nil
            gTodayMoney = nil
            gStateStack:push(StartMenu())
        end,
        clickable = true,
        isQuit = true,
        defaultColor = gColors['red'],
        hoverColor = gColors['scarlet'],
    },
    ['NextDay'] = {
        text = 'NEXT DAY',
        x = UI_CARD.x + UI_CARD.width / 2 - 50,
        y = UI_CARD.y + 92,
        desired_width = 100,
        desired_height = 18,
        action = function()
            gStateStack:clear()
            gTodayMoney = 0
            
            -- Calculate the new balance for the next day
            gStartingBalance = (gStartingBalance or (gMoney or 0)) + (gDailySales or 0) + (gDailyTips or 0)
            
            gDailySales = 0
            gDailyTips = 0
            gCurrentDay = (gCurrentDay or 1) + 1
            
            gStateStack:push(PlayState())
        end,
        clickable = true,
        defaultColor = gColors['white'],
        hoverColor = gColors['yellow'],
    },
    ['Quit'] = {
        text = 'QUIT',
        x = UI_CARD.x + UI_CARD.width / 2 - 40,
        y = UI_CARD.y + 115,
        desired_width = 80,
        desired_height = 18,
        action = function()
            love.event.quit()
        end,
        clickable = true,
        defaultColor = gColors['red'],
        hoverColor = gColors['scarlet'],
    }
}