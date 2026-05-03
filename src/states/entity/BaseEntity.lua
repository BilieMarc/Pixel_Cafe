BaseEntity = class {__includes = BaseState}

function BaseEntity:init(params)
    for k, v in pairs(params) do
        self[k] = v
    end
end

function BaseEntity:render()
    if self.type == 'Cursor' then
        self.x = mouseX
        self.y = mouseY
    end

    love.graphics.draw(self.frame, self.x, self.y, 0, 
        self.desired_width / self.frame:getWidth(), self.desired_height / self.frame:getHeight())
end

function BaseEntity:isMouseOver()
    return mouseX > self.x and mouseX < self.x + self.desired_width and
           mouseY > self.y and mouseY < self.y + self.desired_height
end