## Description
### Free Monads
I'm going to keep this super simple. It has been a challenge to understand what free monads are because tutorials usually go through implementation of free monads from scratch by creating a kind of stream or they talk about the general case which is confusing. In this article, all I'm doing is showing a very simple example and then it will be probably be apparent how this can be used for other things as well. Understanding the general case or implementation details might be easier and more interesting once you have an intuition.

The basic idea is that you may get a monad from any functor and that this monad only produces a structure that you can work with so you can defer the decision of what to do with it. For example you might want to do effects or maybe you want to automatically optimize the program or insert logging between every step, etc.

We'll start by creating our own IO monad and defer the use of effects until later. That way we make our IO code testable. Let's go through my use case. We want to create an IO monad that can print to the console and get a number from somewhere (could be input from the console, in my example it will be a fixed number because reading from console in the browser is... not straight forward...).
```purescript
data ConsoleIOF a
    = Print String a
    | GetNumber (Int -> a)

instance functorMyADT :: Functor ConsoleIOF where
    map f (Print s a) = Print s (f a)
    map f (GetNumber g) = GetNumber (f <<< g)
```
We got ourselves a new functor. In theory we should be able to get a monad from that (for free). The `a` represents the type of the result of the program. In our case we will use `Unit` because we don't want to produce a result.
```purescript
type ConsoleIO = Free ConsoleIOF
```
Cool, now we can create some functions that return our new `ConsoleIO` monad.
```purescript
print :: String -> ConsoleIO Unit
print s = liftF $ Print s unit

getNumber :: ConsoleIO Int
getNumber = liftF $ GetNumber identity
```
Now we can use these functions to produce a program.
```purescript
program :: ConsoleIO Unit
program = do
    print "Let's get a number!"
    n <- getNumber
    print $ "We got " <> show n
```
This "program" doesn't actually **do anything**. It just produces a stream that we can work with to make it **do something**. Let's define how to turn our free monad program into a real effectful program.
```purescript
consoleIOToEffect :: ConsoleIO ~> Effect
consoleIOToEffect = runFreeM $ case _ of
    Print s a -> do
        log s
        pure a
    GetNumber f -> pure (f 42)
```
Consider the type signature of `consoleIOToEffect :: ConsoleIO ~> Effect`. It turns our monad program into an effectful program. And we've defined that when we have a `Print` case, we log to the console and when we have a `GetNumber` case, we provide the integer value `42`.

Finally we perform the transformation and run our program.
```purescript
main :: Effect Unit
main = consoleIOToEffect program
```
This program yields the following console output.
```
Let's get a number!
We got 42
```
A similar example made this finally click for me. It'd be interesting to explore from this point and see what else you can do with it! Hope this was useful!
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install psci-support
    npx psc-package install free
    npx psc-package install console
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl",
        "build": "pulp --psc-package --watch build",
        "start": "pulp --psc-package run"
    }
    ```
1. Create a file `.purs-repl` to automatically import specified modules
    ```purescript
    import Prelude
    import Main
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Start the PureScript build process
    ```
    npm run build
    ```
1. Start the PureScript REPL
    ```
    npm run repl
    ```