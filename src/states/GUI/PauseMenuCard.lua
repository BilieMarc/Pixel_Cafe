PauseMenuCard = class {__includes = BaseState}

function PauseMenuCard:init()
    self.isGUI = true
end

function PauseMenuCard:render()
    local card = UI_CARD

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(gColors['white'])
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', card.x, card.y + 6, card.width, 'center')
    love.graphics.setColor(gColors['white'])
end