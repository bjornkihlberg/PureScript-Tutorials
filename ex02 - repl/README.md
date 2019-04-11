## Description
### Demonstrating the PureScript REPL
Here I will demonstrate how to use the REPL (Read Eval Print Loop). This can be very useful for quickly testing your code with various input without having to compile tests or finding a spot in your code to print to console.

The `Main` module is defined with some simple types, functions, instances and values:
```purescript
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
```
If we run the REPL we get an interactive session where we can write PureScript code. We can define variables, functions, types etc. More importantly we can explore our modules, including installed modules and try them out in a closed enviroment. The `:?` command shows available commands.

`:browse Main` or `:b Main` shows what's defined in the `Main` module:
```
> :b Main

newtype Box a
  = Box a

data Fruit
  = Orange
  | Banana

age :: Int

f :: Number -> Number

g :: forall a. Box a -> a

h :: Fruit -> String
```
We can call our functions with arguments to see what output we get:
```
> f 4.0
18.0

> h Banana
"yellow!"
```
Since we're also automatically importing the `Prelude` module we can use stuff from that
```
> 5 > 4
true
```
Let's define a variable and then use that variable in our session
```
> box = Box "yo!"
> g box
"yo!"
```
We can inspect the kind of a type or the type of a function or value
```
> :k Box
Type -> Type

> :t g
forall a. Box a -> a

> :t age
Int
```
*etc etc*
Reload your session with `:r` to get a fresh state but keep your imported modules.
## Instructions
### Setup
1. Install the psci-support module
    ```
    npx psc-package install psci-support
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl"
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
1. Start the PureScript REPL
    ```
    npm run repl
    ```