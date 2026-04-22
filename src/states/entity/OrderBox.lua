-- OrderBox.lua
-- Renders the speech-bubble order box above a customer and manages patience.
-- Owned by CustomerState; update() must be called each frame from updateWaiting().

OrderBox = class{__includes = BaseState}

function OrderBox:init(params)
    params = params or {}

    -- Link to owning customer
    self.customer  = params.customer
    self.orderType = params.orderType or 'Coffee'

    -- Visual size and offset relative to customer
    self.width   = 34
    self.height  = 26
    self.offsetX = 15
    self.offsetY = -32

    -- Patience: 0-100, decays over time
    self.patience    = CUSTOMER_CONFIG.patienceMax
    self.maxPatience = CUSTOMER_CONFIG.patienceMax

    self.isActive = true
end

function OrderBox:update(dt)
    if not self.isActive or not self.customer then return end

    -- Decay patience
    self.patience = self.patience - CUSTOMER_CONFIG.patienceDecayRate * dt
    if self.patience < 0 then self.patience = 0 end

    -- Out of patience -> customer leaves without paying
    if self.patience <= 0 then
        self.isActive = false
        self.customer:leaveImpatient()
    end
end

function OrderBox:render()
    if not self.isActive or not self.customer then return end

    local boxX = self.customer.x + self.offsetX
    local boxY = self.customer.y + self.offsetY

    -- White box
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', boxX, boxY, self.width, self.height)

    -- Black border
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', boxX, boxY, self.width, self.height)

    -- Order label
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(self.orderType, boxX, boxY + 3, self.width, 'center')

    -- Patience bar background
    local pct    = self.patience / self.maxPatience
    local barW   = self.width - 4
    local barH   = 4
    local barX   = boxX + 2
    local barY   = boxY + self.height - 6

    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle('fill', barX, barY, barW, barH)

    -- Patience bar foreground (green / yellow / red)
    if pct > 0.5 then
        love.graphics.setColor(0.2, 0.8, 0.2, 1)
    elseif pct > 0.25 then
        love.graphics.setColor(1.0, 0.8, 0.2, 1)
    else
        love.graphics.setColor(0.8, 0.2, 0.2, 1)
    end
    love.graphics.rectangle('fill', barX, barY, barW * pct, barH)

    love.graphics.setColor(1, 1, 1, 1)
end

function OrderBox:getPatience()
    return self.patience / self.maxPatience   -- 0-1
end

function OrderBox:deactivate()
    self.isActive = false
end
