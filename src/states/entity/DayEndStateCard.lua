DayEndStateCard = class {__includes = BaseState}

function DayEndStateCard:init(params)
    self.isGUI = true
    self.earnedToday = params.earnedToday
    self.finalTotal = params.finalTotal
end

function DayEndStateCard:render()
    local card = UI_CARD

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(gColors['white'])
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('DAY END', card.x, card.y + 6, card.width, 'center')

    love.graphics.setFont(gFonts['medium'])
    local line1Y = card.y + 45
    local line2Y = card.y + 65
    local labelOffset = 20
    -- Line 1: EARNED
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('EARNED', card.x + labelOffset, line1Y, card.width - labelOffset, 'left')
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.printf(string.format('$%.2f', self.earnedToday), card.x, line1Y, card.width - labelOffset, 'right')
    -- Line 2: TOTAL
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('TOTAL', card.x + labelOffset, line2Y, card.width - labelOffset, 'left')
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.printf(string.format('$%.2f', self.finalTotal), card.x, line2Y, card.width - labelOffset, 'right')
    love.graphics.setColor(1, 1, 1, 1)
end