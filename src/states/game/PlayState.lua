PlayState = class {__includes = BaseState}

function PlayState:init()
    self.type = 'PlayState'

    self.timeManager = TimeManager()

    self.coffeeMachine = CoffeeMachine(COFFEE_MACHINE_ENTITY)
    self.cursor        = Cursor()
    self.customerManager = CustomerManager()
    self.timeManager = TimeManager()
    self.pauseButton = Button(BUTTON_PARAMS['Pause'])

    self.interactables = {
        self.coffeeMachine,
        self.pauseButton,
    }

    gStateStack:push(self.timeManager)
    gStateStack:push(self.customerManager)
    gStateStack:push(self.coffeeMachine)
    gStateStack:push(self.pauseButton)
    gStateStack:push(self.cursor)

    -- Economy
    self.totalMoney   = 0
    self.floatingMoney = {}   -- list of active FloatingMoney objects
end

-- ─── Update ───────────────────────────────────────────────────────────────────

function PlayState:update(dt)
    -- Floating money cleanup
    for i = #self.floatingMoney, 1, -1 do
        local m = self.floatingMoney[i]
        m:update(dt)
        if not m.isActive then
            table.remove(self.floatingMoney, i)
        end
    end

    --[[── Mouse interactions ────────────────────────────────────────────────────
    -- Begin drag from coffee machine
    if love.mouse.wasPressed(1) then
        local target = self:getInteractAt()

        if target then
            target:onPressed()

            if target.productionStage == 'Ready' then
                self.cursor:isDragged(target)
            end
        end
    end

    -- Release: try to deliver to a customer
    if love.mouse.wasReleased(1) and self.cursor.isDragging then
        local target = self:getInteractAt()

        if target and target.type == 'CustomerState' and target.orderBox then
            self:deliverItem(target)
            self.coffeeMachine:taken()
        end
        self.cursor:isReleased()
    end]]

    self:mouseResponse()
end

function PlayState:render()
    -- 1. Background outlines
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20,
                            VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)

    -- HUD — money
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(string.format('$%.2f', self.totalMoney), VIRTUAL_WIDTH - 150, 2)

    --[[ HUD — customer count
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        string.format('In Cafe: %d/%d',
            self.customerManager:getOccupiedSlotCount(), #WAITING_SLOTS),
        10, 15)]]

    -- 5. Floating money
    for _, m in ipairs(self.floatingMoney) do
        m:render()
    end
end

-- Attempt to deliver an item to the given customer.
function PlayState:deliverItem(customer)
    local success = customer:receiveItem(self.cursor.heldItem)
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