-- CustomerState.lua
-- State-driven customer lifecycle: MOVING_IN -> WAITING -> PAYING -> LEAVING -> DONE
-- Managed and updated/rendered directly by PlayState via CustomerManager.

CustomerState = class{__includes = BaseState}

function CustomerState:init(params)
    params = params or {}
    for k, v in pairs(params) do
        self[k] = v
    end

    -- Appearance
    local frameIndex  = math.random(#gFrames.customers)
    self.frame        = gFrames.customers[frameIndex]
    self.desired_width  = 64
    self.desired_height = 64

    -- Position: spawn at entrance, move linearly to assigned slot
    self.x     = ENTRANCE_X
    self.y     = self.slot.y
    self.slotX = self.slot.x
    self.slotY = self.slot.y

    -- State machine
    self.state      = 'moving_in'
    self.stateTimer = 0

    -- Order
    self.orderType = params.orderType or 'Coffee'
    self.order     = ORDER_TYPES[self.orderType]   -- {price, name}
    self.orderBox  = nil

    -- Payment
    self.patienceAtPayment = CUSTOMER_CONFIG.patienceMax
    self.totalPayment      = 0

    -- Flags
    self.leftImpatient = false
end

-- ─── Main update dispatcher ───────────────────────────────────────────────────

function CustomerState:update(dt)
    if     self.state == 'moving_in' then self:updateMovingIn(dt)
    elseif self.state == 'waiting'   then self:updateWaiting(dt)
    elseif self.state == 'paying'    then self:updatePaying(dt)
    elseif self.state == 'leaving'   then self:updateLeaving(dt)
    end
    -- 'done' state: no-op; CustomerManager removes the customer next frame
end

-- ─── Per-state update functions ───────────────────────────────────────────────

function CustomerState:updateMovingIn(dt)
    local distance = self.slotX - self.x
    if math.abs(distance) < 2 then
        self.x = self.slotX
        self.y = self.slotY
        self:setState('waiting')
    else
        local dir = distance > 0 and 1 or -1
        self.x = self.x + dir * CUSTOMER_CONFIG.moveSpeed * dt
    end
end

function CustomerState:updateWaiting(dt)
    self.stateTimer = self.stateTimer + dt

    -- Create order box on first frame of waiting
    if not self.orderBox then
        self.orderBox = OrderBox({customer = self, orderType = self.orderType})
    end

    -- Tick the order box (patience decay + impatient-leave trigger)
    if self.orderBox.isActive then
        self.orderBox:update(dt)
    end
end

function CustomerState:updatePaying(dt)
    -- Brief paying pause (0.5 s) before walking out
    self.stateTimer = self.stateTimer + dt
    if self.stateTimer >= 0.5 then
        self:setState('leaving')
    end
end

function CustomerState:updateLeaving(dt)
    if self.x < EXIT_X then
        self:setState('done')
    else
        local dir = (EXIT_X - self.x) > 0 and 1 or -1
        self.x = self.x + dir * CUSTOMER_CONFIG.moveSpeed * dt
    end
end

-- ─── Render ───────────────────────────────────────────────────────────────────

function CustomerState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.frame, self.x, self.y, 0,
        self.desired_width  / self.frame:getWidth(),
        self.desired_height / self.frame:getHeight()
    )

    -- Render order box while waiting (box manages its own isActive flag)
    if self.orderBox and self.orderBox.isActive then
        self.orderBox:render()
    end
end

-- ─── Public API ───────────────────────────────────────────────────────────────

function CustomerState:setState(newState)
    self.state      = newState
    self.stateTimer = 0
end

-- Called by PlayState when the player drags coffee onto this customer.
-- Strict check: itemType must match self.orderType (string comparison).
function CustomerState:receiveItem(itemType)
    if self.state ~= 'waiting' then return false end
    if itemType ~= self.orderType then return false end     -- wrong item

    -- Capture patience at payment time for tip calculation
    if self.orderBox then
        self.patienceAtPayment = self.orderBox.patience
        self.orderBox:deactivate()
    end

    -- Calculate total payment: base price + patience-scaled tip
    local patiencePct  = self.patienceAtPayment / CUSTOMER_CONFIG.patienceMax
    local baseTip      = self.order.price * CUSTOMER_CONFIG.baseTip
    local patienceTip  = self.order.price * CUSTOMER_CONFIG.patienceBonus * patiencePct
    local tipTotal     = baseTip + patienceTip
    self.totalPayment  = self.order.price + tipTotal

    self:setState('paying')
    return true
end

-- Called by OrderBox when patience hits 0.
function CustomerState:leaveImpatient()
    self.leftImpatient = true
    if self.orderBox then self.orderBox:deactivate() end
    self:setState('leaving')
end

function CustomerState:getPaymentAmount()  return self.totalPayment end
function CustomerState:getTipAmount()      return self.totalPayment - self.order.price end
function CustomerState:didLeaveImpatient() return self.leftImpatient end
function CustomerState:getSlotIndex()      return self.slotIndex end
