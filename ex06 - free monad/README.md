## Description
### Free Monads
I'm going to keep this super simple. It has been a challenge to understand what free monads are because tutorials usually go through implementation of a kind of stream or talk about the general case which is just confusing. In this article, all I'm doing is showing a very simple example and then it will be probably be apparent how this can be used for other things as well. Using something gives an intuition, once you have an intuition, understanding the general case and implementation details might be more interesting.
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