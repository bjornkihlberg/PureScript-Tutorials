module Test.Main where

import Prelude

import Main (f)

import Effect (Effect)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

ftests :: TestSuite
ftests = suite "ftests" do
    test "f 0 = 0" $ Assert.equal (f 0) 0
    test "f 2 = 4" $ Assert.equal (f 2) 4

main :: Effect Unit
main = runTest ftests
