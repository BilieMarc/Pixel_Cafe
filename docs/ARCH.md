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
- TimeManager.lua
src/states/GUI
- StartMenuBackground.lua
- PauseMenuCard.lua
- DayEndStateCard.lua
- PopupWindowCard.lua

## Core Systems

### Input System

### Camera System
- stationary camera with the frame focused on the counter, status bar and customer window.

## Non-Goals
- Multiplayer
- Server authority
