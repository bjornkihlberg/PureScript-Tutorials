module Main where

import Prelude

import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (alert)

main :: Effect Unit
main = window >>= alert "Hello, world!"