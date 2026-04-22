# Changelog

## Prototype Below
### version no. - date
- Changes described such that even outsider can see the progress.

### v0.1.0 - 2026-04-05
- Rough outline of the project is created.

### v0.2.0 - 2026-04-17
- Pixel is font is changed into gFonts table with a variety of font size to accomoadate different writing purpose.
- Changed StateStack's pop and update function so that specific states are exited and also update all the states not just the top one.
- Cursor entity is added with a isDragging property to handle displaying something being dragged. Currently, due to limited assets, only a white cirlce is being dragged.
- Customer State entity now is a functional entity with the capability of redering, receiving order and exiting upon receiving order.
- When entering DayEndState, instead of poping the top of the stack, changed to clearing everything in the stack that includes all the entities and the playstate.
- In playstate, instead of making independent variable like the previous update, make them all global states.
- Change the font of time display.
- In playstate, added dragging logic. Delete the rectangle representing the customer and make it so that there are three customers.
- Data related to entities are written in constants file.
- Move the require of constants below gFonts and gFrames in Dependencies.
- In main file, functions for mouse operations are added. And mx and my are changed from local to global with mouseX and mouseY.
- Added PauseMenu. click p to enter pausemenu and then enter to exit pausemenu. For future use, the state stack is modified to house both play state and pause menu simutaneously.

### v0.3.0 - 2026-04-20
- Extracted time management and tracking logic from PlayState into a new dedicated TimeManager class.
- Stabilized the timer UI by separating the digital clock values from the AM/PM period strings with absolute coordinates to prevent shifting.
- Modified the time UI to only visually update every 15 in-game minutes, making the time cleanly skip steps while maintaining exact continuous time underneath.

### v0.4.0 - 2026-04-21
- In playstate, previous mouse check mechanic is now replaced with a universal one which doesn't need adding more lines. By using interactables table and getInteractableAt function, just adding other interactable entities at the table is all it takes now.
- Separate the condition checking for click and drag so that condition checkings can be reduced further down the line.
- Now all the entities include property type.
- Add a new file to handle basic functions of entities which include initiating a parameter, rendering, mouse check and mouse response.
- Unlike the issue requirement, the circle doesn't disappear with time but drawn. Color is set to a desired color and then reset to white to avoid impacting other entities.
- gColors is built with nine colors to faciliate the use of colors in the future.
- A decision is registered.

### v0.5.0 - 2026-04-22
- **constants.lua**: Replaced static `CUSTOMER_ENTITIES` table with `WAITING_SLOTS` (three x,y counter positions), `ENTRANCE_X`, and `EXIT_X` for linear customer movement. Added `CUSTOMER_CONFIG` (moveSpeed, spawnInterval, patienceMax, patienceDecayRate, baseTip, patienceBonus) and `ORDER_TYPES` table for order pricing.
- **CustomerState.lua**: Full rewrite into a state-driven lifecycle: `MOVING_IN → WAITING → PAYING → LEAVING → DONE`. Customers walk from `ENTRANCE_X` to an assigned slot, wait with an order box, briefly pause in a PAYING state upon receiving their order, then walk to `EXIT_X`. `receiveItem(itemType)` performs a strict string comparison against `self.orderType`. Payment includes a patience-scaled tip.
- **OrderBox.lua**: Created as a separate entity owned by `CustomerState`. Renders a white box with the order label and a colour-coded patience bar (green → yellow → red). Patience decays at `CUSTOMER_CONFIG.patienceDecayRate` per second; hitting 0 triggers `customer:leaveImpatient()`. Box size reduced to 34×26 after initial size was too large.
- **CustomerManager.lua**: New file. Handles the customer spawn timer (with ±0.5 s jitter), slot occupancy tracking, and removal of `done`-state customers. Exposes `getAllCustomers()`, `getOccupiedSlotCount()`, and related helpers to keep `PlayState` clean.
- **FloatingMoney.lua**: New entity. Spawns at the customer's position when an order is paid, floats upward 40 px, and fades out over 1.5 seconds. Managed entirely by `PlayState`'s own table — never pushed to the state stack.
- **PlayState.lua**: Major refactor. Replaced manual three-customer array with `CustomerManager`. All entities (`coffeeMachine`, `cursor`, customers) are now updated and rendered directly by `PlayState` rather than via `gStateStack`, eliminating double-update and double-render bugs. Render order is strictly back-to-front: background → customers → coffee machine (counter occludes customer bottom) → floating money → cursor. Money HUD added (top-right, green). Customer count HUD added (top-left, small font). `deliverCoffee()` and `spawnFloatingMoney()` helpers extracted for clarity.
- **Cursor.lua**: Cursor circle now draws with an explicit amber colour `(0.85, 0.55, 0.1)` and a dark outline, so it is always visible regardless of what the previous render call set. Cursor is rendered as the absolute last draw call in `PlayState:render()`, guaranteeing it appears on top of all other entities including customers and the coffee machine.
- **Dependencies.lua**: Added `require` entries for `CustomerManager`, `OrderBox`, and `FloatingMoney`.