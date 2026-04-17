CoffeeMachine = class {__includes = BaseState}

function CoffeeMachine:enterParams(params)
    self = params
end

function CoffeeMachine:update(dt)
    
end

function CoffeeMachine:render()
    love.graphics.draw(gFrames['CoffeeMachine'], self.x, self.y, 0, 0.5, 0.5)
end