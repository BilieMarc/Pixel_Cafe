BaseEntity = class {__includes = BaseState}

function BaseEntity:init(params)
    for k, v in pairs(params) do
        self[k] = v
    end

    self._isBubbleActive = false
    self._bubbleColor = gColors['white']
end

function BaseEntity:isMouseOver()
    return mouseX > self.x and mouseX < self.x + self.desired_width and
           mouseY > self.y and mouseY < self.y + self.desired_height
end

function BaseEntity:update(dt)
    if self.animation then
        self.animation:update(dt)
        local frame = self.animation:getCurrentFrame()
        if frame then
            self.frame = frame
        end
    end
end

function BaseEntity:showBubble(color)
    self._isBubbleActive = true
    self._bubbleColor = color or self._bubbleColor or gColors['white']
end

function BaseEntity:hideBubble()
    self._isBubbleActive = false
end

function BaseEntity:render()
    if self.type == 'Cursor' then
        self.x = mouseX
        self.y = mouseY
    end

    if not self.frame then return end

    -- Using :typeOf() is completely bulletproof across all LÖVE versions
    if type(self.frame) == "userdata" and self.frame:typeOf("Quad") then
        local _, _, qw, qh = self.frame:getViewport()
        local texture = self.texture or (self.animation and self.animation.texture)
        
        if texture then
            love.graphics.draw(texture, self.frame, self.x, self.y, 0, 
                self.desired_width / qw, self.desired_height / qh)
        end
    elseif type(self.frame) == "userdata" and (self.frame:typeOf("Image") or self.frame:typeOf("Texture")) then
        -- FIXED: Standalone full images (like GrumpyOldMan) fall into this crisp scaler block
        love.graphics.draw(self.frame, self.x, self.y, 0, 
            self.desired_width / self.frame:getWidth(), self.desired_height / self.frame:getHeight())
    end
    love.graphics.draw(self.frame, self.x, self.y, 0, 
        self.desired_width / self.frame:getWidth(), self.desired_height / self.frame:getHeight())
    love.graphics.setColor(gColors['white'])
end

function BaseEntity:renderBubble()
    if self._isBubbleActive then
        -- Event-driven floating animation using math.sin
        local floatOffset = math.sin(love.timer.getTime() * 4) * 2
        local bx = self.x + self.desired_width / 2
        
        -- Radius and tail settings (smaller, more premium size)
        local R = 9
        local tailHeight = 8
        local angleOffset = math.pi / 5.5 -- slightly wider base for the tail
        local angle1 = math.pi / 2 + angleOffset
        local angle2 = math.pi / 2 - angleOffset + 2 * math.pi
        
        -- Adjust 'by' so the pointer tip floats dynamically based on entity height
        local by = self.y - 10 - ((self.desired_height or 0) * 0.2) + floatOffset
        
        local r, g, b, a = unpack(self._bubbleColor)
        
        -- Pre-calculate tail polygon points for main bubble
        local bx1 = bx + R * math.cos(angle1)
        local by1 = by + R * math.sin(angle1)
        local bx2 = bx + R * math.cos(angle2)
        local by2 = by + R * math.sin(angle2)
        local bx_tip = bx
        local by_tip = by + R + tailHeight

        -- Drop Shadow
        love.graphics.setColor(0, 0, 0, 0.35)
        local shadowY = 3
        love.graphics.circle('fill', bx, by + shadowY, R)
        love.graphics.polygon('fill', bx1, by1 + shadowY, bx2, by2 + shadowY, bx_tip, by_tip + shadowY)
        
        -- Glow effect
        love.graphics.setColor(r, g, b, 0.25)
        local glowR = R + 2
        local glowTipY = by + glowR + tailHeight
        local glowX1 = bx + glowR * math.cos(angle1)
        local glowY1 = by + glowR * math.sin(angle1)
        local glowX2 = bx + glowR * math.cos(angle2)
        local glowY2 = by + glowR * math.sin(angle2)
        love.graphics.circle('fill', bx, by, glowR)
        love.graphics.polygon('fill', glowX1, glowY1, glowX2, glowY2, bx, glowTipY)
        
        -- Outer Pin Casing (White)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle('fill', bx, by, R)
        love.graphics.polygon('fill', bx1, by1, bx2, by2, bx_tip, by_tip)
        
        -- Inner Colored Circle
        love.graphics.setColor(r, g, b, 1)
        local innerR = R - 2
        love.graphics.circle('fill', bx, by, innerR)
        
        -- Soft inner volume highlight (for the colored circle)
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.circle('fill', bx - 1.5, by - 1.5, innerR * 0.6)
        
       -- Sharp glossy reflections
        love.graphics.setColor(1, 1, 1, 0.85)
        love.graphics.circle('fill', bx - 2, by - 2, innerR * 0.3)
        love.graphics.circle('fill', bx - 1, by - 4, innerR * 0.15)
        
       -- Thin dark outline to frame the white pin
        love.graphics.setColor(0, 0, 0, 0.25)
        love.graphics.setLineWidth(1)
        love.graphics.arc('line', 'open', bx, by, R, angle1, angle2)
        love.graphics.line(bx1, by1, bx_tip, by_tip)
        love.graphics.line(bx2, by2, bx_tip, by_tip)
        
        
        love.graphics.setColor(gColors['white'])
    end
end