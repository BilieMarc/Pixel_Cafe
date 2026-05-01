PlayState = class {__includes = BaseState}

function PlayState:init()
    self.type = 'PlayState'

    self.moneyManager    = MoneyManager()
    self.timeManager     = TimeManager()
    self.coffeeMachine   = CoffeeMachine(COFFEE_MACHINE_ENTITY)
    self.cursor          = Cursor()
    self.customerManager = CustomerManager()
    self.pauseButton     = Button(BUTTON_PARAMS['Pause'])

    self.interactables = {
        self.coffeeMachine,
        self.pauseButton,
    }

    gStateStack:push(self.moneyManager)
    gStateStack:push(self.timeManager)
    gStateStack:push(self.customerManager)
    gStateStack:push(self.coffeeMachine)
    gStateStack:push(self.pauseButton)
    gStateStack:push(self.cursor)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('p') then
        gStateStack:pause()
        gStateStack:push(PauseMenu())
        return
    end

    self:mouseResponse()
end

function PlayState:render()
    love.graphics.setColor(gColors['white'])
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20,
                            VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)
end

function PlayState:deliverItem(customer)
    local success = customer:receiveItem(self.cursor.heldItem)
    if success then
        local amount, base, tip = self.moneyManager:calculatePayment(customer)
        customer.totalPayment = amount
        self.moneyManager:addPayment(amount, base, tip)
        self.moneyManager:spawnFloatingMoney(
            customer.x + customer.desired_width / 2,
            customer.y,
            amount
        )
    end
end