module Main where

import Prelude

import Data.Lens (Lens, lens)

type MyRecord = { x :: Int, y :: Boolean, z :: String }

_X :: Lens MyRecord MyRecord Int Int
_X = lens getter setter
    where
        getter :: MyRecord -> Int
        getter = _.x
        setter :: MyRecord -> Int -> MyRecord
        setter = _ { x = _ }
