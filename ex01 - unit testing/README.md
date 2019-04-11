## Description
### Simple unit testing example
## Instructions
### Setup
1. Install unit testing package
    ```
    npx psc-package install test-unit
    ```
1. Set up npm script for watching unit tests
    ```
    "scripts": {
        "postinstall": "psc-package install",
        "test": "pulp --psc-package --watch test"
    }
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Run tests
    ```
    npm test
    ```
    *Tests will autorun when files change*
