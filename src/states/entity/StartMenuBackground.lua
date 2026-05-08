StartMenuBackground = class {__includes = BaseState}

function StartMenuBackground:init()
    self.isGUI = true
    self.backgroundFrame = gFrames['StartMenuBackground']
end

function StartMenuBackground:render()
    love.graphics.draw(self.backgroundFrame, 0, 0, 0, 
        VIRTUAL_WIDTH / self.backgroundFrame:getWidth(), VIRTUAL_HEIGHT / self.backgroundFrame:getHeight())
end