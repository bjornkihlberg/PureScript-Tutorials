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
        "build": "pulp --psc-package build",
        "start": "pulp --psc-package run",
        "release": "pulp --psc-package build -O --to bundle.js"
    }
    ```