DayEndState = class{__includes = BaseState}

function DayEndState:init()
    self.totalMoney = gMoney or 0
    self.todayMoney = gTodayMoney or 0

    local card = UI_CARD
    local btnW = 100
    local btnH = 16
    local btnX = card.x + card.width / 2 - btnW / 2

    self.nextDayButton = Button({
        text = 'Next Day',
        x = btnX,
        y = card.y + card.height - 30,
        desired_width = btnW,
        desired_height = btnH,
        action = function()
            gStateStack:clear()
            gTodayMoney = 0
            gStateStack:push(PlayState())
        end,
        clickable = true,
    })

    self.buttons = {
        self.nextDayButton,
    }

    self.interactables = self.buttons
end

function DayEndState:update(dt)
    for _, btn in ipairs(self.buttons) do
        btn:update(dt)
    end

    self:mouseResponse()
end

function DayEndState:render()
    local card = UI_CARD

    love.graphics.setColor(0, 0, 0, 150 / 255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('DAY END', card.x, card.y + 8, card.width, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.printf(
        string.format("Earned:  $%d", self.todayMoney),
        card.x, card.y + 50, card.width, 'center'
    )
    love.graphics.printf(
        string.format('Total:  $%d', self.totalMoney),
        card.x, card.y + 72, card.width, 'center'
    )
    love.graphics.setColor(1, 1, 1, 1)

    for _, btn in ipairs(self.buttons) do
        btn:render()
    end
end
