CustomerState = class{__includes = BaseEntity}

local function randomChoice(list)
    return list[math.random(#list)]
end

local animate = function(self, animationState)
    if self.animationState ~= animationState then
        self.animationState = animationState
        
        local def = ANIMATION_DEFS.getCustomerAnimationDef(self.customerType, self.animationState)
        self.animation = Animation(def)
        
        -- If using a spritesheet texture, explicitly let the entity store it
        if def.texture then
            self.texture = def.texture
        end
    end
    return self.animation
end

function CustomerState:init(params)
    BaseEntity.init(self, params)
    self.type = 'CustomerState'
    self.customerType = randomChoice{
        'LegLady',
        'ArmEater',
        'Headless',
    }
    
    -- Appearance
    self.animation = animate(self, 'idle')
    
    -- FIXED: Changed getFrame() to getCurrentFrame() with an explicit asset fallback
    self.frame = (self.animation and self.animation:getCurrentFrame()) or gFrames.customers[self.customerType]
    
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

    -- Payment
    self.patienceAtPayment = CUSTOMER_CONFIG.patienceMax
    self.totalPayment      = 0

    -- Flags
    self.leftImpatient = false
end

-- ─── Main update dispatcher ───────────────────────────────────────────────────

function CustomerState:update(dt)
    if self.animation then
        -- FIXED: GD50 animation update only requires 'dt'
        self.animation:update(dt)
        
        -- FIXED: Changed getFrame() to getCurrentFrame()
        local frame = self.animation:getCurrentFrame()
        if frame then
            self.frame = frame
        end
    end
    
    -- State updates remain exactly the same
    if     self.state == 'moving_in' then self:updateMovingIn(dt)
    elseif self.state == 'waiting'   then self:updateWaiting(dt)
    elseif self.state == 'paying'    then self:updatePaying(dt)
    elseif self.state == 'leaving'   then self:updateLeaving(dt)
    end
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
    animate(self, 'walk')
end

function CustomerState:updateWaiting(dt)
    self.stateTimer = self.stateTimer + dt

    -- Create order box on first frame of waiting
    if not self.orderBox then
        self.orderBox = OrderBox({customer = self})
    end

    -- Tick the order box (patience decay + impatient-leave trigger)
    if self.orderBox.isActive then
        self.orderBox:update(dt)
    end
    animate(self, 'idle')
end

function CustomerState:updatePaying(dt)
    -- Brief paying pause (0.5 s) before walking out
    self.stateTimer = self.stateTimer + dt
    if self.stateTimer >= 0.5 then
        self:setState('leaving')
    end
    animate(self, 'idle')
end

function CustomerState:updateLeaving(dt)
    if self.x < EXIT_X then
        self:setState('done')
    else
        local dir = (EXIT_X - self.x) > 0 and 1 or -1
        self.x = self.x + dir * CUSTOMER_CONFIG.moveSpeed * dt
    end
    animate(self, 'walk')
end

-- ─── Render ───────────────────────────────────────────────────────────────────

function CustomerState:render()
    BaseEntity.render(self)

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

function CustomerState:receiveItem(itemType)
    if self.state ~= 'waiting' then return false end

    self.isOrderCorrect = (itemType == self.orderBox.orderType)

    if self.isOrderCorrect then
        if self.orderBox then
            self.patienceAtPayment = self.orderBox.patience
            self.orderBox:deactivate()
        end
        self:setState('paying')
        return true
    else
        -- Penalty for wrong order type
        if self.orderBox then
            self.orderBox:decreasePatience(CUSTOMER_CONFIG.wrongOrderPatiencePenalty or 10)
        end
        return false
    end
end

-- Called by OrderBox when patience hits 0.
function CustomerState:leaveImpatient()
    self.leftImpatient = true
    if self.orderBox then self.orderBox:deactivate() end
    self:setState('leaving')
end

function CustomerState:leave()
    if self.orderBox then self.orderBox:deactivate() end
    self:setState('leaving')
end

function CustomerState:getPaymentAmount()  return self.totalPayment end
function CustomerState:getTipAmount()      return self.totalPayment - self.orderBox.order.price end
function CustomerState:didLeaveImpatient() return self.leftImpatient end
function CustomerState:getSlotIndex()      return self.slotIndex end
