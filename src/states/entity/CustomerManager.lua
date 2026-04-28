-- CustomerManager.lua
-- Handles customer spawning (with timer), slot assignment, and cleanup.
-- Lives inside PlayState; update() is called each frame by PlayState:update().

CustomerManager = class{__includes = BaseState}

function CustomerManager:init()
    self.customers     = {}   -- list of active CustomerState objects
    self.occupiedSlots = {}   -- [slotIndex] = true/false

    self.spawnTimer    = 0
    self.nextSpawnTime = CUSTOMER_CONFIG.spawnInterval

    -- Mark all slots free
    for i = 1, #WAITING_SLOTS do
        self.occupiedSlots[i] = false
    end
end

function CustomerManager:update(dt)
    -- Advance spawn timer
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.nextSpawnTime then
        self:spawnCustomer()
        self.spawnTimer    = 0
        -- Add ±0.5 s of jitter so arrivals feel natural
        self.nextSpawnTime = CUSTOMER_CONFIG.spawnInterval + (math.random() - 0.5)
    end

    -- Remove customers that have fully exited (state == 'done')
    for i = #self.customers, 1, -1 do
        local c = self.customers[i]
        if c.state == 'done' then
            if c.slotIndex then
                self.occupiedSlots[c.slotIndex] = false
            end
            table.remove(self.customers, i)
        end
    end

    for _, c in ipairs(self.customers) do
        c:update(dt)
    end
end

function CustomerManager:spawnCustomer()
    local slot = self:getAvailableSlot()
    if not slot then return nil end   -- all slots full

    local customer = CustomerState({
        slotIndex = slot.index,
        slot      = slot,
        --orderType = 'Coffee',
    })

    self.occupiedSlots[slot.index] = true
    table.insert(self.customers, customer)
    return customer
end

function CustomerManager:getAvailableSlot()
    for i, s in ipairs(WAITING_SLOTS) do
        if not self.occupiedSlots[i] then
            return {index = i, x = s.x, y = s.y, id = s.id}
        end
    end
    return nil
end

function CustomerManager:getAllCustomers()
    return self.customers
end

function CustomerManager:getCustomerCount()
    return #self.customers
end

function CustomerManager:getOccupiedSlotCount()
    local n = 0
    for i = 1, #WAITING_SLOTS do
        if self.occupiedSlots[i] then n = n + 1 end
    end
    return n
end

function CustomerManager:render()
    for _, c in ipairs(self.customers) do
        c:render()
    end
end
