# Sudoku Solver

Constraint satisfaction problems allow various contains to be enforced to solve a problem. This project demonstrates constraint satisfactions ued to solve Sudoku.

## Application

A Prolog program that solves Sudoku of any valid size.

* Must be square.
* The total length and width must be equal to the area of inner boxes.
* All inner boxes must be the same size of any width and height.

`Puzzle_Width = Puzzle_Height = Box_Width * Box_Height`

Various valid unsolved Sudoku samples are also provided.

### Invoking Instructions

The program can be loaded with  using `swipl -s main.pl` and solve all provided Sudoku with `main(_).`.

This project works with `SWI-Prolog version 9.0.4`.
