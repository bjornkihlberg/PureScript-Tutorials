## Description
### State Monad
I think the State monad seems very contrived but maybe that's because I try to keep these examples small and this monad doesn't make much sense for simple stuff. Anyway, I've found a tolerable example to demonstrate how this monad work. The idea is that the monad holds a tuple representing a stateful value and a result.
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