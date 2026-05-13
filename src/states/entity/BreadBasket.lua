BreadBasket = class {__includes = BaseEntity}

function BreadBasket:init(def)
    BaseEntity.init(self, def)

    self.type = 'BreadBasket'
    self.isMachine = true

    self.productionStage = 'Ready'
end

function BreadBasket:canDragToPlate(plate)
    if not plate then return false end
    -- Only allow dragging a loaf to the plate if the plate's loaf is finished
    if plate.loafRemaining == 0 then
        return true
    end
    return false
end

function BreadBasket:render()
    BaseEntity.render(self)

    if self.productionStage == 'Ready' then
        love.graphics.setColor(gColors['yellow'])
        love.graphics.rectangle('line', self.x, self.y, self.desired_width, self.desired_height)
        love.graphics.setColor(gColors['white'])
    end
end