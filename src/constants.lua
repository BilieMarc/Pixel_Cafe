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

CUSTOMER_ENTITIES = {
    ['left'] = {
        x = 10,
        y = 25,
        desired_width = 64,
        desired_height = 64,
    },
    ['center'] = {
        x = 110,
        y = 25,
        desired_width = 64,
        desired_height = 64,
    },
    ['right'] = {
        x = 210,
        y = 25,
        desired_width = 64,
        desired_height = 64,
    },
}

gColors = {
    ['white'] = {1, 1, 1, 1},
    ['black'] = {0, 0, 0, 1},
    ['green'] = {0.2, 1, 0.2, 1},
    ['red'] = {1, 0.2, 0.2, 1},
    ['blue'] = {0.2, 0.2, 1, 1},
    ['yellow'] = {1, 1, 0.2, 1},
    ['purple'] = {0.5, 0.2, 0.5, 1},
    ['orange'] = {1, 0.5, 0, 1},
    ['gray'] = {0.5, 0.5, 0.5, 1},
}