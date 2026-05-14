CoffeeMachine = class {__includes = BaseEntity}

function CoffeeMachine:init(params)
    BaseEntity.init(self, params)

    self.counter = 0
    self.duration = 5
    self.productionStage = 'Ready'
    self.volume = 0
    self.isMachine = true
    self.type = 'CoffeeMachine'

    self.animation = Animation(self.animation)
    self:updateFrame()
end

function CoffeeMachine:updateFrame()
    if self.productionStage == 'Producing' then
        self.frame = self.animation:getFrame() or self.frame
    elseif self.productionStage == 'Holding' then
        self.frame = gFrames['CoffeeMachineHold']
    else
        if self.volume == 4 then
            self.frame = gFrames['CoffeeMachinesFillStages4']  -- fullest
        elseif self.volume == 3 then
            self.frame = gFrames['CoffeeMachinesFillStages3']
        elseif self.volume == 2 then
            self.frame = gFrames['CoffeeMachinesFillStages2']
        elseif self.volume == 1 then
            self.frame = gFrames['CoffeeMachinesFillStages1']  -- nearly empty
        else
            self.frame = gFrames['CoffeeMachineAnimation'][1]  -- empty
        end
    end
end


function CoffeeMachine:getHitbox()
    local scale = 0.7 -- Reduce width by 30%
    local w = self.desired_width * scale
    local h = self.desired_height
    local x = self.x + (self.desired_width - w) / 2 - 1 -- Move left by 1 pixel
    local y = self.y
    return x, y, w, h
end

function CoffeeMachine:isMouseOver()
    local x, y, w, h = self:getHitbox()
    return mouseX > x and mouseX < x + w and
           mouseY > y and mouseY < y + h
end

function CoffeeMachine:update(dt)
    if self.productionStage == 'Producing' then
        self.counter = self.counter + dt
        if self.counter >= self.duration then
            self.productionStage = 'Ready'
            self.volume = 4
            self.counter = 0
            self.animation:stop()
        end
    end

    BaseEntity.update(self, dt)

    -- Re-apply correct frame after BaseEntity.update, since the animation system
    -- may have overwritten self.frame with nil when the animation is stopped.
    self:updateFrame()
end

function CoffeeMachine:render()
    BaseEntity.render(self)

    if self.productionStage == 'Producing' then
        love.graphics.setColor(gColors['green'])
        love.graphics.arc('line', 'open', self.x + self.desired_width / 2, self.y + self.desired_height / 2, self.desired_width / 2, -math.pi / 2, -math.pi / 2 + (self.counter / self.duration) * (2 * math.pi))
        love.graphics.setColor(gColors['white'])
    elseif self.productionStage == 'Ready' then
        love.graphics.setColor(gColors['yellow'])
        local hx, hy, hw, hh = self:getHitbox()
        love.graphics.rectangle('line', hx, hy, hw, hh)
        love.graphics.setColor(gColors['white'])
    end
end

function CoffeeMachine:produce()
    if self.volume < 4 and self.productionStage ~= 'Producing' then
        -- 1.25 seconds per missing 1/4 unit of coffee
        self.duration = (4 - self.volume) * 1.25
        self.productionStage = 'Producing'
        self.counter = 0
        self.animation:play()

        -- Start animation at the frame matching current volume so it blends
        -- smoothly instead of always jumping back to frame 1.
        local volumeToFrame = { [0]=1, [1]=5, [2]=7, [3]=10 }
        local startIndex = volumeToFrame[self.volume] or 1
        self.animation.frameIndex = startIndex
        self.animation.timer = 0
        self.animation.frame = self.animation.frames[startIndex] or self.animation.defaultFrame
    end
end



function CoffeeMachine:drag()
    self.productionStage = 'Holding'
    self:updateFrame()
end

function CoffeeMachine:taken()
    self.productionStage = 'Ready'
    self:updateFrame()
end

function CoffeeMachine:undrag()
    self.productionStage = 'Ready'
    self:updateFrame()
end