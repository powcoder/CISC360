https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
% CISC 360 a4, Fall 2022
%
% See a4.pdf for instructions

/*
 * Q1: Student ID
 */
student_id( this is a syntax error ).
% second_student_id(  ).
% If in a group, uncomment the second_student_id line
%   and put the second student's ID between the ( )


/*
 * Q2: Prime numbers
 */

/*
  factorsLoop(N, Start, Factors):
      Given integers N > 1 and Start > 1,
          return in Factors a list of all F such that
                 (F >= Start)
             and F < N
             and (N mod F) = 0.
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
                       (The list Factors includes non-prime factors.
                        For example, factors(20, [2, 4, 5, 10]) is true.)
*/
factors(N, Factors) :- N > 1, factorsLoop( N, 2, Factors).

/*
  Q2a.

  isPrime(N, Answer)

  Given an integer N >= 2:
    Answer = prime               iff  N is prime
    Answer = composite(Factors)  iff  N is composite, with *prime* factors Factors

  Examples:
    ?- isPrime(11, Answer).
    Answer = prime
    ?- isPrime(20, Answer).
    Answer = composite([2, 5])     % The factors of 20 are: 2, 4, 5, 10.
                                   % The *prime* factors of 20 are: 2, 5.

   Replace the word "change_this" in the rules below.
   
   Hint: You should return the *prime* factors (not all of the factors),
         but it may be useful to first write a version of isPrime
           that returns all of the factors,
         complete question Q2b,
         and then return to this question.
*/

isPrime(N, prime) :-
    change_this.
    
isPrime(N, composite(PrimeFactors)) :-
    change_this.

/*
  findPrimes(Numbers, Primes)
    Primes = list of N in Numbers such that N is prime,
             in the same order as Numbers.

  Return only one solution.

  For example,

   ?- findPrimes([2, 3, 4, 5, 6, 7, 8], Primes).
   Primes = [2, 3, 5, 7] ;
   false.
 
  Q2b. Replace the word "change_this" in the rules below.
       Hint:  Try to use  findPrimes(Xs, Ys).
*/
findPrimes([], []).

/*
  In this rule, we include X in the output: [X | Ys].
  So this rule should check that X is prime.
*/
findPrimes([X | Xs], [X | Ys]) :-
  change_this.

/*
  In this rule, we do not include X in the output: Ys.
  So this rule should check that X is composite.
*/
findPrimes([X | Xs], Ys) :-
  change_this.


/*
  upto(X, Y, Zs):
  Zs is every integer from X to Y

  Example:
     ?- upto(3, 7, Range)
     Range = [3, 4, 5, 6, 7]
*/
upto(X, X, [X]).
upto(X, Y, [X | Zs]) :-
    X < Y,
    Xplus1 is X + 1,
    upto(Xplus1, Y, Zs).

/*
  primes_range(M, N, Primes)
    Primes = all prime numbers between M and N, in increasing order.
    Example:
      ?- primes_range(60, 80, Primes).
      Primes = [61, 67, 71, 73, 79] .

 (Return only one solution.)

 Q2c. Replace the word "change_this" in the rule below.
      HINT: Use upto and findPrimes.
*/

primes_range(M, N, Primes) :-
   change_this.


/*
 * Q3. Translate the spiral function (similar to a1).
 *

  `spiral': given a pair of numbers `dir' and `span',
  returns 1 if `dir' is less than or equal to 1,
  and otherwise returns (span - dir) * spiral (dir - 2, span - 3).

  Here is a Haskell solution:
  
  spiral :: (Integer, Integer) -> Integer
  spiral (dir, span) = if dir <= 1 then 1
                       else (span - dir) * spiral(dir - 2, span - 3)

  Finish writing a Prolog predicate

    spiral

  such that  spiral(Dir, Span, R) is true  iff  R = (spiral Dir Span)
                                                (in Haskell)

  Hint: It may be useful to rewrite 'spiral' using 'let' and/or 'where'.
*/
spiral(Dir, _, 1) :- Dir =< 1.

spiral(Dir, Span, R) :-
  change_this.

/*
  To test: ?- spiral(0, 32, 1).
           true .
           ?- spiral(-32, 5, 1).
           true .
           ?- spiral(7, 50, R).
           R = 74046 .             % type .
           ?- spiral(13, 3, R).
           R = 3603600             % type ;
           false.

  Hint: The last two queries (and similar queries) should give
        only one solution.
*/


/*
  Q4: Trees

  Consider the tree     (We are *not* representing
                          trees with Empty "leaves":
             4                         4
            / \                      /   \
           2   5                   2       5
          / \                    /  \     / \
         1   3                 1     3   E   E
                              / \   / \
                          Empty  E E   E            )
                 
  We will express the above tree in Prolog as

    node( 4, node( 2, leaf(1), leaf(3)), leaf(5))
  
  What we are doing here is similar to the Haskell type
  
    data A4Tree = Node Integer A4Tree A4Tree
                | Leaf Integer

  In this question, a "group" is a list of the keys stored at a node and its children.

  For example, the tree

                         4
                        / \      
                       2   5
                      / \        
                     1   3

  contains two groups:

         [4, 2, 5] from    4
                          / \
                         2   5

         [2, 1, 3] from    2
                          / \
                         1   3

  (A leaf, by itself, does not count as a group.)

  In this question, define a Prolog predicate

    group(Tree, P)

  such that P is a group in Tree.

  For example:
  
    ?- group(node(4, node(2, leaf(1), leaf(3)), leaf(5)), [4, 2, 5]).
    true
    ?- group(node(2, leaf(1), leaf(3)), [2, 1, 3]).
    true

  Your predicate should be written so that when the first argument is a specific tree
  (containing no variables) and the second argument is a variable, typing ; returns
  *all* groups in the tree.  For example:

    ?- group(node(4, node(2, leaf(1), leaf(3)), leaf(5)), G).
    G = [4, 2, 5] ;
    G = [2, 1, 3] ;
    false

  A leaf by itself contains no groups, so asking for the groups in a leaf should fail:

    ?- group(leaf(1000), G).
    false

  Define clauses for 'group' below.

  We have defined a predicate 'key' that "returns" the key at the root (of a node),
  or the sole key in a leaf.  Calling 'key' from 'group' may simplify your code.
*/

key( node( K, _, _), K).
key( leaf( K),       K).

