PopupWindowCard = class {__includes = BaseState}

function PopupWindowCard:init(text)
    for index, value in pairs(POPUP_WINDOW_CONFIG) do
        self[index] = value
    end
    self.topBorderHeight = math.abs(self.height / 5)
    self.text = text
end

function PopupWindowCard:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(gColors['white'])

    love.graphics.setColor(self.border)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(gColors['white'])

    local buffer = 1

    love.graphics.setColor(gColors['gray'])
    love.graphics.rectangle('fill', self.x + buffer, self.y + buffer, self.width - buffer * 2, self.topBorderHeight)
    love.graphics.setColor(gColors['white'])

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(gColors['black'])
    love.graphics.printf(self.text, self.x + buffer * 3, self.y + self.topBorderHeight + buffer * 3, self.width - buffer * 2, 'center')
    love.graphics.setColor(gColors['white'])
end