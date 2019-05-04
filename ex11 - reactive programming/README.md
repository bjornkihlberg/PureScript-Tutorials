## Description
### Reactiveness
I've found modelling evolving state as composition of event streams to be intuitive and easy to manage. I do not yet have enough experience with this style of programming to know if it's maintainable or if it scales well.

In this example I'm creating a stream of states tracking which keyboard buttons are pressed down with no successive repeats of the same state. We'll learn some interesting things about PureScript and this style of programming.
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install web-uievents
    npx psc-package install console
    npx psc-package install event
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