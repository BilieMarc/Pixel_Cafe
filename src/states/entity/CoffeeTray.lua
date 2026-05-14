CoffeeTray = class {__includes = BaseEntity}

function CoffeeTray:init(params)
    BaseEntity.init(self, params)

    self.type = 'CoffeeTray'
    self.isClicker = false
    self.productionStage = 'Ready'

    self.emptyCups = 0
    self.filledCups = 0
    self:updateFrame()
end

function CoffeeTray:updateFrame()
    local filled = self.filledCups
    local empty  = self.emptyCups
    local total  = filled + empty

    if total == 0 then
        self.frame = gFrames['EmptyTray']

    elseif total == 1 then
        if filled == 1 then
            self.frame = gFrames['TrayWithCupsFilled4']   -- 1/1 filled
        else
            self.frame = gFrames['TrayWithEmptyCups1']    -- 1 empty
        end

    elseif total == 2 then
        if filled == 2 then
            self.frame = gFrames['TrayWithCupsFilled3']   -- 2/2 filled
        elseif filled == 1 then
            self.frame = gFrames['TwoCupsFillStage1by2']  -- 1/2 filled
        else
            self.frame = gFrames['TrayWithEmptyCups2']    -- 2 empty
        end

    elseif total == 3 then
        if filled == 3 then
            self.frame = gFrames['TrayWithCupsFilled2']     -- 3/3 filled
        elseif filled == 2 then
            self.frame = gFrames['ThreeCupsFillStage2by3'] -- 2/3 filled
        elseif filled == 1 then
            self.frame = gFrames['ThreeCupsFillStage1by3'] -- 1/3 filled
        else
            self.frame = gFrames['TrayWithEmptyCups3']      -- 3 empty
        end

    elseif total >= 4 then
        if filled == 4 then
            self.frame = gFrames['TrayWithCupsFilled1']    -- 4/4 filled
        elseif filled == 3 then
            self.frame = gFrames['FourCupFillStage3by4']   -- 3/4 filled
        elseif filled == 2 then
            self.frame = gFrames['FourCupFillStage2by4']   -- 2/4 filled
        elseif filled == 1 then
            self.frame = gFrames['FourCupFillStage1by4']   -- 1/4 filled
        else
            self.frame = gFrames['TrayWithEmptyCups4']     -- 4 empty
        end
    end
end


function CoffeeTray:receiveItem(item, source)
    if item == 'DisposableCoffeeCup' then
        local total = self.emptyCups + self.filledCups
        if total < 4 then
            self.emptyCups = self.emptyCups + 1
            self:updateFrame()
            return true
        end
    elseif item == 'CoffeeMachine' and source then
        local cupsToFill = math.min(self.emptyCups, source.volume)
        if cupsToFill > 0 then
            self.emptyCups = self.emptyCups - cupsToFill
            self.filledCups = self.filledCups + cupsToFill
            source.volume = source.volume - cupsToFill
            source:updateFrame()
            self:updateFrame()
            return true
        end
    end
    return false
end

function CoffeeTray:drag()
    if self.filledCups > 0 then
        -- Temporarily decrease visually, as if the cup is lifted
        self.filledCups = self.filledCups - 1
        self:updateFrame()
    end
end

function CoffeeTray:taken()
    -- Successfully delivered the cup to a customer. We already decremented in drag().
    -- Just ensure frame is updated.
    self:updateFrame()
end

function CoffeeTray:undrag()
    -- Cancelled drag, put the cup back on the tray.
    -- Wait, if we are undragging, we must have had a filled cup.
    self.filledCups = self.filledCups + 1
    self:updateFrame()
end
