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
            
            self._mouseDown = {
                time = love.timer.getTime(),
                x = mouseX,
                y = mouseY,
                target = target
            }
        else
            self._mouseDown = nil
        end
    end

   
    if self._mouseDown and not (self.cursor and self.cursor.isDragging) and love.mouse.isDown(1) then
        local dx = mouseX - self._mouseDown.x
        local dy = mouseY - self._mouseDown.y
        local dist2 = dx * dx + dy * dy
        local thresh2 = 5 * 5
        if dist2 > thresh2 then
            local target = self._mouseDown.target
            if target and target.productionStage == 'Ready' then
                local allowDrag = true
                if target.type == 'BreadBasket' and self.breadPlate then
                    if not target:canDragToPlate(self.breadPlate) then
                        allowDrag = false
                    end
                end
                if allowDrag then
                    self.cursor:isDragged(target)
                   
                    self._mouseDown = nil
                end
            end
        end
    end

    if love.mouse.wasReleased(1) then
       
        if (self.cursor and self.cursor.isDragging) then
            local target = self:getInteractAt()

            if target then
                if target.type == 'CustomerState' and target.orderBox then
                    self:deliverItem(target)
                    self.coffeeMachine:taken()
                elseif target.type == 'BreadPlate' and (target.productionStage == 'Void' or target.loafRemaining == 0) then
                   
                    self:deliverItem(target)
                elseif target.type == 'SandwichPlate' and target.productionStage == 'Void' then
                    self:deliverItem(target)
                    self.breadPlate:taken()
                end
            end
            self.cursor:isReleased()
            self._mouseDown = nil
        else
            
            if self._mouseDown then
                local dt = love.timer.getTime() - self._mouseDown.time
                local dx = mouseX - self._mouseDown.x
                local dy = mouseY - self._mouseDown.y
                local dist2 = dx * dx + dy * dy
                if dt <= 0.2 and dist2 <= (5 * 5) then
                    local target = self._mouseDown.target
                    if target then
                        if target.isMachine and target.productionStage == 'Void' then
                            target:produce()
                        elseif target.isClicker and target.productionStage ~= 'Void' then
                            target:action()
                        elseif target.isGUI then
                            target:clicked()
                        end
                    end
                end
                self._mouseDown = nil
            end
        end
    end
end