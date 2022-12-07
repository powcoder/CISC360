https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
-- CISC 360 Fall 2022
-- Jana Dunfield

-- Week 7, part 3

module Lec16 where
{-
  "Continuations" are a particular way of using higher-order functions.

  This file contains two versions of a function that searches for a character in a string,
  and returns all the positions at which the character occurs.

  Positions are counted from zero.

  For example:

    stringfind 'a' "cadar"  ==  [1, 3]
                    01234
                     ^ ^
                     a a

    stringfind 'z' "cadar"  ==  []
-}


stringfind :: Char -> String -> [Integer]
stringfind ch s = stringfind_help 0 ch s

-- stringfind_help n ch s:
--   Return the positions at which ch occurs in s, WITH n ADDED.
stringfind_help :: Integer -> Char -> String -> [Integer]

stringfind_help n ch []      = []

stringfind_help n ch (h : t) =
  (if ch == h then [0 + n] else []) ++ stringfind_help (n + 1) ch t




add1 = map ((+) 1)


kstringfind_help :: Char
                 -> String
                 -> ([Integer] -> [Integer])
                 -> [Integer]

kstringfind_help ch []      k = k []

kstringfind_help ch (h : t) k =
  if ch == h then kstringfind_help ch t (\list -> k (0 : add1 list))
  else kstringfind_help ch t (\list -> k (add1 list))

kstringfind :: Char -> String -> [Integer]
kstringfind ch s = kstringfind_help ch s (\list -> list)

