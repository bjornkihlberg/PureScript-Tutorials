module Main where

import Prelude

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Console (log)
import FRP.Behavior (animate)
import FRP.Behavior.Mouse (position)
import FRP.Event.Mouse (getMouse)

main :: Effect Unit
main = do
    mousePos <- getMouse <#> position
    animate mousePos (maybe (pure unit) (show >>> log)) # join
