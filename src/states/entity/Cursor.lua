Cursor = class {__includes = BaseState}

function Cursor:init()
    self.isDragging = false
    self.heldItem = nil
    self.type = Cursor
end

function Cursor:update(dt)
end

function Cursor:render()
    if self.isDragging then
        -- Draw an amber coffee-drop circle; set color explicitly so we're
        -- never dependent on whatever the previous render call left behind.
        love.graphics.setColor(0.85, 0.55, 0.1, 1)
        love.graphics.circle('fill', mouseX, mouseY, 6, 12)
        love.graphics.setColor(0.2, 0.1, 0.0, 1)  -- dark outline
        love.graphics.circle('line', mouseX, mouseY, 6, 12)
        love.graphics.setColor(1, 1, 1, 1)         -- reset
    end
end

function Cursor:isDragged(item)
    self.isDragging = true
    if item.type == 'CoffeeMachine' then
        self.heldItem = 'Coffee'
    end
end

function Cursor:isReleased()
    self.isDragging = false
    self.heldItem = nil
end