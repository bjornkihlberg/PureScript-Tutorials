## Description
### The canonical "hello world" console program
```purescript
module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = log "Hello, world!"
```
There isn't much to say about this. This is obviously what prints *Hello, world!* to the console:
```purescript
main = log "Hello, world!"
```
But let's look at the line above it:
```purescript
main :: Effect Unit
```
This is quite interesting. This it the type definition for `main`. It says that `main` has the type `Effect Unit`. What does that mean? It means that it has a
[side effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science))
; it does something to the outside world (printing to the console in our case). Few languages track stuff like this. This is partly what makes a language like PureScript so fascinating because, as we'll see later, we can't cheat and mix side effects with pure code. That forces us to segregate the two worlds which helps us make more reusable and more reliable code.
## Instructions
### Setup
1. Initialize npm
    ```
    npm init
    ```
1. Install PureScript
    ```
    npm i -D purescript psc-package pulp
    ```
1. Initialize PureScript project
    ```
    npx pulp --psc-package init
    ```
    *If you don't want unit testing you can remove the `./test` folder*
1. Install console and effect modules
    ```
    npx psc-package install effect
    npx psc-package install console
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "build": "pulp --psc-package --watch build",
        "release": "pulp --psc-package build -O --to bundle.js"
    }
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Build project and watch for file changes during development
    ```
    npm run build
    ```
1. Compile and bundle to `./bundle.js` before running
    ```
    npm run release
    ```
1. Run application
    ```
    node bundle.js
    ```