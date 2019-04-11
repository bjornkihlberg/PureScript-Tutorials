module Main where

import Prelude

f :: Number -> Number
f x = x * 4.5

newtype Box a = Box a

g :: forall a. Box a -> a
g (Box x) = x

data Fruit = Orange | Banana

instance showFruit :: Show Fruit where
    show Orange = "orange"
    show Banana = "banana"

h :: Fruit -> String
h Orange = "orange!"
h Banana = "yellow!"

age :: Int
age = 9
