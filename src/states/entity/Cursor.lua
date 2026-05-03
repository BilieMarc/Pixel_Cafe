Cursor = class {__includes = BaseEntity}

function Cursor:init()
    self.isDragging = false
    self.heldItem = nil
    self.type = 'Cursor'

    self.desired_width = 16
    self.desired_height = 16
end

function Cursor:update(dt)
end

function Cursor:render()
    if self.isDragging then
        if self.frame then
            BaseEntity.render(self)
        else
            -- Draw an amber coffee-drop circle; set color explicitly so we're
            -- never dependent on whatever the previous render call left behind.
            love.graphics.setColor(0.85, 0.55, 0.1, 1)
            love.graphics.circle('fill', mouseX, mouseY, 6, 12)
            love.graphics.setColor(0.2, 0.1, 0.0, 1)  -- dark outline
            love.graphics.circle('line', mouseX, mouseY, 6, 12)
            love.graphics.setColor(gColors['white'])         -- reset

            love.graphics.print(self.heldItem, mouseX + 10, mouseY - 10)
        end
    end
end

function Cursor:isDragged(item)
    self.isDragging = true
    if item.type == 'CoffeeMachine' then
        self.heldItem = 'Coffee'
    elseif item.type == 'BreadBasket' then
        self.heldItem = 'LoafOfBread'
    elseif item.type == 'BreadPlate' then
        self.heldItem = 'SliceOfBread'
    elseif item.type == 'SandwichPlate' then
        self.heldItem = 'Sandwich'
    end
    self.frame = gFrames[self.heldItem]
end

function Cursor:isReleased()
    self.isDragging = false
    self.heldItem = nil
end