PopupWindow = class {__includes = BaseState}

function PopupWindow:init(type)
    self.type = type

    if self.type == 'DataLossAsk' then self.text = gTexts[self.type]
    elseif self.type == 'Dev' then self.text = gTexts[self.type]
    else self.text = 'None' end

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
    elseif self.type == 'Dev' then
        self.input = InputBox()
        table.insert(self.interactables, self.input)
        gStateStack:push(self.input)
    end
end

function PopupWindow:update(dt)
    self:mouseResponse()
end

function PopupWindow:render()
end