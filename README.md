# GameOfLife

## Rules

- Alive Cells
  - 2,3 neighbors: stay alive
  - <2 neighbors: die
  - 4+ neighbors: die
- Dead Cells
  - 3 neighbors: come alive

## Design

- Game
  - knows the rules
  - _ticks_ the clock
- World
  - where the cells live
  - assumption is usually a 2d board like a chess board
  - could be anything you want
    - cube
    - sphere
    - infinite boundaries
  - Agent or Server where state is a list of alive cells
- Cell
