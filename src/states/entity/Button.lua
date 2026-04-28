Button = class {__includes = BaseEntity}

function Button:init(params)
    BaseEntity.init(self, params)
    self.isHovering = false
    self.isGUI = true
end

function Button:update(dt)
    if self:isMouseOver() then
        self.isHovering = true
    else
        self.isHovering = false
    end
end

function Button:render()
    if self.isHovering and self.clickable then
        love.graphics.setColor(gColors['yellow'])
    elseif self.clickable then
        love.graphics.setColor(gColors['white'])
    else
        love.graphics.setColor(gColors['gray'])
    end
    love.graphics.rectangle('fill', self.x, self.y, self.desired_width, self.desired_height)
    love.graphics.setColor(gColors['black'])
    love.graphics.setFont(gFonts['small'])
    local buffer = math.max(1, math.abs(self.desired_height - self.y) * 0.05)
    love.graphics.printf(self.text, self.x, self.y + buffer, self.desired_width, 'center')
    love.graphics.setColor(gColors['black'])
    love.graphics.rectangle('line', self.x, self.y, self.desired_width, self.desired_height)
    love.graphics.setColor(gColors['white'])
end

function Button:clicked()
    self.action()
end