DayEndState = class{__includes = BaseState}

function DayEndState:init()
    self._dailySalesAmount = gDailySales or 0
    self._dailyTipsAmount = gDailyTips or 0
    self._startingBalance = gStartingBalance or (gMoney or 0) --gMoney will be saved as persistent data

    self._earnedToday = self._dailySalesAmount + self._dailyTipsAmount --this variable will be saved
    self._finalTotal = self._startingBalance + self._earnedToday

    DataManager:moneyDataSave(self._finalTotal, self._earnedToday)
    DataManager:create() --immediately store the variables to be used

    --[[local card = UI_CARD
    -- Ensure card stays fixed size (restoring original height)
    card.height = 140 ]] --comment out this block assuming to be of no use

    self.nextDayButton = Button(BUTTON_PARAMS['NextDay'])
    self.quitButton = Button(BUTTON_PARAMS['Quit'])

    self.interactables = {
        self.nextDayButton,
        self.quitButton
    }

    self.card = DayEndStateCard({earnedToday = self._earnedToday, finalTotal = self._finalTotal, currentDate = DataManager:getData('currentDate')})
    gStateStack:push(self.card)
    for _, btn in ipairs(self.interactables) do
        gStateStack:push(btn)
    end
end

function DayEndState:update(dt)
    self:mouseResponse()
end