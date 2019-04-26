module Main where

import Prelude

import Control.Monad.Indexed (class IxApplicative, class IxApply, class IxBind, class IxFunctor, class IxMonad, (:>>=))
import Data.Newtype (class Newtype, unwrap)

newtype IxABC i o a = IxABC a

data A
data B
data C

derive instance newtypeIxABC :: Newtype (IxABC i o a) _

instance showABC :: (Show a) => Show (IxABC i o a) where
    show (IxABC x) = "IxABC (" <> show x <> ")"

instance ixFunctorABC :: IxFunctor IxABC where
    imap f (IxABC x) = IxABC (f x)

instance ixApplyABC :: IxApply IxABC where
    iapply (IxABC f) (IxABC x) = IxABC (f x)

instance ixApplicativeABC :: IxApplicative IxABC where
    ipure = IxABC

instance ixBindABC :: IxBind IxABC where
    ibind (IxABC x) f = (IxABC <<< unwrap) (f x)

instance ixMonadABC :: IxMonad IxABC

doA :: Int -> IxABC Void A Int
doA = IxABC

doB :: Int -> IxABC A B Int
doB = (_ * 2) >>> IxABC

doC :: Int-> IxABC B C Int
doC = (_ - 1) >>> IxABC

myABC :: IxABC Void C Int
myABC = doA 5 :>>= doB :>>= doC
