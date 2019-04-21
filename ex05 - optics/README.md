## Description
### Profunctor optics
The subject of optics or lenses is quite big. There is [a book](https://leanpub.com/lenses) on this subject. In this tutorial I will only show some basics. Optics seem quite easy to work with but a little bit more complicated to build from scratch. I'll try to summarise as best as I understand how this works.
## Instructions
### Setup
1. Install required modules
    ```
    npx psc-package install profunctor-lenses
    npx psc-package install psci-support
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