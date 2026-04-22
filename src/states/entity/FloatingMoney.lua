-- FloatingMoney.lua
-- A short-lived entity that floats a "+$X.XX" amount upward then fades out.
-- Owned and updated/rendered directly by PlayState (NOT on the state stack).

FloatingMoney = class{__includes = BaseState}

function FloatingMoney:init(params)
    params = params or {}

    self.x      = params.x or 0
    self.y      = params.y or 0
    self.startY = self.y

    self.amount  = params.amount or 0

    -- Animation config
    self.lifetime      = 1.5   -- seconds total
    self.elapsed       = 0
    self.floatDistance = 40    -- pixels to float upward

    self.color    = params.color or {0.2, 0.8, 0.2}
    self.isActive = true
end

function FloatingMoney:update(dt)
    self.elapsed = self.elapsed + dt
    if self.elapsed >= self.lifetime then
        self.isActive = false
        -- PlayState removes this from its floatingMoney[] table when isActive == false.
        -- Do NOT call gStateStack:pop() — FloatingMoney is never pushed to the stack.
    end
end

function FloatingMoney:render()
    if not self.isActive then return end

    local progress = self.elapsed / self.lifetime
    local currentY = self.startY - self.floatDistance * progress
    local alpha    = 1 - progress

    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('+$' .. string.format('%.2f', self.amount), self.x, currentY)

    love.graphics.setColor(1, 1, 1, 1)
end

function FloatingMoney:getAmount()
    return self.amount
end
