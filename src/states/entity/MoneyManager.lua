MoneyManager = class{__includes = BaseEntity}

function MoneyManager:init()
    self.totalMoney = gMoney or MONEY_CONFIG.startingMoney
    self.todayMoney = 0
    self.floatingMoney = {}

    self._startingBalance = self.totalMoney
    self._dailySalesAmount = 0
    self._dailyTipsAmount = 0

    self.displayMoney = self.totalMoney
end

function MoneyManager:calculatePayment(customer)
    local order        = customer.orderBox.order
    local basePrice    = order.price

    if not customer.isOrderCorrect then
        local penaltyPrice = basePrice * 0.5
        return penaltyPrice, penaltyPrice, 0
    end

    local patience = customer.patienceAtPayment
    local tip = 0

    if patience >= 80 then
        tip = basePrice * 0.10
    elseif patience >= 50 then
        tip = basePrice * 0.05
    elseif patience >= 20 then
        tip = basePrice * 0.02
    end

    -- Add a random variance of +/- 10 cents (-10 to 10 cents)
    local varianceCents = math.random(-10, 10)
    tip = tip + (varianceCents / 100)

    -- Ensure tip doesn't exceed 10% of base price, and doesn't drop below 0
    local maxTip = basePrice * 0.10
    if tip > maxTip then tip = maxTip end
    if tip < 0 then tip = 0 end

    return basePrice + tip, basePrice, tip
end

function MoneyManager:addPayment(amount, base, tip)
    self.totalMoney = self.totalMoney + amount
    self.todayMoney = self.todayMoney + amount

    self._dailySalesAmount = self._dailySalesAmount + (base or amount)
    self._dailyTipsAmount = self._dailyTipsAmount + (tip or 0)

    gMoney      = self.totalMoney
    gTodayMoney = self.todayMoney
    
    gDailySales = self._dailySalesAmount
    gDailyTips = self._dailyTipsAmount
    gStartingBalance = self._startingBalance
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
        string.format('$%.2f', self.displayMoney),
        VIRTUAL_WIDTH - 200, 2, 60, 'right'
    )
    love.graphics.setColor(1, 1, 1, 1)

    for _, m in ipairs(self.floatingMoney) do
        m:render()
    end
end

function MoneyManager:getTotalMoney() return self.totalMoney end
function MoneyManager:getTodayMoney() return self.todayMoney end
