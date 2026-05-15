ShopTopBox = class {__includes = BaseState}

function ShopTopBox:init()
    self.isGUI = true
end

function ShopTopBox:render()
    love.graphics.setColor(gColors['red'])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.setColor(gColors['white'])
end