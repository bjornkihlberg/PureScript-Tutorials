module Main where

import Prelude

import Control.Monad.Free (Free, liftF, runFreeM)
import Effect (Effect)
import Effect.Console (log)

data ConsoleIOF a
    = Print String a
    | GetNumber (Int -> a)

instance functorMyADT :: Functor ConsoleIOF where
    map f (Print s a) = Print s (f a)
    map f (GetNumber g) = GetNumber (f <<< g)

type ConsoleIO = Free ConsoleIOF

print :: String -> ConsoleIO Unit
print s = liftF $ Print s unit

getNumber :: ConsoleIO Int
getNumber = liftF $ GetNumber identity

program :: ConsoleIO Unit
program = do
    print "Let's get a number!"
    n <- getNumber
    print $ "We got " <> show n

consoleIOToEffect :: ConsoleIO ~> Effect
consoleIOToEffect = runFreeM $ case _ of
    Print s a -> do
        log s
        pure a
    GetNumber f -> pure (f 42)

main :: Effect Unit
main = consoleIOToEffect program
