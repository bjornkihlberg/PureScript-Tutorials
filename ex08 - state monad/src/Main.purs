module Main where

import Prelude

import Control.Monad.State (State, state)
import Data.Int.Bits (shr, (.&.))
import Data.Tuple (Tuple(..))

fastRand :: Int -> Int
fastRand seed = (214013 * seed + 2531011) `shr` 16 .&. 5

fastRandSt :: State Int Int
fastRandSt = state (\seed -> let r = fastRand seed in Tuple r r)

randomSum :: State Int Int
randomSum = do
    a <- fastRandSt
    b <- fastRandSt
    c <- fastRandSt
    pure (a + b + c)
