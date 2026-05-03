BreadPlate = class {__includes = BaseEntity}

function BreadPlate:init(params)
    BaseEntity.init(self, params)

    self.type = 'BreadPlate'
    self.isClicker = true

    self.productionStage = 'Void'
    self.slices = 0
    self.color = gColors['transparent']
end

function BreadPlate:update(dt)
    if self.productionStage == 'Producing' and self.slices > 0 then
        self.productionStage = 'Ready'
    elseif self.productionStage == 'Ready' and self.slices == 0 then
        self.productionStage = 'Void'
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
        elseif self.slices == 3 then
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
    --love.graphics.print(self.slices, self.x, self.y + self.desired_height + 2)
end

function BreadPlate:action()
    if self.slices < 3 then
        self.slices = self.slices + 1
    end
end

function BreadPlate:taken()
    self.slices = self.slices - 1
    if self.slices < 0 then
        self.slices = 0
    elseif self.slices == 0 then
        self.productionStage = 'Void'
    end
end

function BreadPlate:receiveItem(item)
    if item == 'LoafOfBread' and self.productionStage == 'Void' then
        self.productionStage = 'Producing'
    end

    return false
end