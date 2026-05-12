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

-- start the game with StartMenu 
    gStateStack = StateStack()
    gStateStack:push(StartMenu())

    --gStateStack = StateStack()
    --gStateStack:push(PlayState())
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.update(dt)
    _G.mouseX, _G.mouseY = push:toGame(love.mouse.getX(), love.mouse.getY())
    if mouseX and mouseY then
        suit.updateMouse(mouseX, mouseY, love.mouse.isDown(1))
    end

    if love.keyboard.wasPressed('k') and not gStateStack.isPopup then
        gStateStack:popupCreate()
        gStateStack:push(PopupWindow('Dev'))
    end

    gStateStack:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    InputBox.keypressed(key)
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.textedited(text, start, length)
    InputBox.textedited(text, start, length)
end

function love.mousepressed(x, y, button)
    love.mouse.keysPressed[button] = true
end

function love.mousereleased(x, y, button)
    love.mouse.keysReleased[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.keysPressed[button]
end

function love.mouse.wasReleased(button)
    return love.mouse.keysReleased[button]
end

function love.textinput(t) InputBox.textinput(t) end