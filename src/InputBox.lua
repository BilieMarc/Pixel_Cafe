suit.theme.color = {
    normal = { bg = gColors['black'], fg = gColors['white']},
    hovered = { bg = gColors['black'], fg = gColors['white']},
    active = { bg = gColors['black'], fg = gColors['white']}
}
suit.theme.cornerRadius = 0

local inputBox = {
    input = { text = "" },
}

--setmetatable(inputBox, inputBox)

--[[POPUP_INPUT_BOX = {
    x = math.floor(POPUP_WINDOW_CONFIG.x + POPUP_WINDOW_CONFIG.width / 2 - 65),
    y = math.floor(POPUP_WINDOW_CONFIG.y + POPUP_WINDOW_CONFIG.height / 2),
    desired_width = POPUP_WINDOW_CONFIG.width - 20, --10 is buffer for both sides
    desired_height = 30,
    color = gColors['gray'],
    border = gColors['black'],
}]]

local once = true

function inputBox.update(dt)
    --suit.active = 'inputBox'
    if inputBox.input.text == 'k' and once then
        inputBox.input.text = ''
        once = false
    end
    local state = suit.Input(
        inputBox.input,
        { id = 'inputBox' },
        POPUP_INPUT_BOX.x,
        POPUP_INPUT_BOX.y,
        POPUP_INPUT_BOX.desired_width,
        POPUP_INPUT_BOX.desired_height
    )

    if state.submitted then 
        local raw = inputBox.input.text

        inputBox.input.text = '' 

        if raw == '' then return end

        local tokens = {}
        for token in raw:gmatch("%S+") do 
            table.insert(tokens, token) 
        end
        return raw, tokens
    end
end

function inputBox.draw() suit.draw() end

function inputBox.textinput(t) suit.textinput(t) end

function inputBox.textedited(text, start, length) suit.textedited(text, start, length) end

function inputBox.keypressed(key) suit.keypressed(key) end

return inputBox