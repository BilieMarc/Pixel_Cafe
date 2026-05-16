PlayState = class {__includes = BaseState}

local function find(list, name)
    for i = 1, #list do
        if list[i] == name then
            return true
        end
    end
    return false
end

function PlayState:init()
    self.type = 'PlayState'
    self.interactables = {}

    self.data = DataManager:getData()
    print('Current Date: ' .. tostring(self.data['currentDate']))
    print('PlayState - Today Money: ' .. tostring(self.data['todayMoney']) .. ' Total Money: ' .. tostring(self.data['totalMoney']))

    -- we can insert more item here
    for k, v in pairs(AVAILABLE_ITEMS) do AVAILABLE_ITEMS[k] = nil end
    if find(self.data['unlockedMachine'], 'CoffeeMachine') then
        table.insert(AVAILABLE_ITEMS, 'Coffee')
    end
    if find(self.data['unlockedMachine'], 'BreadBasket') then
        table.insert(AVAILABLE_ITEMS, 'LoafOfBread')
    end
    if find(self.data['unlockedMachine'], 'BreadPlate') then
        table.insert(AVAILABLE_ITEMS, 'SliceOfBread')
    end
    if find(self.data['unlockedMachine'], 'SandwichPlate') then
        table.insert(AVAILABLE_ITEMS, 'Sandwich')
    end

    self.cityBackground = CityBackground()
    gStateStack:push(self.cityBackground)

    self.customerManager = CustomerManager()
    gStateStack:push(self.customerManager)

    self.counterBackground = CounterBackground() -- 16 116
    gStateStack:push(self.counterBackground)

    self.moneyManager    = MoneyManager(self.data['totalMoney'], self.data['todayMoney'])
    gStateStack:push(self.moneyManager)

    self.timeManager     = TimeManager(self.data['currentDate'], self.customerManager)
    gStateStack:push(self.timeManager)

    self.pauseButton     = Button(BUTTON_PARAMS['Pause'])
    gStateStack:push(self.pauseButton)
    table.insert(self.interactables, self.pauseButton)

    self.shopButton      = Button(BUTTON_PARAMS['ToShop'])
    gStateStack:push(self.shopButton)
    table.insert(self.interactables, self.shopButton)

    if find(self.data['unlockedMachine'], 'CoffeeMachine') then
        self.coffeeMachine   = CoffeeMachine(COFFEE_MACHINE_ENTITY)
        gStateStack:push(self.coffeeMachine)
        table.insert(self.interactables, self.coffeeMachine)
        
        self.coffeeCupStack  = CoffeeCupStack(COFFEE_CUP_STACK_CONFIG)
        gStateStack:push(self.coffeeCupStack)
        table.insert(self.interactables, self.coffeeCupStack)
        
        self.coffeeTray      = CoffeeTray(COFFEE_TRAY_CONFIG)
        gStateStack:push(self.coffeeTray)
        table.insert(self.interactables, self.coffeeTray)
    end

    if find(self.data['unlockedMachine'], 'BreadBasket') then
        self.breadBasket = BreadBasket(BREAD_BASKET_CONFIG)
        gStateStack:push(self.breadBasket)
        table.insert(self.interactables, self.breadBasket)
    end

    if find(self.data['unlockedMachine'], 'BreadPlate') then
        self.breadPlate = BreadPlate(BREAD_PLATE_CONFIG)
        gStateStack:push(self.breadPlate)
        table.insert(self.interactables, self.breadPlate)
    end

    if find(self.data['unlockedMachine'], 'SandwichPlate') then
        self.sandwichPlate = SandwichPlate(SANDWICH_PLATE_CONFIG)
        gStateStack:push(self.sandwichPlate)
        table.insert(self.interactables, self.sandwichPlate)
    end

    self.cursor          = Cursor()
    gStateStack:push(self.cursor)
end

function PlayState:enter()
    if gMusic and gSettings.musicVolume > 0 then
        gMusic:setVolume(gSettings.musicVolume)
        gMusic:play()
    end
end

function PlayState:exit()
    if gMusic then
        gMusic:stop()
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('p') then
        gStateStack:pause()
        gStateStack:push(PauseMenu())
        return
    elseif love.keyboard.wasPressed('d') then
        print('Developer Mode')
        self.timeManager:devTimeSkip()
    end

    self:mouseResponse()
end

function PlayState:render()
    --[[love.graphics.setColor(gColors['white'])
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20,
                            VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)]]
end

function PlayState:deliverItem(target)
    local success = target:receiveItem(self.cursor.heldItem, self.cursor.dragSource)
    if success then
        -- Only customers generate payments; other entities simply accept the item
        if target.type == 'CustomerState' and target.orderBox then
            local amount, base, tip = self.moneyManager:calculatePayment(target)
            target.totalPayment = amount
            self.moneyManager:addPayment(amount, base, tip)
            self.moneyManager:spawnFloatingMoney(
                target.x + target.desired_width / 2,
                target.y,
                amount
            )
        end
    end
    return success
end