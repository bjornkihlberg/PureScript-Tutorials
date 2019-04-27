## Description
### State Monad
I think the State monad seems very contrived but maybe that's because I try to keep these examples small and this monad doesn't make much sense for simple stuff. Anyway, I've found a tolerable example to demonstrate how this monad work. The idea is that the monad holds a tuple representing a stateful value and a result.

In this example I've created a simple (really bad... don't use it) random function.
```purescript
fastRand :: Int -> Int
fastRand seed = (214013 * seed + 2531011) `shr` 16 .&. 5
```
`fastRand` is pure so in order to get "random" numbers you pass its result back to it to ge the next "random" number. How it works isn't important because it sucks.
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