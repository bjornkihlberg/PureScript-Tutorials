## Description
### Profunctors
## Instructions
### Setup
1. Install required modules
    ```
    npx psc-package install profunctor
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
    import Data.Profunctor
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