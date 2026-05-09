OrderBox = class{__includes = BaseEntity}

local ORDER_LABELS = {
    ['Coffee']       = 'Coffee',
    ['SliceOfBread'] = 'Bread',
    ['Sandwich']     = 'Sandwich',
}

local ORDER_COLORS = {
    ['Coffee']       = {0.15, 0.55, 0.75, 1},
    ['SliceOfBread'] = {0.75, 0.55, 0.15, 1},
    ['Sandwich']     = {0.45, 0.25, 0.65, 1},
}

function OrderBox:init(params)
    BaseEntity.init(self, params)

    self.orderType = AVAILABLE_ITEMS[math.random(#AVAILABLE_ITEMS)]
    self.order = ORDER_TYPES[self.orderType]

    self.width   = 54
    self.height  = 32
    self.offsetX = -11
    self.offsetY = -30
    self.tailH   = 5

    self.patience    = CUSTOMER_CONFIG.patienceMax
    self.maxPatience = CUSTOMER_CONFIG.patienceMax

    self.isActive = true
end

function OrderBox:update(dt)
    if not self.isActive or not self.customer then return end

    self.patience = self.patience - CUSTOMER_CONFIG.patienceDecayRate * dt
    if self.patience < 0 then self.patience = 0 end

    if self.patience <= 0 then
        self.isActive = false
        self.customer:leaveImpatient()
    end
end

function OrderBox:render()
    if not self.isActive or not self.customer then return end

    local bx = self.customer.x + self.offsetX
    local by = self.customer.y + self.offsetY
    local bw = self.width
    local bh = self.height

    love.graphics.setColor(0, 0, 0, 0.35)
    love.graphics.rectangle('fill', bx + 2, by + 2, bw, bh)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', bx, by, bw, bh)

    local hdrH     = 10
    local hdrColor = ORDER_COLORS[self.orderType] or {0.4, 0.4, 0.4, 1}
    love.graphics.setColor(hdrColor)
    love.graphics.rectangle('fill', bx, by, bw, hdrH)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    local label = ORDER_LABELS[self.orderType] or self.orderType
    love.graphics.printf(label, bx, by + 1, bw, 'center')

    local pct  = self.patience / self.maxPatience
    local barX = bx + 3
    local barY = by + hdrH + 9
    local barW = bw - 6
    local barH = 5

    love.graphics.setColor(0.25, 0.25, 0.25, 1)
    love.graphics.rectangle('fill', barX, barY, barW, barH)

    local r, g, b
    if pct > 0.5 then
        r, g, b = 0.2, 0.85, 0.3
    elseif pct > 0.25 then
        r, g, b = 0.95, 0.75, 0.1
    else
        r, g, b = 0.9, 0.2, 0.2
    end
    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle('fill', barX, barY, math.max(0, barW * pct), barH)

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', barX, barY, barW, barH)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', bx, by, bw, bh)

    local tx = bx + bw / 2
    local ty = by + bh
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon('fill', tx - 4, ty, tx + 4, ty, tx, ty + self.tailH)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(1)
    love.graphics.polygon('line', tx - 4, ty, tx + 4, ty, tx, ty + self.tailH)

    love.graphics.setColor(1, 1, 1, 1)
end

function OrderBox:getPatience()
    return self.patience / self.maxPatience
end

function OrderBox:deactivate()
    self.isActive = false
end
