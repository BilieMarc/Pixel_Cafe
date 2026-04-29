MoneyManager = class{__includes = BaseEntity}

function MoneyManager:init()
    self.totalMoney = gMoney or MONEY_CONFIG.startingMoney
    self.todayMoney = 0
    self.floatingMoney = {}

    self.displayMoney = self.totalMoney
end

function MoneyManager:calculatePayment(customer)
    local order        = customer.orderBox.order
    local basePrice    = order.price
    local patiencePct  = customer.patienceAtPayment / CUSTOMER_CONFIG.patienceMax
    local baseTip      = basePrice * CUSTOMER_CONFIG.baseTip
    local patienceTip  = basePrice * CUSTOMER_CONFIG.patienceBonus * patiencePct
    local raw          = basePrice + baseTip + patienceTip

    local unit = MONEY_CONFIG.minUnit
    return math.max(unit, math.floor(raw / unit + 0.5) * unit)
end

function MoneyManager:addPayment(amount)
    self.totalMoney = self.totalMoney + amount
    self.todayMoney = self.todayMoney + amount

    gMoney      = self.totalMoney
    gTodayMoney = self.todayMoney
end

function MoneyManager:spawnFloatingMoney(x, y, amount)
    table.insert(self.floatingMoney, FloatingMoney({
        x      = x,
        y      = y,
        amount = amount,
    }))
end

function MoneyManager:update(dt)
    if self.displayMoney < self.totalMoney then
        self.displayMoney = self.displayMoney + MONEY_CONFIG.countUpSpeed * dt
        if self.displayMoney >= self.totalMoney then
            self.displayMoney = self.totalMoney
        end
    elseif self.displayMoney > self.totalMoney then
        self.displayMoney = self.totalMoney
    end

    for i = #self.floatingMoney, 1, -1 do
        self.floatingMoney[i]:update(dt)
        if not self.floatingMoney[i].isActive then
            table.remove(self.floatingMoney, i)
        end
    end
end

function MoneyManager:render()
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(
        string.format('$%d', math.floor(self.displayMoney)),
        VIRTUAL_WIDTH - 200, 2, 60, 'right'
    )
    love.graphics.setColor(1, 1, 1, 1)

    for _, m in ipairs(self.floatingMoney) do
        m:render()
    end
end

function MoneyManager:getTotalMoney() return self.totalMoney end
function MoneyManager:getTodayMoney() return self.todayMoney end
