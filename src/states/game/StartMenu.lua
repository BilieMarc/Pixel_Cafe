StartMenu = class{__includes = BaseState}

function StartMenu:init()
end

function StartMenu:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- End StartMenu and enters PlayState
        gStateStack:pop()
        local playState = PlayState()
        playState:enterParams({timeOfDay = 8})
        gStateStack:push(playState)
    end
end

function StartMenu:render()
    --Font and text 
    love.graphics.setFont(PixelFont)
    love.graphics.printf('Start Menu', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
end