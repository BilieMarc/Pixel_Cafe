PlayState = class {__includes = BaseState}

function PlayState:init()
    -- Default start: 8:00 AM
    self.dayTime  = 8 * 60
    self.timeScale = 15   -- 1 real second = 15 game minutes

    -- Customer system
    self.customerManager = CustomerManager()

    -- Core entities (NOT on the state stack — PlayState owns update/render)
    self.coffeeMachine = CoffeeMachine(COFFEE_MACHINE_ENTITY)
    self.cursor        = Cursor()

    -- Economy
    self.totalMoney   = 0
    self.floatingMoney = {}   -- list of active FloatingMoney objects
end

-- ─── Update ───────────────────────────────────────────────────────────────────

function PlayState:update(dt)
    -- Pause menu
    if love.keyboard.wasPressed('p') then
        gStateStack:pause()
        gStateStack:push(PauseMenu())
    end

    -- Day timer
    self.dayTime = self.dayTime + self.timeScale * dt
    if math.floor(self.dayTime / 60) >= 20 then
        gStateStack:clear()
        gStateStack:push(DayEndState())
    end

    -- Update subsystems (none of these are on the state stack)
    self.coffeeMachine:update(dt)
    self.cursor:update(dt)
    self.customerManager:update(dt)

    for _, customer in ipairs(self.customerManager:getAllCustomers()) do
        customer:update(dt)
    end

    -- Floating money cleanup
    for i = #self.floatingMoney, 1, -1 do
        local m = self.floatingMoney[i]
        m:update(dt)
        if not m.isActive then
            table.remove(self.floatingMoney, i)
        end
    end

    -- ── Mouse interactions ────────────────────────────────────────────────────
    -- Begin drag from coffee machine
    if love.mouse.wasPressed(1) then
        local cm = self.coffeeMachine
        if mouseX > cm.x and mouseX < cm.x + cm.desired_width and
           mouseY > cm.y and mouseY < cm.y + cm.desired_height then
            self.cursor:isDragged()
        end
    end

    -- Release: try to deliver to a customer
    if love.mouse.wasReleased(1) and self.cursor.isDragging then
        local hit = self:getCustomerAtMouse()
        if hit then
            self:deliverCoffee(hit)
        end
        self.cursor:isReleased()
    end
end

-- ─── Render ───────────────────────────────────────────────────────────────────
-- Render order (back → front):
--   1. Background outlines
--   2. HUD (time, money, customer count)
--   3. Customers           ← behind the counter
--   4. Coffee machine      ← counter, in front of customers
--   5. Floating money
--   6. Cursor              ← always on top

function PlayState:render()
    -- 1. Background outlines
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20,
                            VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)

    -- 2. HUD — time
    local hours      = math.floor(self.dayTime / 60)
    local minutes    = math.floor(self.dayTime % 60)
    local period     = hours % 24 >= 12 and 'P.M.' or 'A.M.'
    local displayH   = hours % 12
    if displayH == 0 then displayH = 12 end
    local timeString = string.format('%02d:%02d %s', displayH, minutes, period)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(timeString, 10, 2)

    -- HUD — money
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.print(string.format('$%.2f', self.totalMoney), VIRTUAL_WIDTH - 60, 2)

    -- HUD — customer count
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        string.format('In Cafe: %d/%d',
            self.customerManager:getOccupiedSlotCount(), #WAITING_SLOTS),
        10, 15)

    -- 3. Customers (behind counter)
    for _, customer in ipairs(self.customerManager:getAllCustomers()) do
        customer:render()
    end

    -- 4. Coffee machine (counter — draws over bottom of customer sprites)
    self.coffeeMachine:render()

    -- 5. Floating money
    for _, m in ipairs(self.floatingMoney) do
        m:render()
    end

    -- 6. Cursor — rendered absolutely last so it is always on top
    self.cursor:render()
end

-- ─── Helper functions ─────────────────────────────────────────────────────────

-- Returns the first WAITING customer under the mouse cursor, or nil.
function PlayState:getCustomerAtMouse()
    for _, c in ipairs(self.customerManager:getAllCustomers()) do
        if c.state == 'waiting' and c.orderBox and c.orderBox.isActive then
            if mouseX > c.x and mouseX < c.x + c.desired_width and
               mouseY > c.y and mouseY < c.y + c.desired_height then
                return c
            end
        end
    end
    return nil
end

-- Attempt to deliver coffee to the given customer.
function PlayState:deliverCoffee(customer)
    local success = customer:receiveItem('Coffee')
    if success then
        self:spawnFloatingMoney(customer)
    end
end

-- Spawn a FloatingMoney animation at the customer's position.
function PlayState:spawnFloatingMoney(customer)
    local amount = customer:getPaymentAmount()
    table.insert(self.floatingMoney, FloatingMoney({
        x      = customer.x + customer.desired_width / 2,
        y      = customer.y,
        amount = amount,
    }))
    self.totalMoney = self.totalMoney + amount
end

function PlayState:getTotalMoney()
    return self.totalMoney
end