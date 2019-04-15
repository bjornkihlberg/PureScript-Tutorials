module Main where

import Prelude

newtype Box a = Box a

instance functorBox :: Functor Box where
    map f (Box x) = Box (f x)

instance showBox :: (Show a) => Show (Box a) where
    show (Box x) = "Box " <> (show x)

class ContravariantFunctor f where
    contramap :: forall a b c. (b -> a) -> f a c -> f b c

instance contravariantFunctorFn :: ContravariantFunctor (Function) where
    contramap = (>>>)
