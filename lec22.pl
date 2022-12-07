https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
% CISC 360, Fall 2022
%
% Prolog code for Week 10, part 3 (no accompanying PDF)
% Load with
%   consult('/Users/jana/360/lec22.pl').
% adjusting the path as needed.

/*
  Tracing

  The "query"

    ?- trace.

  turns tracing on.

  The "query"

    ?- nodebug.

  turns tracing off.

  c - creep :   trace slowly
  s - skip  :   skip to the next Exit
  u - up    :   complete the current goal without tracing through it
*/

/* select/2:

   Given a pair Pair = (X,Y),  select(Pair, Z) is true iff Z = X or Z = Y.
   Examples:
     ?- select((99, 'abc'), 99).
     true      % type ;
     false.    % Prolog found no more solutions
     
     ?- select((99, 'abc'), 'abc').
     true.     % Prolog didn't ask for input, because it saw there were
               %  no more possible solutions

     ?- select((99, 'abc'), Z).
     Z = 99      % type ;
     Z = abc.
*/
select( (X, _), X).
select( (_, Y), Y).

/* Tracing select:

    ?- trace.
    true.

    [trace]  ?- select((99, 'abc'), Z).
       Call: (8) select((99, abc), _1618) ? creep
       Exit: (8) select((99, abc), 99) ? creep
    Z = 99 
       Redo: (8) select((99, abc), _1618) ? creep
       Exit: (8) select((99, abc), abc) ? creep
    Z = abc.
*/

/* selectlist/2:

   Given a list of pairs Pairs,
   
     selectlist(Pairs, Components)
     iff
     Components consists of components of the pairs in Pairs,
     in the same order.

   Example:

     ?- selectlist( [(1,2), (33,44), ('a','b')], [2, 44, 'a']).
     true   % type ;
     false.
     ?- selectlist( [(1,2), (33,44), ('a','b')], [2, 33, 'b']).
     true   % type ;
     false.
*/

selectlist( [], []).

selectlist( [Pair | Rest], [Component | NewRest]) :-
   select( Pair, Component),
   selectlist( Rest, NewRest).


/* Tracing selectlist:

[trace]  ?- selectlist( [(1, 2), (33, 44)], Answer).

[trace]  ?- selectlist( [(1, 2), (33, 44)], Answer).
   Call: (8) selectlist([(1, 2),  (33, 44)], _1636) ? creep
   Call: (9) select((1, 2), _1874) ? creep
   Exit: (9) select((1, 2), 1)creep
   Call: (9) selectlist([(33, 44)], _1876) ?  ? creep
   Call: (10) select((33, 44), _1880) ? creep
   Exit: (10) select((33, 44), 33) ? creep
   Call: (10) selectlist([], _1882) ? creep
   Exit: (10) selectlist([], []) ? creep
   Exit: (9) selectlist([(33, 44)], [33]) ? creep
   Exit: (8) selectlist([(1, 2),  (33, 44)], [1, 33]) ? creep
Answer = [1, 33] 
   Redo: (10) select((33, 44), _1880) ? creep
   Exit: (10) select((33, 44), 44) ? creep
   Call: (10) selectlist([], _1882) ? creep
   Exit: (10) selectlist([], []) ? creep
   Exit: (9) selectlist([(33, 44)], [44]) ? creep
   Exit: (8) selectlist([(1, 2),  (33, 44)], [1, 44]) ? creep
Answer = [1, 44] 
   Redo: (9) select((1, 2), _1874) ? creep
   Exit: (9) select((1, 2), 2) ? creep
   Call: (9) selectlist([(33, 44)], _1876) ? up          % NOTE 'up' here
   Exit: (8) selectlist([(1, 2),  (33, 44)], [2, 33]) ? creep
Answer = [2, 33] 
   Redo: (10) select((33, 44), _1880) ? up
   Exit: (9) selectlist([(33, 44)], [44]) ? up
   Exit: (8) selectlist([(1, 2),  (33, 44)], [2, 44]) ? up
Answer = [2, 44].

*/


/* Additional example:

?- trace.
true.

[trace]  ?- prereq(math101, math102).
   Call: (8) prereq(math101, math102) ? creep
   Exit: (8) prereq(math101, math102) ? creep
true .

[trace]  ?- required(math101, math210).
   Call: (8) required(math101, math210) ? creep   -- Current goal
   Call: (9) prereq(math101, math210) ? creep         -- Try the first rule
   Fail: (9) prereq(math101, math210) ? creep          No, not a direct prereq.
   Redo: (8) required(math101, math210) ? creep   -- Try again
                                                      -- Try the second rule
   Call: (9) prereq(math101, _5906) ? creep           -- First premise; _5906 is the variable B
   Exit: (9) prereq(math101, math102) ? creep         -- Success: prereq(math101, B) where B = math102
   Call: (9) required(math102, math210) ? creep       -- Second premise
   Call: (10) prereq(math102, math210) ? creep            -- Try the first rule
   Exit: (10) prereq(math102, math210) ? creep            -- Success: prereq(math102, math210)
   Exit: (9) required(math102, math210) ? creep       -- Success: required(math102, math210)
   Exit: (8) required(math101, math210) ? creep   -- Success: required(math101, math210)
true .
*/

/*                     
  math101 ---> math102 ---> math210 ---> phys201
     |              \                    /|\
     |               \                    |
     |                '---> phys102 ------'
    \|/
  chem101 ---> chem200
*/

prereq(math101, math102).
prereq(math101, chem101).
prereq(math102, math210).
prereq(math102, phys102).
prereq(phys102, phys201).
prereq(math210, phys201).

prereq(chem101, chem200).

required(A, B) :-
    prereq(A, B).

required(A, C) :-   % required(math101,math210)
    prereq(A, B),   % prereq(math101, B)
    required(B, C). % required(B,math210)

/*
  fact n = if n == 0 then 1 else n * fact (n - 1)
or:
  fact 0 = 1
  fact n = n * fact (n - 1)

  function from integers to integers
  becomes
  predicate on two integers

  Haskell function of k arguments
  becomes
  Prolog predicate of k+1 arguments
        (the k arguments, and then the output)

  Exercise: trace a query such as

  ?-  fact(2, Answer).
*/
fact(0, 1).
fact(N, Result) :- NMinus1 is N - 1,
                   fact(NMinus1, X),
                   Result is N * X.


/*
  Example: Factoring an integer
*/

/*
  factorsLoop(N, Start, Factors): Given integers N > 1 and Start > 1,
                                     return in Factors a list of all F such that
                                       (F >= Start)
                                       and
                                       F < N
                                       and
                                       (N mod F) = 0.
*/
factorsLoop( N, Start, []) :- N > 1, Start > 1, Start >= N.

factorsLoop( N, Start, [Start | Rest]) :-
      N > 1, Start > 1, Start < N,
      (N mod Start) =:= 0,
      Next is Start + 1,
      factorsLoop( N, Next, Rest).

factorsLoop( N, Start, Rest) :-
      N > 1, Start > 1, Start < N,
      (N mod Start) =\= 0,
      Next is Start + 1,
      factorsLoop( N, Next, Rest).

/*
  factors(N, Factors): Given an integer N > 1,
                          return in Factors a list of all F such that
                              F > 1 and F < N and (N mod F) = 0.
*/
factors(N, Factors) :- N > 1, factorsLoop( N, 2, Factors).

