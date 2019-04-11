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