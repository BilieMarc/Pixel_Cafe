PlayState = class {__includes = BaseState}

function PlayState:init()
    self.timeManager = TimeManager()

    self.customerStates = {
        CustomerState(CUSTOMER_ENTITIES['left']),
        CustomerState(CUSTOMER_ENTITIES['center']),
        CustomerState(CUSTOMER_ENTITIES['right']),
    }
    self.coffeeMachine = CoffeeMachine(COFFEE_MACHINE_ENTITY)
    self.cursor = Cursor()

    gStateStack:push(self.customerStates[1])
    gStateStack:push(self.customerStates[2])
    gStateStack:push(self.customerStates[3])
    gStateStack:push(self.coffeeMachine)
    gStateStack:push(self.cursor)

    self.interactables = {
        self.coffeeMachine,
        self.customerStates[1],
        self.customerStates[2],
        self.customerStates[3]
    }
    gStateStack:push(self.timeManager)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        -- End PlayState and enters DayEndState
        gStateStack:pause()
        gStateStack:push(PauseMenu())
    end

    if love.mouse.wasPressed(1) then
        local target = self:getInteractableAt()

        if target then
            target:onPressed()

            if target.productionStage == 'Ready' then
                self.cursor:isDragged(target)
            end
        end
    end

    if love.mouse.wasReleased(1) and self.cursor.isDragging then
        local target = self:getInteractableAt()

        if target and target.isCustomer and self.cursor.heldItem == 'Coffee' then
            target:receiveOrder()
            self.coffeeMachine:taken()
        end
        self.cursor:isReleased()
    end
end

function PlayState:render()
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20, VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)
end

function PlayState:getInteractableAt()
    for _, object in ipairs(self.interactables) do
        if object:isMouseOver() then
            return object
        end
    end
    return nil
end
