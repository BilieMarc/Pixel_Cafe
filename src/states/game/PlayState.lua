PlayState = class {__includes = BaseState}

function PlayState:init()

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- End PlayState and enters DayEndState
        gStateStack:pop()
        gStateStack:push(DayEndState())
    end
end

function PlayState:render()
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20, VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)
    love.graphics.rectangle('line', 10, 25, 30, 0.40 * VIRTUAL_HEIGHT - 5)
end