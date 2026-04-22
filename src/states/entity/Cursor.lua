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
        love.graphics.circle('fill', mouseX, mouseY, 5, 5)
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