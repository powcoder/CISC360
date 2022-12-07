https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
% CISC 360, Fall 2022
% Jana Dunfield
%
% Prolog code for Week 10, part 1 (no accompanying PDF)
%
% Lists in Prolog

/*
  As in Haskell, Prolog has built-in lists with special syntax.
  Also as in Haskell, Prolog lists are "really" trees, written differently.

  For example, in Haskell, the expression

    [1, 2, 3]

  is "nicer" syntax for

    1 : (2 : (3 : []))

  which we can write as a tree:   :
                                 / \
                                1   :
                                   / \
                                  2   :
                                     / \
                                    3   []

  Prolog also allows you to write this list as [1, 2, 3].
  Unfortunately, that's where the similarity between Haskell and Prolog syntax ends.

  In Haskell, the "cons" operator, :, takes an element (the new head)
  and a list (the new tail).  So 3 : [] takes the element 3 and adds it
  to the front of the empty list [].

  This also works for nested lists:

    [1, 2] : [[3, 4], [5]]

  says to add [1, 2] to the front of the nested list [[3, 4], [5]], resulting in

    [[1, 2], [3, 4], [5]]
  
  Prolog also has a cons operator, but it is written differently,
  and in a way I think is misleading.

  In Prolog, if we want to add an element H to the front of a list T,
  we write this:

    [H | T]

  I think this is misleading, because the [ ] suggest that we are making a
  more deeply nested list.  But that's not how Prolog works.  If we enter

    ?- Z = [1 | [2, 3, 4]].

  we are asking "does there exist Z such that Z = [1 | [2, 3, 4]]?", and Prolog responds:

    Z = [1, 2, 3, 4].

  This is not a nested list.  Compare  [1 : [2, 3, 4]] in Haskell: we get

    [[1,2,3,4]]

  because  1 : [2, 3, 4]  is  [1,2,3,4], so [ 1 : [2,3,4] ] is [[1,2,3,4]].

  In Prolog, as in Haskell, we often need to create a new list (or pattern-match on
  a known list) by using 'cons', so we can't avoid writing [H | T].
  All we can do is try to remember that it works differently from Haskell:
  the brackets in [H | T] don't mean we're making a new list.

  Haskell is typed, and requires that every element of a list have the
  same type.  You can't write [4, True, (\x -> x)] in Haskell, because
  4, True, and (\x -> x) have different types.

  That also means you can't write [[1, 2], 3], because [1, 2] has a
  different type from 3.

  Prolog is not typed.  Translating [4, True] into Prolog, we get

    [4, true]

  which Prolog allows.  Prolog also allows

    [[1, 2], 3]

  Because Prolog is not typed, it will not warn you if you unintentionally
  create a list with elements of different types.
*/

/* Having ranted, let's look at something that's actually cool in Prolog.

  In Haskell, we can use the "list append" or "concatenation" operator ++
  as a prefix operator by adding ( ) around it:

    [1, 2, 3] ++ [4, 5]      ==  [1, 2, 3, 4, 5]
    (++) [1, 2, 3] [4, 5]    ==  [1, 2, 3, 4, 5]
  ?- (++)([1, 2, 3], [4, 5],     [1, 2, 3, 4, 5]).
  
  Since we translate Haskell functions that take n arguments into
  Prolog predicates that take n+1 arguments, with the extra argument representing
  the result, a Prolog "append" predicate should take three arguments.

  And in fact, Prolog has such a predicate, called "append":

    ?- append([1, 2, 3], [4, 5], Answer).
    Answer = [1, 2, 3, 4, 5].

  Why is this cool?

  In Prolog, we can run 'append' *backwards*.
  The Prolog query above says

    "Does there exist Answer such that  append([1, 2, 3], [4, 5], Answer)
     is true?"

  We can also ask:

    "Does there exist SecondList such that
     append([1, 2, 3], SecondList, [1, 2, 3, 4, 5])
     is true?"

    ?- append([1, 2, 3], SecondList, [1, 2, 3, 4, 5]).
    SecondList = [4, 5].

  Haskell's ++ can't do this.  We could write a Haskell function to
  do something like this, but it doesn't come "for free".

  EXERCISE: Run a Prolog query that finds the *first* list, not the second.

  Then keep reading.
  


  We can actually get *all* the first and second lists whose
  concatenation is [1, 2, 3, 4, 5].  (I used Xs and Ys because I
  decided I wanted shorter names.)

    ?- append(Xs, Ys, [1, 2, 3, 4, 5]).

    Xs = [],
    Ys = [1, 2, 3, 4, 5]   % I typed ; repeatedly to get more solutions
    Xs = [1],
    Ys = [2, 3, 4, 5] 
    Xs = [1, 2],
    Ys = [3, 4, 5] 
    Xs = [1, 2, 3],
    Ys = [4, 5] 
    Xs = [1, 2, 3, 4],
    Ys = [5] 
    Xs = [1, 2, 3, 4, 5],
    Ys = []               
    false.                 % "false": no more solutions

  Let's see if we can get something like this with our own predicates.
*/

/* ASIDE: Annoying Prolog reminder:

  Prolog does not let you write spaces before (s.
  The following won't work, because there is a space before the (.

    ?- append ([1,2], [3], Answer).
    ERROR: Syntax error: Operator expected
    ERROR: append
    ERROR: ** here **
    ERROR:  ([1,2], [3], Answer) .

  Prolog does let you write spaces *after* ('s, which looks kind of weird
  but makes the code look less dense:

    ?- append( [1,2], [3], Answer).
*/

/*
  'interleave' predicate:
  
  interleave(A, B, C) true iff the interleaving of A and B is C,
  where "interleave" means taking one element from A, then one from B, etc.
  So A and B must be the same length.

  For example:
  interleave([1, 3], [2, 4], [1, 2, 3, 4]) should be true.  
*/
interleave( [], [], []).
interleave( [X | Xs], [Y | Ys], [X | [Y | Zs]]) :- interleave( Xs, Ys, Zs).
%           ^^^^^^^^  ^^^^^^^^  ^^^^^^^^^^^^^^
%            X : Xs          a list           ^^^ return [X | [Y | Zs]]
%    a list whose head is X  whose head is Y              X : (Y : Zs)
%    and whose tail is Xs    & whose tail is Ys

% converting this rule to Haskell:
%
%   interleave (x : xs) (y : ys) =
%     let zs = interleave xs ys in
%       x : (y : zs)

%%%%% NOTE: figure out how to make Prolog print the entire list when answering queries
/*

  https://www.swi-prolog.org/FAQ/AllOutput.html

  1. When Prolog is waiting for ; or ., can type 'w' to print the entire list.

  2. Run this query:

  set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).
*/

/*
  EXERCISE: Run queries in which different combinations of the
    first, second, and third arguments to interleave are variables.
    For example:

    ?- interleave( Xs, [4, 5, 6], Zs).

   You may see things like "_2008"; these are variables that Prolog makes
   up as it tries to find solutions.
   (Some versions of SWI-Prolog will use somewhat more readable variable names.)

   Also, try  interleave  where the last argument (Zs) is an *odd*-length list.
*/

/*
  EXERCISE: Implement a predicate that works like the 'zip' function in Haskell.
  (Prolog has tuples that work pretty much the same way as in Haskell.)
  For example:

     zip([1, 2, 3], [4, 5, 6], [(1, 4), (2, 5), (3, 6)]).
*/

