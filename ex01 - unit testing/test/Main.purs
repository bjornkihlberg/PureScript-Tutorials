module Test.Main where

import Prelude

import Main (square)

import Effect (Effect)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

squareTests :: TestSuite
squareTests = suite "square tests" do
    test "square 0 = 0" $ Assert.equal (square 0) 0
    test "square 2 = 4" $ Assert.equal (square 2) 4
    test "square 3 = 9" $ Assert.equal (square 3) 9

main :: Effect Unit
main = runTest squareTests
