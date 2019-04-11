module Main where

import Prelude

newtype Box a = Box a

instance functorBox :: Functor Box where
    map f (Box x) = Box (f x)

instance showBox :: (Show a) => Show (Box a) where
    show (Box x) = "Box " <> (show x)
