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
    -- when left click in the mouse, get which interactable entity exists there
    if love.mouse.wasPressed(1) then
        local target = self:getInteractAt()
        -- if interactable entity exists, establish a table containing properties at that instant
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

    -- the entity at which the mouse point has been confirmed to be interactable and cursor is not dragging and also the mouse is continuously press
    if self._mouseDown and not (self.cursor and self.cursor.isDragging) and love.mouse.isDown(1) then
        local dx = mouseX - self._mouseDown.x --difference between global position and the position at which the mouse was clicked
        local dy = mouseY - self._mouseDown.y
        local dist2 = dx * dx + dy * dy
        local thresh2 = 5 * 5 --accepted as drag threshold circle has radius 5
        if dist2 > thresh2 then --if the current mouse position has exceeded threshold
            local target = self._mouseDown.target
            if target and target.productionStage == 'Ready' then --if it is a machine ready for drag
                local allowDrag = true
                if target.type == 'BreadBasket' and self.breadPlate then --if the dragged entity is from BreadBasket and BreadPlate exists
                    if not target:canDragToPlate(self.breadPlate) then --if the plate is unable to accept the dragged entity
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
            local target = self:getInteractAt() -- the entity the current cursor point at

            if target then
                if target.type == 'CustomerState' and target.orderBox then
                    self:deliverItem(target)
                    -- Decrement the source that produced the held item
                    if self.cursor and self.cursor.heldItem == 'Coffee' and self.coffeeMachine then
                        self.coffeeMachine:taken()
                    elseif self.cursor and self.cursor.heldItem == 'SliceOfBread' and self.breadPlate then
                        self.breadPlate:taken()
                    elseif self.cursor and self.cursor.heldItem == 'Sandwich' and self.sandwichPlate then
                        self.sandwichPlate:taken()
                    end
                elseif target.type == 'BreadPlate' and target.loafRemaining == 0 then
                    self:deliverItem(target)
                elseif target.type == 'SandwichPlate' and target.productionStage == 'Void' then
                    self:deliverItem(target)
                    self.breadPlate:taken()
                end
            end
            self.cursor:isReleased()
            self._mouseDown = nil
        else --cursor isn't dragging something
            if self._mouseDown then
                local dt = love.timer.getTime() - self._mouseDown.time -- the difference between that instance and now
                local dx = mouseX - self._mouseDown.x
                local dy = mouseY - self._mouseDown.y
                local dist2 = dx * dx + dy * dy
                if dt <= 0.2 and dist2 <= (5 * 5) then --if the time and distance are under threshold
                    local target = self._mouseDown.target
                    if target then --target is not dragged but clicked
                        if target.isMachine and target.productionStage == 'Void' then
                            target:produce()
                        elseif target.isClicker and target.productionStage ~= 'Void' then
                            target:action()
                        elseif target.isGUI then
                            target:clicked()
                        end
                    end
                end
                self._mouseDown = nil --the coordinate is no longer needed
            end
        end
    end
end