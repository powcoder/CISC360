https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
-- CISC 360 Fall 2022
-- Jana Dunfield

-- Week 7, part 1

module Lec15 where
{-
  "Continuations" are a particular use of higher-order functions.

  Similar to an earlier lecture, we define binary trees containing
    *keys* (Integers)
  and
    *values* (Strings).

  Example:

    Branch Empty (3, "tertiary") Empty

  is a tree that contains one key, 3, with the associated value "tertiary".
-}
data Tree = Empty
          | Branch Tree (Integer, String) Tree
          deriving (Show, Eq)

{-
  find t n:  Look for the key  n  in  t.  If found, return  Just s  where
             s  is the value (string) associated
             with the first occurrence of  n in a preorder traversal
             (root first, then left child, then right child)

             If not found, return Nothing.
-}
find :: Tree -> Integer -> Maybe String

find Empty                 n = Nothing
                           -- an empty tree contains no keys
                               
find (Branch tL (m, s) tR) n =
  if n == m then Just s
            else (case (find tL n) of
                    Nothing -> find tR n
                    Just s  -> Just s)
-- ('case' does pattern matching without defining a separate function;
--  see lec13.hs for more explanation)

tree1 = Branch Empty (1, "first") Empty

tree1a = Branch (Branch Empty (1, "first") Empty)
                (2, "two")
                Empty

onetwothree = Branch (Branch Empty (1, "one") Empty)
                     (2, "two")
                     (Branch Empty (3, "three") Empty)

-- three copies of 1, with "left", "root", "right"
oneoneone = Branch (Branch Empty (1, "left") Empty)
                   (1, "root")
                   (Branch Empty (1, "right") Empty)


{-
  findAll t n:  Look for the key  n  in  t.  Return a list of *all* associated values.
-}
findAll :: Tree -> Integer -> [String]
findAll Empty                 n = []
findAll (Branch tL (m, s) tR) n =
  if n == m then (findAll tL n) ++ [s] ++ (findAll tR n)
            else (findAll tL n) ++ (findAll tR n)

{-
  There is a way to refactor (generalize) 'find' and 'findAll',
  so we can put the "logic" of searching into one function.

  Here is our first attempt.

  It uses functions as "continuations":
    some of the arguments are functions that represent
    "what to do next".
  It's traditional here to pretend that "continuation" begins with a 'k',
  so variables beginning with 'k' will be related to continuations.

  Aside:  () is pronounced "unit"; the type of () is also written ().
          Think of it as a 0-tuple: an empty container.
          Unlike the Maybe type, if you have (), you always have ().
-}
-- kfind1: "kontinuation" find
kfind1 ::   Tree            -- tree to search in
         -> Integer         -- integer key to find
         -> (String -> b,   -- "success" continuation:
                            -- "call me if you find the key"
                            
             () -> b        -- "failure" continuation:
                            -- "call me if you didn't find the key"
             )
         -> b   -- return b, which is whatever the continuations return
kfind1 Empty                 n (kSucceed, kFail) = kFail ()
kfind1 (Branch tL (m, s) tR) n (kSucceed, kFail) =
  if n == m then kSucceed s
            else kfind1 tL
                        n
                        (kSucceed,  -- if found in tL, succeed
                         (\() ->    -- if not found in tL, look in tR
                           kfind1 tR n (kSucceed, -- if found in tR, succeed
                                       kFail      -- if not found in tR:
                                         -- we looked at m, tL, and tR and
                                         --  didn't find n, so we failed.
                                        )))

-- We can use kfind1 to simulate 'find'
-- ("instantiating" the type variable b with Maybe String)
kfind1Maybe :: Tree -> Integer -> Maybe String
kfind1Maybe t n = kfind1 t n (\s -> Just s,
                              \() -> Nothing)

-- We can also easily return [String] instead of Maybe String
-- ("instantiating" the type variable b with [String])
kfind1List :: Tree -> Integer -> [String]
kfind1List t n = kfind1 t n (\s -> [s],
                             \() -> [])
-- However, this only finds the first element

{-
  To return more than one result,
  we need to change how the success continuation kSucceed works.

  In kfind1, kSucceed takes the (first) string that was found;
             it has no way to ask for more results.

  In Haskell, we can provide that by giving kSucceed an extra argument
              called "kMore".
-}
kfind ::    Tree
         -> Integer
         -> (
             ((String -> (() -> b) -> b), -- "success" continuation:
                      -- ^^^^^^^^^ function to call to get more results
                        -- "call me if you find a matching key,
                        -- giving me the string *and* a way to get
                        -- more results"
                        
              () -> b   -- "failure" continuation:
                        -- "call me if you can't find the key"
              )
             -> b)   -- return b, which is whatever the continuations return
kfind Empty                 n (kSucceed, kFail) = kFail ()
kfind (Branch tL (m, s) tR) n (kSucceed, kFail) =
  let
    look_in_tR         () = kfind tR n (kSucceed, kFail)
    look_in_tL_then_tR () = kfind tL n (kSucceed, look_in_tR)
  in
    if n == m then
      kSucceed s                    -- the string found
               look_in_tL_then_tR   -- how to get more results
    else
      look_in_tL_then_tR ()

kfindFirst :: Tree -> Integer -> Maybe String
kfindFirst t n =
  kfind t n
        (\s -> \kMore -> Just s,  -- I just want to find the first,
                                  --  so ignore kMore
         \() -> Nothing)

kfindAll :: Tree -> Integer -> [String]
kfindAll t n =
  kfind t n
        (\s -> \kMore -> s : kMore(),  -- return s and other results
         \() -> ["that's all"])        -- found nothing? return []

kfindTwo :: Tree -> Integer -> [String]
kfindTwo t n = take 2 (kfindAll t n)


-- kfind1Maybe oneoneone 1
-- kfind1List oneoneone 1

-- kfindFirst oneoneone 1
-- kfindAll oneoneone 1
