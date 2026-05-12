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
    if self.type == 'Dev' or self.type == 'NameGive' then self.inputBox.update(dt) end
end

function PopupWindow:render()
    if self.type == 'Dev' or self.type == 'NameGive' then self.inputBox.draw() end
end