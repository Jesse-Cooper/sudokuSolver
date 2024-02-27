# Sudoku Solver

Constraint satisfaction problems allow various constraints to be enforced in-order solve a problem. This project demonstrates constraint satisfactions used to solve Sudoku.

## Application

A Prolog program that solves Sudoku of any valid size.

* Must be square.
* The total length and width must be equal to the area of inner boxes.
* All inner boxes must be the same size of any width and height.

`Puzzle_Width = Puzzle_Height = Box_Width * Box_Height`

Various valid unsolved Sudoku samples are also provided.

### Invoking Instructions

The program can be loaded with `swipl -s main.pl` and to solve all provided Sudoku use `main(_).`.

This project works with `SWI-Prolog version 9.0.4`.
