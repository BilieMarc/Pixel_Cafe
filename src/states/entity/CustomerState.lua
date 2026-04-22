CustomerState = class{__includes = BaseEntity}

function CustomerState:init(params)
    BaseEntity.init(self, params)
    local frameIndex = math.random(#gFrames.customers)
    self.frame = gFrames.customers[frameIndex]
    self.receivedOrder = false
    self.isCustomer = true
    self.type = 'CustomerState'
end

function CustomerState:update(dt)
    if self.receivedOrder then
        gStateStack:pop(self)
    end
end

function CustomerState:receiveOrder()
    self.receivedOrder = true
end
