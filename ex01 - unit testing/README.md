## Description
### Simple unit testing and [QuickCheck](https://en.wikipedia.org/wiki/QuickCheck) example
A simple squaring function in `./src/Main.purs`
```purescript
module Main where

import Prelude

f :: Int -> Int
f x = x * x
```
Tests for Main module in `./test/Main.purs`
```purescript
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
```
This should be quite explanatory. However, it is quite interesting that if you were to run these tests, they would all pass but they shouldn't. This line tests whether `square x` is always larger than `0.0` which it isn't:
```purescript
test "square x > 0" $ quickCheck (\ x -> square x > 0.0)
```
This
[particular implementation of quickcheck](https://pursuit.purescript.org/packages/purescript-quickcheck/6.1.0/docs/Test.QuickCheck)
doesn't seem to have a so called "shrinker" that tries "special" values like `0.0`. It is however possible to generate your own values but I'm not going to go through that in this tutorial.
## Instructions
### Setup
1. Install unit testing package
    ```
    npx psc-package install test-unit
    ```
1. Set up npm script for watching unit tests
    ```
    "scripts": {
        "postinstall": "psc-package install",
        "test": "pulp --psc-package --watch test"
    }
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Compile project and run tests
    ```
    npm test
    ```
    *Tests will autorun when files change*
