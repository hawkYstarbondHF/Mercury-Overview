%-----------------------------------------------------------------------------%
% vim: ft=mercury ts=4 sw=4 et
%-----------------------------------------------------------------------------%
% Module: test
% Author: Jacob Schrum
% Date: 2024-05-31
%
% Description:
% Perform unit tests on mercury_overview. Since Mercury is a new language, and
% does not have a firmly established unit testing framework yet, this file
% uses a custom approach to test the code.
%-----------------------------------------------------------------------------%

:- module test.
:- interface.
:- import_module io.

% main/2
% Performs all tests.
%
% Parameters:
%   !IO - The input-output state. Note that the use of ! signifies
%         two parameters, both the before and after state of a variable.
%
:- pred main(io::di, io::uo) is det.

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%

:- implementation. % Actual code appears beneath this

:- import_module mercury_overview.
:- import_module string.
:- import_module list.
:- import_module exception.
:- import_module char.
:- import_module maybe.

% capture_output/4
% Executes a command that would normally output to the console,
% but sends the output to a temporary file instead. Next, the
% contents of that temporary file are read and turned into
% and output string from this predicate.
%
% Parameters:
%          P - Predicate that takes !IO and produces console output.
%     Output - String of output that would normally go to the console from P.
%        !IO - The input-output state. Note that the use of ! signifies
%              two parameters, both the before and after state of a variable.
% 
:- pred capture_output(pred(io, io), string, io, io).
:- mode capture_output(pred(di, uo) is det, out, di, uo) is det.
capture_output(P, Output, !IO) :-
    make_temp_file(Tmp, !IO),
    (
        Tmp = ok(TmpFileName)
    ;
        throw("Failed to create temp file. Cannot complete tests.")
    ),
    % Open temporary file for writing
    io.open_output(TmpFileName, Result, !IO),
    (
        Result = ok(File),
        % Redirect output to the file
        io.set_output_stream(File, OldStream, !IO),
        % Call the predicate whose output we want to capture
        P(!IO), % Writes to file
        % Restore original output stream
        io.set_output_stream(OldStream, _, !IO),
        % Close the temporary file
        io.close_output(File, !IO),
        % Now re-open and read the file contents
        read_file(TmpFileName, TempContents, !IO),
        (
            TempContents = yes(Output)
        ;
            TempContents = no,
            throw("Could not read from temp file. Cannot complete tests.")
        )
    ;
        Result = error(_),
        throw("Could not write to temp file. Cannot complete tests.")
    ),
    % Try to delete, but don't stop program if it somehow fails
    remove_file(TmpFileName, _, !IO).

% read_file/4
% Adapted from https://dbp.io/essays/2011-09-03-mercury-tidbits.html
% This reads the entire contents of a designated file
% into a single string.
%
% Parameters:
%   Path     - Full string path to file to read.
%   Contents - Either yes(String) where String represents the file
%              contents, or no if reading fails.
%        !IO - The input-output state. Note that the use of ! signifies
%              two parameters, both the before and after state of a variable.
% 
:- pred read_file(string::in,
                  maybe(string)::out,
                  io::di,io::uo) is det.
read_file(Path,Contents,!IO) :-
  io.see(Path,Result,!IO),
  ( Result = ok,
    io.read_file_as_string(File,!IO),
    io.seen(!IO),
    (
      File = ok(String),
      Contents = yes(String)
    ;
      File = error(_,_),
      Contents = no
    )
  ;
    Result = error(_),
    Contents = no
  ).

