# Architecture Document

## Tech Stack
- Language: Lua
- Engine: LÖVE2D
- Libraries: SUIT, Class, Push, StateMachine, StateStack, dkjson

## Project Structure
- main.lua
- .gitignore
- .gitmodules
- README.md
src/
- Animation.lua
- constants.lua
- DataManager.lua
- Dependencies.lua
- InputBox.lua
src/libs
- SUIT
- class.lua
- dkjson.lua
- push.lua
- StateMachine.lua
- StateStack.lua
src/states
- BaseState.lua
src/states/game
- PlayState.lua 
- DayEndState.lua
- PauseMenu.lua
- PopupWindow.lua
- SettingState.lua
- ShopMenu.lua
- StartMenu.lua
src/states/entity
- BaseEntity.lua
- BreadBasket.lua
- BreadPlate.lua
- Button.lua
- CoffeeMachine.lua
- Cursor.lua
- CustomerState.lua
- CustomerManager.lua
- OrderBox.lua
- FloatingMoney.lua
- SandwichPlate.lua
- Scrollbar.lua
- ShopItem.lua
- TimeManager.lua
src/states/GUI
- StartMenuBackground.lua
- PauseMenuCard.lua
- DayEndStateCard.lua
- PopupWindowCard.lua
- CityBackground.lua
- CounterBackground.lua
- ShopBackground.lua
- ShopTopBox.lua

## Core Systems

### Input System
- The game utilizes a hybrid input model handled primarily through main.lua and BaseState.lua:
- Mouse (Primary):
    - X/Y Tracking: Global mouseX and mouseY variables updated every frame via push:toReal.
    - Interaction Logic: getInteractableAt(x, y) checks the self.interactables table of the current state to trigger onPressed or onReleased events.
    - Wheel Scroll: gWheelY tracks vertical scroll offset, specifically utilized by the Scrollbar and ShopMenu for list navigation.

- Keyboard (Secondary/Utility):
    - State Toggles: p or ESC triggers the PauseMenu via the StateStack.
    - Developer Terminal: k opens the InputBox (via SUIT) for string-based command parsing (e.g., \dev skip).
    - Shortcuts: d allows for instant day skipping during the prototype phase

### Camera System
- stationary camera with the frame focused on the counter, status bar and customer window.

## Non-Goals
- Multiplayer
- Server authority
