module Main where

import Prelude

import Data.Lens (Lens, lens)

type MyRecord = { x :: Int, y :: Boolean, z :: String }

_X :: Lens MyRecord MyRecord Int Int
_X = lens _.x $ _ { x = _ }
