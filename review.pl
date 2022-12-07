https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
/*
  CISC 360, Fall 2022
  Jana Dunfield

  Course wrap-up and review

  Week 12/13, 2022-12-05
*/

/*
  Translating from Haskell

data ArithExpr = Constant Integer
               | Negate ArithExpr
               | Add ArithExpr ArithExpr
               | Subtract ArithExpr ArithExpr 
               deriving (Show, Eq)

calc :: ArithExpr -> Integer
calc (Constant k)     = k
calc (Negate e)       = 0 - (calc e)
calc (Add e1 e2)      = (calc e1) + (calc e2)
calc (Subtract e1 e2) = (calc e1) - (calc e2)
*/
calc( constant(K), K).
calc( negate(E), N)   :- calc(E, R), N is -R.
calc( add(E1, E2), N) :- calc(E1, R1), calc(E2, R2), N is R1 + R2.
calc( subtract(E1, E2), N) :- calc(E1, R1), calc(E2, R2), N is R1 - R2.


/*
Exercise: translate getConsts

getConsts :: ArithExpr -> [Integer]
getConsts (Constant k) = [k]
getConsts (Negate e) = getConsts e
getConsts (Add e1 e2) = getConsts e1 ++ getConsts e2
getConsts (Subtract e1 e2) = getConsts e1 ++ getConsts e2
*/

/*
Translate:

swap :: ArithExpr -> ArithExpr

swap (Add e1 e2) = Add (swap e2) (swap e1)
swap (Negate e)  = e
swap e           = e

-- (Doesn't matter if this code is "correct" or "useful",
--  no matter how weird it is, we can translate it)

-- (Possibly correct translation further down in this file)
*/














/*

Code with two cuts.  Do either of them cause bugs?

swap( add(E1, E2), add(R2, R1)) :- swap(E1, R1), swap(E2, R2), !.

swap( negate(E), E).

swap( E, E) :- !.
*/


/*
  Haskell function:

  data Sign = Negative | Zero | Positive
              deriving (Show, Eq)

  sign :: Integer -> Sign
  sign x = if x < 0 then Negative
           else if x == 0 then Zero
           else Positive

  Prolog code with cuts:
*/
/*
sign( X, S) :- !, X < 0, S = negative.

sign( X, S) :- !, X =:= 0, S = zero.

sign( X, S) :- X > 0, S = positive.
*/
/* Are either of these cuts bugs?  Why? */


/*
Subtly different:

sign( X, negative) :- !, X < 0.
sign( X, zero    ) :- !, X =:= 0.
sign( X, positive) :- X > 0.
*/




/*
Quiz 3 last question:

Write a Prolog predicate adj( Xs, Pair) that is true iff Pair is a pair (X, Y) of adjacent elements in Xs.

adj should work for (at least) the following two "modings":

    adj(INPUT, INPUT ): first argument is a concrete list, second argument is a concrete pair
    adj(INPUT, OUTPUT): first argument is a concrete list, second argument is a Prolog variable

For example, we want:

  ?- adj( [d, c, b, a], (c, b)).      % (INPUT, INPUT)
  true

  ?- adj( [d, c, b, a], A).      % (INPUT, OUTPUT)
  A = (d, c) ;
  A = (c, b) ;
  A = (b, a) ;
  false

If the given list Xs contains zero or one elements, adj(Xs, A) should be false:

  ?- adj( [500], A).
  false

It is okay if your adj finds solutions in a different order.  For example:

  ?- adj( [d, c, b, a], A).      % (INPUT, OUTPUT)
  A = (b, a) ;
  A = (c, b) ;
  A = (d, c) ;
  false

is also correct.

Hint: You may find it useful to use append.  (But you don't have to.)

Hint: I do not recommend using cuts in your solution.
*/
