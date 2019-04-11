module Test.Main where

import Prelude

import Test.Unit (test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Effect (Effect)

main :: Effect Unit
main = runTest $ test "f" $ Assert.equal 5 5
