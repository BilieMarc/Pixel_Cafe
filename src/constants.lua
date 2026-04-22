WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

COFFEE_MACHINE_ENTITY = {
    frame = gFrames['CoffeeMachine'],
    x = 10,
    y = 130,
    desired_width = 32,
    desired_height = 32,
}

-- Customer waiting positions at the counter (slots).
-- y=55: sprite is 64px tall, bottom edge = y=119, clears counter at y=130.
WAITING_SLOTS = {
    {x = 60,  y = 55, id = 'left'},
    {x = 160, y = 55, id = 'center'},
    {x = 260, y = 55, id = 'right'},
}

-- Entrance (right, off-screen) and exit (left, off-screen)
ENTRANCE_X = 420
EXIT_X     = -70

-- Customer movement and behavior
CUSTOMER_CONFIG = {
    moveSpeed         = 100,  -- pixels per second
    spawnInterval     = 4,    -- seconds between arrivals
    patienceMax       = 100,  -- full patience value
    patienceDecayRate = 5,    -- patience lost per second while waiting
    baseTip           = 0.2,  -- 20% base tip
    patienceBonus     = 0.3,  -- up to 30% extra tip based on patience
}

-- Order types: name -> {price, name}
ORDER_TYPES = {
    ['Coffee'] = {price = 5, name = 'Coffee'},
}