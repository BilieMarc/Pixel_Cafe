require('src.Dependencies')

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Pixel Cafe')
    --love.window.setIcon(gLogo)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    gStateStack = StateStack()
    gStateStack:push(PlayState())
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    local mx, my = push:toGame(love.mouse.getX(), love.mouse.getY())
    if mx and my then
        suit.updateMouse(mx, my, love.mouse.isDown(1))
    end
    gStateStack:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.textedited(text, start, length)
    suit.textedited(text, start, length)
end