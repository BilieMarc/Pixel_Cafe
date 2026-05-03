SandwichPlate = class {__includes = BaseEntity}

function SandwichPlate:init(params)
    BaseEntity.init(self, params)

    self.type = 'SandwichPlate'
    self.isClicker = true

    self.productionStage = 'Void'
    self.color = gColors['transparent']
end

function SandwichPlate:render()
    BaseEntity.render(self)

    love.graphics.setColor(self.color)
    love.graphics.rectangle('line', self.x, self.y, self.desired_width, self.desired_height)
    love.graphics.setColor(gColors['white'])
end

function SandwichPlate:action()
    -- No action; the sandwich plate is just a delivery point for now.
end

function SandwichPlate:taken()
    self.productionStage = 'Void'
end

function SandwichPlate:receiveItem(item)
    if item == 'SliceOfBread' and self.productionStage == 'Void' then
        self.productionStage = 'Ready'
        self.color = gColors['green']
    end

    return false
end