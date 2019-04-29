## Description
### Interacting with the browser
#### Bundling
To start off we create regular old *index.html* with a `script` tag referring to *bundle.js*.
```html
<body>
    <script src="bundle.js"></script>
</body>
```
We bundle our application into the same folder as *index.html* and name it *bundle.js*.
```
pulp --psc-package build --to bundle.js
```
This command minifies the output and only includes what's necessary from the PureScript packages. Default behaviour is for the entrypoint `main :: Effect Unit` automatically be invoked when the script is loaded. It's possible to disable this but I keep it on for now.
```purescript
module Main where

import Prelude

import Effect (Effect)
import Effect.Console as Console

main :: Effect Unit
main = Console.log "Hello, world!"
```
*This will cause the browser to present `Hello, world!` in the console when loading index.html*
#### window, document, etc
We use the [web-html](https://pursuit.purescript.org/packages/purescript-web-html/2.0.1) package to do basic operations with the browser. Interacting with the `window` object and the DOM are effectful operations and need to be performed in a monadic `Effect` context. For example, to get the window object we invoke `window :: Effect Window` and to make an alert we invoke `alert :: String ->  Window -> Effect Unit`.
```purescript
main :: Effect Unit
main = do
    w <- window
    alert "Hello, world!" w
```
*Since Effect is a monad the above code can be refactored with `>>=`*
```purescript
main :: Effect Unit
main = window >>= alert "Hello, world!"
```
*This is called "point free style" because we just pipe the results through our functions without using temporary variables like `w`*
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install psci-support
    npx psc-package install web-html
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl",
        "build": "pulp --psc-package --watch build",
        "bundle": "pulp --psc-package build --to bundle.js"
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