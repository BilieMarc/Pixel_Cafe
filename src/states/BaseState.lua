BaseState = class{}

function BaseState:init() end
function BaseState:enterParams(params) end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
function BaseState:processAI(params, dt) end

function BaseState:getInteractAt()
    self:getInteractables()
    for _, c in ipairs(self.interactables) do
        if c:isMouseOver() then
            return c
        end
    end
    return nil
end

function BaseState:getInteractables()
    local entities
    if self.type == 'PlayState' then entities = self.customerManager end
    if entities == nil then
        return
    end
    for _, i in ipairs(entities:getAllCustomers()) do
        table.insert(self.interactables, i)
    end
end

function BaseState:mouseResponse()
    if love.mouse.wasPressed(1) then
        local target = self:getInteractAt()

        if target then
            if target.productionStage == 'Ready' then
                self.cursor:isDragged(target)
            elseif target.isMachine and target.productionStage == 'Void' then
                target:produce()
            elseif target.isClicker and target.productionStage ~= 'Void' then
                target:action()
            elseif target.isGUI then
                target:clicked()
            end
        end
    end

    if love.mouse.wasReleased(1) and (self.cursor and self.cursor.isDragging) then
        local target = self:getInteractAt()

        if target then
            if target.type == 'CustomerState' and target.orderBox then
                self:deliverItem(target)
                self.coffeeMachine:taken()
            elseif target.type == 'BreadPlate' and target.productionStage == 'Void' then
                self:deliverItem(target)
            elseif target.type == 'SandwichPlate' and target.productionStage == 'Void' then
                self:deliverItem(target)
                self.breadPlate:taken()
            end
        end
        self.cursor:isReleased()
    end
end