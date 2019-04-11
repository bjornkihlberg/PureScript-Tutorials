module Test.Main where

import Prelude

import Effect (Effect)
import Main (square)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Test.Unit.QuickCheck (quickCheck)

squareTestSuite :: TestSuite
squareTestSuite = suite "square" do
    test "square 0 = 0" $ Assert.equal (square 0.0) 0.0
    test "square 2 = 4" $ Assert.equal (square 2.0) 4.0
    test "square 3 = 9" $ Assert.equal (square 3.0) 9.0
    test "square x = square -x" $ quickCheck (\ x -> square x == square (-x))
    test "square x > 0" $ quickCheck (\ x -> square x > 0.0)

main :: Effect Unit
main = runTest squareTestSuite
