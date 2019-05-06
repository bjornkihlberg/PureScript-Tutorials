## Description
### Simple game
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install console
    npx psc-package install event
    npx psc-package install web-uievents
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "build": "pulp --psc-package --watch build --to bundle.js"
    }
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