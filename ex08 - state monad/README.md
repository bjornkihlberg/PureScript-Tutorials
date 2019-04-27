## Description
### State Monad
I think the State monad seems very contrived but maybe that's because I try to keep these examples small and this monad doesn't make much sense for simple stuff. Anyway, I've found a tolerable example to demonstrate how this monad work. The idea is that the monad holds a tuple representing a stateful value and a result.

In this example I've created a simple (really bad... don't use it) random function.
```purescript
fastRand :: Int -> Int
fastRand seed = (214013 * seed + 2531011) `shr` 16 .&. 5
```
`fastRand` is pure so in order to get "random" numbers you pass its result back to it to ge the next "random" number. How it works isn't important because it sucks.

We create a `State` with `state :: (s -> Tuple a s) -> State s a` (type signature is simplified and specialized for this example). The `s` represents the state of the monad and the `a` represents the result of the computation.
```purescript
fastRandSt :: State Int Int
fastRandSt = state (\seed -> let r = fastRand seed in Tuple r r)
```
What's interesting is that the initial value of the computation is nowhere to be seen here. Here is a stateful computation that builds upon `fastRandSt`
```purescript
randomSum :: State Int Int
randomSum = do
    a <- fastRandSt
    b <- fastRandSt
    c <- fastRandSt
    pure (a + b + c)
```
This code looks remarkably imperative but again, notice that the initial value is nowhere to be seen. All of this is completely pure. In order to get the result we have to pass the computation to `evalState :: State s a -> s -> a` and as we can see in its signature, it needs an initial value to produce the result.
```
> evalState randomSum 1234
6
```
I use `1234` as a random seed. If I were to run the computation multiple times, I get the same result back. This is why the `State` monad is actually pure. I don't think this example is perfect and this monad seems a little pointless except that it allows you to create a memory efficient solution for something that could otherwise be inefficient were you to use a stream or something.
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install psci-support
    npx psc-package install transformers
    npx psc-package install integers
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl",
        "build": "pulp --psc-package --watch build"
    }
    ```
1. Create a file `.purs-repl` to automatically import specified modules
    ```purescript
    import Prelude
    import Main
    import Control.Monad.State
    import Data.Int.Bits
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