% assert_equals/5
% If two strings are equal, then this predicate does nothing.
% However, if they are not equal, then output to the console
% will indicate the difference between actual and expected output.
%
% Parameters:
%   Expected - String that is supposed to be produced.
%     Actual - String that user code did produce.
%      Label - Identifying label for the test in the error message.
%        !IO - The input-output state. Note that the use of ! signifies
%              two parameters, both the before and after state of a variable.
% 
:- pred assert_equals(string::in, string::in, string::in, io::di,io::uo) is det.
assert_equals(Expected, Actual, Label, !IO) :-
    (Actual = Expected -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.format("%s output incorrect:\nExpected:\n%s\nActual:\n%s\n",[s(Label),s(Expected),s(Actual)],!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ).

:- pred limited_sum_tests is semidet.
limited_sum_tests :-
    \+ limited_sum(200, 1287, 62780),
    limited_sum(200, 1287, 62790),
    \+ limited_sum(15, 78, 300),
    limited_sum(15, 78, 260),
    \+ limited_sum(331, 1503, 82470),
    limited_sum(331, 1503, 82485).

:- pred first_longer_shorter_tests is semidet.
first_longer_shorter_tests :-
    \+ first_longer_shorter("Hello","Bye","BH"),
    first_longer_shorter("Hello","Bye","HB"),
    \+ first_longer_shorter("Bye","Hello","BH"),
    first_longer_shorter("Bye","Hello","HB"),
    \+ first_longer_shorter("1","abc","1a"),
    first_longer_shorter("1","abc","a1"),
    \+ first_longer_shorter("abc","1","1a"),
    first_longer_shorter("abc","1","a1"),
    \+ first_longer_shorter("abc","123","1a"),
    first_longer_shorter("abc","123","a1"),
    \+ first_longer_shorter("123","abc","a1"),
    first_longer_shorter("123","abc","1a"),
    \+ first_longer_shorter("x x x x x x x x x x x x x x x x x x x x x x x x s x s sdasf dsfsdf sdf sdf sdfewfasf fsakkkasdfkwa o93 2","sad","sx"),
    first_longer_shorter("x x x x x x x x x x x x x x x x x x x x x x x x s x s sdasf dsfsdf sdf sdf sdfewfasf fsakkkasdfkwa o93 2","sad","xs"),
    \+ first_longer_shorter("\taddasdad \n\n we","\n \t\n\n\n\t\tx x x x x x x x x x x x x x x x x x x x x x x x s x s sdasf dsfsdf sdf sdf sdfewfasf fsakkkasdfkwa o93 2","\t\n"),
    first_longer_shorter("\taddasdad \n\n we","\n \t\n\n\n\t\tx x x x x x x x x x x x x x x x x x x x x x x x s x s sdasf dsfsdf sdf sdf sdfewfasf fsakkkasdfkwa o93 2","\n\t").

:- pred first_longer_shorter_error1(string::out) is det.
first_longer_shorter_error1(Message) :-
    promise_equivalent_solutions [Message] (
        try [] first_longer_shorter("","Test",_)
        then Message = "first_longer_shorter_error1 failed\n"
        catch "invalid string" -> Message = "" % There is supposed to be an exception
    ).

:- pred first_longer_shorter_error2(string::out) is det.
first_longer_shorter_error2(Message) :-
    promise_equivalent_solutions [Message] ( 
        try [] first_longer_shorter("Test","",_)
        then Message = "first_longer_shorter_error2 failed\n"
        catch "invalid string" -> Message = "" % There is supposed to be an exception
    ).

:- pred moved_to_end_tests is semidet.
moved_to_end_tests :-
    map(moved_to_end([1,2,3,4,5,6,7,8,9,10]),[0,1,2,3,4,5,6,7,8,9], [[2,3,4,5,6,7,8,9,10,1],[1,3,4,5,6,7,8,9,10,2],[1,2,4,5,6,7,8,9,10,3],[1,2,3,5,6,7,8,9,10,4],[1,2,3,4,6,7,8,9,10,5],[1,2,3,4,5,7,8,9,10,6],[1,2,3,4,5,6,8,9,10,7],[1,2,3,4,5,6,7,9,10,8],[1,2,3,4,5,6,7,8,10,9],[1,2,3,4,5,6,7,8,9,10]]),
    map(moved_to_end([10000,-243,32,367845]),[0,1,2,3], [[-243,32,367845,10000],[10000,32,367845,-243],[10000,-243,367845,32],[10000,-243,32,367845]]),
    map(moved_to_end([1,2,3,1,2,3,4,4,3,2]),[0,1,2,3,4,5,6,7,8], [[2,3,1,2,3,4,4,3,2,1],[1,3,1,2,3,4,4,3,2,2],[1,2,1,2,3,4,4,3,2,3],[1,2,3,2,3,4,4,3,2,1],[1,2,3,1,3,4,4,3,2,2],[1,2,3,1,2,4,4,3,2,3],[1,2,3,1,2,3,4,3,2,4],[1,2,3,1,2,3,4,3,2,4],[1,2,3,1,2,3,4,4,2,3]]),
    \+ moved_to_end([1,2,3,4,5,6,7,8,9,10],0,[1,2,3,4,5,6,7,8,9,10]),
    \+ moved_to_end([1,2,3,4,5,6,7,8,9,10],0,[1,3,4,5,6,7,8,9,10,2]),
    \+ moved_to_end([1,2,3,4,5,6,7,8,9,10],3,[1,2,3,5,6,7,8,9,10]).

:- pred recursive_seq_tests is semidet.
recursive_seq_tests :-
    \+ recursive_seq(0,0),
    \+ recursive_seq(9,42),
    map(recursive_seq, [0,1,2,3,4,5,6,7,8,9,10,20,30], [1,2,3,4,6,9,13,19,28,41,60,2745,125491]).

:- pred recursive_seq_error1(string::out) is det.
recursive_seq_error1(Message) :-
    promise_equivalent_solutions [Message] (
        try [] recursive_seq(-30,_)
        then Message = "recursive_seq_error1 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).

:- pred recursive_seq_error2(string::out) is det.
recursive_seq_error2(Message) :-
    promise_equivalent_solutions [Message] (
        try [] recursive_seq(-5,_)
        then Message = "recursive_seq_error2 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).

:- pred recursive_seq_error3(string::out) is det.
recursive_seq_error3(Message) :-
    promise_equivalent_solutions [Message] (
        try [] recursive_seq(-1,_)
        then Message = "recursive_seq_error3 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).

:- pred dynamic_seq_tests is semidet.
dynamic_seq_tests :-
    \+ dynamic_seq(0,0),
    \+ dynamic_seq(9,42),
    map(dynamic_seq, 
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99], 
        [1,2,3,4,6,9,13,19,28,41,60,88,129,189,277,406,595,872,1278,1873,2745,4023,5896,8641,12664,18560,27201,39865,58425,85626,125491,183916,269542,395033,578949,848491,1243524,1822473,2670964,3914488,5736961,8407925,12322413,18059374,26467299,38789712,56849086,83316385,122106097,178955183,262271568,384377665,563332848,825604416,1209982081,1773314929,2598919345,3808901426,5582216355,8181135700,11990037126,17572253481,25753389181,37743426307,55315679788,81069068969,118812495276,174128175064,255197244033,374009739309,548137914373,803335158406,1177344897715,1725482812088,2528817970494,3706162868209,5431645680297,7960463650791,11666626519000,17098272199297,25058735850088,36725362369088,53823634568385,78882370418473,115607732787561,169431367355946,248313737774419,363921470561980,533352837917926,781666575692345,1145588046254325,1678940884172251,2460607459864596,3606195506118921,5285136390291172,7745743850155768,11351939356274689,16637075746565861,24382819596721629,35734758952996318]).

:- pred dynamic_seq_error1(string::out) is det.
dynamic_seq_error1(Message) :-
    promise_equivalent_solutions [Message] (
        try [] dynamic_seq(-30,_)
        then Message = "dynamic_seq_error1 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).

:- pred dynamic_seq_error2(string::out) is det.
dynamic_seq_error2(Message) :-
    promise_equivalent_solutions [Message] (
        try [] dynamic_seq(-5,_)
        then Message = "dynamic_seq_error2 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).

:- pred dynamic_seq_error3(string::out) is det.
dynamic_seq_error3(Message) :-
    promise_equivalent_solutions [Message] (
        try [] dynamic_seq(-1,_)
        then Message = "dynamic_seq_error3 failed\n"
        catch "negative int" -> Message = "" % There is supposed to be an exception
    ).
  
:- pred exercise5_different_file(io::di,io::uo) is det.
exercise5_different_file(!IO) :-
    rename_file("numbers.txt", "numbers.cpy", Result, !IO),
    (
        Result = ok,
        open_output("numbers.txt", OutFile, !IO),
        (
            OutFile = ok(OutStream),
            io.write_string(OutStream, "-34\n-12312\n-200\n-3\n-145\n-57\n-9494\n-90909\n", !IO),
            io.close_output(OutStream, !IO),

            capture_output(exercise5, E5Output, !IO),
            E5Expected = "Maximum value: -3\nAverage value: -14144.250000\n",
            assert_equals(E5Expected,E5Output,"Exercise 5 (Different File)",!IO)
        ;
            OutFile = error(_),
            io.write_string("exercise5_different_file failed to create a new numbers file\n",!IO),
            io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
        ),
        rename_file("numbers.cpy", "numbers.txt", _, !IO) % Copy the file back, assume it works
    ;
        Result = error(_),
        io.write_string("exercise5_different_file failed to rename original file\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ).

:- pred exercise5_no_file(io::di,io::uo) is det.
exercise5_no_file(!IO) :-
    rename_file("numbers.txt", "numbers.cpy", Result, !IO),
    (
        Result = ok,

        capture_output(exercise5, E5Output, !IO),
        E5Expected = "The file \"numbers.txt\" does not exist. Exiting.\n",
        assert_equals(E5Expected,E5Output,"Exercise 5 (No File)",!IO),

        rename_file("numbers.cpy", "numbers.txt", _, !IO) % Copy the file back, assume it works
    ;
        Result = error(_),
        io.write_string("exercise5_no_file failed to rename original file\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ).

% Run the tests
main(!IO) :-
    capture_output(exercise1, E1Output, !IO),
    E1Expected = "The sum is: 62790\n",
    assert_equals(E1Expected,E1Output,"Exercise 1",!IO),
    (limited_sum_tests -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.write_string("limited_sum_tests failed\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ),
    capture_output(exercise2, E2Output, !IO),
    E2Expected = "HB\nHB\na1\na1\na1\n1a\n",
    assert_equals(E2Expected,E2Output,"Exercise 2",!IO),
    (first_longer_shorter_tests -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.write_string("first_longer_shorter_tests failed\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ),
    first_longer_shorter_error1(FLSE1),
    io.write_string(FLSE1,!IO),
    (FLSE1 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    first_longer_shorter_error2(FLSE2),
    io.write_string(FLSE2,!IO),
    (FLSE2 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    capture_output(exercise3, E3Output, !IO),
    E3Expected = "1, 2, 3, 4, 6, 7, 8, 9, 10, 5\n",
    assert_equals(E3Expected,E3Output,"Exercise 3",!IO),
    (moved_to_end_tests -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.write_string("moved_to_end_tests failed\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ),
    capture_output(exercise4, E4Output, !IO),
    E4Expected = "9\n9\n28\n28\n406\n406\n",
    assert_equals(E4Expected,E4Output,"Exercise 4",!IO),
    (recursive_seq_tests -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.write_string("recursive_seq_tests failed\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ),
    recursive_seq_error1(RSE1),
    io.write_string(RSE1,!IO),
    (RSE1 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    recursive_seq_error2(RSE2),
    io.write_string(RSE2,!IO),
    (RSE2 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    recursive_seq_error3(RSE3),
    io.write_string(RSE3,!IO),
    (RSE3 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    (dynamic_seq_tests -> 
        io.write_string("", !IO) % Do nothing
    ;
        io.write_string("dynamic_seq_tests failed\n",!IO),
        io.set_exit_status(1, !IO)  % Non-zero exit status indicates an error
    ),
    dynamic_seq_error1(DSE1),
    io.write_string(DSE1,!IO),
    (DSE1 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    dynamic_seq_error2(DSE2),
    io.write_string(DSE2,!IO),
    (DSE2 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    dynamic_seq_error3(DSE3),
    io.write_string(DSE3,!IO),
    (DSE3 = "" -> true ; io.set_exit_status(1, !IO)),  % Non-zero exit status indicates an error
    capture_output(exercise5, E5Output, !IO),
    E5Expected = "Maximum value: 201\nAverage value: 8.688525\n",
    assert_equals(E5Expected,E5Output,"Exercise 5",!IO),
    exercise5_different_file(!IO),
    exercise5_no_file(!IO).

%-----------------------------------------------------------------------------%
:- end_module test.
%-----------------------------------------------------------------------------%
