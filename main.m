%-----------------------------------------------------------------------------%
% vim: ft=mercury ts=4 sw=4 et
%-----------------------------------------------------------------------------%
% Module: main
% Author: Jacob Schrum
% Date: 2024-05-30
%
% Description:
% Runs the various exercises from mercury_overview.
%
% DO NOT MODIFY THIS FILE!

:- module main.
:- interface.
:- import_module io.

% main/2
% Launches code for all exercises. Do not change.
% Note that the main predicate has to be declared under interface
% because this predicate is invoked by executing this code. However,
% the actual implementation appears in the implementation portion of
% the code below.
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
:- pred main(io::di, io::uo) is det.

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%

:- implementation.

:- import_module mercury_overview. % Where you will write your code
:- import_module list.
:- import_module string.

%-----------------------------------------------------------------------------%

% Runs exercises from mercury_overview
main(!IO) :-
    print_divider(1,!IO),
    exercise1(!IO),
    print_divider(2,!IO),
    exercise2(!IO),
    print_divider(3,!IO),
    exercise3(!IO),
    print_divider(4,!IO),
    exercise4(!IO),
    print_divider(5,!IO),
    exercise5(!IO).

%% For predicates that are not called externally, both the predicate
%% declaration and the corresponding definition can appear together.

% print_divider/3
% Prints a dividing line between each exercise.  
%
% Parameters:
%     X - Problem number printed in output
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
:- pred print_divider(int::in, io::di, io::uo) is det.
print_divider(X,!IO) :-
    io.format("--Exercise %d----------------------------------\n", [i(X)], !IO).

%-----------------------------------------------------------------------------%
:- end_module main.
%-----------------------------------------------------------------------------%
