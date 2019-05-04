## Description
### Reactiveness
I've found modelling evolving state as composition of event streams to be intuitive and easy to manage. I do not yet have enough experience with this style of programming to know if it's maintainable or if it scales well.

In this example I'm creating a stream of states tracking which keyboard buttons are pressed down with no successive repeats of the same state. We'll learn some interesting things about PureScript and this style of programming along the way.

We start by creating a pair of an event stream and a function that push events onto that stream. To do this we use `create :: forall a. Effect { event :: Event a, push :: a -> Effect Unit }` from the [FRP.Event](https://pursuit.purescript.org/packages/purescript-event/1.2.4/docs/FRP.Event) module.
```purescript
main :: Effect Unit
main = do
    { event, push } <- create

    pure unit
```
*Note that we haven't told PureScript which types we want to work with. PureScript has a Hindley-Milner type system that infer the types by how we use `event` or `push`. We get the terseness of dynamic languages like Python but high reliability.*

*Further you should notice that this is very similar to [Redux](https://redux.js.org/). Actually, you can implement Redux in PureScript in one or two lines of code.*
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