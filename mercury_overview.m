%-----------------------------------------------------------------------------%
% vim: ft=mercury ts=4 sw=4 et
%-----------------------------------------------------------------------------%
% Module: mercury_overview
% Author: Jacob Schrum
% Date: 2024-05-30
%
% Description:
% Assignment that provides an overview of basic features
% of the Mercury programming language.                 
%
% I will be grading the output of evaluating the main predicate
% defined in main.m. I will compile and run in the manner described
% in the README file. I recommend using GitHub codespaces to work 
% on this code. 
%
% You are expected to complete all exercises according
% to the specifications. Do not change the names or headers
% for any existing predicates. You may add new predicates.                
% This will require you to provide both the pred signature and the 
% predicate definition. All predicates in this file must have complete 
% header comments as described in the commenting style guide on Moodle.
% Additional documentation is required within predicate bodies as 
% appropriate. Some predicate stubs result in a dummy result of
% true or an arbitrary dummy assignment to allow execution, but 
% you will need to replace these with proper results. Whenever 
% console output is required, all formatting must match the 
% specification exactly.
%
% Important Note on Style: A Singleton Variable is a variable that
% only appears once in a predicate definition. If a variable only
% appears once, then it serves no purpose, because it could take on                  
% any value without affecting whether or not the predicate evaluates
% to true. The presence of a singleton variable often indicates some
% kind of logic error, but even if there are no errors, such variables
% are still an example of bad style. STYLE POINTS WILL BE SUBTRACTED
% IF THERE ARE SINGLETON VARIBLES IN YOUR SUBMISSION. Note that the
% original code stub has singleton variables because the code is 
% incomplete (a warning appears when you compile it), but these should
% be fixed in your final submission.
%-----------------------------------------------------------------------------%

:- module mercury_overview.
:- interface.

% The modules imported here can be used in your implementations below, but they
% need to be imported in the interface section of the code because they introduce types
% that are required in some of the type signatures.

:- import_module io.         % nl, write_string, format, write_int, read, see, seen, open_input, close_input, and more
:- import_module list.       % list type, [], [X|XS], ++, length, map, and more
:- import_module int.        % int type and arithmetic operations
:- import_module string.     % string type, length, det_index, from_char_list, split_into_lines, strip, det_to_int, and more

% As you add additional predicates below, you will also need to add
% the corresponding predicate interface here.

:- pred exercise1(io::di, io::uo) is det.
:- pred limited_sum(int::in, int::in, int::out) is det.
:- pred exercise2(io::di, io::uo) is det.
:- pred first_longer_shorter(string::in, string::in, string::out) is det.
:- pred exercise3(io::di, io::uo) is det.
:- pred moved_to_end(list(int)::in, int::in, list(int)::out) is det.
:- pred exercise4(io::di, io::uo) is det.
:- pred recursive_seq(int::in, int::out) is det.
:- pred dynamic_seq(int::in, int::out) is det.
:- pred exercise5(io::di, io::uo) is det.

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%

:- implementation. % Actual code appears beneath this

% These modules might be needed in the implementation below, but are not
% required in any of the interface signatures above.

:- import_module exception.  % throw
:- import_module maybe.      % maybe type is either yes(Result) or no
:- import_module float.      % float type and arithmetic operations 
:- import_module char.       % char type and more

%-----------------------------------------------------------------------------%

% exercise1/2
% Exercise 1: Iterative Recursion
% 9 points functionality, 4 points documentation  
%
% For this exercise, you must use recursion
% to iterate over several values and reach a conclusion. Therefore,
% you will need to define an additional predicate to handle the       
% iteration for you.
%
% Define the predicate limited_sum(B,E,S), which is true if the sum of all 
% numbers between B and E inclusive that are divisible by 13 equals S. Use
% this predicate in the exercise1() predicate to determine the sum of
% all numbers between 200 and 1287 inclusive that are divisible by 13. 
% Afterward, take that result and print it to the console. The format 
% of your printed output should be a single line with a carriage return, 
% and look like the following:
% 
% The sum is: XXX
% 
% where XXX is the resulting sum.
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
exercise1(!IO) :-
    true.   % TODO: Change this


% limited_sum/3
% True if S is the sum of all numbers between B and E (inclusive)
% that are divisible by 13.
%
% Parameters:
%   B - Beginning of the number range to scan.
%   E - End of the number range to scan.
%   S - Sum of numbers in the range divisible by 13.
%
limited_sum(B, E, S) :-
    S = -1. % TODO: Change this assignment

%-----------------------------------------------------------------------------%

% exercise2/2
% Exercise 2: Strings
% 9 points functionality, 9 points documentation
% 
% Define a predicate called first_longer_shorter(A,B,R)
% where all parameters are strings, and A and B each have
% at least one character. If either A or B is an empty
% string, then use the command throw("invalid string")
% to produce an exception. Otherwise, the parameter R is the 
% result, a string consisting of exactly two characters:
% The first character of the longer string (between A and B), 
% followed by the first character of the shorter string
% (between A and B). If both strings have equal length,                
% then the first character of A should come first in R.
% 
% After defining your predicate, uncomment the test calls
% below which call your predicate. Note that your predicate
% must work for any valid input, not just for these
% examples.
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
exercise2(!IO) :-
    % TODO: Uncomment to test your completed predicate.
    %       Turn in your code with these lines uncommented. 
    %first_longer_shorter("Hello","Bye",A),
    %io.write_string(A,!IO),
    io.nl(!IO),
    %first_longer_shorter("Bye","Hello",B),
    %io.write_string(B,!IO),
    io.nl(!IO),
    %first_longer_shorter("1","abc",C),
    %io.write_string(C,!IO),
    io.nl(!IO),
    %first_longer_shorter("abc","1",D),
    %io.write_string(D,!IO),
    io.nl(!IO),
    %first_longer_shorter("abc","123",E),
    %io.write_string(E,!IO),
    io.nl(!IO),
    %first_longer_shorter("123","abc",F),
    %io.write_string(F,!IO),
    io.nl(!IO).

