DayEndState = class{__includes = BaseState}

function DayEndState:init()
end

function DayEndState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- End the DayEndState and return to the StartMenu
        gStateStack:pop()
        gStateStack:push(StartMenu())
    end
end

function DayEndState:render()
    --Font and text 
    love.graphics.setFont(PixelFont)
    love.graphics.printf('DayEndState', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
end
