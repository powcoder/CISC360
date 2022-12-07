https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
{-
  CISC 360 W. 2021
  Sample solution to selected final exam questions
-}

-- Q2
data Rbt = Red Rbt String Rbt
         | Black Rbt String Rbt
         | Empty
         deriving (Show, Eq)

q2 = Black (Red Empty "czb" (Red Empty "" Empty)) "a" Empty

{- 
-- Q3
Notes:
  This is important: "if, for every Red node in the tree,"
  It means 'cinv' may need to look at *every* node in the tree.

  The overall structure of both sample solutions is:
  - Check whether the colour invariant holds at the root.
    If it doesn't hold, return False: it is *not* the case that, for every Red node, ... .

  - If it holds at the root, make recursive calls on the children
      (if any; for Empty, there are no children, return True immediately).

  The difference between the sample solutions is in
  how to check whether the colour invariant is violated at the root.
-}

-- Sample solution 1: use a helper function...

-- blackOrEmpty: True iff root is either Black or Empty
blackOrEmpty :: Rbt -> Bool
blackOrEmpty (Black _ _ _) = True
blackOrEmpty Empty         = True
blackOrEmpty (Red _ _ _)   = False

-- ...one clause for each Rbt constructor

cinv :: Rbt -> Bool
cinv Empty = True
cinv (Red left _ right) =
  blackOrEmpty left && blackOrEmpty right && cinv left && cinv right
cinv (Black left _ right) =
  cinv left && cinv right

-- Sample solution 2: no helper function,
--      utilize order of pattern matching
{-
cinv :: Rbt -> Bool
cinv (Red (Red _ _ _) _ _) = False
cinv (Red _ _ (Red _ _ _)) = False
cinv Empty                 = True
cinv (Black left _ right)  = cinv left && cinv right
cinv (Red   left _ right)  = cinv left && cinv right
-}

{-
-- Q4
-}
adjust :: ((t -> t), [t]) -> [t]
adjust (u, x : y : zs) = (u y) : x : adjust (u, zs)
adjust (u, zs)         = []

{-
    adjust ((\w -> w), [(\a -> a + 2), (\b -> 10), (\c -> c)])
 =  adjust ((\w -> w), (\a -> a + 2) : (\b -> 10) : [(\c -> c)])
 => ((\w -> w) (\b -> 10)) : (\a -> a + 2) : adjust ((\w -> w), [(\c -> c)])
    by function application
    with substitution  (\w -> w) for u,
                       (\a -> a + 2) for x,
                       (\b -> 10) for y,
                       [(\c -> c)] for zs
 => (\b -> 10) : (\a -> a + 2) : adjust ((\w -> w), [(\c -> c)])
    by function application
    with substitution  (\b -> 10) for w
 => (\b -> 10) : (\a -> a + 2) : []
    by function application
    with substitution  (\w -> w) for u, [(\c -> c)] for zs

-- optional:
 = [(\b -> 10), (\a -> a + 2)]

-- Hint: Even though the result is a list of functions, which Haskell won't print,
   you can still get an idea of whether the expression you get at the end is correct:

*Main> map (\f -> f 200) (adjust ((\w -> w), (\a -> a + 2) : (\b -> 10) : [(\c -> c)]))
[10,202]
-}

{-
-- Q5
-}
data Exp = Const Integer
         | Var String
         | Add Exp Exp
         | Negate Exp
         deriving (Show, Eq)
{-
Given code:
inline :: Exp -> Exp
inline (Const m)   = Const m
inline (Add e1 e2) = case (inline e1, inline e2) of
                       (Const m1, Const m2) -> m1 + m2
                       (e1', e2') -> Add e1 e2
inline (Negate e)  = case (inline e) of
                       Const m -> Const (-m)
                       e' -> e'
-}
-- Corrected code:
inline :: Exp -> Exp
inline (Const m)   = Const m
inline (Var s)     = Var s
inline (Add e1 e2) = case (inline e1, inline e2) of
                        (Const m1, Const m2) -> Const (m1 + m2)
                        (e1', e2') -> Add e1' e2'
inline (Negate e)  = case (inline e) of
                       Const m -> Const (-m)
                       e' -> Negate e'
{- Explanation of bugs:
Bug 1:
The question says "The (Var "x") should be left alone, because we don't know what it is".
The given code doesn't handle this case.  Add a clause 

  inline (Var s)     = Var s

that leaves Var alone.

Bug 2:
In the Add clause, the given code returns  m1 + m2, which has type Integer, but we want type Exp.
We need to add Const (as we do for Negate):
                        (Const m1, Const m2) -> Const (m1 + m2)

Bug 3:
In the Add clause, in the second subcase, we use the original children e1 and e2.
We want to use the new inlined expressions e1' and e2'.
Change to:
                        (e1', e2') -> Add e1' e2'

Bug 4:
In the Negate clause, in the second subcase, we return e', forgetting the Negate constructor.  Change to:
                       e' -> Negate e'
-}
