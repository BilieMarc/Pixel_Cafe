InputBox = class {__includes = BaseEntity}

function InputBox:init()
    self.GUI = true
    self.box = POPUP_INPUT_BOX
    self.font = gFonts['small']
    self.text = ""
    self.cursor = {
        position = 0,
        height = 5,
    }
    self.startType = false
end

function InputBox:update(dt)
end

function InputBox:render()
    love.graphics.setColor(self.box.color)
    love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.desired_width, self.box.desired_height)
    love.graphics.setColor(self.box.border)
    love.graphics.rectangle('line', self.box.x, self.box.y, self.box.desired_width, self.box.desired_height)
end

function InputBox:clicked()
    self.startType = true
end

return InputBox