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
main :: Effect Unit
main = Console.log "Hello, world!"
```
*This will cause the browser to present `Hello, world!` in the console when loading index.html*
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