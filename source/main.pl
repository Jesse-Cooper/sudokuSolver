% Provides a program to solve Sudoku.

% Sample Sudoku are provided and can be selected, solved and displayed with
% the `main` predicate.

% Sudoku should have 1 solution, however, the program will find multiple if
% possible.

% Can load the program with `swipl -s main.pl` and solve all with `main(_).`.


:- ensure_loaded(library(clpfd)).
:- ensure_loaded(library(listing)).

:- include(samples).


%% main(?I_Sample).
%
%  Selects, solves and displays a sample `Sudoku`.
main(I_Sample) :-
    sample(I_Sample, Sudoku, Box_Width, Box_Height),
    sudoku_solution(Sudoku, Box_Width, Box_Height),
    maplist(portray_clause, Sudoku).


%% sudoku_solution(+Sudoku, +Box_Width, +Box_Height).
%
%  Solves `Sudoku`.
%  Ensures `Sudoku` is valid with the boxes defined by `Box_Width` and
%  `Box_Height` fitting within it.
%
%  Constrain each row, column and box of `Sudoku` to have distinct values then
%  solves it.
sudoku_solution(Sudoku, Box_Width, Box_Height) :-

    Sudoku_Size is Box_Width * Box_Height,

    % ensure `Sudoku` is valid - square and width/height = `Sudoku_Size`
    Box_Width >= 1,
    Box_Height >= 1,
    length(Sudoku, Sudoku_Size),
    maplist(same_length(Sudoku), Sudoku),

    % constrain each value to the range `[1, Sudoku_Size]`
    maplist({Sudoku_Size}/[Row] >> (Row ins 1..Sudoku_Size), Sudoku),

    % constrain rows and columns to have distinct values
    maplist(all_distinct, Sudoku),
    transpose(Sudoku, Sudoku_Transpose),
    maplist(all_distinct, Sudoku_Transpose),

    constrain_boxes(Sudoku, 0, 0, Box_Width, Box_Height, Sudoku_Size),

    maplist(label, Sudoku).


%% constrain_boxes(+Sudoku, +X, +Y, +Box_Width, +Box_Height, +Sudoku_Size).
%
%  Constrains each box of the `Sudoku` to have distinct values.
%
%  Uses a sliding window of matrix minors to get each `Sudoku` box into a single
%  list to constrain each value to be distinct.

% Have constrained all boxes.
constrain_boxes(_, _, Sudoku_Size, _, _, Sudoku_Size).

% Have constrained all boxes on current line move to next line.
constrain_boxes(Sudoku, Sudoku_Size, Y, Box_Width, Box_Height, Sudoku_Size) :-
    Y2 is Y + Box_Height,
    constrain_boxes(Sudoku, 0, Y2, Box_Width, Box_Height, Sudoku_Size).

% Constrain box to have distinct values at starting at `X` and `Y`.
constrain_boxes(Sudoku, X, Y, Box_Width, Box_Height, Sudoku_Size) :-
    X < Sudoku_Size,
    Y < Sudoku_Size,

    minor(Sudoku, Box, X, Y, Box_Width, Box_Height),
    all_distinct(Box),

    X2 is X + Box_Width,
    constrain_boxes(Sudoku, X2, Y, Box_Width, Box_Height, Sudoku_Size).


%% minor(+Matrix, ?Minor, +X, +Y, +W, +H).
%
%  Gets the `Minor` or `Matrix` of width, `W`, and  height, `H`, starting at row
%  `Y` and column `X`.
%  `Minor` is a single list (matrix rows flattened).
%  Intended for matrices of relatively small sizes (uses append).
%
%  Moves down `Matrix` rows until at row `Y`. `H` times splits each row into 3
%  lists with the middle list starting at element `X` and of length `W`. The
%  middle list is a row of the `Minor` and is combined into a single list.

% Have collected all rows of the minor.
minor(_, [], _, _, _, 0).

% Move down rows of the matrix until at row `Y`.
minor([_|Tail], Minor, X, Y, W, H) :-
    Y > 0,
    Y2 is Y - 1,
    minor(Tail, Minor, X, Y2, W, H).

% Collect the current row of the minor and combine it with the next row.
minor([Head|Tail], Minor, X, 0, W, H) :-
    X >= 0,
    W > 0,

    % split the current row into 3 lists - `Mid` is the list wanted
    length(Left, X),
    append(Left, Mid_Right, Head),
    length(Mid, W),
    append(Mid, _, Mid_Right),

    % combine next row values with this `Mid`
    H2 is H - 1,
    append(Mid, Next, Minor),
    minor(Tail, Next, X, 0, W, H2).
