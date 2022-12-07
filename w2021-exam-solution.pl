https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
/* CISC 360
   Winter 2021 exam sample solution (Prolog questions)
   Jana Dunfield
*/

% Q6

equiv(U, U) :- equiv(U, V).

mapped(D2, D1) :- engrey(black(Z, A, B), D1), engrey(red(Z, B, A), D2).


% Q7

twirl( empty, _, empty).
twirl( black(Left, S1, Right), red(_, S2, _), Result) :-
  S1 = S2,
  twirl(Right, Right, Result).

twirl( black(Left, S1, Right), red(_, S2, _), Result) :-
  S1 \= S2,
  twirl(Right, Left, Result).

twirl( red(Left, S, Right), _, black(Result, S, Right)) :-
  twirl(Left, Right, Result).

twirl( black(_, _, _), black(_, _, _), empty).
twirl( black(_, _, _), empty,          empty).

% Q8

/*
Given code:
% UseAssumption rule
derive( Ctx, Q, use(Q)) :-
 member(Q, Ctx),
 !.
% AND-Left rule
derive( Ctx, Q, and_left(P1, P2, Proof)) :-
 append( Ctx1, [and(P1, P2) | Ctx2], Ctx),
 !,
 append( Ctx1, [P1 | [P2 | Ctx2]], CtxP12),
 derive( CtxP1P2, Q, Proof).
*/
% Corrected code:
derive( Ctx, Q, use(Q)) :-
 member(Q, Ctx)
 .

derive( Ctx, Q, and_left(P1, P2, Proof)) :-
 append( Ctx1, [and(P1, P2) | Ctx2], Ctx),
 
 append( Ctx1, [P1 | [P2 | Ctx2]], CtxP1P2),
 derive( CtxP1P2, Q, Proof).

/* Explanation [parts in square brackets aren't required]:

1. Within the first clause (UseAssumption),
   the cut prevents Prolog from trying later rules such as AND-Left.
   
   [It also prevents Prolog from getting multiple "true" solutions
    from the call to 'member', but it's not clear whether that's a bug.]

   Solution: Remove the cut.

2. Within the second clause,
   CtxP12 is a typo for CtxP1P2.  [or vice versa]

   Change CtxP12 to CtxP1P2.

3. Within the second clause (AND-Left),
   the cut prevents Prolog from finding different and(..., ...) assumptions.
   [If this is not the last clause defining 'derive', it also prevents Prolog from
    trying later clauses.]

   Solution: Remove the cut.

   [For example: If Ctx is [and(v(a), v(b)), and(v(c), v(d))],
    and we're trying to prove v(c),
    we need to get the second solution P1 = v(c), P2 = v(d).

   Compare:

?- append( Ctx1, [and(P1, P2) | Ctx2], [and(v(a), v(b)), and(v(c), v(d))]).
Ctx1 = [],
P1 = v(a),
P2 = v(b),
Ctx2 = [and(v(c), v(d))] 
Ctx1 = [and(v(a), v(b))],
P1 = v(c),
P2 = v(d),
Ctx2 = [] 
false.

% query with a cut after 'append':
?- append( Ctx1, [and(P1, P2) | Ctx2], [and(v(a), v(b)), and(v(c), v(d))]), !.
Ctx1 = [],
P1 = v(a),
P2 = v(b),
Ctx2 = [and(v(c), v(d))].

?- 

*/