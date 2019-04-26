## Description
### Indexed Monads
The [IxMonad](https://pursuit.purescript.org/packages/purescript-indexed-monad/1.0.0/docs/Control.Monad.Indexed#t:IxMonad) is a monad to help enforce operations happen in a certain order. This is to help prevent you from moving to an illegal state. For example, if you're controlling an external device, perhaps you'd need to activate a locking mechanism before opening it (can't open something that i slocked), and close it only when it's opened (no point closing something that is already closed) and lock it when it's closed (no point locking if something isn't closed). It seems to me that it doesn't guarantee safety but it helps you to remember to do operations in the right order.

A use case I'm very interested in is if it's possible to use this when working with the GPU with [WebGL](https://get.webgl.org/) or [OpenGL](https://opengl.org/).
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install psci-support
    npx psc-package install indexed-monad
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