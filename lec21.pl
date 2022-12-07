https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
% CISC 360, Fall 2022
% Jana Dunfield
%
% Prolog code for Week 10, part 2 (no accompanying PDF)
%
% Practice with arithmetic, recursion and lists

/*
  The 'diag' function from long ago:

  diag :: Integer -> Integer
  diag n = if n == 0 then 0 else n + diag (n - 1)

  -- An easier-to-translate version:

  diag :: Integer -> Integer
  diag 0 = 0
  diag n = let nminus1   = n - 1
               recursive = diag nminus1
               result    = n + recursive
           in
             result

  Write a Prolog predicate  diag  such that

  diag(N, Answer) is true  iff  Haskell  diag N  returns  Answer
  
  This Prolog code has two bugs.
  Try to find them before reading further.
*/
diag( 0, 0).                              
diag( N, N + Recursive) :- Nminus1 is N - 1,
                           diag( Nminus1, Recursive).














/*
  First bug:

  Queries with first argument > 0 create expressions instead of
  giving a number:

  diag( N, N + Recursive)
           ^^^^^^^^^^^^^

  Fix: Replace "N + Recursive" with a new variable, and use "is"
       to calculate  N + Recursive  and put the answer into the new variable.

diag( N, Result) :- Nminus1 is N - 1,
                    diag( Nminus1, Recursive),
                    Result is N + Recursive.
*/
/*
  Second bug:

  If we type ";" during a query to look for more solutions,
  we get a "stack space exceeded" error.  The query

    ?- diag( 0, Answer).

  first gives Answer = 0, but then tries the second clause,
  which computes Nminus1 to be -1, then calls

    diag( -1, Recursive)

  which calls diag( -2, Recursive), and so on.

  The fix is to add a premise checking that N > 0.

  This check isn't needed in Haskell because Haskell always uses
  the first clause whose pattern matches the argument.
*/
/* Corrected version:
diag( 0, 0).
diag( N, Result) :- N > 0,                         % fix second bug         
                    Nminus1 is N - 1,
                    diag( Nminus1, Recursive),
                    Result is N + Recursive.
*/




/*
  "Return" alternating (1st, 3rd, 5th, ...) elements of a list.

  In Haskell:

  alternate :: [a] -> [a]
  alternate []             = []
  alternate [x]            = [x]
  alternate (x : (y : zs)) = x : (alternate zs)

  Example: alternate [11, 22, 33] returns [11, 33]:

    alternate (11 : 22 : 33 : [])
 => 11 : (alternate (33 : []))
 =  11 : (alternate [33])
 => 11 : [33]
 =  [11, 33]

  Start the translation to Prolog.
  Want:  alternate(In, Out) true
         iff  in Haskell, (alternate In) == Out
*/
alternate( [], []).
alternate( [X], [X]).

/* Buggy version:

alternate( [X | [Y | Zs]], [X | Zs]) :-
      alternate( Zs, Zs).    % This says: (alternate zs) == zs
*/
/* Buggy version:
alternate( [X | [Y | Zs]], Result) :-
      alternate( Zs, [X | Result]).
  The premise requires that  (alternate zs) == (x : ...).
  So it can't work if  (alternate zs)  returns [].
% alternate( [11, 22, 33], Answer).
% alternate( [X  | [Y  | Zs]], Result) :-
% alternate( [11 | [22 | 33]], Answer).
% X = 11, Y = 22, Zs = [33], [X | Result] = Answer
%   alternate( [33], Result)
%    (alternate zs) == (x : result)
*/ 
alternate( [X | [Y | Zs]], [X | Result]) :-
      alternate( Zs, Result).
      /*             ^^^^^^  Correct version.
         When calling a predicate, always make the
         output be a new ("fresh") variable.
      */

/* Different version of 'alternate' in Haskell:

  alternate2 :: [a] -> [a]
  alternate2 (x : y : zs) = x : (alternate2 zs)
  alternate2 xs           = xs

  The second clause,  alternate2 xs = xs,  is matched only
  if the first clause doesn't match.
  Since the first clause matches any list with 2 or more
  elements, the second clause matches lists with 0 or 1 elements.

  An incorrect Prolog version:
*/
alternate2( [X | [Y | Zs]], [X | R]) :-
     alternate2( Zs, R).
alternate2( Xs, Xs).

/*
  A correct Prolog version:

alternate2( [X | [Y | Zs]], [X | R]) :-
     alternate2( Zs, R).

alternate2( [], []).           % This "expands" the pattern so it only matches
alternate2( [X], [X]).         %  the lists that the original Haskell pattern would match

% Another way of writing the last two clauses:
alternate2( Xs, Xs) :- Xs = [_].
alternate2( Xs, Xs) :- Xs = [_, _].
*/
