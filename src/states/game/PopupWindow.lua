PopupWindow = class {__includes = BaseState}

function PopupWindow:init(type)
    self.type = type

    self.text = gTexts[self.type] or 'None'

    self.card = PopupWindowCard(self.text)
    gStateStack:push(self.card)

    self.xButton = Button(BUTTON_PARAMS['PopupX'])
    gStateStack:push(self.xButton)

    self.interactables = {
        self.xButton,
    }

    if self.type == 'DataLossAsk' then
        self.okButton = Button(BUTTON_PARAMS['OkButton'])
        table.insert(self.interactables, self.okButton)
        gStateStack:push(self.okButton)
    elseif self.type == 'Dev' or self.type == 'NameGive' then
        --[[self.okButton = Button(BUTTON_PARAMS['OkNameGive'])
        table.insert(self.interactables, self.okButton)
        gStateStack:push(self.okButton)]]
        self.inputBox = InputBox
        suit.setHit('inputBox')
    end
end

function PopupWindow:update(dt)
    self:mouseResponse()
    local name, tokens
    if self.type == 'NameGive' then
        name, tokens = self.inputBox.update(dt)
        if name then
            DataManager:getDefaultData()
            DataManager:nameDataSave(name)
            print(DataManager:getData('name'))
            gStateStack:clear()
            gStateStack:popupDelete()
            gStateStack:clear()
            gStateStack:push(PlayState())
        end
    elseif self.type == 'Dev' then
        name, tokens = self.inputBox.update(dt)
        if tokens and string.lower(tostring(tokens[1])) == '\\dev' then
            if string.lower(tostring(tokens[2])) == 'skip' and tokens[3] then
                DataManager:modify('currentDate', tonumber(tokens[3]))
                gStateStack:clear()
                gStateStack:push(DayEndState())
            elseif string.lower(tostring(tokens[2])) == 'money' and tokens[3] then
                gMoney = tonumber(tokens[3])
            end
        end
    end
end

function PopupWindow:render()
    if self.type == 'Dev' or self.type == 'NameGive' then self.inputBox.draw() end
end