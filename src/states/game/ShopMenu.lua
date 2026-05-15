ShopMenu = class {__includes = BaseState}

local items = {
    ['PaperCup'] = {
        frame = nil,
        id = 1,
        name = 'Paper Cup',
        price = 3,
        stock = 10,
        purchasable = true,
    },
    ['CoffeeSeed'] = {
        frame = nil,
        id = 2,
        name = 'Coffee Seed',
        price = 2,
        stock = 20,
        purchasable = true,
    },
}

local buffer = 5

function ShopMenu:init()
    self.type = 'ShopMenu'

    self.background = ShopBackground()
    gStateStack:push(self.background)

    self.scrollbar = Scrollbar(SCROLLBAR_CONFIG)
    gStateStack:push(self.scrollbar)

    self.indexY = 0
    self.items = {}
    self.buttons = {}
    self.interactables = { self.scrollbar }

    local i = 1
    for name, data in pairs(items) do
        local item = ShopItem(data)
        table.insert(self.items, item)
        gStateStack:push(item)
        self.scrollbar:addHeight(item:getHeight() + buffer)
        self.buttons[i] = item:getButton()
        gStateStack:push(self.buttons[i])
        table.insert(self.interactables, self.buttons[i])
        i = i + 1
    end

    self.topBox = ShopTopBox()
    gStateStack:push(self.topBox)

    self.exitButton = Button(BUTTON_PARAMS['FromShop'])
    gStateStack:push(self.exitButton)
    table.insert(self.interactables, self.exitButton)
end

function ShopMenu:update(dt)
    self:mouseResponse()
    self.indexY = self.scrollbar:getY()

    local topLimit = 20

    for i = 1, #self.items do
        local item = self.items[i]
        item:updateY(self.indexY)
        item:getButton():updateY(self.indexY, item.id, item:getHeight(), buffer)

        if item:getBottom() < topLimit and item.isVisible then
            item.isVisible = false
        elseif item:getBottom() >= topLimit and not item.isVisible then
            item.isVisible = true
        end
    end
    gWheelY = 0
end

function ShopMenu:render()
end