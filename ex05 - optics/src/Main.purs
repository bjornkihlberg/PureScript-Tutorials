module Main where

import Prelude

type RecordA = { b :: RecordB }
type RecordB = { x :: Int }

getX :: RecordA -> Int
getX a = a.b.x

setX :: Int -> RecordA -> RecordA
setX x a = a { b = a.b { x = x } }
