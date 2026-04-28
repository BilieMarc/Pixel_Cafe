# Architecture Document

## Tech Stack
- Language: Lua
- Engine: LÖVE2D
- Libraries: SUIT, Class, Push, StateMachine, StateStack

## Project Structure
- main.lua
- .gitignore
- .gitmodules
- README.md
src/
- constants.lua
- Dependencies.lua
src/libs
- SUIT
- class.lua
- push.lua
- StateMachine.lua
- StateStack.lua
src/states
- BaseState.lua
src/states/game
- PlayState.lua 
- DayEndState.lua
- PauseMenu.lua
- StartMenu.lua
src/states/entity
- BaseEntity.lua
- Button.lua
- CoffeeMachine.lua
- Cursor.lua
- CustomerState.lua
- CustomerManager.lua
- OrderBox.lua
- FloatingMoney.lua
- TimeManager.lua

## Core Systems

### Input System

### Camera System
- stationary camera with the frame focused on the counter, status bar and customer window.

## Non-Goals
- Multiplayer
- Server authority