% Provide the definition and a properly formatted comment for this predicate.
first_longer_shorter(A,B,R) :-
    R = "". % TODO: Change this assignment

%-----------------------------------------------------------------------------%

% exercise3/2
% Exercise 3: Lists
% 10 points functionality, 9 points documentation
% 
% Define a predicate called moved_to_end that takes a list,
% an index within that list, and a resulting list. The predicate
% is true if the resulting list has the same items in the same order,
% except that the item at the designated index is now at the end of
% the list, and items that previously came after it now appear one
% position to the left.    
% 
% Test your predicate by completing the code below. This code should
% call moved_to_end with a list containing 1, 2, ..., 10 in order, 
% and an index of 4, with the result specified as a variable. Afterward, 
% print the contents of the result list to the console on a single line 
% with a carriage return at the end, and a comma and space between each 
% entry. The result should look like the following:
% 
% 1, 2, 3, 4, 6, 7, 8, 9, 10, 5
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
exercise3(!IO) :-
    % TODO: Call moved_to_end as described above and print the result.
    true. % TODO: Change this

% Provide the definition and a properly formatted comment for this predicate.
moved_to_end(L,I,R) :-
    R = []. % TODO: Change this assignment

%-----------------------------------------------------------------------------%

% exercise4/2
% Exercise 4: Recursion
% 10 points functionality, 9 points documentation
% 
% Define a sequence in the following way. The first three
% numbers are 1, 2, and 3. Every subsequent number is the sum of
% the previous number, and the number two entries before that
% one. So, the first few numbers in the sequence are:
% F(0) = 1
% F(1) = 2
% F(2) = 3
% F(3) = 1+3 = 4
% F(4) = 2+4 = 6
% 
% This sequence is similar to, but different from the Fibonacci
% sequence. You will write two predicates determining if an 
% element is the N-th number of the sequence. One uses pure recursion, 
% the other uses dynamic programming. However, your dynamic
% programming solution will also use recursion. In order to 
% use dynamic programming, you have to track enough information
% with your parameters to avoid recalculating any values of the
% sequence. You will need an auxiliary predicate to accomplish this.
% 
% The predicate stubs for each approach are provided below. Once they
% are complete, you can uncomment the code in this method to test
% them. Note that for negative inputs, these predicates should each 
% use the command throw("negative int") to throw an exception.
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
exercise4(!IO) :-
    % TODO: Uncomment the commented lines below to test your completed predicates.
    %       Turn in your code with these lines uncommented.
    %recursive_seq(5,A),
    %io.write_int(A,!IO),
    io.nl(!IO),
    %dynamic_seq(5,X),
    %io.write_int(X,!IO),
    io.nl(!IO),
    %recursive_seq(8,B),
    %io.write_int(B,!IO),
    io.nl(!IO),
    %dynamic_seq(8,Y),
    %io.write_int(Y,!IO),
    io.nl(!IO),
    %recursive_seq(15,C),
    %io.write_int(C,!IO),
    io.nl(!IO),
    %dynamic_seq(15,Z),
    %io.write_int(Z,!IO),
    io.nl(!IO).

% recursive_seq/2
% 
% Recursively determine if F is the N-th number of
% the sequence described in the comment for
% exercise4.
%
% Parameters:
%   N - Position in the sequence
%   F - n-th value in the sequence
%
recursive_seq(N,F) :-
    F = -1. % TODO: Change this assignment.

% dynamic_seq/2
% 
% Determine if F is the N-th number of
% the sequence described in the comment for
% exercise4 using dynamic programming.
% This predicate is only a kick-off for
% a recursive predicate.
%
% Parameters:
%   N - Position in the sequence
%   F - n-th value in the sequence
%
dynamic_seq(N,F) :-
    F = -1. % TODO: Change this assignment.

%-----------------------------------------------------------------------------%

% exercise5/2
% Exercise 5: File I/O
% 12 points functionality, 9 points documentation
% 
% This predicate should read from the file "numbers.txt" which
% contains only integers, exactly one per line. I recommend using a
% helper predicate that computes the maximum and average of the 
% numbers in the file recursively. Once computed, the values should
% be printed to the console. The maximum should be formatted as an 
% int, but the average should be a floating point average. The output
% will consist of exactly two lines, each followed by a carriage return.
% Here is an example:
% 
% Maximum value: XXX
% Average value: XXX
% 
% where the XXX portions will be replaced with actual values calculated
% from the file. Note that your code must work for arbitrary input files,
% not just the provided example. However, you can assume the file is
% named "numbers.txt". If a file with this name does not exist, then
% do not crash with an exception. Instead, print the error message below
% followed by a carriage return:
% 
% The file "numbers.txt" does not exist. Exiting.
%  
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
exercise5(!IO) :- 
    % TODO: Write according to the specification above.
    true. % TODO: Change this.

%-----------------------------------------------------------------------------%
:- end_module mercury_overview.
%-----------------------------------------------------------------------------%
