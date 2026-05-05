BreadPlate = class {__includes = BaseEntity}

function BreadPlate:init(params)
    BaseEntity.init(self, params)

    self.type = 'BreadPlate'
    self.isClicker = true

    self.productionStage = 'Void'
    self.slices = 0
    self.loafRemaining = 0
    self.color = gColors['transparent']
end

function BreadPlate:update(dt)
    if self.productionStage == 'Producing' then
        if self.slices > 0 then
            self.productionStage = 'Ready'
        end
    elseif self.productionStage == 'Ready' then
        if self.slices == 0 then
            -- if there is still loaf remaining, go back to Producing, otherwise Void
            if self.loafRemaining > 0 then
                self.productionStage = 'Producing'
            else
                self.productionStage = 'Void'
            end
        end
    end

    if self.productionStage == 'Void' then
        self.color = gColors['transparent']
    elseif self.productionStage == 'Producing' then
        self.color = gColors['green']
    elseif self.productionStage == 'Ready' then
        if self.slices == 1 then
            self.color = gColors['yellow']
        elseif self.slices == 2 then
            self.color = gColors['orange']
        elseif self.slices >= 3 then
            self.color = gColors['red']
        end
    end

end

function BreadPlate:render()
    BaseEntity.render(self)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.desired_width, self.desired_height)
    love.graphics.setColor(gColors['white'])
    love.graphics.setFont(gFonts['small'])
    local label = 'Slices: ' .. self.slices
    local font = gFonts['small']
    local tw = font:getWidth(label)
    local fh = font:getHeight()
    love.graphics.setFont(font)
    love.graphics.setColor(gColors['white'])
    love.graphics.print(label, self.x + self.desired_width / 2 - tw / 2, self.y + self.desired_height + 4)
end

function BreadPlate:action()
    if self.loafRemaining > 0 then
        self.slices = self.slices + 1
        self.loafRemaining = self.loafRemaining - 1
        self.productionStage = 'Ready'
    end
end

function BreadPlate:taken()
    self.slices = self.slices - 1
    if self.slices < 0 then
        self.slices = 0
    elseif self.slices == 0 then
        if self.loafRemaining > 0 then
            self.productionStage = 'Producing'
        else
            self.productionStage = 'Void'
        end
    end
end

function BreadPlate:receiveItem(item)
    if item == 'LoafOfBread' then
        if self.productionStage == 'Void' or self.loafRemaining == 0 then
            self.productionStage = 'Producing'
            self.loafRemaining = 3
            return true
        else
            return false
        end
    end

    return false
end