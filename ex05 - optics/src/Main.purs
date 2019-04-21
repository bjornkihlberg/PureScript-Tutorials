module Main where

import Prelude

import Data.Lens (Lens, lens)

_X :: forall a b c. Lens { x :: a | c } { x :: b | c } a b
_X = lens _.x $ _ { x = _ }
