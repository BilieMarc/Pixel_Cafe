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

<<<<<<< HEAD
### v0.3.0 - 2026-04-21
- In playstate, previous mouse check mechanic is now replaced with a universal one which doesn't need adding more lines. By using interactables table and getInteractableAt function, just adding other interactable entities at the table is all it takes now.
- Separate the condition checking for click and drag so that condition checkings can be reduced further down the line.
- Now all the entities include property type.
- Add a new file to handle basic functions of entities which include initiating a parameter, rendering, mouse check and mouse response.
- Unlike the issue requirement, the circle doesn't disappear with time but drawn. Color is set to a desired color and then reset to white to avoid impacting other entities.
- gColors is built with nine colors to faciliate the use of colors in the future.
- A decision is registered.
=======
### v0.3.0 - 2026-04-20
- Extracted time management and tracking logic from PlayState into a new dedicated TimeManager class.
- Stabilized the timer UI by separating the digital clock values from the AM/PM period strings with absolute coordinates to prevent shifting.
- Modified the time UI to only visually update every 15 in-game minutes, making the time cleanly skip steps while maintaining exact continuous time underneath.
>>>>>>> f59a5ad196999dbbd94da98907cdc9eeb8ade5f7
