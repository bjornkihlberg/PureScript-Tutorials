module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

f :: Int -> Int
f x = x * 2

main :: Effect Unit
main = log "Hello, world!"
