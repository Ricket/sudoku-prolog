% Sudoku constraints in prolog

%   012345678
% 0 000111222
% 1 000111222
% 2 000111222
% 3 333444555
% 4 333444555
% 5 333444555
% 6 666777888
% 7 666777888
% 8 666777888

% box 0: 0, 1, 2, 9, 10, 11, 18, 19, 20
% box 1: 3, 4, 5, 12, 13, 14, 21, 22, 23
% box 2: 6, 7, 8, 15, 16, 17, 24, 25, 26
% box 3: 27, 28, 29, 36, 37, 38
% box 4: 30, 31, 32,
% box 5: 33, 34, 35

cell_index(C) :-
    integer(C),
    C >= 0,
    C < 81.

cell_value(V) :-
    integer(V),
    V >= 1,
    V < 10.

row(Cell, Rownum) :-
    cell_index(Cell),
    Rownum is floor(Cell / 9).
col(Cell, Colnum) :-
    cell_index(Cell),
    Colnum is Cell mod 9.
box(Cell, Boxnum) :-
    cell_index(Cell),
    row(Cell, Rownum),
    col(Cell, Colnum),
    Boxnum is floor(Rownum / 3) * 3 + floor(Colnum / 3).

same_row(C1, C2) :-
    row(C1, Rownum),
    row(C2, Rownum).

same_column(C1, C2) :-
    col(C1, Colnum),
    col(C2, Colnum).

same_box(C1, C2) :-
    box(C1, Boxnum),
    box(C2, Boxnum).

orthogonal_ordered(C1, C2) :-
    cell_index(C1),
    cell_index(C2),
    (
        C1 is C2 - 1;
        C1 is C2 - 9
    ).
orthogonal(C1, C2) :- orthogonal_ordered(C1, C2).
orthogonal(C1, C2) :- orthogonal_ordered(C2, C1).

kings_move_ordered(C1, C2) :-
    cell_index(C1),
    cell_index(C2),
    (
        orthogonal_ordered(C1, C2);
        C1 is C2 - 10;
        C1 is C2 - 8
    ).

knights_move_ordered(C1, C2) :-
    cell_index(C1),
    cell_index(C2),
    (
        C1 is C2 - 19;
        C1 is C2 - 17;
        C1 is C2 - 7;
        C1 is C2 - 11
    ).
knights_move(C1, C2) :- knights_move_ordered(C1, C2).
knights_move(C1, C2) :- knights_move_ordered(C2, C1).

valid_value(Cell, Val) :- value(Cell, Val).
valid_value(Cell, Val) :-
    valid_value(Cell2, Val),
    Cell \= Cell2,
    not(same_column(Cell, Cell2)),
    not(same_row(Cell, Cell2)),
    not(same_box(Cell, Cell2)),
    not(knights_move(Cell, Cell2)),
    valid_value(Cell3, Val),
    Cell \= Cell3,
    not(orthogonal(Cell, Cell3)).

% populate the sudoku board
value(38, 1).
value(51, 2).



